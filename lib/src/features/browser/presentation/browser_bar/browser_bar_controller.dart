// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserBarController extends StateNotifier<BrowserBarState> {
  BrowserBarController({
    required BrowserBarState barState,
  }) : super(barState);

  void toggleBarVisibility() {
    state = state.copyWith(
      isBarVisible: !state.isBarVisible,
    );
  }

  void toggleSelectedBrowser() {
    state = state.copyWith(
      isTopBrowserSelected: !state.isTopBrowserSelected,
    );
  }
}

final browserBarControllerProvider =
    StateNotifierProvider<BrowserBarController, BrowserBarState>((ref) {
  return BrowserBarController(
    barState: const BrowserBarState(
      isBarVisible: true,
      isTopBrowserSelected: true,
    ),
  );
});
