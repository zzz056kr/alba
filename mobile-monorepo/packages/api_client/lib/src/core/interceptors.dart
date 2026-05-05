import 'dart:async';

import 'package:common/common.dart';
import 'package:dio/dio.dart';

import '../store/auth_token_provider.dart';
import 'auth_event_bus.dart';

const _publicPathFragments = <String>[
  '/auth/login',
  '/app/auth/login',
  '/auth/join',
  '/auth/refresh',
];

const _logoutPathFragment = '/auth/logout';

bool _isPublicRequest(String? path) {
  if (path == null) return false;
  return _publicPathFragments.any(path.contains);
}

bool _isLogoutRequest(String? path) {
  if (path == null) return false;
  return path.contains(_logoutPathFragment);
}

bool _shouldShowLoading(RequestOptions options) {
  return options.extra['showLoading'] != false;
}

bool _shouldShowErrorPopup(RequestOptions options) {
  return options.extra['showErrorPopup'] != false;
}

String _resolveErrorMessage(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return '요청 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.';
  }

  if (error.type == DioExceptionType.connectionError) {
    return '서버에 연결할 수 없습니다. 네트워크 상태 또는 서버 실행 상태를 확인해주세요.';
  }

  final data = error.response?.data;
  if (data is Map) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
    final errorMsg = data['error'];
    if (errorMsg is String && errorMsg.isNotEmpty) return errorMsg;
  }

  final status = error.response?.statusCode;
  if (status != null && status >= 500) {
    return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
  }

  return error.message ?? '요청 처리 중 오류가 발생했습니다.';
}

typedef AuthTokenProviderGetter = AuthTokenProvider Function();

void setupAuthInterceptor(
  Dio dio, {
  required AuthTokenProviderGetter tokenProvider,
  required void Function(String message) showError,
}) {
  var isRefreshing = false;
  final pendingQueue = <Completer<String?>>[];

  void resolveQueue(String? token) {
    for (final completer in pendingQueue) {
      if (!completer.isCompleted) completer.complete(token);
    }
    pendingQueue.clear();
  }

  void rejectQueue(Object error) {
    for (final completer in pendingQueue) {
      if (!completer.isCompleted) completer.completeError(error);
    }
    pendingQueue.clear();
  }

  Future<bool> performRefresh() async {
    if (isRefreshing) {
      final completer = Completer<String?>();
      pendingQueue.add(completer);
      try {
        final token = await completer.future;
        return token != null;
      } catch (_) {
        return false;
      }
    }

    isRefreshing = true;
    try {
      final ok = await tokenProvider().refreshToken();
      if (ok) {
        resolveQueue(tokenProvider().tokenResponse?.accessToken);
      } else {
        rejectQueue(StateError('Token refresh failed'));
      }
      return ok;
    } catch (error) {
      rejectQueue(error);
      rethrow;
    } finally {
      isRefreshing = false;
    }
  }

  void emitRedirectToLogin() {
    tokenProvider().clearTokenResponse();
    AuthEventBus.instance.emit(AuthEvent.redirectToLogin);
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_shouldShowLoading(options)) LoadingBus.start();

        if (_isPublicRequest(options.path)) {
          handler.next(options);
          return;
        }

        if (!tokenProvider().isInitialized) {
          await tokenProvider().initializeAuth();
        }

        final token = tokenProvider().tokenResponse;
        final issuedAt = tokenProvider().tokenIssuedAt;

        if (token == null || token.accessToken.isEmpty) {
          handler.next(options);
          return;
        }

        final isLogout = _isLogoutRequest(options.path);

        if (!isLogout && isTokenExpired(token, issuedAt)) {
          if (_shouldShowLoading(options)) LoadingBus.stop();
          emitRedirectToLogin();
          handler.reject(
            DioException(
              requestOptions: options,
              error: 'Token expired',
              type: DioExceptionType.cancel,
            ),
          );
          return;
        }

        if (!isLogout && isTokenExpiringSoon(token, issuedAt)) {
          try {
            final ok = await performRefresh();
            if (!ok) {
              if (_shouldShowLoading(options)) LoadingBus.stop();
              emitRedirectToLogin();
              handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Token refresh failed',
                  type: DioExceptionType.cancel,
                ),
              );
              return;
            }
          } catch (error) {
            if (_shouldShowLoading(options)) LoadingBus.stop();
            emitRedirectToLogin();
            handler.reject(
              DioException(
                requestOptions: options,
                error: error,
                type: DioExceptionType.cancel,
              ),
            );
            return;
          }
        }

        final accessToken = tokenProvider().tokenResponse?.accessToken;
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers[authHeader] = '$authType$accessToken';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (_shouldShowLoading(response.requestOptions)) LoadingBus.stop();
        handler.next(response);
      },
      onError: (error, handler) async {
        final request = error.requestOptions;
        if (_shouldShowLoading(request)) LoadingBus.stop();

        final status = error.response?.statusCode;
        final isAuthRequest =
            _isPublicRequest(request.path) ||
            _isLogoutRequest(request.path) ||
            request.path.contains('/auth/refresh');
        final hasRetried = request.extra['_retry'] == true;
        final shouldHandle401 = status == 401 && !hasRetried && !isAuthRequest;

        if (!shouldHandle401) {
          if (_shouldShowErrorPopup(request) && !isAuthRequest) {
            showError(_resolveErrorMessage(error));
          }
          handler.next(error);
          return;
        }

        request.extra['_retry'] = true;

        try {
          final ok = await performRefresh();
          if (!ok) {
            if (_shouldShowErrorPopup(request)) {
              showError(_resolveErrorMessage(error));
            }
            emitRedirectToLogin();
            handler.next(error);
            return;
          }

          final newToken = tokenProvider().tokenResponse?.accessToken;
          if (newToken != null && newToken.isNotEmpty) {
            request.headers[authHeader] = '$authType$newToken';
          }

          final retryResponse = await dio.fetch<dynamic>(request);
          handler.resolve(retryResponse);
        } catch (refreshError) {
          if (_shouldShowErrorPopup(request)) {
            showError(_resolveErrorMessage(error));
          }
          emitRedirectToLogin();
          handler.next(error);
        }
      },
    ),
  );
}
