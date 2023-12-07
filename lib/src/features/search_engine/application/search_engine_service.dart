import 'package:bouser/src/features/browser/data/browser_repository.dart';
import 'package:bouser/src/features/search_engine/data/default_search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/utils/web_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchEngineService {
  SearchEngineService({
    required this.userSearchEngineRepository,
    required this.searchEnginesRepository,
    required this.defaultSearchEnginesRepository,
    required this.browserRepository,
  });

  final UserSearchEngineRepository userSearchEngineRepository;
  final SearchEnginesRepository searchEnginesRepository;
  final DefaultSearchEnginesRepository defaultSearchEnginesRepository;
  final BrowserRepository browserRepository;

  Future<void> search(BrowserId id, String input) async {
    final userSearchEngineId =
        await userSearchEngineRepository.fetchUserSearchEngineId();
    final defaultEngines = defaultSearchEnginesRepository.searchEngines;
    final customEngines = await searchEnginesRepository.fetchSearchEngines();
    final allEngines = {...defaultEngines, ...customEngines};
    final userSearchEngine =
        allEngines[userSearchEngineId] ?? defaultEngines.values.first;

    final url = isWebAddress(input)
        ? input
        : userSearchEngine.urlTemplate.replaceAll('%s', input);
    return browserRepository.openUrl(id, url);
  }

  Future<bool> setUserSearchEngine(SearchEngineId id) {
    return userSearchEngineRepository.setUserSearchEngineId(id);
  }

  Future<SearchEngineId?> addSearchEngine(String name, String urlTemplate) {
    return searchEnginesRepository.addSearchEngine(name, urlTemplate);
  }

  Future<bool> removeSearchEngine(SearchEngine searchEngine) async {
    final userSearchEngineId =
        await userSearchEngineRepository.fetchUserSearchEngineId();
    if (searchEngine.id == userSearchEngineId) {
      final success = await setUserSearchEngine(
          defaultSearchEnginesRepository.searchEngines.keys.first);
      if (!success) {
        return Future.value(false);
      }
    }
    return searchEnginesRepository.removeSearchEngine(searchEngine);
  }
}

final searchEngineServiceProvider = Provider<SearchEngineService>((ref) {
  return SearchEngineService(
    userSearchEngineRepository: ref.watch(userSearchEngineRepositoryProvider),
    searchEnginesRepository: ref.watch(searchEnginesRepositoryProvider),
    defaultSearchEnginesRepository:
        ref.watch(defaultSearchEnginesRepositoryProvider),
    browserRepository: ref.watch(browserRepositoryProvider),
  );
});
