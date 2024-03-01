import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ShareRepository {
  Future<void> share(String url, [Rect? sharePositionOrigin]);
}

final shareRepositoryProvider = Provider<ShareRepository>((ref) {
  throw UnimplementedError();
});
