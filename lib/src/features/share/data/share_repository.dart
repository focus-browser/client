import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ShareRepository {
  Future<void> share(String url);
}

final shareRepositoryProvider = Provider<ShareRepository>((ref) {
  throw UnimplementedError();
});
