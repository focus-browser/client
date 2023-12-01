import 'package:flutter/foundation.dart';

@immutable
class FakeBrowserRepositoryState {
  const FakeBrowserRepositoryState({
    this.currentUrl,
    this.history = const <String>[],
    this.index = -1,
  });

  final String? currentUrl;
  final List<String> history;
  final int index;

  @override
  bool operator ==(covariant FakeBrowserRepositoryState other) {
    if (identical(this, other)) return true;

    return other.currentUrl == currentUrl &&
        listEquals(other.history, history) &&
        other.index == index;
  }

  @override
  int get hashCode => currentUrl.hashCode ^ history.hashCode ^ index.hashCode;

  @override
  String toString() =>
      'FakeBrowserRepositoryState(currentUrl: $currentUrl, history: $history, index: $index)';

  FakeBrowserRepositoryState copyWith({
    String? currentUrl,
    List<String>? history,
    int? index,
  }) {
    return FakeBrowserRepositoryState(
      currentUrl: currentUrl ?? this.currentUrl,
      history: history ?? this.history,
      index: index ?? this.index,
    );
  }
}
