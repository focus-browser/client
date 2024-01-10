import 'package:focus_browser/src/constants/default_search_engines.dart';
import 'package:focus_browser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastUserSearchEngineRepository implements UserSearchEngineRepository {
  SembastUserSearchEngineRepository(this.db);
  final Database db;
  final store = StoreRef.main();

  static Future<Database> createDatabase(String filename) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
  }

  static Future<SembastUserSearchEngineRepository> makeDefault() async {
    return SembastUserSearchEngineRepository(
        await createDatabase('default.db'));
  }

  static const userSearchEngineKey = 'userSearchEngine';

  @override
  Future<SearchEngineId> fetchUserSearchEngineId() async {
    final searchEngineId =
        await store.record(userSearchEngineKey).get(db) as SearchEngineId?;
    return searchEngineId ?? kDefaultSearchEngines.keys.first;
  }

  @override
  Future<bool> setUserSearchEngineId(SearchEngineId searchEngineId) async {
    final object =
        await store.record(userSearchEngineKey).put(db, searchEngineId);
    return object != null;
  }

  @override
  Stream<SearchEngineId> watchUserSearchEngineId() {
    final record = store.record(userSearchEngineKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return snapshot.value as SearchEngineId;
      } else {
        return kDefaultSearchEngines.keys.first;
      }
    });
  }

  // call this when the DB is no longer needed
  void dispose() => db.close();
}
