import 'package:bouser/src/constants/default_search_engines.dart';
import 'package:bouser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/utils/delay.dart';
import 'package:bouser/src/utils/in_memory_store.dart';

class FakeUserSearchEngineRepository extends UserSearchEngineRepository {
  FakeUserSearchEngineRepository({
    this.addDelay = true,
  });

  final _userSearchEngineIndex =
      InMemoryStore<SearchEngineId>(kDefaultSearchEngines.first.id);
  final bool addDelay;

  @override
  Future<SearchEngineId> fetchUserSearchEngineId() {
    return _userSearchEngineIndex.stream.first;
  }

  @override
  Stream<SearchEngineId> watchUserSearchEngineId() =>
      _userSearchEngineIndex.stream;

  @override
  Future<void> setUserSearchEngineId(SearchEngineId searchEngineId) async {
    await delay(addDelay);
    _userSearchEngineIndex.value = searchEngineId;
  }
}
