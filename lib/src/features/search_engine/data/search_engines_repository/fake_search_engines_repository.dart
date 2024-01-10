import 'package:focus_browser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:focus_browser/src/utils/delay.dart';
import 'package:focus_browser/src/utils/in_memory_store.dart';

class FakeSearchEnginesRepository implements SearchEnginesRepository {
  FakeSearchEnginesRepository({
    this.addDelay = true,
  });

  final _searchEngines = InMemoryStore<Map<SearchEngineId, SearchEngine>>({});
  final bool addDelay;

  @override
  Future<Map<SearchEngineId, SearchEngine>> fetchSearchEngines() =>
      _searchEngines.stream.first;

  @override
  Stream<Map<SearchEngineId, SearchEngine>> watchSearchEngines() =>
      _searchEngines.stream;

  @override
  Future<SearchEngineId?> addSearchEngine(SearchEngine searchEngine) async {
    await delay(addDelay);
    final id = searchEngine.name;
    _searchEngines.value = {
      ..._searchEngines.value,
      id: searchEngine,
    };
    return Future.value(id);
  }

  @override
  Future<bool> removeSearchEngine(SearchEngineId searchEngineId) async {
    await delay(addDelay);
    final searchEngines = _searchEngines.value;
    searchEngines.remove(searchEngineId);
    _searchEngines.value = searchEngines;
    return Future.value(true);
  }
}
