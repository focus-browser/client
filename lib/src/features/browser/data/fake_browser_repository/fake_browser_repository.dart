import 'package:bouser/src/features/browser/data/browser_repository.dart';
import 'package:bouser/src/features/browser/data/fake_browser_repository/fake_browser_repository_state.dart';
import 'package:bouser/src/utils/delay.dart';
import 'package:bouser/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeBrowserRepository implements BrowserRepository {
  FakeBrowserRepository({
    this.addDelay = true,
  });

  final InMemoryStore<Map<BrowserId, FakeBrowserRepositoryState>> _states =
      InMemoryStore(
    <BrowserId, FakeBrowserRepositoryState>{},
  );
  final bool addDelay;

  Future<FakeBrowserRepositoryState> _navigateToIndex(
      FakeBrowserRepositoryState state, int index) async {
    await delay(addDelay);
    return state.copyWith(currentUrl: state.history[index], index: index);
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
  BrowserId createBrowser() {
    final id = _states.value.isEmpty ? 0 : 1;
    _states.value = {
      ..._states.value,
      id: const FakeBrowserRepositoryState(),
    };
    return id;
  }

  @override
  Future<String?> fetchCurrentUrl(BrowserId id) async {
    return _states.value[id]?.currentUrl;
  }

  @override
  Future<void> goBack(BrowserId id) async {
    final state = _states.value[id];
    if (state != null) {
      _states.value = {
        ..._states.value,
        id: await _navigateToIndex(state, state.index - 1),
      };
    }
  }

  @override
  Future<void> goForward(BrowserId id) async {
    final state = _states.value[id];
    if (state != null) {
      _states.value = {
        ..._states.value,
        id: await _navigateToIndex(state, state.index + 1),
      };
    }
  }

  @override
  Future<void> openUrl(BrowserId id, String url) async {
    final state = _states.value[id];
    if (state != null) {
      final newState = _appendToHistory(state, url);
      _states.value = {
        ..._states.value,
        id: await _navigateToIndex(newState, newState.index + 1),
      };
    }
  }

  @override
  Future<void> reload(BrowserId id) async {
    final state = _states.value[id];
    if (state != null) {
      _states.value = {
        ..._states.value,
        id: await _navigateToIndex(state, state.index),
      };
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

  void dispose() {
    _states.close();
  }
}

final fakeBrowserRepositoryProvider = Provider<FakeBrowserRepository>((ref) {
  final repo = FakeBrowserRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});
