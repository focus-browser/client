import 'package:bouser/src/features/browser/data/browser_repository.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_state.dart';
import 'package:bouser/src/features/search_engine/application/search_engine_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserBarController extends StateNotifier<BrowserBarState> {
  BrowserBarController({
    required BrowserBarState state,
    required this.searchEngineService,
  }) : super(state);

  final SearchEngineService searchEngineService;

  void toggleBarVisibility() {
    state = state.copyWith(
      isVisible: !state.isVisible,
    );
  }

  Future<void> search(BrowserId id, String input) async {
    await searchEngineService.search(id, input);
  }
}

final browserBarControllerProvider =
    StateNotifierProvider.autoDispose<BrowserBarController, BrowserBarState>(
  (ref) {
    final searchEngineService = ref.watch(searchEngineServiceProvider);
    return BrowserBarController(
      state: const BrowserBarState(
        isVisible: true,
      ),
      searchEngineService: searchEngineService,
    );
  },
);

final isBarVisibleProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(browserBarControllerProvider).isVisible;
});
