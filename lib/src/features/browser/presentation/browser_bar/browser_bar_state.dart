import 'package:flutter/foundation.dart';

@immutable
class BrowserBarState {
  const BrowserBarState({
    required this.isBarVisible,
    required this.isPrimaryBrowserWidgetSelected,
  });

  final bool isBarVisible;
  final bool isPrimaryBrowserWidgetSelected;

  BrowserBarState copyWith({
    bool? isBarVisible,
    bool? isPrimaryBrowserWidgetSelected,
  }) {
    return BrowserBarState(
      isBarVisible: isBarVisible ?? this.isBarVisible,
      isPrimaryBrowserWidgetSelected:
          isPrimaryBrowserWidgetSelected ?? this.isPrimaryBrowserWidgetSelected,
    );
  }
}
