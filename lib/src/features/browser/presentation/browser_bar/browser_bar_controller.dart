import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_bar/browser_bar_state.dart';
import 'package:focus_browser/src/features/search_engine/application/search_engine_service.dart';
import 'package:focus_browser/src/features/share/application/share_service.dart';
import 'package:focus_browser/src/utils/web_utils.dart';

class BrowserBarController extends StateNotifier<BrowserBarState> {
  BrowserBarController({
    required BrowserBarState state,
    required this.searchEngineService,
    required this.shareService,
    required this.browserRepository,
  }) : super(state);

  final SearchEngineService searchEngineService;
  final ShareService shareService;
  final BrowserRepository browserRepository;

  void toggleBarVisibility() {
    state = state.copyWith(
      isVisible: !state.isVisible,
    );
  }

  Future<void> search(BrowserId id, String input) async {
    if (!isWebAddress(input)) {
      input = await searchEngineService.renderSearchUrl(input);
    }
    return browserRepository.openUrl(id, input);
  }

  Future<void> shareCurrentUrl(BrowserId id,
      [Rect? sharePositionOrigin]) async {
    await shareService.shareCurrentUrl(id, sharePositionOrigin);
  }

  void clearBrowserState() {
    browserRepository.clearAllStates();
  }
}

final browserBarControllerProvider =
    StateNotifierProvider.autoDispose<BrowserBarController, BrowserBarState>(
  (ref) {
    return BrowserBarController(
      state: const BrowserBarState(
        isVisible: true,
      ),
      searchEngineService: ref.watch(searchEngineServiceProvider),
      shareService: ref.watch(shareServiceProvider),
      browserRepository: ref.watch(browserRepositoryProvider),
    );
  },
);

final isBarVisibleProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(browserBarControllerProvider).isVisible;
});
