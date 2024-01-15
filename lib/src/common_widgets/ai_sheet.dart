import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/common/app_sizes.dart';

class AiSheet extends StatelessWidget {
  const AiSheet({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final AsyncValue<String> value;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.2,
      builder: (BuildContext context, ScrollController scrollController) {
        return Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: ListView(
            controller: scrollController,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.p16),
              value.when(
                data: (data) => SelectableText(data),
                error: (e, st) => Center(
                  child: Text('Error: $e'),
                ),
                loading: () => const _AiTextLoading(),
              ),
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
    return StreamBuilder<int>(
      stream: Stream.periodic(
        const Duration(milliseconds: 200),
        (i) => i,
      ),
      builder: (context, snapshot) {
        int count = snapshot.data ?? 0;
        String text = '$thinkingWord${'.' * (count % 4)}';
        return Text(text);
      },
    );
  }
}
