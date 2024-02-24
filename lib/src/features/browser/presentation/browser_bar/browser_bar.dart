import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/common_widgets/ai_sheet.dart';
import 'package:focus_browser/src/common_widgets/responsive_center.dart';
import 'package:focus_browser/src/constants/breakpoint.dart';
import 'package:focus_browser/src/features/ai_search/data/ai_search_repository.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_bar/browser_bar_buttons.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_bar/browser_bar_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_controller.dart';
import 'package:focus_browser/src/features/browser/presentation/browser_screen/browser_screen_state.dart';
import 'package:focus_browser/src/features/extensions/presentation/browser_bar_extensions_button.dart';
import 'package:focus_browser/src/localization/string_hardcoded.dart';
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
    return LayoutBuilder(builder: (context, contraints) {
      final wide = contraints.maxWidth >= Breakpoint.tablet;
      if (wide) {
        return const _BrowserBarHorizontal();
      }
      return const _BrowserBarVertical();
    });
  }
}

class _BrowserBarHorizontal extends StatelessWidget {
  const _BrowserBarHorizontal();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BrowserBarButtonBack(),
        const BrowserBarButtonForward(),
        Opacity(
          opacity: 0,
          child: PlatformIconButton(
            icon: Icon(context.platformIcons.search),
            onPressed: () {},
          ),
        ),
        const Expanded(
          child: ResponsiveCenter(
            child: _BrowserSearchBar(),
          ),
        ),
        const BrowserBarButtonShare(),
        const BrowserBarButtonClear(),
        const BrowserBarButtonMore(),
      ],
    );
  }
}

class _BrowserBarVertical extends StatelessWidget {
  const _BrowserBarVertical();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _BrowserSearchBar(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BrowserBarButtonBack(),
            BrowserBarButtonForward(),
            BrowserBarButtonShare(),
            BrowserBarButtonClear(),
            BrowserBarButtonMore(),
          ],
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
      padding: const EdgeInsets.only(left: Sizes.p16, right: Sizes.p16),
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
                          onTapLink: (href) {
                            ref
                                .read(browserBarControllerProvider.notifier)
                                .search(browserNumber, href);
                            context.pop();
                          },
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
