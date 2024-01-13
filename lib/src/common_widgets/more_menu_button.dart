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
    required this.icon,
    required this.itemBuilder,
  });

  final bool isCupertino;
  final Widget icon;
  final MoreMenuItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final items = itemBuilder(context);
    if (isCupertino) {
      /// Override the current theme to make the menu background transparent.
      /// Fixes laggy animation on iOS.
      /// See https://github.com/notDmDrl/pull_down_button/issues/39 and
      /// https://github.com/notDmDrl/pull_down_button/issues/10 for more info.
      return Theme(
        data: Theme.of(context).copyWith(
          extensions: [
            PullDownButtonTheme(
              routeTheme: PullDownMenuRouteTheme(
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 255, 250, 254)
                        : const Color.fromARGB(255, 26, 26, 28),
              ),
            ),
          ],
        ),
        child: PullDownButton(
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
            child: icon,
          ),
        ),
      );
    }
    final itemsMap = items.asMap();
    return PopupMenuButton(
      onSelected: (int key) => itemsMap[key]?.onTap(),
      icon: icon,
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
