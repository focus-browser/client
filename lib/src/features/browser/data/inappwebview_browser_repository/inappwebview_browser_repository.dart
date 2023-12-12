import 'package:bouser/src/features/browser/data/browser_repository.dart';
import 'package:bouser/src/features/browser/data/inappwebview_browser_repository/inappwebview_browser_repository_state.dart';
import 'package:bouser/src/utils/in_memory_store.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InAppWebViewBrowserRepository extends BrowserRepository {
  final _states =
      InMemoryStore<Map<BrowserId, InAppWebViewBrowserRepositoryState>>(
    <BrowserId, InAppWebViewBrowserRepositoryState>{
      0: const InAppWebViewBrowserRepositoryState(),
    },
  );

  @override
  Future<BrowserId> createBrowser() async {
    const id = 1;
    _states.value = {
      ..._states.value,
      id: const InAppWebViewBrowserRepositoryState(),
    };
    return id;
  }

  @override
  Future<void> destroyBrowser(BrowserId id) async {
    _states.value = _states.value..remove(id);
  }

  @override
  Stream<List<BrowserId>> watchBrowsers() {
    return _states.stream.map((states) => states.keys.toList());
  }

  @override
  Future<String?> fetchCurrentUrl(BrowserId id) async {
    return _states.value[id]?.currentUrl;
  }

  @override
  Future<void> goBack(BrowserId id) async {
    _states.value[id]?.webViewController?.goBack();
  }

  @override
  Future<void> goForward(BrowserId id) async {
    _states.value[id]?.webViewController?.goForward();
  }

  @override
  Future<void> openUrl(BrowserId id, String url) async {
    var uri = Uri.parse(url);
    if (uri.scheme.isEmpty) {
      uri = Uri.parse("http://$url");
    }
    _states.value[id]?.webViewController
        ?.loadUrl(urlRequest: URLRequest(url: uri));
  }

  @override
  Future<void> reload(BrowserId id) async {
    _states.value[id]?.webViewController?.reload();
  }

  @override
  Stream<bool> watchCanGoBack(BrowserId id) {
    return _states.stream.asyncMap((states) =>
        states[id]?.webViewController?.canGoBack() ?? Future.value(false));
  }

  @override
  Stream<bool> watchCanGoForward(BrowserId id) {
    return _states.stream.asyncMap((states) =>
        states[id]?.webViewController?.canGoForward() ?? Future.value(false));
  }

  @override
  Stream<bool> watchCanReload(BrowserId id) {
    return _states.stream.asyncMap((states) => states[id]?.currentUrl != null);
  }

  @override
  Stream<String?> watchCurrentUrl(BrowserId id) {
    return _states.stream.asyncMap((states) => states[id]?.currentUrl);
  }

  void setController(BrowserId id, InAppWebViewController webViewController) {
    final state = _states.value[id];
    if (state != null) {
      _states.value = {
        ..._states.value,
        id: state.copyWith(webViewController: webViewController),
      };
    }
  }

  void updateCurrentUrl(BrowserId id, Uri? value) {
    final state = _states.value[id];
    if (state != null) {
      _states.value = {
        ..._states.value,
        id: state.copyWith(currentUrl: value.toString()),
      };
    }
  }

  void dispose() {
    _states.close();
  }
}

final inAppWebViewBrowserRepositoryProvider =
    Provider<InAppWebViewBrowserRepository>((ref) {
  final repo = InAppWebViewBrowserRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});
