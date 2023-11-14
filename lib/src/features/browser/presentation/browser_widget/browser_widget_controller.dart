// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserWidgetController extends StateNotifier<AsyncValue<void>> {
  BrowserWidgetController() : super(const AsyncData(null));

  InAppWebViewController? _webViewController;
  final TextEditingController _textController = TextEditingController();

  TextEditingController get textController => _textController;

  void setWebViewController(InAppWebViewController webViewController) =>
      _webViewController = webViewController;

  void goBack() {
    _webViewController?.goBack();
  }

  void goForward() {
    _webViewController?.goForward();
  }

  void reload() {
    _webViewController?.reload();
  }

  void loadUrl(String value) {
    var uri = Uri.parse(value);
    if (uri.scheme.isEmpty) {
      uri = Uri.parse("http://$value");
    }
    _webViewController?.loadUrl(urlRequest: URLRequest(url: uri));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

final browserWidgetControllerProvider = StateNotifierProvider.autoDispose
    .family<BrowserWidgetController, AsyncValue<void>, bool>(
        (ref, _) => BrowserWidgetController());
