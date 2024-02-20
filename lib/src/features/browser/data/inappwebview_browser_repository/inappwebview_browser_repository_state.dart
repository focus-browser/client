import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

@immutable
class InAppWebViewBrowserRepositoryState {
  const InAppWebViewBrowserRepositoryState({
    this.webViewController,
    this.currentUrl,
    this.loadingProgress = 1.0,
  });

  final InAppWebViewController? webViewController;
  final String? currentUrl;
  final double loadingProgress;

  @override
  bool operator ==(covariant InAppWebViewBrowserRepositoryState other) {
    if (identical(this, other)) return true;

    return other.webViewController == webViewController &&
        other.currentUrl == currentUrl &&
        other.loadingProgress == loadingProgress;
  }

  @override
  int get hashCode =>
      webViewController.hashCode ^
      currentUrl.hashCode ^
      loadingProgress.hashCode;

  InAppWebViewBrowserRepositoryState copyWith({
    InAppWebViewController? webViewController,
    String? currentUrl,
    double? loadingProgress,
  }) {
    return InAppWebViewBrowserRepositoryState(
      webViewController: webViewController ?? this.webViewController,
      currentUrl: currentUrl ?? this.currentUrl,
      loadingProgress: loadingProgress ?? this.loadingProgress,
    );
  }

  @override
  String toString() =>
      'InAppWebViewBrowserRepositoryState(webViewController: $webViewController, currentUrl: $currentUrl, loadingProgress: $loadingProgress)';
}
