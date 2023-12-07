import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchEnginesListScreenState {
  SearchEnginesListScreenState({
    required this.isEditing,
    required this.selectedSearchEngineId,
  });

  final bool isEditing;
  final AsyncValue<SearchEngineId?> selectedSearchEngineId;

  @override
  bool operator ==(covariant SearchEnginesListScreenState other) {
    if (identical(this, other)) return true;

    return other.isEditing == isEditing &&
        other.selectedSearchEngineId == selectedSearchEngineId;
  }

  @override
  int get hashCode => isEditing.hashCode ^ selectedSearchEngineId.hashCode;

  SearchEnginesListScreenState copyWith({
    bool? isEditing,
    AsyncValue<SearchEngineId?>? selectedSearchEngineId,
  }) {
    return SearchEnginesListScreenState(
      isEditing: isEditing ?? this.isEditing,
      selectedSearchEngineId:
          selectedSearchEngineId ?? this.selectedSearchEngineId,
    );
  }

  @override
  String toString() =>
      'SearchEnginesListScreenState(isEditing: $isEditing, selectedSearchEngineId: $selectedSearchEngineId)';
}
