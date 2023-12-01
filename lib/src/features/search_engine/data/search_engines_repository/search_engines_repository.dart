import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class SearchEnginesRepository {
  Future<Map<SearchEngineId, SearchEngine>> fetchSearchEngines();
  Stream<Map<SearchEngineId, SearchEngine>> watchSearchEngines();

  Future<void> addSearchEngine(SearchEngine searchEngine);
  Future<void> removeSearchEngine(SearchEngine searchEngine);
}

final searchEnginesRepositoryProvider =
    Provider<SearchEnginesRepository>((ref) => throw UnimplementedError());

final searchEnginesProvider =
    StreamProvider.autoDispose<Map<SearchEngineId, SearchEngine>>(
  (ref) => ref.watch(searchEnginesRepositoryProvider).watchSearchEngines(),
);
