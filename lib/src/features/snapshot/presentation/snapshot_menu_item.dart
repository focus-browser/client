import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common_widgets/more_menu_button.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';

MoreMenuItem snapshotMenuItem(
    WidgetRef ref, BrowserId browserNumber, String currentUrl) {
  return MoreMenuItem(
    title: 'View Snapshot'.hardcoded,
    iconData: Icons.restore,
    onTap: () {
      final browserRepository = ref.read(browserRepositoryProvider);
      browserRepository.openUrl(
          browserNumber, 'https://archive.ph/newest/$currentUrl');
    },
  );
}
