import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/common_widgets/more_menu_button.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget_controller.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    return Row(
      children: [
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.leftChevron),
            onPressed: () => ref
                .read(browserControllersProvider(browserNumber).notifier)
                .goBack(),
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.rightChevron),
            onPressed: () => ref
                .read(browserControllersProvider(browserNumber).notifier)
                .goForward(),
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.share),
            onPressed: () => (),
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.delete),
            onPressed: () => (),
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
    final isPrimaryBrowserSelected =
        ref.watch(isPrimaryBrowserSelectedProvider);
    final isPrimaryBrowserSwapped = ref.watch(isPrimaryBrowserSwappedProvider);
    final screenSplitState = ref.watch(screenSplitProvider);
    final isScreenSplit = screenSplitState != BrowserSplitState.none;
    final isVerticalSplit = screenSplitState == BrowserSplitState.vertical;
    return MoreMenuButton(
      isCupertino: isCupertino(context),
      itemBuilder: (context) => [
        if (isScreenSplit)
          MoreMenuItem(
            title: isPrimaryBrowserSelected
                ? 'Switch to Window 2'.hardcoded
                : 'Switch to Window 1'.hardcoded,
            iconData:
                isPrimaryBrowserSelected ? Icons.looks_two : Icons.looks_one,
            onTap: () => ref
                .read(browserScreenControllerProvider.notifier)
                .toggleSelectedBrowser(),
          ),
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
    final currentUrl = ref.watch(browserControllersProvider(browserNumber)
        .select((value) => value.currentUrl));
    final textController = ref.watch(_textEditingControllerProvider);
    textController.text = currentUrl;
    final focusNode = ref.watch(_focusNodeProvider);

    return Padding(
      padding: const EdgeInsets.only(
          left: Sizes.p16, right: Sizes.p16, top: Sizes.p12),
      child: PlatformSearchBar(
        controller: textController,
        focusNode: focusNode,
        hintText: 'Search or enter website name'.hardcoded,
        material: (context, platform) => MaterialSearchBarData(
          leading: const _PrefixIcon(),
          trailing: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref
                  .read(browserControllersProvider(browserNumber).notifier)
                  .reload(),
            ),
          ],
          onSubmitted: (value) => ref
              .read(browserControllersProvider(browserNumber).notifier)
              .loadUrl(value),
        ),
        cupertino: (context, platform) => CupertinoSearchBarData(
          keyboardType: TextInputType.url,
          prefixIcon: const _PrefixIcon(),
          suffixIcon: const Icon(CupertinoIcons.refresh),
          onSuffixTap: () => ref
              .read(browserControllersProvider(browserNumber).notifier)
              .reload(),
          onSubmitted: (value) => ref
              .read(browserControllersProvider(browserNumber).notifier)
              .loadUrl(value),
        ),
      ),
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
    if (isScreenSplit == BrowserSplitState.none) {
      return Icon(context.platformIcons.search);
    } else {
      return displayNumber == 1
          ? const Icon(Icons.looks_one)
          : const Icon(Icons.looks_two);
    }
  }
}
