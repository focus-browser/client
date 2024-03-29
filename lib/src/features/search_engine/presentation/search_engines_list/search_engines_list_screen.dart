import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/common_widgets/async_values_widget.dart';
import 'package:focus_browser/src/common_widgets/responsive_center.dart';
import 'package:focus_browser/src/constants/breakpoint.dart';
import 'package:focus_browser/src/features/search_engine/data/default_search_engines_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';
import 'package:focus_browser/src/features/search_engine/presentation/search_engines_list/search_engine_list_tile.dart';
import 'package:focus_browser/src/features/search_engine/presentation/search_engines_list/search_engines_list_screen_controller.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';
import 'package:focus_browser/src/routing/app_router.dart';
import 'package:go_router/go_router.dart';

final _userSearchEngineIdProvider = Provider<SearchEngineId>((ref) {
  throw UnimplementedError();
});

final _customSearchEnginesProvider =
    Provider<Map<SearchEngineId, SearchEngine>>((ref) {
  throw UnimplementedError();
});

class SearchEnginesListScreen extends ConsumerWidget {
  const SearchEnginesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchEngineId = ref.watch(userSearchEngineIdProvider);
    final customSearchEngines = ref.watch(searchEnginesProvider);
    final state = ref.watch(searchEnginesListScreenControllerProvider);
    return PlatformScaffold(
      backgroundColor:
          isCupertino(context) ? CupertinoColors.systemGroupedBackground : null,
      appBar: PlatformAppBar(
        title: PlatformText('Search Engines'.hardcoded),
        trailingActions: [
          PlatformTextButton(
              padding: EdgeInsets.zero,
              onPressed: () => ref
                  .read(searchEnginesListScreenControllerProvider.notifier)
                  .toggleEditing(),
              child: PlatformText(
                  state.isEditing ? 'Done'.hardcoded : 'Edit'.hardcoded))
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxContentWidth: Breakpoint.tablet,
          child: AsyncValuesWidget(
            values: [userSearchEngineId, customSearchEngines],
            data: (values) => ProviderScope(
              overrides: [
                _userSearchEngineIdProvider
                    .overrideWithValue(values[0] as SearchEngineId),
                _customSearchEnginesProvider.overrideWithValue(
                    values[1] as Map<SearchEngineId, SearchEngine>),
              ],
              child: const CustomScrollView(
                slivers: [
                  _DefaultSearchEnginesList(),
                  _CustomSearchEnginesList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultSearchEnginesList extends ConsumerWidget {
  const _DefaultSearchEnginesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultSearchEngines = ref.watch(defaultSearchEnginesProvider);
    final userSearchEngineId = ref.watch(_userSearchEngineIdProvider);
    final state = ref.watch(searchEnginesListScreenControllerProvider);

    if (isCupertino(context)) {
      return SliverToBoxAdapter(
        child: CupertinoListSection.insetGrouped(
          header: Text('Default'.hardcoded),
          children: [
            for (final searchEngine in defaultSearchEngines.entries)
              Opacity(
                opacity: state.isEditing ? 0.5 : 1,
                child: SearchEngineListTile(
                  record: (id: searchEngine.key, engine: searchEngine.value),
                  isSelected: searchEngine.key == userSearchEngineId,
                ),
              ),
          ],
        ),
      );
    } else {
      return SliverPrototypeExtentList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return ListTile(
                title: Text(
                  'Default'.hardcoded,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }
            index--;
            final searchEngine = defaultSearchEngines.entries.toList()[index];
            return Opacity(
              opacity: state.isEditing ? 0.5 : 1,
              child: SearchEngineListTile(
                record: (id: searchEngine.key, engine: searchEngine.value),
                isSelected: searchEngine.key == userSearchEngineId,
              ),
            );
          },
          childCount: defaultSearchEngines.length + 1,
        ),
        prototypeItem: ListTile(
          title: Text('Google'.hardcoded),
        ),
      );
    }
  }
}

class _CustomSearchEnginesList extends ConsumerWidget {
  const _CustomSearchEnginesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchEngines = ref.watch(_customSearchEnginesProvider);
    final userSearchEngineId = ref.watch(_userSearchEngineIdProvider);

    if (isCupertino(context)) {
      return SliverToBoxAdapter(
        child: CupertinoListSection.insetGrouped(
          header: Text('Custom'.hardcoded),
          children: [
            for (final searchEngine in searchEngines.entries)
              SearchEngineListTile(
                record: (id: searchEngine.key, engine: searchEngine.value),
                isSelected: searchEngine.key == userSearchEngineId,
                isCustom: true,
              ),
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.add),
              title: Text('Add Search Engine'.hardcoded),
              onTap: () => context.goNamed(AppRoutes.addSearchEngine.name),
            ),
          ],
        ),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.only(top: Sizes.p16),
        sliver: SliverPrototypeExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return ListTile(
                  title: Text(
                    'Custom'.hardcoded,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
              index--;
              if (index < searchEngines.length) {
                final searchEngine = searchEngines.entries.toList()[index];
                return SearchEngineListTile(
                  record: (id: searchEngine.key, engine: searchEngine.value),
                  isSelected: searchEngine.key == userSearchEngineId,
                  isCustom: true,
                );
              }
              return ListTile(
                leading: const Icon(Icons.add),
                title: Text('Add Search Engine'.hardcoded),
                onTap: () => context.goNamed(AppRoutes.addSearchEngine.name),
              );
            },
            childCount: searchEngines.length + 2,
          ),
          prototypeItem: ListTile(
            title: Text('Google'.hardcoded),
          ),
        ),
      );
    }
  }
}
