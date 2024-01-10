import 'package:focus_browser/src/features/share/data/share_repository.dart';
import 'package:focus_browser/src/utils/delay.dart';
import 'package:flutter/foundation.dart';

class FakeShareRepository implements ShareRepository {
  FakeShareRepository({
    this.addDelay = true,
  });

  final bool addDelay;

  @override
  Future<void> share(String url) async {
    await delay(addDelay);
    debugPrint('Sharing $url');
  }
}
