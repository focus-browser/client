import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/common_widgets/async_values_widget.dart';
import 'package:bouser/src/features/search_engine/data/default_search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:bouser/src/features/search_engine/domain/search_engine.dart';
import 'package:bouser/src/features/search_engine/presentation/search_engines_list_screen_controller.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return PlatformScaffold(
      backgroundColor:
          isCupertino(context) ? CupertinoColors.systemGroupedBackground : null,
      appBar: PlatformAppBar(
        title: PlatformText('Search Engines'.hardcoded),
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

    if (isCupertino(context)) {
      return SliverToBoxAdapter(
        child: CupertinoListSection(
          header: Text('Default'.hardcoded),
          hasLeading: false,
          children: [
            for (final searchEngine in defaultSearchEngines.values)
              _SearchEngineListTile(
                searchEngine: searchEngine,
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
            return _SearchEngineListTile(
              searchEngine: searchEngine,
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

class _SearchEngineListTile extends ConsumerWidget {
  const _SearchEngineListTile({
    required this.searchEngine,
  });

  final SearchEngine searchEngine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchEngineId = ref.watch(_userSearchEngineIdProvider);
    final state = ref.watch(searchEnginesListScreenControllerProvider);

    final trailingWidget = () {
      if (userSearchEngineId == searchEngine.id) {
        return isCupertino(context)
            ? const Icon(CupertinoIcons.checkmark_alt)
            : const Icon(Icons.check);
      } else if (state.isLoading && state.asData?.value == searchEngine.id) {
        return PlatformCircularProgressIndicator();
      } else {
        return null;
      }
    }();

    return PlatformListTile(
      title: PlatformText(searchEngine.name),
      trailing: trailingWidget,
      onTap: () => userSearchEngineId != searchEngine.id && !state.isLoading
          ? ref
              .read(searchEnginesListScreenControllerProvider.notifier)
              .setUserSearchEngine(searchEngine.id)
          : null,
    );
  }
}

class _CustomSearchEnginesList extends ConsumerWidget {
  const _CustomSearchEnginesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchEngineId = ref.watch(_userSearchEngineIdProvider);
    final searchEngines = ref.watch(_customSearchEnginesProvider);

    if (searchEngines.isNotEmpty) {
      if (isCupertino(context)) {
        return SliverToBoxAdapter(
          child: CupertinoListSection(
            header: Text('Custom'.hardcoded),
            hasLeading: false,
            children: [
              for (final searchEngine in searchEngines.values)
                CupertinoListTile(
                  title: Text(searchEngine.name),
                  trailing: userSearchEngineId == searchEngine.id
                      ? const Icon(CupertinoIcons.checkmark_alt)
                      : null,
                ),
              // TODO: only in Edit mode
              CupertinoListTile(
                leading: const Icon(CupertinoIcons.add),
                title: Text('Add'.hardcoded),
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
                final searchEngine = searchEngines.values.toList()[index];
                return ListTile(
                  title: Text(searchEngine.name),
                  trailing: userSearchEngineId == searchEngine.id
                      ? const Icon(Icons.check)
                      : null,
                );
              },
              childCount: searchEngines.length + 1,
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
