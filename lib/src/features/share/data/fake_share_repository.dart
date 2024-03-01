import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:focus_browser/src/features/share/data/share_repository.dart';
import 'package:focus_browser/src/utils/delay.dart';

class FakeShareRepository implements ShareRepository {
  FakeShareRepository({
    this.addDelay = true,
  });

  final bool addDelay;

  @override
  Future<void> share(String url, [Rect? sharePositionOrigin]) async {
    await delay(addDelay);
    debugPrint('Sharing $url');
  }
}
