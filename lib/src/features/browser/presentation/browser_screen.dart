import 'package:bouser/src/common/app_sizes.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar.dart';
import 'package:bouser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:bouser/src/features/browser/presentation/browser_widget/browser_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserScreen extends ConsumerWidget {
  const BrowserScreen({
    super.key,
  });

  final double dragHandleSize = Sizes.p48;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserBarController = ref.watch(browserBarControllerProvider);
    final isBarVisible = browserBarController.isBarVisible;
    final isVerticalSplit = ref.watch(browserScreenIsVerticalSplitProvider);
    final bottomBrowserSize = ref.watch(browserWidgetSizeProvider);
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                Flex(
                  direction: isVerticalSplit ? Axis.vertical : Axis.horizontal,
                  children: [
                    const Expanded(
                      child: BrowserWidget(
                        isTopBrowser: true,
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          height: isVerticalSplit
                              ? bottomBrowserSize.clamp(dragHandleSize,
                                  constraints.maxHeight - dragHandleSize)
                              : constraints.maxHeight,
                          width: isVerticalSplit
                              ? constraints.maxWidth
                              : bottomBrowserSize.clamp(dragHandleSize,
                                  constraints.maxWidth - dragHandleSize),
                          child: const BrowserWidget(
                            isTopBrowser: false,
                          ),
                        ),
                        GestureDetector(
                          onPanUpdate: (details) => ref
                                  .read(browserWidgetSizeProvider.notifier)
                                  .state -=
                              isVerticalSplit
                                  ? details.delta.dy
                                  : details.delta.dx,
                          child: Container(
                            height: isVerticalSplit ? dragHandleSize : null,
                            width: isVerticalSplit ? null : dragHandleSize,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!isBarVisible)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Opacity(
                      opacity: 0.25,
                      child: PlatformIconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.black,
                        ),
                        onPressed: () => ref
                            .read(browserBarControllerProvider.notifier)
                            .toggleBarVisibility(),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
        if (isBarVisible) const BrowserBar(),
      ],
    );
  }
}

final browserWidgetSizeProvider = StateProvider<double>((ref) {
  return 100.0;
});

final browserScreenIsVerticalSplitProvider = StateProvider<bool>((ref) {
  return true;
});
