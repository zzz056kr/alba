import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class AuthFlowService {
  AuthFlowService({
    required this.authService,
    required this.redirectBaseUrl,
    AppLinks? appLinks,
  }) : _appLinks = appLinks ?? AppLinks();

  final AuthService authService;
  final String redirectBaseUrl;
  final AppLinks _appLinks;

  StreamSubscription<Uri> listenDeepLinks(
    void Function(OAuthCallbackResult result) onCallback,
  ) {
    return _appLinks.uriLinkStream.listen((uri) {
      final callback = parseCallback(uri);
      if (callback != null) {
        onCallback(callback);
      }
    });
  }

  Future<void> handleInitialLink(
    void Function(OAuthCallbackResult result) onCallback,
  ) async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri == null) {
      return;
    }

    final callback = parseCallback(initialUri);
    if (callback != null) {
      onCallback(callback);
    }
  }

  OAuthCallbackResult? parseCallback(Uri uri) {
    final redirectUri = Uri.parse(redirectBaseUrl);
    if (uri.scheme != redirectUri.scheme) {
      return null;
    }
    return OAuthCallbackResult.fromUri(uri);
  }

  Future<OAuthCallbackResult> startSocialLogin(OAuthProvider provider) async {
    final uri = authService.socialLoginUri(
      provider,
      redirectUrl: redirectBaseUrl,
    );
    final callbackUrlScheme = Uri.parse(redirectBaseUrl).scheme;
    final callbackUrl = await FlutterWebAuth2.authenticate(
      url: uri.toString(),
      callbackUrlScheme: callbackUrlScheme,
    );
    final callback = parseCallback(Uri.parse(callbackUrl));

    if (callback == null) {
      throw StateError('Unexpected OAuth callback: $callbackUrl');
    }

    return callback;
  }
}
