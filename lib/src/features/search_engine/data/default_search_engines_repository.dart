import 'package:bouser/src/constants/default_search_engines.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultSearchEnginesRepository {
  final _searchEngines = {
    for (var searchEngine in kDefaultSearchEngines)
      searchEngine.id: searchEngine
  };

  Map<SearchEngineId, SearchEngine> get searchEngines => _searchEngines;
}

final defaultSearchEnginesRepositoryProvider =
    Provider<DefaultSearchEnginesRepository>((ref) {
  return DefaultSearchEnginesRepository();
});

final defaultSearchEnginesProvider =
    Provider<Map<SearchEngineId, SearchEngine>>((ref) =>
        ref.watch(defaultSearchEnginesRepositoryProvider).searchEngines);
