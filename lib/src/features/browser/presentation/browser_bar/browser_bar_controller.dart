import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserBarController extends StateNotifier<BrowserBarState> {
  BrowserBarController(super.state);

  void toggleBarVisibility() {
    state = state.copyWith(
      isVisible: !state.isVisible,
    );
  }
}

final browserBarControllerProvider =
    StateNotifierProvider.autoDispose<BrowserBarController, BrowserBarState>(
  (ref) {
    return BrowserBarController(
      const BrowserBarState(
        isVisible: true,
      ),
    );
  },
);

final isBarVisibleProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(browserBarControllerProvider).isVisible;
});
