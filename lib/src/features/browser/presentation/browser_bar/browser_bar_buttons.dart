import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/common_widgets/more_menu_button.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';
import 'package:focus_browser/src/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class BrowserBarButtonBack extends ConsumerWidget {
  const BrowserBarButtonBack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    final canGoBack = ref.watch(browserCanGoBackProvider(browserNumber));
    return PlatformIconButton(
      icon: Icon(context.platformIcons.leftChevron),
      onPressed: canGoBack.value ?? false
          ? () => ref.read(browserRepositoryProvider).goBack(browserNumber)
          : null,
    );
  }
}

class BrowserBarButtonForward extends ConsumerWidget {
  const BrowserBarButtonForward({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    final canGoForward = ref.watch(browserCanGoForwardProvider(browserNumber));
    return PlatformIconButton(
      icon: Icon(context.platformIcons.rightChevron),
      onPressed: canGoForward.value ?? false
          ? () => ref.read(browserRepositoryProvider).goForward(browserNumber)
          : null,
    );
  }
}

class BrowserBarButtonShare extends ConsumerWidget {
  const BrowserBarButtonShare({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    final currentUrl = ref.watch(browserCurrentUrlProvider(browserNumber));
    return PlatformIconButton(
      icon: Icon(context.platformIcons.share),
      onPressed: currentUrl.value != null
          ? () => ref
              .read(browserBarControllerProvider.notifier)
              .shareCurrentUrl(browserNumber)
          : null,
    );
  }
}

class BrowserBarButtonClear extends ConsumerWidget {
  const BrowserBarButtonClear({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformIconButton(
      icon: Icon(context.platformIcons.delete),
      onPressed: () =>
          ref.read(browserBarControllerProvider.notifier).clearBrowserState(),
    );
  }
}

class BrowserBarButtonMore extends ConsumerWidget {
  const BrowserBarButtonMore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPrimaryBrowserSwapped = ref.watch(isPrimaryBrowserSwappedProvider);
    final screenSplitState = ref.watch(screenSplitProvider);
    final isScreenSplit = screenSplitState != BrowserSplitState.none;
    final isVerticalSplit = screenSplitState == BrowserSplitState.vertical;
    return Padding(
      padding: const EdgeInsets.only(right: Sizes.p8),
      child: MoreMenuButton(
        isCupertino: isCupertino(context),
        icon: isCupertino(context)
            ? const Icon(CupertinoIcons.ellipsis_circle)
            : const Icon(Icons.more_horiz),
        itemBuilder: (context) => [
          if (isScreenSplit)
            MoreMenuItem(
              title: isVerticalSplit
                  ? 'Split Vertically'.hardcoded
                  : 'Split Horizontally'.hardcoded,
              iconData: isVerticalSplit
                  ? Icons.vertical_split
                  : Icons.horizontal_split,
              onTap: () => ref
                  .read(browserScreenControllerProvider.notifier)
                  .toggleSplitOrientation(),
            ),
          if (isScreenSplit)
            MoreMenuItem(
              title: 'Swap Windows'.hardcoded,
              iconData: isVerticalSplit ? Icons.swap_vert : Icons.swap_horiz,
              onTap: () => ref
                  .read(browserScreenControllerProvider.notifier)
                  .toggleSwappedBrowser(),
            ),
          MoreMenuItem(
            title: isScreenSplit
                ? 'Close Window ${isPrimaryBrowserSwapped ? 1 : 2}'.hardcoded
                : 'Split Screen'.hardcoded,
            iconData: isScreenSplit ? Icons.close : Icons.splitscreen,
            onTap: () => ref
                .read(browserScreenControllerProvider.notifier)
                .toggleSplitMode(),
          ),
          MoreMenuItem(
            title: 'Search Engines'.hardcoded,
            iconData: PlatformIcons(context).search,
            onTap: () => context.goNamed(AppRoutes.searchEngine.name),
          ),
          MoreMenuItem(
            title: 'Hide Toolbar'.hardcoded,
            iconData: Icons.open_in_full,
            onTap: () => ref
                .read(browserBarControllerProvider.notifier)
                .toggleBarVisibility(),
          ),
        ],
      ),
    );
  }
}
