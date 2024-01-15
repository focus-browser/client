import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common_widgets/more_menu_button.dart';
import 'package:focus_browser/src/features/ai_summary/data/ai_summary_repository.dart';
import 'package:focus_browser/src/common_widgets/ai_sheet.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/snapshot/presentation/snapshot_menu_item.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';

class BrowserBarExtensionsButton extends ConsumerWidget {
  const BrowserBarExtensionsButton({
    super.key,
    required this.iconData,
    required this.browserNumber,
    required this.currentUrl,
  });

  final IconData iconData;
  final BrowserId browserNumber;
  final String? currentUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MoreMenuButton(
      isCupertino: isCupertino(context),
      icon: Icon(
        iconData,
        color: isCupertino(context) ? CupertinoColors.systemGrey : Colors.grey,
      ),
      itemBuilder: (context) => currentUrl != null
          ? [
              MoreMenuItem(
                title: 'AI Summary'.hardcoded,
                iconData: Icons.smart_button,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => Consumer(
                    builder: (context, ref, child) => AiSheet(
                      title: currentUrl!,
                      value: ref.watch(aiSummaryProvider(currentUrl!)),
                    ),
                  ),
                ),
              ),
              snapshotMenuItem(ref, browserNumber, currentUrl!),
            ]
          : List<MoreMenuItem>.empty(),
    );
  }
}
