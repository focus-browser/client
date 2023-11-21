import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserWidget extends ConsumerWidget {
  const BrowserWidget({
    super.key,
    required this.isPrimaryBrowser,
  });

  final bool isPrimaryBrowser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(browserWidgetsControllersProvider(isPrimaryBrowser));
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse("https://flutter.dev")),
      initialOptions: InAppWebViewGroupOptions(
        ios: IOSInAppWebViewOptions(
          maximumZoomScale: 5.0,
        ),
      ),
      onWebViewCreated: (webViewController) => ref
          .read(browserWidgetsControllersProvider(isPrimaryBrowser).notifier)
          .setWebViewController(webViewController),
      onLoadStart: (controller, url) => ref
          .read(browserWidgetsControllersProvider(isPrimaryBrowser).notifier)
          .updateUrl(url.toString()),
      onLoadStop: (controller, url) => ref
          .read(browserWidgetsControllersProvider(isPrimaryBrowser).notifier)
          .updateUrl(url.toString()),
      onLoadError: (controller, url, code, message) =>
          debugPrint("url: $url, code: $code, message: $message"),
      onUpdateVisitedHistory: (controller, url, androidIsReload) => ref
          .read(browserWidgetsControllersProvider(isPrimaryBrowser).notifier)
          .updateUrl(url.toString()),
    );
  }
}
