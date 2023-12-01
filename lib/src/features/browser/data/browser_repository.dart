import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BrowserId = int;

abstract class BrowserRepository {
  BrowserId createBrowser();
  Future<void> goBack(BrowserId id);
  Future<void> goForward(BrowserId id);
  Future<void> openUrl(BrowserId id, String url);
  Future<void> reload(BrowserId id);
  Stream<String?> watchCurrentUrl(BrowserId id);
  Stream<bool> watchCanGoBack(BrowserId id);
  Stream<bool> watchCanGoForward(BrowserId id);
  Stream<bool> watchCanReload(BrowserId id);
}

final browserRepositoryProvider = Provider<BrowserRepository>(
  (ref) => throw UnimplementedError(),
);

final browserCurrentUrlProvider = StreamProvider.family<String?, BrowserId>(
  (ref, id) => ref.watch(browserRepositoryProvider).watchCurrentUrl(id),
);
