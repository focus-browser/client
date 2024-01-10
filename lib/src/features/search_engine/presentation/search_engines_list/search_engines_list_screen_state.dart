import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchEnginesListScreenState {
  SearchEnginesListScreenState({
    required this.isEditing,
    required this.value,
  });

  final bool isEditing;
  final AsyncValue<SearchEngineId?> value;

  @override
  bool operator ==(covariant SearchEnginesListScreenState other) {
    if (identical(this, other)) return true;

    return other.isEditing == isEditing && other.value == value;
  }

  @override
  int get hashCode => isEditing.hashCode ^ value.hashCode;

  SearchEnginesListScreenState copyWith({
    bool? isEditing,
    AsyncValue<SearchEngineId?>? value,
  }) {
    return SearchEnginesListScreenState(
      isEditing: isEditing ?? this.isEditing,
      value: value ?? this.value,
    );
  }

  @override
  String toString() =>
      'SearchEnginesListScreenState(isEditing: $isEditing, selectedSearchEngineId: $value)';
}
