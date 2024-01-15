import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/features/search_engine/data/default_search_engines_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';

class SearchEngineService {
  SearchEngineService({
    required this.userSearchEngineRepository,
    required this.searchEnginesRepository,
    required this.defaultSearchEnginesRepository,
  });

  final UserSearchEngineRepository userSearchEngineRepository;
  final SearchEnginesRepository searchEnginesRepository;
  final DefaultSearchEnginesRepository defaultSearchEnginesRepository;

  Future<String> renderSearchUrl(String input) async {
    final userSearchEngineId =
        await userSearchEngineRepository.fetchUserSearchEngineId();
    final defaultEngines = defaultSearchEnginesRepository.searchEngines;
    final customEngines = await searchEnginesRepository.fetchSearchEngines();
    final allEngines = {...defaultEngines, ...customEngines};
    final userSearchEngine =
        allEngines[userSearchEngineId] ?? defaultEngines.values.first;

    return userSearchEngine.urlTemplate.replaceAll('%s', input);
  }

  Future<bool> setUserSearchEngine(SearchEngineId id) {
    return userSearchEngineRepository.setUserSearchEngineId(id);
  }

  Future<SearchEngineId?> addSearchEngine(String name, String urlTemplate) {
    return searchEnginesRepository.addSearchEngine(
      SearchEngine(
        name: name,
        urlTemplate: urlTemplate,
      ),
    );
  }

  Future<bool> removeSearchEngine(SearchEngineId searchEngineId) async {
    final userSearchEngineId =
        await userSearchEngineRepository.fetchUserSearchEngineId();
    if (searchEngineId == userSearchEngineId) {
      final success = await setUserSearchEngine(
          defaultSearchEnginesRepository.searchEngines.keys.first);
      if (!success) {
        return false;
      }
    }
    return searchEnginesRepository.removeSearchEngine(searchEngineId);
  }
}

final searchEngineServiceProvider = Provider<SearchEngineService>((ref) {
  return SearchEngineService(
    userSearchEngineRepository: ref.watch(userSearchEngineRepositoryProvider),
    searchEnginesRepository: ref.watch(searchEnginesRepositoryProvider),
    defaultSearchEnginesRepository:
        ref.watch(defaultSearchEnginesRepositoryProvider),
  );
});
