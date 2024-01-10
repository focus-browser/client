import 'package:focus_browser/src/constants/default_search_engines.dart';
import 'package:focus_browser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:focus_browser/src/utils/delay.dart';
import 'package:focus_browser/src/utils/in_memory_store.dart';

class FakeUserSearchEngineRepository implements UserSearchEngineRepository {
  FakeUserSearchEngineRepository({
    this.addDelay = true,
  });

  final _userSearchEngineIndex =
      InMemoryStore<SearchEngineId>(kDefaultSearchEngines.keys.first);
  final bool addDelay;

  @override
  Future<SearchEngineId> fetchUserSearchEngineId() {
    return _userSearchEngineIndex.stream.first;
  }

  @override
  Stream<SearchEngineId> watchUserSearchEngineId() =>
      _userSearchEngineIndex.stream;

  @override
  Future<bool> setUserSearchEngineId(SearchEngineId searchEngineId) async {
    await delay(addDelay);
    _userSearchEngineIndex.value = searchEngineId;
    return Future.value(true);
  }
}
