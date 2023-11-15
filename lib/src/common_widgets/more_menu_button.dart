import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

typedef MoreMenuItemBuilder = List<MoreMenuItem> Function(BuildContext context);

class MoreMenuItem {
  const MoreMenuItem({
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final VoidCallback onTap;
}

/// Wrapper widget for a "more" menu button. Uses [PullDownButton] from the
/// package:pull_down_button on Apple platforms and [PopupMenuButton] from
/// Material design for all other platforms.
class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({
    super.key,
    required this.isCupertino,
    required this.itemBuilder,
  });

  final bool isCupertino;
  final MoreMenuItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final items = itemBuilder(context);
    if (isCupertino) {
      return PullDownButton(
        itemBuilder: (context) => items
            .map(
              (menuItem) => PullDownMenuItem(
                title: menuItem.title,
                icon: menuItem.iconData,
                onTap: menuItem.onTap,
              ),
            )
            .toList(),
        buttonBuilder: (context, showMenu) => CupertinoButton(
          onPressed: showMenu,
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.ellipsis_circle),
        ),
      );
    }
    final itemsMap = items.asMap();
    return PopupMenuButton(
      onSelected: (int key) => itemsMap[key]?.onTap(),
      itemBuilder: (context) => itemsMap.entries
          .map(
            (e) => PopupMenuItem(
              value: e.key,
              child: ListTile(
                title: Text(e.value.title),
                trailing: Icon(e.value.iconData),
              ),
            ),
          )
          .toList(),
    );
  }
}
