import 'package:bouser/src/features/search_engine/application/search_engine_service.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/features/search_engine/presentation/search_engines_list/search_engines_list_screen_state.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchEnginesListScreenController
    extends StateNotifier<SearchEnginesListScreenState> {
  SearchEnginesListScreenController({required this.searchEngineService})
      : super(SearchEnginesListScreenState(
          isEditing: false,
          selectedSearchEngineId: const AsyncData(null),
        ));

  final SearchEngineService searchEngineService;

  Future<void> setUserSearchEngine(SearchEngineId id) async {
    final loading =
        const AsyncLoading<SearchEngineId?>().copyWithPrevious(AsyncData(id));
    state = state.copyWith(selectedSearchEngineId: loading);

    final value = await AsyncValue.guard(() async {
      final success = await searchEngineService.setUserSearchEngine(id);
      return success
          ? null
          : throw Exception('Failed to set user search engine'.hardcoded);
    });
    state = state.copyWith(selectedSearchEngineId: value);
  }

  Future<void> toggleEditing() async {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  Future<bool> removeSearchEngine(SearchEngine searchEngine) async {
    final loading = const AsyncLoading<SearchEngineId?>()
        .copyWithPrevious(AsyncData(searchEngine.id));
    state = state.copyWith(selectedSearchEngineId: loading);
    final value = await AsyncValue.guard(() async {
      final success =
          await searchEngineService.removeSearchEngine(searchEngine);
      return success
          ? null
          : throw Exception('Failed to remove search engine'.hardcoded);
    });
    state = state.copyWith(selectedSearchEngineId: value);
    return !value.hasError;
  }
}

final searchEnginesListScreenControllerProvider =
    StateNotifierProvider.autoDispose<SearchEnginesListScreenController,
        SearchEnginesListScreenState>((ref) {
  return SearchEnginesListScreenController(
    searchEngineService: ref.watch(searchEngineServiceProvider),
  );
});
