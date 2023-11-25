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
    required this.isPrimaryBrowserSwapped,
  });

  final BrowserSplitState split;
  final double secondaryBrowserWidgetSize;
  final bool isPrimaryBrowserSelected;
  final bool isPrimaryBrowserSwapped;

  BrowserScreenState copyWith({
    BrowserSplitState? split,
    double? secondaryBrowserWidgetSize,
    bool? isPrimaryBrowserSelected,
    bool? isPrimaryBrowserSwapped,
  }) {
    return BrowserScreenState(
      split: split ?? this.split,
      secondaryBrowserWidgetSize:
          secondaryBrowserWidgetSize ?? this.secondaryBrowserWidgetSize,
      isPrimaryBrowserSelected:
          isPrimaryBrowserSelected ?? this.isPrimaryBrowserSelected,
      isPrimaryBrowserSwapped:
          isPrimaryBrowserSwapped ?? this.isPrimaryBrowserSwapped,
    );
  }

  @override
  bool operator ==(covariant BrowserScreenState other) {
    if (identical(this, other)) return true;

    return other.split == split &&
        other.secondaryBrowserWidgetSize == secondaryBrowserWidgetSize &&
        other.isPrimaryBrowserSelected == isPrimaryBrowserSelected &&
        other.isPrimaryBrowserSwapped == isPrimaryBrowserSwapped;
  }

  @override
  int get hashCode {
    return split.hashCode ^
        secondaryBrowserWidgetSize.hashCode ^
        isPrimaryBrowserSelected.hashCode ^
        isPrimaryBrowserSwapped.hashCode;
  }
}
