import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/utils/stream_string.dart';

abstract class AiSummaryRepository {
  Future<String> summarise(String url);
}

final aiSummaryRepositoryProvider = Provider<AiSummaryRepository>(
  (ref) => throw UnimplementedError(),
);

final aiSummaryProvider =
    StreamProvider.autoDispose.family<String, String>((ref, url) async* {
  final response = await ref.watch(aiSummaryRepositoryProvider).summarise(url);
  yield* streamString(response);
});
