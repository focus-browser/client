import 'package:bouser/src/features/share/data/share_repository.dart';
import 'package:flutter/foundation.dart';

class FakeShareRepository implements ShareRepository {
  @override
  Future<void> share(String url) async {
    debugPrint('Sharing $url');
  }
}
