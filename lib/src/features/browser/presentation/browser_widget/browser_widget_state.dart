import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@immutable
class BrowserWidgetState {
  const BrowserWidgetState({
    required this.webViewController,
    required this.currentUrl,
  });

  final InAppWebViewController? webViewController;
  final String currentUrl;

  BrowserWidgetState copyWith({
    InAppWebViewController? webViewController,
    String? currentUrl,
  }) {
    return BrowserWidgetState(
      webViewController: webViewController ?? this.webViewController,
      currentUrl: currentUrl ?? this.currentUrl,
    );
  }
}
