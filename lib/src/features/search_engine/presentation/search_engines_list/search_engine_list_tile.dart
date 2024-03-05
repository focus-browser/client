import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/common_widgets/image_network.dart';
import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:focus_browser/src/features/search_engine/presentation/search_engines_list/search_engines_list_screen_controller.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';
import 'package:focus_browser/src/utils/web_utils.dart';
import 'package:go_router/go_router.dart';

class SearchEngineListTile extends ConsumerWidget {
  const SearchEngineListTile({
    super.key,
    required this.record,
    required this.isSelected,
    this.isCustom = false,
  });

  final SearchEngineRecord record;
  final bool isSelected;
  final bool isCustom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchEnginesListScreenControllerProvider);
    return PlatformListTile(
      leading: SizedBox(
        width: Sizes.p32,
        height: Sizes.p32,
        child: isCustom && state.isEditing
            ? PlatformIconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  context.platformIcons.removeCircledSolid,
                  color: isCupertino(context)
                      ? CupertinoColors.systemRed
                      : Colors.red,
                ),
                onPressed: () {
                  showPlatformDialog(
                    context: context,
                    builder: (context) => _SearchEngineListTileDeleteDialog(
                      record: record,
                    ),
                  );
                },
              )
            : ImageNetwork(
                url: getFaviconUrlFromUrl(record.engine.urlTemplate),
                errorWidget: const SizedBox.shrink(),
              ),
      ),
      title: PlatformText(record.engine.name),
      trailing: _SearchEngineListTileTrailing(
        searchEngineId: record.id,
        isSelected: isSelected,
      ),
      onTap: !isSelected && !state.value.isLoading && !state.isEditing
          ? () => ref
              .read(searchEnginesListScreenControllerProvider.notifier)
              .setUserSearchEngine(record.id)
          : null,
    );
  }
}

class _SearchEngineListTileDeleteDialog extends ConsumerWidget {
  const _SearchEngineListTileDeleteDialog({
    required this.record,
  });

  final SearchEngineRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformAlertDialog(
      title: PlatformText('Delete'.hardcoded),
      content: PlatformText(
          'Are you sure you want to delete ${record.engine.name} search engine?'
              .hardcoded),
      actions: [
        PlatformDialogAction(
          child: PlatformText('Cancel'.hardcoded),
          onPressed: () => context.pop(),
        ),
        PlatformDialogAction(
          child: PlatformText('Delete'.hardcoded),
          cupertino: (context, platform) => CupertinoDialogActionData(
            isDestructiveAction: true,
          ),
          onPressed: () {
            ref
                .read(searchEnginesListScreenControllerProvider.notifier)
                .removeSearchEngine(record.id);
            context.pop();
          },
        ),
      ],
    );
  }
}

class _SearchEngineListTileTrailing extends ConsumerWidget {
  const _SearchEngineListTileTrailing({
    required this.searchEngineId,
    required this.isSelected,
  });

  final SearchEngineId searchEngineId;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchEnginesListScreenControllerProvider);

    if (state.value.isLoading && state.value.asData?.value == searchEngineId) {
      return PlatformCircularProgressIndicator();
    } else if (isSelected) {
      return Opacity(
        opacity: state.isEditing ? 0.5 : 1,
        child: isCupertino(context)
            ? const Icon(CupertinoIcons.checkmark_alt)
            : const Icon(Icons.check),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
