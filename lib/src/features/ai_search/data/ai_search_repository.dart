import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AiSearchRepository {
  Future<String> search(String query);
}

final aiSearchRepositoryProvider = Provider<AiSearchRepository>(
  (ref) => throw UnimplementedError(),
);

final aiSearchProvider =
    StreamProvider.autoDispose.family<String, String>((ref, query) async* {
  final response = await ref.watch(aiSearchRepositoryProvider).search(query);
  String output = '';
  List<String> words = response.split(' ');
  for (String word in words) {
    output += '$word ';
    yield output;
    await Future.delayed(const Duration(milliseconds: 10));
  }
});
