import 'package:flutter/foundation.dart';

@immutable
class BrowserBarState {
  const BrowserBarState({
    required this.isBarVisible,
    required this.isTopBrowserSelected,
  });

  final bool isBarVisible;
  final bool isTopBrowserSelected;

  BrowserBarState copyWith({
    bool? isBarVisible,
    bool? isTopBrowserSelected,
  }) {
    return BrowserBarState(
      isBarVisible: isBarVisible ?? this.isBarVisible,
      isTopBrowserSelected: isTopBrowserSelected ?? this.isTopBrowserSelected,
    );
  }
}
