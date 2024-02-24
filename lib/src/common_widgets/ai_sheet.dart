import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/constants/breakpoint.dart';

class AiSheet extends StatelessWidget {
  const AiSheet({
    super.key,
    required this.title,
    required this.value,
    this.onTapLink,
  });

  final String title;
  final AsyncValue<String> value;
  final void Function(String)? onTapLink;
  static const double _padding = Sizes.p24;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.2,
      builder: (BuildContext context, ScrollController scrollController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _padding),
          child: ListView(
            controller: scrollController,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: Sizes.p16),
              LayoutBuilder(builder: (context, constraints) {
                final wide =
                    constraints.maxWidth >= Breakpoint.tablet - (2 * _padding);
                final textStyle = wide
                    ? Theme.of(context).textTheme.bodyLarge
                    : Theme.of(context).textTheme.bodyMedium;
                return value.when(
                  data: (data) => MarkdownBody(
                    data: data,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(p: textStyle),
                    onTapLink: (text, href, title) {
                      if (onTapLink != null) {
                        onTapLink!(href ?? text);
                      }
                    },
                  ),
                  error: (e, st) => Center(
                    child: Text('Error: $e', style: textStyle),
                  ),
                  loading: () => const _AiTextLoading(),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _AiTextLoading extends StatelessWidget {
  const _AiTextLoading();

  static final List<String> _thinkingWords = [
    'Thinking',
    'Computing',
    'Synthesizing',
    'Inferring',
    'Deducing',
    'Formulating',
  ];

  @override
  Widget build(BuildContext context) {
    String thinkingWord =
        _thinkingWords[Random().nextInt(_thinkingWords.length)];
    return LayoutBuilder(builder: (context, constraints) {
      final wide =
          constraints.maxWidth >= Breakpoint.tablet - (2 * AiSheet._padding);
      final textStyle = wide
          ? Theme.of(context).textTheme.bodyLarge
          : Theme.of(context).textTheme.bodyMedium;
      return StreamBuilder<int>(
        stream: Stream.periodic(
          const Duration(milliseconds: 200),
          (i) => i,
        ),
        builder: (context, snapshot) {
          int count = snapshot.data ?? 0;
          String text = '$thinkingWord${'.' * (count % 4)}';
          return Text(text, style: textStyle);
        },
      );
    });
  }
}
