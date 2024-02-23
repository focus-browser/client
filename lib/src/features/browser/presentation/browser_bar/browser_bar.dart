import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/common_widgets/ai_sheet.dart';
import 'package:focus_browser/src/common_widgets/more_menu_button.dart';
import 'package:focus_browser/src/features/ai_search/data/ai_search_repository.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:focus_browser/src/features/extensions/presentation/browser_bar_extensions_button.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';
import 'package:focus_browser/src/routing/app_router.dart';
import 'package:go_router/go_router.dart';

final _textEditingControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final textEditingController = TextEditingController();
  ref.onDispose(
    () => textEditingController.dispose(),
  );
  return textEditingController;
});

final _focusNodeProvider = Provider.autoDispose<FocusNode>((ref) {
  final textController = ref.watch(_textEditingControllerProvider);
  final focusNode = FocusNode();
  ref.onDispose(() => focusNode.dispose());
  focusNode.addListener(() {
    if (focusNode.hasFocus) {
      textController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textController.text.length,
      );
    }
  });
  return focusNode;
});

class BrowserBar extends ConsumerWidget {
  const BrowserBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        const Column(
          children: [
            _BrowserSearchBar(),
            _BrowserToolbar(),
          ],
        ),
      ],
    );
  }
}

class _BrowserToolbar extends ConsumerWidget {
  const _BrowserToolbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    final canGoBack = ref.watch(browserCanGoBackProvider(browserNumber));
    final canGoForward = ref.watch(browserCanGoForwardProvider(browserNumber));
    final currentUrl = ref.watch(browserCurrentUrlProvider(browserNumber));
    return Row(
      children: [
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.leftChevron),
            onPressed: canGoBack.value ?? false
                ? () =>
                    ref.read(browserRepositoryProvider).goBack(browserNumber)
                : null,
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.rightChevron),
            onPressed: canGoForward.value ?? false
                ? () =>
                    ref.read(browserRepositoryProvider).goForward(browserNumber)
                : null,
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.share),
            onPressed: currentUrl.value != null
                ? () => ref
                    .read(browserBarControllerProvider.notifier)
                    .shareCurrentUrl(browserNumber)
                : null,
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.delete),
            onPressed: () => ref
                .read(browserBarControllerProvider.notifier)
                .clearBrowserState(),
          ),
        ),
        const Expanded(
          child: _BrowserMoreMenuButton(),
        ),
      ],
    );
  }
}

class _BrowserMoreMenuButton extends ConsumerWidget {
  const _BrowserMoreMenuButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPrimaryBrowserSwapped = ref.watch(isPrimaryBrowserSwappedProvider);
    final screenSplitState = ref.watch(screenSplitProvider);
    final isScreenSplit = screenSplitState != BrowserSplitState.none;
    final isVerticalSplit = screenSplitState == BrowserSplitState.vertical;
    return MoreMenuButton(
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
            iconData:
                isVerticalSplit ? Icons.vertical_split : Icons.horizontal_split,
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
    );
  }
}

class _BrowserSearchBar extends ConsumerWidget {
  const _BrowserSearchBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    final textController = ref.watch(_textEditingControllerProvider);
    ref
        .watch(browserCurrentUrlProvider(browserNumber))
        .whenData((value) => textController.text = value ?? '');
    final focusNode = ref.watch(_focusNodeProvider);
    final canReload = ref.watch(browserCanReloadProvider(browserNumber));

    return Padding(
      padding: const EdgeInsets.only(
          left: Sizes.p16, right: Sizes.p16, top: Sizes.p12),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PlatformSearchBar(
            controller: textController,
            focusNode: focusNode,
            hintText: 'Search or enter website name'.hardcoded,
            material: (context, platform) => MaterialSearchBarData(
              leading: const _PrefixIcon(),
              trailing: [
                if (canReload.value ?? false)
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p12),
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => ref
                          .read(browserRepositoryProvider)
                          .reload(browserNumber),
                    ),
                  ),
              ],
              onSubmitted: (query) => query.endsWith('?')
                  ? showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (_) => Consumer(
                        builder: (context, ref, child) => AiSheet(
                          title: query,
                          value: ref.watch(aiSearchProvider(query)),
                        ),
                      ),
                    )
                  : ref
                      .read(browserBarControllerProvider.notifier)
                      .search(browserNumber, query),
            ),
            cupertino: (context, platform) => CupertinoSearchBarData(
              autocorrect: false,
              prefixIcon: const _PrefixIcon(),
              suffixInsets: const EdgeInsets.all(Sizes.p12),
              suffixIcon: canReload.value ?? false
                  ? const Icon(CupertinoIcons.refresh)
                  : const Icon(CupertinoIcons.xmark_circle_fill),
              onSuffixTap: canReload.value ?? false
                  ? () =>
                      ref.read(browserRepositoryProvider).reload(browserNumber)
                  : null,
              onSubmitted: (query) => query.endsWith('?')
                  ? showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (_) => Consumer(
                        builder: (context, ref, child) => AiSheet(
                          title: query,
                          value: ref.watch(aiSearchProvider(query)),
                        ),
                      ),
                    )
                  : ref
                      .read(browserBarControllerProvider.notifier)
                      .search(browserNumber, query),
            ),
          ),
          const _ProgressBar(),
        ],
      ),
    );
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    final progress = ref.watch(browserProgressProvider(browserNumber));
    return progress.maybeWhen(
      data: (data) => data < 1
          ? Padding(
              padding:
                  const EdgeInsets.only(left: 1.0, right: 1.0, bottom: 1.0),
              child: LinearProgressIndicator(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(Sizes.p64),
                ),
                value: data,
              ),
            )
          : const SizedBox.shrink(),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _PrefixIcon extends ConsumerWidget {
  const _PrefixIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScreenSplit = ref.watch(screenSplitProvider);
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    final isPrimaryBrowserSwapped = ref.watch(isPrimaryBrowserSwappedProvider);
    final displayNumber =
        (isPrimaryBrowserSwapped ? browserNumber ^ 1 : browserNumber) + 1;
    final currentUrl =
        ref.watch(browserCurrentUrlProvider(browserNumber)).value;

    final iconData = displayNumber == 2
        ? Icons.looks_two
        : isScreenSplit != BrowserSplitState.none
            ? Icons.looks_one
            : currentUrl == null
                ? context.platformIcons.search
                : Icons.extension;

    return BrowserBarExtensionsButton(
      iconData: iconData,
      browserNumber: browserNumber,
      currentUrl: currentUrl,
    );
  }
}
