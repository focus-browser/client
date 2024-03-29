import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/common_widgets/async_value_widget.dart';
import 'package:focus_browser/src/constants/breakpoint.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_bar/browser_bar.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_widget/browser_widget.dart';

final _browserWidgetKeysProvider = Provider.autoDispose<List<GlobalKey>>((ref) {
  ref.watch(browserClearedStatesProvider);
  return [GlobalKey(), GlobalKey()];
});

class BrowserScreen extends StatelessWidget {
  const BrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: const SafeArea(
        child: _BrowserScreen(),
      ),
    );
  }
}

class _BrowserScreen extends ConsumerWidget {
  const _BrowserScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBarVisible = ref.watch(isBarVisibleProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= Breakpoint.tablet;
        return Column(
          children: [
            if (isBarVisible && wide) const BrowserBar(),
            Expanded(
              child: KeyboardDismissOnTap(
                // Unfocus the search bar text field when the user taps the browser area
                dismissOnCapturedTaps: true,
                child: Stack(
                  children: [
                    const _BrowserBackground(),
                    const _BrowserWindows(),
                    if (!isBarVisible) const _BrowserBarUnhideButton(),
                  ],
                ),
              ),
            ),
            if (isBarVisible && !wide)
              const Padding(
                padding: EdgeInsets.only(top: Sizes.p8),
                child: BrowserBar(),
              ),
          ],
        );
      },
    );
  }
}

class _BrowserWindows extends ConsumerWidget {
  const _BrowserWindows();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSplitState = ref.watch(screenSplitProvider);
    final isPrimaryBrowserSwapped = ref.watch(isPrimaryBrowserSwappedProvider);
    final browserWidgetKeys = ref.watch(_browserWidgetKeysProvider);
    final browserIds = ref.watch(browserIdsProvider);
    return AsyncValueWidget(
      value: browserIds,
      data: (browsers) => LayoutBuilder(builder: (context, constraints) {
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
                  browserWidgetNumberProvider.overrideWith(
                    (ref) => browsers.first,
                  ),
                ],
                child: const BrowserWidget(),
              ),
            ),
            if (screenSplitState != BrowserSplitState.none)
              ConstrainedBox(
                constraints: constraints,
                child: _SecondaryBrowserWidget(
                  browserId: browsers.last,
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _SecondaryBrowserWidget extends ConsumerWidget {
  const _SecondaryBrowserWidget({
    required this.browserId,
  });

  final BrowserId browserId;
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
                browserWidgetNumberProvider.overrideWith(
                  (ref) => browserId,
                ),
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

class _BrowserBackground extends StatelessWidget {
  const _BrowserBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 127, 182, 227),
                Color.fromARGB(255, 109, 94, 228),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        Center(
          child: Image.asset(
            "assets/images/logo.png",
          ),
        ),
      ],
    );
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
