import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../model/address_search_result.dart';

class AddressSearchView extends StatefulWidget {
  const AddressSearchView({
    super.key,
    required this.onCompleted,
    required this.onClosed,
  });

  final ValueChanged<AddressSearchResult> onCompleted;
  final VoidCallback onClosed;

  @override
  State<AddressSearchView> createState() => _AddressSearchViewState();
}

class _AddressSearchViewState extends State<AddressSearchView> {
  String? _html;
  bool _isReturning = false;
  InAppWebViewController? _controller;
  Timer? _pollTimer;
  bool _isClosingView = false;

  @override
  void initState() {
    super.initState();
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    final html = await rootBundle.loadString('assets/html/postcode.html');
    if (!mounted) {
      return;
    }

    setState(() {
      _html = html;
    });
  }

  void _finish(AddressSearchResult result) {
    if (!mounted || _isReturning) {
      return;
    }

    _isReturning = true;
    _detachWebView().then((_) {
      if (!mounted) {
        return;
      }
      widget.onCompleted(result);
    });
  }

  void _close() {
    if (!mounted || _isReturning) {
      return;
    }

    _isReturning = true;
    _detachWebView().then((_) {
      if (!mounted) {
        return;
      }
      widget.onClosed();
    });
  }

  Future<void> _detachWebView() async {
    if (mounted) {
      setState(() {
        _isClosingView = true;
      });
    }

    _pollTimer?.cancel();

    final controller = _controller;
    if (controller != null) {
      try {
        await controller.loadData(
          data:
              '<!DOCTYPE html><html><body style="margin:0;background:#ffffff;"></body></html>',
          mimeType: 'text/html',
          encoding: 'utf-8',
        );
      } catch (_) {
        // Ignore teardown errors while forcing the platform view to detach.
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 80));
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(milliseconds: 250), (_) async {
      if (!mounted || _isReturning) {
        _pollTimer?.cancel();
        return;
      }

      final controller = _controller;
      if (controller == null) {
        return;
      }

      try {
        final raw = await controller.evaluateJavascript(
          source: 'window.__ALBA_POSTCODE_EVENT__ || ""',
        );
        final resolved = _resolveJsString(raw);
        if (resolved.isEmpty) {
          return;
        }

        _handleBridgeEvent(resolved);
      } catch (_) {
        // Ignore transient evaluation errors during initial load.
      }
    });
  }

  void _handleBridgeEvent(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, dynamic>) {
      return;
    }

    final type = json['type'];
    if (type == 'complete') {
      final payload = json['payload'];
      if (payload is Map<String, dynamic>) {
        _finish(AddressSearchResult.fromJsonString(jsonEncode(payload)));
      }
      return;
    }

    if (type == 'close') {
      _close();
    }
  }

  String _resolveJsString(Object? raw) {
    if (raw == null) {
      return '';
    }

    if (raw is String) {
      if (raw.isEmpty) {
        return '';
      }
      try {
        final decoded = jsonDecode(raw);
        return decoded is String ? decoded : raw;
      } catch (_) {
        return raw;
      }
    }

    return raw.toString();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final html = _html;

    return Material(
      color: Colors.white,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _close,
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '우편번호 찾기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isClosingView
                ? const ColoredBox(color: Colors.white)
                : html == null
                ? const Center(child: CircularProgressIndicator())
                : InAppWebView(
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      transparentBackground: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    initialData: InAppWebViewInitialData(
                      data: html,
                      baseUrl: WebUri('https://localhost.local/'),
                      mimeType: 'text/html',
                      encoding: 'utf-8',
                    ),
                    onWebViewCreated: (controller) {
                      _controller = controller;
                      controller.addJavaScriptHandler(
                        handlerName: 'onCompleteAddress',
                        callback: (arguments) {
                          if (arguments.isEmpty) {
                            return null;
                          }

                          final raw = arguments.first;
                          final source = raw is String ? raw : jsonEncode(raw);
                          _finish(AddressSearchResult.fromJsonString(source));
                          return null;
                        },
                      );
                      controller.addJavaScriptHandler(
                        handlerName: 'onCloseAddress',
                        callback: (_) {
                          _close();
                          return null;
                        },
                      );
                    },
                    onLoadStop: (controller, url) {
                      _startPolling();
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      final message = consoleMessage.message;
                      const prefix = '__ALBA_POSTCODE__';
                      if (!message.startsWith(prefix) || _isReturning) {
                        return;
                      }

                      try {
                        _handleBridgeEvent(message.substring(prefix.length));
                      } catch (_) {
                        // Ignore malformed console payloads.
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
