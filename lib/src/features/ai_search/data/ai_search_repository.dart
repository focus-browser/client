import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/utils/stream_string.dart';

abstract class AiSearchRepository {
  Future<String> search(String query);
}

final aiSearchRepositoryProvider = Provider<AiSearchRepository>(
  (ref) => throw UnimplementedError(),
);

final aiSearchProvider =
    StreamProvider.autoDispose.family<String, String>((ref, query) async* {
  final response = await ref.watch(aiSearchRepositoryProvider).search(query);
  yield* streamString(response);
});
