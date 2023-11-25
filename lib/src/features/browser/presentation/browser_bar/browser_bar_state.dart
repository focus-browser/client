import 'package:flutter/foundation.dart';

@immutable
class BrowserBarState {
  const BrowserBarState({
    required this.isBarVisible,
  });

  final bool isBarVisible;

  BrowserBarState copyWith({
    bool? isBarVisible,
  }) {
    return BrowserBarState(
      isBarVisible: isBarVisible ?? this.isBarVisible,
    );
  }
}
