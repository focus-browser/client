import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserScreenController extends StateNotifier<BrowserScreenState> {
  BrowserScreenController(super.state);

  void toggleSplitMode() {
    if (state.split == BrowserSplitState.none) {
      state = state.copyWith(
        split: BrowserSplitState.vertical,
        isPrimaryBrowserSelected: false,
      );
    } else {
      state = state.copyWith(
        split: BrowserSplitState.none,
        isPrimaryBrowserSelected: true,
        isPrimaryBrowserSwapped: false,
      );
    }
  }

  void toggleSplitOrientation() {
    state = state.copyWith(
      split: state.split == BrowserSplitState.vertical
          ? BrowserSplitState.horizontal
          : BrowserSplitState.vertical,
    );
  }

  void toggleSelectedBrowser() {
    state = state.copyWith(
      isPrimaryBrowserSelected: !state.isPrimaryBrowserSelected,
    );
  }

  void toggleSwappedBrowser() {
    state = state.copyWith(
      isPrimaryBrowserSwapped: !state.isPrimaryBrowserSwapped,
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
      split: BrowserSplitState.none,
      secondaryBrowserWidgetSize: 100.0,
      isPrimaryBrowserSelected: true,
      isPrimaryBrowserSwapped: false,
    ),
  );
});

final screenSplitProvider = Provider.autoDispose<BrowserSplitState>((ref) {
  return ref.watch(browserScreenControllerProvider).split;
});

final secondaryBrowserWidgetSizeProvider = Provider.autoDispose<double>((ref) {
  return ref.watch(browserScreenControllerProvider).secondaryBrowserWidgetSize;
});

final isPrimaryBrowserSelectedProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(browserScreenControllerProvider).isPrimaryBrowserSelected;
});

final isPrimaryBrowserSwappedProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(browserScreenControllerProvider).isPrimaryBrowserSwapped;
});

final selectedBrowserNumberProvider = Provider.autoDispose<int>((ref) {
  final isPrimaryBrowserSelected = ref.watch(isPrimaryBrowserSelectedProvider);
  final primarySecondaryBrowserSwapped =
      ref.watch(isPrimaryBrowserSwappedProvider);
  return isPrimaryBrowserSelected ^ primarySecondaryBrowserSwapped ? 0 : 1;
});
