import 'package:flutter/widgets.dart';

class SliverToBoxWrapper extends StatelessWidget {
  const SliverToBoxWrapper({
    super.key,
    required this.wrap,
    required this.child,
  });
  final bool wrap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (wrap) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }
}
