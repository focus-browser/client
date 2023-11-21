import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/common_widgets/more_menu_button.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
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
    return Row(
      children: [
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.leftChevron),
            onPressed: () =>
                ref.read(selectedBrowserControllerProvider).goBack(),
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.rightChevron),
            onPressed: () =>
                ref.read(selectedBrowserControllerProvider).goForward(),
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
    final splitState = ref.watch(browserSplitProvider);
    final isSplit = splitState != BrowserSplitState.none;
    final isVerticalSplit = splitState == BrowserSplitState.vertical;
    return MoreMenuButton(
      isCupertino: isCupertino(context),
      itemBuilder: (context) => [
        if (isSplit)
          MoreMenuItem(
            title: isPrimaryBrowserSelected
                ? 'Switch to Secondary Window'.hardcoded
                : 'Switch to Primary Window'.hardcoded,
            iconData:
                isPrimaryBrowserSelected ? Icons.looks_two : Icons.looks_one,
            onTap: () => ref
                .read(browserBarControllerProvider.notifier)
                .toggleSelectedBrowser(),
          ),
        if (isSplit)
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
        MoreMenuItem(
          title: isSplit
              ? 'Close Secondary Window'.hardcoded
              : 'Split Screen'.hardcoded,
          iconData: isSplit ? Icons.close : Icons.splitscreen,
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
    final textController = ref.watch(textEditingControllerProvider);
    textController.text = ref.read(selectedBrowserCurrentUrlProvider);
    ref.listen(
      selectedBrowserCurrentUrlProvider,
      (previous, next) => textController.text = next,
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: Sizes.p16, right: Sizes.p16, top: Sizes.p12),
      child: PlatformSearchBar(
        controller: textController,
        hintText: 'Search or enter website name'.hardcoded,
        material: (context, platform) => MaterialSearchBarData(
          leading: const Icon(Icons.search),
          trailing: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  ref.read(selectedBrowserControllerProvider).reload(),
            ),
          ],
          onSubmitted: (value) =>
              ref.read(selectedBrowserControllerProvider).loadUrl(value),
        ),
        cupertino: (context, platform) => CupertinoSearchBarData(
          keyboardType: TextInputType.url,
          suffixIcon: const Icon(CupertinoIcons.refresh),
          onSuffixTap: () =>
              ref.read(selectedBrowserControllerProvider).reload(),
          onSubmitted: (value) =>
              ref.read(selectedBrowserControllerProvider).loadUrl(value),
        ),
      ),
    );
  }
}

final textEditingControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final textEditingController = TextEditingController();
  ref.onDispose(
    () => textEditingController.dispose(),
  );
  return textEditingController;
});
