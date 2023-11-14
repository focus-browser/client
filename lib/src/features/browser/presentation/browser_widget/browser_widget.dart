// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserWidget extends ConsumerWidget {
  const BrowserWidget({
    super.key,
    required this.isTopBrowser,
  });

  final bool isTopBrowser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(browserWidgetControllerProvider(isTopBrowser));
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse("https://flutter.dev")),
      initialOptions: InAppWebViewGroupOptions(
        ios: IOSInAppWebViewOptions(
          maximumZoomScale: 5.0,
        ),
      ),
      onWebViewCreated: (webViewController) => ref
          .read(browserWidgetControllerProvider(isTopBrowser).notifier)
          .setWebViewController(webViewController),
      onLoadStart: (controller, url) => ref
          .read(browserWidgetControllerProvider(isTopBrowser).notifier)
          .textController
          .text = url.toString(),
      onLoadStop: (controller, url) => ref
          .read(browserWidgetControllerProvider(isTopBrowser).notifier)
          .textController
          .text = url.toString(),
      onLoadError: (controller, url, code, message) =>
          debugPrint("url: $url, code: $code, message: $message"),
      onUpdateVisitedHistory: (controller, url, androidIsReload) => ref
          .read(browserWidgetControllerProvider(isTopBrowser).notifier)
          .textController
          .text = url.toString(),
    );
  }
}
