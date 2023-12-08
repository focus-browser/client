import 'package:bouser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastSearchEnginesRepository implements SearchEnginesRepository {
  SembastSearchEnginesRepository(this.db);
  final Database db;
  final store = stringMapStoreFactory.store('searchEngines');

  static Future<Database> createDatabase(String filename) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
  }

  static Future<SembastSearchEnginesRepository> makeDefault() async {
    return SembastSearchEnginesRepository(await createDatabase('default.db'));
  }

  @override
  Future<SearchEngineId?> addSearchEngine(SearchEngine searchEngine) {
    return store.add(db, searchEngine.toMap());
  }

  @override
  Future<Map<SearchEngineId, SearchEngine>> fetchSearchEngines() async {
    final records = await store.query().getSnapshots(db);
    final Map<SearchEngineId, SearchEngine> searchEngines =
        records.fold({}, (map, record) {
      map[record.key] = SearchEngine.fromMap(record.value);
      return map;
    });
    return searchEngines;
  }

  @override
  Future<bool> removeSearchEngine(SearchEngineId searchEngineId) async {
    final result = await store.record(searchEngineId).delete(db);
    return result != null;
  }

  @override
  Stream<Map<SearchEngineId, SearchEngine>> watchSearchEngines() {
    return store.query().onSnapshots(db).map((event) {
      final Map<SearchEngineId, SearchEngine> searchEngines =
          event.fold({}, (map, record) {
        map[record.key] = SearchEngine.fromMap(record.value);
        return map;
      });
      return searchEngines;
    });
  }

  // call this when the DB is no longer needed
  void dispose() => db.close();
}
