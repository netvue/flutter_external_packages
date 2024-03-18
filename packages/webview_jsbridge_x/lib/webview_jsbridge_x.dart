library webview_jsbridge_x;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef Future<T?> WebViewJSBridgeXHandler<T extends Object?>(Object? data);

enum WebViewXInjectJsVersion { es5, es7 }

class WebViewJSBridgeX {
  final WebViewController controller = WebViewController();
  late NavigationDelegate _navigationDelegate;
  NavigationDelegate? _externalNavigationDelegate;
  WebViewJSBridgeXHandler? _defaultHandler;
  WebViewXInjectJsVersion _esVersion = WebViewXInjectJsVersion.es5;
  final _completers = <int, Completer>{};
  final _handlers = <String, WebViewJSBridgeXHandler>{};
  var _completerIndex = 0;

  WebViewJSBridgeX() {
    _navigationDelegate = NavigationDelegate(
      onNavigationRequest: _onNavigationRequest,
      onPageStarted: _onPageStarted,
      onPageFinished: _onPageFinished,
      onProgress: _onNavigationProgress,
      onWebResourceError: _onWebResourceError,
      onUrlChange: _onUrlChange,
    );
    controller
      ..addJavaScriptChannel(
        "YGFlutterJSBridgeChannel",
        onMessageReceived: _onMessageReceived,
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(_navigationDelegate);
  }

  Future<void> injectJs({
    WebViewXInjectJsVersion esVersion = WebViewXInjectJsVersion.es5,
  }) async {
    final jsVersion =
        esVersion == WebViewXInjectJsVersion.es5 ? 'default' : 'async';
    final jsPath = 'packages/webview_jsbridge_x/assets/$jsVersion.js';
    final jsFile = await rootBundle.loadString(jsPath);
    controller.runJavaScript(jsFile);
  }

  void registerHandler(String handlerName, WebViewJSBridgeXHandler handler) {
    _handlers[handlerName] = handler;
  }

  void removeHandler(String handlerName) {
    _handlers.remove(handlerName);
  }

  Future<void> _jsCall(Map<String, dynamic> jsonData) async {
    if (jsonData.containsKey('handlerName')) {
      final String handlerName = jsonData['handlerName'];
      if (_handlers.containsKey(handlerName)) {
        final data = await _handlers[handlerName]?.call(jsonData['data']);
        _jsCallResponse(jsonData, data);
      } else {
        _jsCallError(jsonData);
      }
    } else {
      if (_defaultHandler != null) {
        final data = await _defaultHandler?.call(jsonData['data']);
        _jsCallResponse(jsonData, data);
      } else {
        _jsCallError(jsonData);
      }
    }
  }

  void _jsCallResponse(Map<String, dynamic> jsonData, Object? data) {
    jsonData['type'] = 'response';
    jsonData['data'] = data;
    _evaluateJavascript(jsonData);
  }

  void _jsCallError(Map<String, dynamic> jsonData) {
    jsonData['type'] = 'error';
    _evaluateJavascript(jsonData);
  }

  Future<T?> callHandler<T extends Object?>(String handlerName,
      {Object? data}) async {
    return _nativeCall<T>(handlerName: handlerName, data: data);
  }

  Future<T?> send<T extends Object?>(Object data) async {
    return _nativeCall<T>(data: data);
  }

  Future<T?> _nativeCall<T extends Object?>(
      {String? handlerName, Object? data}) async {
    final jsonData = {
      'index': _completerIndex,
      'type': 'request',
    };
    if (data != null) {
      jsonData['data'] = data;
    }
    if (handlerName != null) {
      jsonData['handlerName'] = handlerName;
    }

    final completer = Completer<T>();
    _completers[_completerIndex] = completer;
    _completerIndex += 1;

    _evaluateJavascript(jsonData);
    return completer.future;
  }

  void _nativeCallResponse(Map<String, dynamic> jsonData) {
    final int index = jsonData['index'];
    final completer = _completers[index];
    _completers.remove(index);
    if (jsonData['type'] == 'response') {
      completer?.complete(jsonData['data']);
    } else {
      completer?.completeError('native call js error for request $jsonData');
    }
  }

  void _evaluateJavascript(Map<String, dynamic> jsonData) {
    final jsonStr = jsonEncode(jsonData);
    final encodeStr = Uri.encodeFull(jsonStr);
    final script = 'WebViewJavascriptBridge.nativeCall("$encodeStr")';
    controller.runJavaScript(script);
  }

  /// [esVersion] 修改默认 esVersion. 在不设定 [navigationDelegate].onPageFinished 时, 使用默认 esVersion 注入. 若设定了 onPageFinished, esVersion 将被忽略.
  /// [defaultHandler]
  /// [nativeHandlerName] 与 [nativeHandler] 同时使用时生效.
  /// [nativeHandler] 与 [nativeHandlerName] 同时使用时生效.
  /// [onLoad] 回调 [WebViewController] 以供调用者加载网页.
  /// [navigationDelegate] 导航委托.
  WebViewWidget buildWebView({
    WebViewXInjectJsVersion? esVersion,
    WebViewController? webViewController,
    Future<Object?> Function(Object? data)? defaultHandler,
    String? nativeHandlerName,
    Future<Object?> Function(Object? data)? nativeHandler,
    required void Function(WebViewController controller) onLoad,
    NavigationDelegate? navigationDelegate,
  }) {
    _esVersion = esVersion ?? _esVersion;
    _externalNavigationDelegate = navigationDelegate;
    _defaultHandler = defaultHandler;
    if (nativeHandlerName == null && nativeHandler == null) {
      // ignored
    } else if (nativeHandlerName == null || nativeHandler == null) {
      throw Exception(
          "You should set nativeHandlerName && nativeHandler both!");
    } else {
      registerHandler(nativeHandlerName, nativeHandler);
    }
    onLoad(webViewController ?? controller);
    return WebViewWidget(controller: webViewController ?? controller);
  }

  void _onMessageReceived(JavaScriptMessage message) {
    final decodeStr = Uri.decodeFull(message.message);
    final jsonData = jsonDecode(decodeStr);
    final String type = jsonData['type'];
    switch (type) {
      case 'request':
        _jsCall(jsonData);
        break;
      case 'response':
      case 'error':
        _nativeCallResponse(jsonData);
        break;
      default:
        break;
    }
  }

  FutureOr<NavigationDecision> _onNavigationRequest(NavigationRequest request) {
    // 内部暂无特殊处理逻辑
    final result =
        _externalNavigationDelegate?.onNavigationRequest?.call(request);
    if (result != null) {
      return result;
    }
    return NavigationDecision.navigate;
  }

  _onPageStarted(String url) {
    _externalNavigationDelegate?.onPageStarted?.call(url);
  }

  _onPageFinished(String url) {
    final externalCall = _externalNavigationDelegate?.onPageFinished;
    if (externalCall == null) {
      // 默认注入 JS
      injectJs(esVersion: _esVersion);
    } else {
      // 外部决定是否注入 JS
      externalCall.call(url);
    }
  }

  void _onNavigationProgress(int progress) {
    _externalNavigationDelegate?.onProgress?.call(progress);
  }

  void _onWebResourceError(WebResourceError error) {
    _externalNavigationDelegate?.onWebResourceError?.call(error);
  }

  void _onUrlChange(UrlChange change) {
    // ignored
  }
}
