import 'package:bouser/src/features/search_engine/application/search_engine_service.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchEnginesListScreenController
    extends StateNotifier<AsyncValue<SearchEngineId?>> {
  SearchEnginesListScreenController({required this.searchEngineService})
      : super(const AsyncData(null));

  final SearchEngineService searchEngineService;

  Future<void> setUserSearchEngine(SearchEngineId id) async {
    state =
        const AsyncLoading<SearchEngineId?>().copyWithPrevious(AsyncData(id));
    state = await AsyncValue.guard(() async {
      final success = await searchEngineService.setUserSearchEngine(id);
      return success
          ? null
          : throw Exception('Failed to set user search engine'.hardcoded);
    });
  }
}

final searchEnginesListScreenControllerProvider = StateNotifierProvider<
    SearchEnginesListScreenController, AsyncValue<SearchEngineId?>>((ref) {
  return SearchEnginesListScreenController(
    searchEngineService: ref.watch(searchEngineServiceProvider),
  );
});
