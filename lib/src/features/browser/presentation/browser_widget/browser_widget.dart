import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/data/inappwebview_browser_repository/inappwebview_browser_repository.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';

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
    final currentUrlIsEmpty =
        ref.watch(browserCurrentUrlProvider(browserNumber)).value == null;
    return Listener(
      onPointerDown: (_) => ref
          .read(browserScreenControllerProvider.notifier)
          .setSelectedBrowser(browserNumber),
      child: Opacity(
        opacity: currentUrlIsEmpty ? 0.0 : 1.0,
        child: InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              incognito: true,
            ),
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
        ),
      ),
    );
  }
}
