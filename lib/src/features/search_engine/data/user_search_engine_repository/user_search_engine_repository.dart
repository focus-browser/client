import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UserSearchEngineRepository {
  Future<SearchEngineId> fetchUserSearchEngineId();
  Stream<SearchEngineId> watchUserSearchEngineId();

  Future<bool> setUserSearchEngineId(SearchEngineId searchEngineId);
}

final userSearchEngineRepositoryProvider =
    Provider<UserSearchEngineRepository>((ref) => throw UnimplementedError());

final userSearchEngineIdProvider = StreamProvider.autoDispose<SearchEngineId>(
  (ref) =>
      ref.watch(userSearchEngineRepositoryProvider).watchUserSearchEngineId(),
);
