import 'package:flutter/foundation.dart';

enum BrowserSplitState {
  none,
  horizontal,
  vertical,
}

@immutable
class BrowserScreenState {
  const BrowserScreenState({
    required this.split,
    required this.secondaryBrowserWidgetSize,
  });

  final BrowserSplitState split;
  final double secondaryBrowserWidgetSize;

  BrowserScreenState copyWith({
    BrowserSplitState? split,
    double? secondaryBrowserWidgetSize,
  }) {
    return BrowserScreenState(
      split: split ?? this.split,
      secondaryBrowserWidgetSize:
          secondaryBrowserWidgetSize ?? this.secondaryBrowserWidgetSize,
    );
  }
}
