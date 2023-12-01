import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/features/browser/data/browser_repository.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _browserWidgetKeysProvider = Provider<List<GlobalKey>>((ref) {
  return [
    GlobalKey(),
    GlobalKey(),
  ];
});

class BrowserScreen extends ConsumerWidget {
  const BrowserScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBarVisible = ref.watch(isBarVisibleProvider);
    final screenSplitState = ref.watch(screenSplitProvider);
    final isPrimaryBrowserSwapped = ref.watch(isPrimaryBrowserSwappedProvider);
    final browserWidgetKeys = ref.watch(_browserWidgetKeysProvider);
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return Flex(
                  direction: screenSplitState == BrowserSplitState.vertical
                      ? Axis.vertical
                      : Axis.horizontal,
                  children: [
                    Expanded(
                      child: ProviderScope(
                        key: !isPrimaryBrowserSwapped
                            ? browserWidgetKeys.first
                            : browserWidgetKeys.last,
                        overrides: [
                          browserWidgetNumberProvider.overrideWith((ref) => ref
                              .read(browserRepositoryProvider)
                              .createBrowser()),
                        ],
                        child: const BrowserWidget(),
                      ),
                    ),
                    if (screenSplitState != BrowserSplitState.none)
                      ConstrainedBox(
                        constraints: constraints,
                        child: const _SecondaryBrowserWidget(),
                      ),
                  ],
                );
              }),
              if (!isBarVisible) const _BrowserBarUnhideButton(),
            ],
          ),
        ),
        if (isBarVisible) const BrowserBar(),
      ],
    );
  }
}

class _SecondaryBrowserWidget extends ConsumerWidget {
  const _SecondaryBrowserWidget();

  final double dragHandleSize = Sizes.p48;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(secondaryBrowserWidgetSizeProvider);
    final isVerticalSplit =
        ref.watch(screenSplitProvider) == BrowserSplitState.vertical;
    final isPrimaryBrowserSwapped = ref.watch(isPrimaryBrowserSwappedProvider);
    final browserWidgetKeys = ref.watch(_browserWidgetKeysProvider);
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          SizedBox(
            height: isVerticalSplit
                ? size.clamp(
                    dragHandleSize,
                    constraints.maxHeight - dragHandleSize,
                  )
                : constraints.maxHeight,
            width: isVerticalSplit
                ? constraints.maxWidth
                : size.clamp(
                    dragHandleSize,
                    constraints.maxWidth - dragHandleSize,
                  ),
            child: ProviderScope(
              key: isPrimaryBrowserSwapped
                  ? browserWidgetKeys.first
                  : browserWidgetKeys.last,
              overrides: [
                browserWidgetNumberProvider.overrideWith((ref) =>
                    ref.read(browserRepositoryProvider).createBrowser()),
              ],
              child: const BrowserWidget(),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) => ref
                .read(browserScreenControllerProvider.notifier)
                .adjustWidgetSize(
                  details.delta.dx,
                  details.delta.dy,
                ),
            child: Container(
              height: isVerticalSplit ? dragHandleSize : null,
              width: isVerticalSplit ? null : dragHandleSize,
              color: Colors.transparent,
            ),
          ),
        ],
      );
    });
  }
}

class _BrowserBarUnhideButton extends ConsumerWidget {
  const _BrowserBarUnhideButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Opacity(
        opacity: 0.25,
        child: PlatformIconButton(
          icon: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(Sizes.p4),
            child: const Icon(
              Icons.close_fullscreen,
              color: Colors.white,
            ),
          ),
          onPressed: () => ref
              .read(browserBarControllerProvider.notifier)
              .toggleBarVisibility(),
        ),
      ),
    );
  }
}
