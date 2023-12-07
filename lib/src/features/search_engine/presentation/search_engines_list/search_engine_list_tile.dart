import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/features/search_engine/presentation/search_engines_list/search_engines_list_screen_controller.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchEngineListTile extends ConsumerWidget {
  const SearchEngineListTile({
    super.key,
    required this.searchEngine,
    required this.isSelected,
    this.isCustom = false,
  });

  final SearchEngine searchEngine;
  final bool isSelected;
  final bool isCustom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchEnginesListScreenControllerProvider);
    return PlatformListTile(
      leading: isCustom && state.isEditing
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
                    searchEngine: searchEngine,
                  ),
                );
              },
            )
          : null,
      title: PlatformText(searchEngine.name),
      trailing: _SearchEngineListTileTrailing(
        searchEngine: searchEngine,
        isSelected: isSelected,
      ),
      onTap: !isSelected &&
              !state.selectedSearchEngineId.isLoading &&
              !state.isEditing
          ? () => ref
              .read(searchEnginesListScreenControllerProvider.notifier)
              .setUserSearchEngine(searchEngine.id)
          : null,
    );
  }
}

class _SearchEngineListTileDeleteDialog extends ConsumerWidget {
  const _SearchEngineListTileDeleteDialog({
    required this.searchEngine,
  });

  final SearchEngine searchEngine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformAlertDialog(
      title: PlatformText('Delete'.hardcoded),
      content: PlatformText(
          'Are you sure you want to delete ${searchEngine.name} search engine?'
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
                .removeSearchEngine(searchEngine);
            context.pop();
          },
        ),
      ],
    );
  }
}

class _SearchEngineListTileTrailing extends ConsumerWidget {
  const _SearchEngineListTileTrailing({
    required this.searchEngine,
    required this.isSelected,
  });

  final SearchEngine searchEngine;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchEnginesListScreenControllerProvider);

    if (state.selectedSearchEngineId.isLoading &&
        state.selectedSearchEngineId.asData?.value == searchEngine.id) {
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
