import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@immutable
class InAppWebViewBrowserRepositoryState {
  const InAppWebViewBrowserRepositoryState({
    this.webViewController,
    this.currentUrl,
  });

  final InAppWebViewController? webViewController;
  final String? currentUrl;

  @override
  bool operator ==(covariant InAppWebViewBrowserRepositoryState other) {
    if (identical(this, other)) return true;

    return other.webViewController == webViewController &&
        other.currentUrl == currentUrl;
  }

  @override
  int get hashCode => webViewController.hashCode ^ currentUrl.hashCode;

  InAppWebViewBrowserRepositoryState copyWith({
    InAppWebViewController? webViewController,
    String? currentUrl,
  }) {
    return InAppWebViewBrowserRepositoryState(
      webViewController: webViewController ?? this.webViewController,
      currentUrl: currentUrl ?? this.currentUrl,
    );
  }

  @override
  String toString() =>
      'InAppWebViewBrowserRepositoryState(webViewController: $webViewController, currentUrl: $currentUrl)';
}
