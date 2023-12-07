import 'package:bouser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/utils/delay.dart';
import 'package:bouser/src/utils/in_memory_store.dart';

class FakeSearchEnginesRepository extends SearchEnginesRepository {
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
  Future<SearchEngineId?> addSearchEngine(
      String name, String urlTemplate) async {
    await delay(addDelay);
    final id = name;
    _searchEngines.value = {
      ..._searchEngines.value,
      id: SearchEngine(
        id: id,
        name: name,
        urlTemplate: urlTemplate,
      ),
    };
    return Future.value(id);
  }

  @override
  Future<bool> removeSearchEngine(SearchEngine searchEngine) async {
    await delay(addDelay);
    final searchEngines = _searchEngines.value;
    searchEngines.remove(searchEngine.id);
    _searchEngines.value = searchEngines;
    return Future.value(true);
  }
}
