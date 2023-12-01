import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen.dart';
import 'package:bouser/src/features/search_engine/presentation/search_engines_list_screen.dart';
import 'package:bouser/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  home,
  searchEngine,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false, // optional – log navigated paths in console
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.home.name,
        builder: (context, state) => const BrowserScreen(),
        routes: [
          GoRoute(
            path: 'searchEngine',
            name: AppRoutes.searchEngine.name,
            builder: (context, state) => const SearchEnginesListScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Center(child: Text('Not found!'.hardcoded)),
  );
});
