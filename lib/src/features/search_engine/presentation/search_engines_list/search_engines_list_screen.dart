import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/common_widgets/async_values_widget.dart';
import 'package:bouser/src/features/search_engine/data/default_search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/features/search_engine/presentation/search_engines_list/search_engine_list_tile.dart';
import 'package:bouser/src/features/search_engine/presentation/search_engines_list/search_engines_list_screen_controller.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:bouser/src/routing/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        child: CupertinoListSection(
          header: Text('Default'.hardcoded),
          hasLeading: false,
          children: [
            for (final searchEngine in defaultSearchEngines.values)
              Opacity(
                opacity: state.isEditing ? 0.5 : 1,
                child: SearchEngineListTile(
                  searchEngine: searchEngine,
                  isSelected: searchEngine.id == userSearchEngineId,
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
            final searchEngine = defaultSearchEngines.values.toList()[index];
            return Opacity(
              opacity: state.isEditing ? 0.5 : 1,
              child: SearchEngineListTile(
                searchEngine: searchEngine,
                isSelected: searchEngine.id == userSearchEngineId,
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
    final state = ref.watch(searchEnginesListScreenControllerProvider);

    if (searchEngines.isNotEmpty || state.isEditing) {
      if (isCupertino(context)) {
        return SliverToBoxAdapter(
          child: CupertinoListSection(
            header: Text('Custom'.hardcoded),
            hasLeading: false,
            children: [
              for (final searchEngine in searchEngines.values)
                SearchEngineListTile(
                  searchEngine: searchEngine,
                  isSelected: searchEngine.id == userSearchEngineId,
                  isCustom: true,
                ),
              if (state.isEditing)
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.add),
                  title: Text('Add'.hardcoded),
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
                  final searchEngine = searchEngines.values.toList()[index];
                  return SearchEngineListTile(
                    searchEngine: searchEngine,
                    isSelected: searchEngine.id == userSearchEngineId,
                    isCustom: true,
                  );
                }
                if (state.isEditing) {
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: Text('Add'.hardcoded),
                    onTap: () =>
                        context.goNamed(AppRoutes.addSearchEngine.name),
                  );
                }
                return null;
              },
              childCount: searchEngines.length + (state.isEditing ? 2 : 1),
            ),
            prototypeItem: ListTile(
              title: Text('Google'.hardcoded),
            ),
          ),
        );
      }
    } else {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}
