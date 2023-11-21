import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_state.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserBarController extends StateNotifier<BrowserBarState> {
  BrowserBarController(super.state);

  void toggleBarVisibility() {
    state = state.copyWith(
      isBarVisible: !state.isBarVisible,
    );
  }

  void toggleSelectedBrowser() {
    state = state.copyWith(
      isPrimaryBrowserWidgetSelected: !state.isPrimaryBrowserWidgetSelected,
    );
  }
}

final browserBarControllerProvider =
    StateNotifierProvider.autoDispose<BrowserBarController, BrowserBarState>(
  (ref) {
    return BrowserBarController(
      const BrowserBarState(
        isBarVisible: true,
        isPrimaryBrowserWidgetSelected: true,
      ),
    );
  },
);

final isBarVisibleProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(browserBarControllerProvider).isBarVisible;
});

final isPrimaryBrowserSelectedProvider = Provider.autoDispose<bool>((ref) {
  final browserSplitState = ref.watch(browserSplitProvider);
  if (browserSplitState == BrowserSplitState.none) {
    return true;
  }
  return ref.watch(browserBarControllerProvider).isPrimaryBrowserWidgetSelected;
});

final selectedBrowserControllerProvider =
    Provider.autoDispose<BrowserWidgetController>((ref) {
  final isPrimaryBrowserSelected = ref.watch(isPrimaryBrowserSelectedProvider);
  return ref.watch(
      browserWidgetsControllersProvider(isPrimaryBrowserSelected).notifier);
});

final selectedBrowserStateProvider =
    Provider.autoDispose<BrowserWidgetState>((ref) {
  final isPrimaryBrowserSelected = ref.watch(isPrimaryBrowserSelectedProvider);
  return ref.watch(browserWidgetsControllersProvider(isPrimaryBrowserSelected));
});

final selectedBrowserCurrentUrlProvider = Provider.autoDispose<String>((ref) {
  return ref.watch(selectedBrowserStateProvider).currentUrl;
});
