// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/common_widgets/more_menu_button.dart';
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
    final isTopBrowserSelected =
        ref.watch(browserBarControllerProvider).isTopBrowserSelected;
    return Row(
      children: [
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.leftChevron),
            onPressed: () => ref
                .read(browserWidgetControllerProvider(isTopBrowserSelected)
                    .notifier)
                .goBack(),
          ),
        ),
        Expanded(
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.rightChevron),
            onPressed: () => ref
                .read(browserWidgetControllerProvider(isTopBrowserSelected)
                    .notifier)
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
    final isVerticalSplit = ref.watch(browserScreenIsVerticalSplitProvider);
    final isTopBrowserSelected =
        ref.watch(browserBarControllerProvider).isTopBrowserSelected;
    final screenState = (isVerticalSplit, isTopBrowserSelected);
    return MoreMenuButton(
      isCupertino: isCupertino(context),
      itemBuilder: (context) => [
        MoreMenuItem(
          title: switch (screenState) {
            (true, true) => 'Switch to Bottom Window',
            (true, false) => 'Switch to Top Window',
            (false, true) => 'Switch to Right Window',
            (false, false) => 'Switch to Left Window',
          },
          iconData: switch (screenState) {
            (true, true) => Icons.arrow_drop_down,
            (true, false) => Icons.arrow_drop_up,
            (false, true) => Icons.arrow_right,
            (false, false) => Icons.arrow_left,
          },
          onTap: () => ref
              .read(browserBarControllerProvider.notifier)
              .toggleSelectedBrowser(),
        ),
        MoreMenuItem(
          title: isVerticalSplit ? 'Split Vertically' : 'Split Horizontally',
          iconData:
              isVerticalSplit ? Icons.vertical_split : Icons.horizontal_split,
          onTap: () => ref
              .read(browserScreenIsVerticalSplitProvider.notifier)
              .state = !isVerticalSplit,
        ),
        MoreMenuItem(
          title: 'Hide Toolbar',
          iconData: Icons.keyboard_arrow_down,
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
