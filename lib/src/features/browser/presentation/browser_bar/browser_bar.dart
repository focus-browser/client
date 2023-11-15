// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen.dart';
import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget_controller.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserBar extends StatelessWidget {
  const BrowserBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _BrowserSearchBar(),
        _BrowserToolbar(),
      ],
    );
  }
}

class _BrowserToolbar extends ConsumerWidget {
  const _BrowserToolbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVerticalSplit = ref.watch(browserScreenIsVerticalSplitProvider);
    final isTopBrowserSelected =
        ref.watch(browserBarControllerProvider).isTopBrowserSelected;
    return Row(
      children: [
        PlatformIconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => ref
              .read(browserWidgetControllerProvider(isTopBrowserSelected)
                  .notifier)
              .goBack(),
        ),
        PlatformIconButton(
          icon: const Icon(Icons.navigate_next),
          onPressed: () => ref
              .read(browserWidgetControllerProvider(isTopBrowserSelected)
                  .notifier)
              .goForward(),
        ),
        const Spacer(),
        PlatformTextButton(
          onPressed: () => ref
              .read(browserBarControllerProvider.notifier)
              .toggleSelectedBrowser(),
          child: isTopBrowserSelected
              ? PlatformText('Top')
              : PlatformText('Bottom'),
        ),
        const Spacer(),
        PlatformIconButton(
          icon: isVerticalSplit
              ? const Icon(Icons.horizontal_split)
              : const Icon(Icons.vertical_split),
          onPressed: () => ref
              .read(browserScreenIsVerticalSplitProvider.notifier)
              .state = !isVerticalSplit,
        ),
        PlatformIconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => ref
              .read(browserBarControllerProvider.notifier)
              .toggleBarVisibility(),
        ),
      ],
    );
  }
}

class _BrowserSearchBar extends ConsumerWidget {
  const _BrowserSearchBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTopBrowserSelected =
        ref.watch(browserBarControllerProvider).isTopBrowserSelected;
    final selectedBrowserWidgetControllerProvider =
        browserWidgetControllerProvider(isTopBrowserSelected);
    final browserWidgetController =
        ref.watch(selectedBrowserWidgetControllerProvider.notifier);
    final browserWidgetState =
        ref.watch(selectedBrowserWidgetControllerProvider);
    return Padding(
      padding: const EdgeInsets.only(
          left: Sizes.p16, right: Sizes.p16, top: Sizes.p12),
      child: PlatformSearchBar(
        controller: browserWidgetController.textController,
        hintText: 'Search or enter website name'.hardcoded,
        material: (context, platform) => MaterialSearchBarData(
          leading: const Icon(Icons.search),
          trailing: [
            browserWidgetState.isLoading
                ? const IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: null,
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => browserWidgetController.reload(),
                  ),
          ],
          onSubmitted: (value) => browserWidgetController.loadUrl(value),
        ),
        cupertino: (context, platform) => CupertinoSearchBarData(
          keyboardType: TextInputType.url,
          suffixIcon: browserWidgetState.isLoading
              ? const Icon(CupertinoIcons.xmark)
              : const Icon(CupertinoIcons.refresh),
          onSuffixTap: () => browserWidgetController.reload(),
          onSubmitted: (value) => browserWidgetController.loadUrl(value),
        ),
      ),
    );
  }
}
