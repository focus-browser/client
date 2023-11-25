import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget_state.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserWidgetController extends StateNotifier<BrowserWidgetState> {
  BrowserWidgetController(super.state);

  void setWebViewController(InAppWebViewController webViewController) {
    state = state.copyWith(
      webViewController: webViewController,
    );
  }

  void updateUrl(String value) {
    state = state.copyWith(
      currentUrl: value,
    );
  }

  void goBack() {
    state.webViewController?.goBack();
  }

  void goForward() {
    state.webViewController?.goForward();
  }

  void reload() {
    state.webViewController?.reload();
  }

  void loadUrl(String value) {
    var uri = Uri.parse(value);
    if (uri.scheme.isEmpty) {
      uri = Uri.parse("http://$value");
    }
    state.webViewController?.loadUrl(urlRequest: URLRequest(url: uri));
  }
}

final browserNumberProvider = Provider.autoDispose<int>((ref) {
  throw UnimplementedError();
});

final browserControllersProvider = StateNotifierProvider.family
    .autoDispose<BrowserWidgetController, BrowserWidgetState, int>((ref, _) {
  return BrowserWidgetController(
    const BrowserWidgetState(
      webViewController: null,
      currentUrl: '',
    ),
  );
});
