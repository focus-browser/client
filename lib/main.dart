import 'package:bouser/src/app.dart';
import 'package:bouser/src/features/browser/data/browser_repository.dart';
import 'package:bouser/src/features/browser/data/inappwebview_browser_repository/inappwebview_browser_repository.dart';
import 'package:bouser/src/features/search_engine/data/search_engines_repository/fake_search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:bouser/src/features/search_engine/data/user_search_engine_repository/fake_user_search_engine_repository.dart';
import 'package:bouser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  const themeMode = ThemeMode.system;

  final materialLightTheme = ThemeData.light();
  final materialDarkTheme = ThemeData.dark();

  final cupertinoLightTheme =
      MaterialBasedCupertinoThemeData(materialTheme: materialLightTheme);
  const darkDefaultCupertinoTheme =
      CupertinoThemeData(brightness: Brightness.dark);
  final cupertinoDarkTheme = MaterialBasedCupertinoThemeData(
    materialTheme: materialDarkTheme.copyWith(
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
        barBackgroundColor: darkDefaultCupertinoTheme.barBackgroundColor,
        textTheme: CupertinoTextThemeData(
          navActionTextStyle: darkDefaultCupertinoTheme
              .textTheme.navActionTextStyle
              .copyWith(color: const Color(0xF0F9F9F9)),
          navLargeTitleTextStyle: darkDefaultCupertinoTheme
              .textTheme.navLargeTitleTextStyle
              .copyWith(color: const Color(0xF0F9F9F9)),
        ),
      ),
    ),
  );

  runApp(
    PlatformProvider(
      builder: (context) => PlatformTheme(
        themeMode: themeMode,
        materialLightTheme: materialLightTheme,
        materialDarkTheme: materialDarkTheme,
        cupertinoLightTheme: cupertinoLightTheme,
        cupertinoDarkTheme: cupertinoDarkTheme,
        builder: (context) => ProviderScope(
          overrides: [
            browserRepositoryProvider.overrideWith(
              (ref) => ref.read(inAppWebViewBrowserRepositoryProvider),
            ),
            // TODO: Remove this override when we have a real repository
            searchEnginesRepositoryProvider.overrideWith(
              (ref) => FakeSearchEnginesRepository(),
            ),
            // TODO: Remove this override when we have a real repository
            userSearchEngineRepositoryProvider.overrideWith(
              (ref) => FakeUserSearchEngineRepository(),
            ),
          ],
          child: const App(),
        ),
      ),
    ),
  );
}
