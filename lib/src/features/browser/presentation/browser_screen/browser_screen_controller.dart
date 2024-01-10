import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserScreenController extends StateNotifier<BrowserScreenState> {
  BrowserScreenController(
    super.state, {
    required this.browserRepository,
  });

  final BrowserRepository browserRepository;

  void toggleSplitMode() async {
    if (state.split == BrowserSplitState.none) {
      await browserRepository.createBrowser();
      state = state.copyWith(
        split: BrowserSplitState.vertical,
        isPrimaryBrowserSelected: false,
      );
    } else {
      await browserRepository.destroyBrowser(1);
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

  void setSelectedBrowser(BrowserId browserNumber) {
    if (state.split != BrowserSplitState.none) {
      state = state.copyWith(
        isPrimaryBrowserSelected:
            browserNumber == (state.isPrimaryBrowserSwapped ? 1 : 0),
      );
    }
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
  ref.watch(browserClearedStatesProvider);
  return BrowserScreenController(
    const BrowserScreenState(
      split: BrowserSplitState.none,
      secondaryBrowserWidgetSize: 100.0,
      isPrimaryBrowserSelected: true,
      isPrimaryBrowserSwapped: false,
    ),
    browserRepository: ref.watch(browserRepositoryProvider),
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
