import 'package:bouser/src/common_widgets/sliver_to_box_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  /// Widget returned by data() is not wrapped in a SliverToBoxAdapter; gives more control to the caller
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.wrapInSliver = false,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final bool wrapInSliver;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => SliverToBoxWrapper(
        wrap: wrapInSliver,
        child: Center(
          child: PlatformText('Error: $e'),
        ),
      ),
      loading: () => SliverToBoxWrapper(
        wrap: wrapInSliver,
        child: Center(
          child: PlatformCircularProgressIndicator(),
        ),
      ),
    );
  }
}
