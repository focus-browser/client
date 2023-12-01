import 'package:bouser/src/common_widgets/sliver_to_box_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValuesWidget<T> extends StatelessWidget {
  /// Widget returned by data() is not wrapped in a SliverToBoxAdapter; gives more control to the caller
  const AsyncValuesWidget({
    super.key,
    required this.values,
    required this.data,
    this.wrapInSliver = false,
  });
  final List<AsyncValue<T>> values;
  final Widget Function(List<T>) data;
  final bool wrapInSliver;

  @override
  Widget build(BuildContext context) {
    if (values.any((value) => value is AsyncError)) {
      return SliverToBoxWrapper(
        wrap: wrapInSliver,
        child: const Center(
          child: Text('Error'),
        ),
      );
    }
    if (values.any((value) => value is AsyncLoading)) {
      return SliverToBoxWrapper(
        wrap: wrapInSliver,
        child: Center(
          child: isCupertino(context)
              ? const CupertinoActivityIndicator()
              : const CircularProgressIndicator(),
        ),
      );
    }
    return data(values.map((value) => (value as AsyncData<T>).value).toList());
  }
}
