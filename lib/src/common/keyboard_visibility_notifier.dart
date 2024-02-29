import 'dart:async';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyboardVisibilityNotifier extends StateNotifier<bool> {
  KeyboardVisibilityNotifier({
    required this.keyboardVisibilityController,
  }) : super(keyboardVisibilityController.isVisible) {
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((visible) {
      state = visible;
    });
  }

  final KeyboardVisibilityController keyboardVisibilityController;
  late final StreamSubscription<bool> keyboardSubscription;

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}

final keyboardVisibilityProvider =
    StateNotifierProvider.autoDispose<KeyboardVisibilityNotifier, bool>((ref) {
  final keyboardVisibilityNotifier = KeyboardVisibilityNotifier(
    keyboardVisibilityController: KeyboardVisibilityController(),
  );
  return keyboardVisibilityNotifier;
});
