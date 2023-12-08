import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/features/search_engine/presentation/add_search_engine/add_search_engine_screen_controller.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddSearchEngineScreen extends ConsumerWidget {
  const AddSearchEngineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addSearchEngineScreenControllerProvider);
    return PlatformScaffold(
      backgroundColor:
          isCupertino(context) ? CupertinoColors.systemGroupedBackground : null,
      appBar: PlatformAppBar(
        title: PlatformText('Add Search Engine'.hardcoded),
        trailingActions: [
          PlatformTextButton(
            padding: EdgeInsets.zero,
            onPressed: state.name.isNotEmpty &&
                    state.urlTemplate.isNotEmpty &&
                    !state.value.isLoading
                ? () async {
                    final goRouter = GoRouter.of(context);
                    final success = await ref
                        .read(addSearchEngineScreenControllerProvider.notifier)
                        .addSearchEngine();
                    if (success) {
                      goRouter.pop();
                    }
                  }
                : null,
            child: state.value.isLoading
                ? PlatformCircularProgressIndicator()
                : PlatformText('Save'.hardcoded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _SearchEngineNameField(),
            if (isMaterial(context))
              const Padding(padding: EdgeInsets.only(top: Sizes.p24)),
            const _SearchEngineUrlField(),
          ],
        ),
      ),
    );
  }
}

class _SearchEngineNameField extends ConsumerWidget {
  const _SearchEngineNameField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addSearchEngineScreenControllerProvider);

    if (isCupertino(context)) {
      return CupertinoListSection(
        header: Text('Name'.hardcoded),
        hasLeading: false,
        children: [
          CupertinoTextField(
            decoration: null,
            padding: const EdgeInsets.all(10.0),
            autocorrect: false,
            enabled: !state.value.isLoading,
            placeholder: 'Search engine name'.hardcoded,
            onChanged: (value) => ref
                .read(addSearchEngineScreenControllerProvider.notifier)
                .setName(value),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ListTile(
            title: Text(
              'Name'.hardcoded,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: TextField(
              autocorrect: false,
              enabled: !state.value.isLoading,
              decoration: InputDecoration(
                hintText: 'Search engine name'.hardcoded,
              ),
              onChanged: (value) => ref
                  .read(addSearchEngineScreenControllerProvider.notifier)
                  .setName(value),
            ),
          ),
        ],
      );
    }
  }
}

class _SearchEngineUrlField extends ConsumerWidget {
  const _SearchEngineUrlField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addSearchEngineScreenControllerProvider);

    if (isCupertino(context)) {
      return CupertinoListSection(
        header: Text('URL Template'.hardcoded),
        hasLeading: false,
        children: [
          CupertinoTextField(
            decoration: null,
            padding: const EdgeInsets.all(10.0),
            keyboardType: TextInputType.url,
            autocorrect: false,
            enabled: !state.value.isLoading,
            placeholder: '%s in place of query'.hardcoded,
            onChanged: (value) => ref
                .read(addSearchEngineScreenControllerProvider.notifier)
                .setUrl(value),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ListTile(
            title: Text(
              'URL Template'.hardcoded,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            title: TextField(
              keyboardType: TextInputType.url,
              autocorrect: false,
              enabled: !state.value.isLoading,
              decoration: InputDecoration(
                hintText: '%s in place of query'.hardcoded,
              ),
              onChanged: (value) => ref
                  .read(addSearchEngineScreenControllerProvider.notifier)
                  .setUrl(value),
            ),
          ),
        ],
      );
    }
  }
}
