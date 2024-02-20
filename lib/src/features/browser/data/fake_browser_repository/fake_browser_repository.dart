import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/data/fake_browser_repository/fake_browser_repository_state.dart';
import 'package:focus_browser/src/utils/delay.dart';
import 'package:focus_browser/src/utils/in_memory_store.dart';

class FakeBrowserRepository implements BrowserRepository {
  FakeBrowserRepository({
    this.addDelay = true,
  });

  final InMemoryStore<Map<BrowserId, FakeBrowserRepositoryState>> _states =
      InMemoryStore(
    <BrowserId, FakeBrowserRepositoryState>{
      0: const FakeBrowserRepositoryState(),
    },
  );
  final bool addDelay;

  Stream<FakeBrowserRepositoryState> _navigateToIndex(
      FakeBrowserRepositoryState state, int index) async* {
    yield state.copyWith(
        currentUrl: state.history[index], index: index, loadingProgress: 0.3);
    await delay(addDelay);
    yield state.copyWith(
        currentUrl: state.history[index], index: index, loadingProgress: 1);
  }

  FakeBrowserRepositoryState _appendToHistory(
      FakeBrowserRepositoryState state, String url) {
    var history = state.history;
    // if (_index.value < _history.length - 1) {
    history.removeRange(state.index + 1, history.length);
    // }
    return state.copyWith(
      history: [...history, url],
    );
  }

  @override
  Future<BrowserId> createBrowser() async {
    const id = 1;
    _states.value = {
      ..._states.value,
      id: const FakeBrowserRepositoryState(),
    };
    return id;
  }

  @override
  Future<void> destroyBrowser(BrowserId id) async {
    _states.value = _states.value..remove(id);
  }

  @override
  Future<void> clearAllStates() async {
    _states.value = {
      0: const FakeBrowserRepositoryState(),
    };
  }

  @override
  Stream<void> watchClearedState() {
    return _states.stream.where(
        (states) => states[0]?.currentUrl == null && states[0]?.index == -1);
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
    final state = _states.value[id];
    if (state != null) {
      await for (final newState in _navigateToIndex(state, state.index - 1)) {
        _states.value = {
          ..._states.value,
          id: newState,
        };
      }
    }
  }

  @override
  Future<void> goForward(BrowserId id) async {
    final state = _states.value[id];
    if (state != null) {
      await for (final newState in _navigateToIndex(state, state.index + 1)) {
        _states.value = {
          ..._states.value,
          id: newState,
        };
      }
    }
  }

  @override
  Future<void> openUrl(BrowserId id, String url) async {
    final state = _states.value[id];
    if (state != null) {
      final updatedState = _appendToHistory(state, url);
      await for (final newState
          in _navigateToIndex(updatedState, updatedState.index + 1)) {
        _states.value = {
          ..._states.value,
          id: newState,
        };
      }
    }
  }

  @override
  Future<void> reload(BrowserId id) async {
    final state = _states.value[id];
    if (state != null) {
      await for (final newState in _navigateToIndex(state, state.index)) {
        _states.value = {
          ..._states.value,
          id: newState,
        };
      }
    }
  }

  @override
  Stream<bool> watchCanGoBack(BrowserId id) {
    return _states.stream
        .map((states) => states[id] ?? const FakeBrowserRepositoryState())
        .map((state) => state.index > 0);
  }

  @override
  Stream<bool> watchCanGoForward(BrowserId id) {
    return _states.stream
        .map((states) => states[id] ?? const FakeBrowserRepositoryState())
        .map((state) => state.index < state.history.length - 2);
  }

  @override
  Stream<bool> watchCanReload(BrowserId id) {
    return _states.stream
        .map((states) => states[id] ?? const FakeBrowserRepositoryState())
        .map((state) => state.index >= 0);
  }

  @override
  Stream<String?> watchCurrentUrl(BrowserId id) {
    return _states.stream.map((states) => states[id]?.currentUrl);
  }

  @override
  Stream<double> watchProgress(BrowserId id) {
    return _states.stream.map((states) => states[id]?.loadingProgress ?? 0);
  }

  void dispose() {
    _states.close();
  }
}

final fakeBrowserRepositoryProvider = Provider<FakeBrowserRepository>((ref) {
  final repo = FakeBrowserRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});
