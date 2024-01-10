import 'package:focus_browser/src/constants/default_search_engines.dart';
import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultSearchEnginesRepository {
  Map<SearchEngineId, SearchEngine> get searchEngines => kDefaultSearchEngines;
}

final defaultSearchEnginesRepositoryProvider =
    Provider<DefaultSearchEnginesRepository>((ref) {
  return DefaultSearchEnginesRepository();
});

final defaultSearchEnginesProvider =
    Provider<Map<SearchEngineId, SearchEngine>>((ref) =>
        ref.watch(defaultSearchEnginesRepositoryProvider).searchEngines);
