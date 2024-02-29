import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/common/focus_node_notifier.dart';
import 'package:focus_browser/src/common/keyboard_visibility_notifier.dart';
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
import 'package:focus_browser/src/utils/web_utils.dart';
import 'package:go_router/go_router.dart';

final _textEditingControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final textEditingController = TextEditingController();
  ref.onDispose(() => textEditingController.dispose());

  final browserNumber = ref.watch(selectedBrowserNumberProvider);
  ref.watch(browserCurrentUrlProvider(browserNumber)).whenData((value) {
    textEditingController.text = value ?? '';
  });
  return textEditingController;
});

final _searchBarFocusNodeProvider = Provider.autoDispose<FocusNode>((ref) {
  final focusNode = FocusNode();
  ref.onDispose(() => focusNode.dispose());
  return focusNode;
});

final _searchBarIsFocusedProvider =
    StateNotifierProvider.autoDispose<FocusNodeNotifier, bool>((ref) {
  final focusNode = ref.watch(_searchBarFocusNodeProvider);
  final searchBarFocusNotifier = FocusNodeNotifier(
    focusNode: focusNode,
  );
  return searchBarFocusNotifier;
});

class BrowserBar extends StatelessWidget {
  const BrowserBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

class _BrowserBarVertical extends ConsumerWidget {
  const _BrowserBarVertical();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild according to keyboard visibility changes only.
    // Read the value of SearchBar's FocusNode directly.
    // This solves the problem of when SearchBar loses focus but the keyboard
    // is still visible (has yet to be dismissed) which causes the SearchBar
    // to be disposed of.
    final isKeyboardVisible = ref.watch(keyboardVisibilityProvider);
    final isSearchBarFocused = ref.watch(_searchBarFocusNodeProvider).hasFocus;
    return Column(
      children: [
        if (!isKeyboardVisible || isSearchBarFocused) const _BrowserSearchBar(),
        const _BrowserBarToolbarRow(),
      ],
    );
  }
}

class _BrowserBarToolbarRow extends ConsumerWidget {
  const _BrowserBarToolbarRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardVisible = ref.watch(keyboardVisibilityProvider);
    if (isKeyboardVisible) {
      return const SizedBox(height: Sizes.p4);
    }
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BrowserBarButtonBack(),
        BrowserBarButtonForward(),
        BrowserBarButtonShare(),
        BrowserBarButtonClear(),
        BrowserBarButtonMore(),
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
    final focusNode = ref.watch(_searchBarFocusNodeProvider);
    final canReload = ref.watch(browserCanReloadProvider(browserNumber));
    final aiSearchButtonTooltipKey = GlobalKey<TooltipState>();
    final isSearchBarFocused = ref.watch(_searchBarIsFocusedProvider);
    if (isSearchBarFocused) {
      textController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: textController.text.length,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: Sizes.p16, right: Sizes.p16),
      child: Row(
        children: [
          Expanded(
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
                    onSubmitted: (query) =>
                        query.endsWith('?') || query.endsWith('？')
                            ? showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                builder: (_) => _AiSearchSheet(query: query),
                              )
                            : ref
                                .read(browserBarControllerProvider.notifier)
                                .search(browserNumber, query),
                  ),
                  cupertino: (context, platform) => CupertinoSearchBarData(
                    autocorrect: false,
                    padding: const EdgeInsets.only(
                      top: Sizes.p12,
                      bottom: Sizes.p12,
                    ),
                    prefixInsets: EdgeInsets.zero,
                    prefixIcon: isSearchBarFocused
                        ? const SizedBox(width: Sizes.p16)
                        : const _PrefixIcon(),
                    suffixInsets: const EdgeInsets.only(
                      left: Sizes.p8,
                      right: Sizes.p12,
                    ),
                    suffixIcon: isSearchBarFocused
                        ? const Icon(CupertinoIcons.xmark_circle_fill)
                        : const Icon(CupertinoIcons.refresh),
                    onSuffixTap: isSearchBarFocused
                        ? null
                        : () => ref
                            .read(browserRepositoryProvider)
                            .reload(browserNumber),
                    onSubmitted: (query) =>
                        query.endsWith('?') || query.endsWith('？')
                            ? showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                showDragHandle: true,
                                builder: (_) => _AiSearchSheet(query: query),
                              )
                            : ref
                                .read(browserBarControllerProvider.notifier)
                                .search(browserNumber, query),
                  ),
                ),
                const _ProgressBar(),
              ],
            ),
          ),
          Tooltip(
            message:
                "Enter text, then tap me and i'll search for you".hardcoded,
            triggerMode: TooltipTriggerMode.manual,
            key: aiSearchButtonTooltipKey,
            preferBelow: false,
            child: PlatformIconButton(
              icon: const Icon(Icons.smart_toy_outlined),
              padding: EdgeInsets.zero,
              onPressed: () {
                final text = textController.text;
                if (text.isEmpty || isWebAddress(text)) {
                  aiSearchButtonTooltipKey.currentState?.ensureTooltipVisible();
                  return;
                }
                if (!(text.endsWith('?') || text.endsWith('？'))) {
                  textController.text = '$text?';
                }
                final query = textController.text;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => _AiSearchSheet(query: query),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AiSearchSheet extends ConsumerWidget {
  const _AiSearchSheet({
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserNumber = ref.watch(selectedBrowserNumberProvider);
    return AiSheet(
      title: query,
      onTapLink: (href) {
        ref
            .read(browserBarControllerProvider.notifier)
            .search(browserNumber, href);
        if (context.mounted) {
          context.pop();
        }
      },
      value: ref.watch(aiSearchProvider(query)),
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
