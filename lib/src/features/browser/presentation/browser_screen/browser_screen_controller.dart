import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserScreenController extends StateNotifier<BrowserScreenState> {
  BrowserScreenController(super.state);

  void toggleSplitOrientation() {
    state = state.copyWith(
      split: state.split == BrowserSplitState.vertical
          ? BrowserSplitState.horizontal
          : BrowserSplitState.vertical,
    );
  }

  void adjustWidgetSize(double dx, double dy) {
    final delta = state.split == BrowserSplitState.horizontal ? dx : dy;
    state = state.copyWith(
      secondaryBrowserWidgetSize: state.secondaryBrowserWidgetSize - delta,
    );
  }
}

final browserScreenControllerProvider = StateNotifierProvider.autoDispose<
    BrowserScreenController, BrowserScreenState>((ref) {
  return BrowserScreenController(
    const BrowserScreenState(
      secondaryBrowserWidgetSize: 100.0,
    ),
  );
});

final browserSplitProvider = Provider.autoDispose<BrowserSplitState>((ref) {
  return ref.watch(browserScreenControllerProvider).split;
});

final secondaryBrowserWidgetSizeProvider = Provider.autoDispose<double>((ref) {
  return ref.watch(browserScreenControllerProvider).secondaryBrowserWidgetSize;
});
