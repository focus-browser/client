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

  @override
  bool operator ==(covariant BrowserBarState other) {
    if (identical(this, other)) return true;

    return other.isBarVisible == isBarVisible;
  }

  @override
  int get hashCode => isBarVisible.hashCode;
}
