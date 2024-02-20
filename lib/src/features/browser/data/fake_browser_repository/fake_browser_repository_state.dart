import 'package:flutter/foundation.dart';

@immutable
class FakeBrowserRepositoryState {
  const FakeBrowserRepositoryState({
    this.currentUrl,
    this.loadingProgress = 1.0,
    this.history = const <String>[],
    this.index = -1,
  });

  final String? currentUrl;
  final double loadingProgress;
  final List<String> history;
  final int index;

  @override
  bool operator ==(covariant FakeBrowserRepositoryState other) {
    if (identical(this, other)) return true;

    return other.currentUrl == currentUrl &&
        other.loadingProgress == loadingProgress &&
        listEquals(other.history, history) &&
        other.index == index;
  }

  @override
  int get hashCode {
    return currentUrl.hashCode ^
        loadingProgress.hashCode ^
        history.hashCode ^
        index.hashCode;
  }

  @override
  String toString() {
    return 'FakeBrowserRepositoryState(currentUrl: $currentUrl, loadingProgress: $loadingProgress, history: $history, index: $index)';
  }

  FakeBrowserRepositoryState copyWith({
    String? currentUrl,
    double? loadingProgress,
    List<String>? history,
    int? index,
  }) {
    return FakeBrowserRepositoryState(
      currentUrl: currentUrl ?? this.currentUrl,
      loadingProgress: loadingProgress ?? this.loadingProgress,
      history: history ?? this.history,
      index: index ?? this.index,
    );
  }
}
