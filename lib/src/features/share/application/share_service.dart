import 'dart:ui';

import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/share/data/share_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareService {
  ShareService({
    required this.browserRepository,
    required this.shareRepository,
  });

  final BrowserRepository browserRepository;
  final ShareRepository shareRepository;

  Future<void> shareCurrentUrl(BrowserId id, [Rect? sharePositionOrigin]) async {
    final currentUrl = await browserRepository.fetchCurrentUrl(id);
    if (currentUrl != null) {
      await shareRepository.share(currentUrl, sharePositionOrigin);
    }
  }
}

final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService(
    browserRepository: ref.watch(browserRepositoryProvider),
    shareRepository: ref.watch(shareRepositoryProvider),
  );
});
