import 'dart:math';

import 'package:focus_browser/src/common/app_sizes.dart';
import 'package:focus_browser/src/features/ai_search/data/ai_search_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiSearchWindow extends ConsumerWidget {
  const AiSearchWindow({
    super.key,
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final response = ref.watch(aiSearchProvider(query));
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
              Text(query, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.p16),
              response.when(
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
