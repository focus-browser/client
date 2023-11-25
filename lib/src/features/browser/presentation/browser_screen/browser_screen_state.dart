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
    required this.isPrimaryBrowserSelected,
  });

  final BrowserSplitState split;
  final double secondaryBrowserWidgetSize;
  final bool isPrimaryBrowserSelected;

  BrowserScreenState copyWith({
    BrowserSplitState? split,
    double? secondaryBrowserWidgetSize,
    bool? isPrimaryBrowserSelected,
  }) {
    return BrowserScreenState(
      split: split ?? this.split,
      secondaryBrowserWidgetSize:
          secondaryBrowserWidgetSize ?? this.secondaryBrowserWidgetSize,
      isPrimaryBrowserSelected:
          isPrimaryBrowserSelected ?? this.isPrimaryBrowserSelected,
    );
  }
}
