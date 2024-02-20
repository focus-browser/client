import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BrowserId = int;

abstract class BrowserRepository {
  Future<BrowserId> createBrowser();
  Future<void> destroyBrowser(BrowserId id);
  Future<void> clearAllStates();
  Stream<void> watchClearedState();
  Future<void> goBack(BrowserId id);
  Future<void> goForward(BrowserId id);
  Future<void> openUrl(BrowserId id, String url);
  Future<void> reload(BrowserId id);
  Stream<List<BrowserId>> watchBrowsers();
  Future<String?> fetchCurrentUrl(BrowserId id);
  Stream<String?> watchCurrentUrl(BrowserId id);
  Stream<double> watchProgress(BrowserId id);
  Stream<bool> watchCanGoBack(BrowserId id);
  Stream<bool> watchCanGoForward(BrowserId id);
  Stream<bool> watchCanReload(BrowserId id);
}

final browserRepositoryProvider = Provider<BrowserRepository>(
  (ref) => throw UnimplementedError(),
);

final browserIdsProvider = StreamProvider.autoDispose<List<BrowserId>>((ref) {
  return ref.watch(browserRepositoryProvider).watchBrowsers();
});

final browserClearedStatesProvider = StreamProvider.autoDispose<void>((ref) {
  return ref.watch(browserRepositoryProvider).watchClearedState();
});

final browserCurrentUrlProvider =
    StreamProvider.family.autoDispose<String?, BrowserId>(
  (ref, id) => ref.watch(browserRepositoryProvider).watchCurrentUrl(id),
);

final browserProgressProvider = StreamProvider.family<double, BrowserId>(
  (ref, id) => ref.watch(browserRepositoryProvider).watchProgress(id),
);

final browserCanGoBackProvider =
    StreamProvider.family.autoDispose<bool, BrowserId>(
  (ref, id) => ref.watch(browserRepositoryProvider).watchCanGoBack(id),
);

final browserCanGoForwardProvider =
    StreamProvider.family.autoDispose<bool, BrowserId>(
  (ref, id) => ref.watch(browserRepositoryProvider).watchCanGoForward(id),
);

final browserCanReloadProvider =
    StreamProvider.family.autoDispose<bool, BrowserId>(
  (ref, id) => ref.watch(browserRepositoryProvider).watchCanReload(id),
);
