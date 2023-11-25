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

  @override
  bool operator ==(covariant BrowserWidgetState other) {
    if (identical(this, other)) return true;

    return other.webViewController == webViewController &&
        other.currentUrl == currentUrl;
  }

  @override
  int get hashCode => webViewController.hashCode ^ currentUrl.hashCode;
}
