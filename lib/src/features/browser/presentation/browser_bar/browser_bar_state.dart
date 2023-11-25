import 'package:flutter/foundation.dart';

@immutable
class BrowserBarState {
  const BrowserBarState({
    required this.isVisible,
  });

  final bool isVisible;

  BrowserBarState copyWith({
    bool? isVisible,
  }) {
    return BrowserBarState(
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  bool operator ==(covariant BrowserBarState other) {
    if (identical(this, other)) return true;

    return other.isVisible == isVisible;
  }

  @override
  int get hashCode => isVisible.hashCode;
}
