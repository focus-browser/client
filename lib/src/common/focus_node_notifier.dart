import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusNodeNotifier extends StateNotifier<bool> {
  FocusNodeNotifier({
    required this.focusNode,
  }) : super(focusNode.hasFocus) {
    focusNode.addListener(updateState);
  }

  final FocusNode focusNode;

  updateState() {
    state = focusNode.hasFocus;
  }

  @override
  void dispose() {
    focusNode.removeListener(updateState);
    super.dispose();
  }
}
