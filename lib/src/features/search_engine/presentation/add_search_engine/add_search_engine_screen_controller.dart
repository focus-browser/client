import 'package:focus_browser/src/features/search_engine/application/search_engine_service.dart';
import 'package:focus_browser/src/features/search_engine/presentation/add_search_engine/add_search_engine_screen_state.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSearchEngineScreenController
    extends StateNotifier<AddSearchEngineScreenState> {
  AddSearchEngineScreenController({
    required this.searchEngineService,
  }) : super(AddSearchEngineScreenState(
          value: const AsyncData(null),
          name: '',
          urlTemplate: '',
        ));

  final SearchEngineService searchEngineService;

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setUrl(String value) {
    state = state.copyWith(urlTemplate: value);
  }

  Future<bool> addSearchEngine() async {
    state = state.copyWith(value: const AsyncLoading<void>());
    final value = await AsyncValue.guard<void>(() async {
      final searchEngineId = await searchEngineService.addSearchEngine(
          state.name, state.urlTemplate);
      if (searchEngineId == null) {
        throw Exception('Failed to add search engine'.hardcoded);
      }
    });
    state = state.copyWith(value: value);
    return !value.hasError;
  }
}

final addSearchEngineScreenControllerProvider =
    StateNotifierProvider.autoDispose<AddSearchEngineScreenController,
        AddSearchEngineScreenState>((ref) {
  return AddSearchEngineScreenController(
    searchEngineService: ref.watch(searchEngineServiceProvider),
  );
});
