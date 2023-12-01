import 'package:bouser/src/features/browser/data/inappwebview_browser_repository/inappwebview_browser_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final browserWidgetNumberProvider = Provider.autoDispose<int>((ref) {
  throw UnimplementedError();
});

class BrowserWidget extends ConsumerWidget {
  const BrowserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(browserWidgetNumberProvider);
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse("https://flutter.dev")),
      initialOptions: InAppWebViewGroupOptions(
        ios: IOSInAppWebViewOptions(
          maximumZoomScale: 5.0,
        ),
      ),
      onWebViewCreated: (webViewController) => ref
          .read(inAppWebViewBrowserRepositoryProvider)
          .setController(browserNumber, webViewController),
      onLoadStart: (controller, url) => ref
          .read(inAppWebViewBrowserRepositoryProvider)
          .updateCurrentUrl(browserNumber, url),
      onLoadStop: (controller, url) => ref
          .read(inAppWebViewBrowserRepositoryProvider)
          .updateCurrentUrl(browserNumber, url),
      onLoadError: (controller, url, code, message) => debugPrint(
          "browserNumber: $browserNumber, url: $url, code: $code, message: $message"),
      onUpdateVisitedHistory: (controller, url, androidIsReload) => ref
          .read(inAppWebViewBrowserRepositoryProvider)
          .updateCurrentUrl(browserNumber, url),
    );
  }
}
