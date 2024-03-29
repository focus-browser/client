import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_browser/src/app.dart';
import 'package:focus_browser/src/features/ai_search/data/ai_search_repository.dart';
import 'package:focus_browser/src/features/ai_search/data/remote_ai_search_repository/remote_ai_search_repository.dart';
import 'package:focus_browser/src/features/ai_summary/data/ai_summary_repository.dart';
import 'package:focus_browser/src/features/ai_summary/data/remote_ai_summary_repository/remote_ai_summary_repository.dart';
import 'package:focus_browser/src/features/browser/data/browser_repository.dart';
import 'package:focus_browser/src/features/browser/data/inappwebview_browser_repository/inappwebview_browser_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/search_engines_repository/search_engines_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/search_engines_repository/sembast_search_engines_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/user_search_engine_repository/sembast_user_search_engine_repository.dart';
import 'package:focus_browser/src/features/search_engine/data/user_search_engine_repository/user_search_engine_repository.dart';
import 'package:focus_browser/src/features/share/data/share_plus_repository.dart';
import 'package:focus_browser/src/features/share/data/share_repository.dart';

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

  WidgetsFlutterBinding.ensureInitialized();
  PlatformInAppWebViewController.debugLoggingSettings.enabled = false;

  final searchEnginesRepository =
      await SembastSearchEnginesRepository.makeDefault();
  final userSearchEngineRepository =
      await SembastUserSearchEngineRepository.makeDefault();

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
            searchEnginesRepositoryProvider.overrideWith(
              (ref) {
                ref.onDispose(() => searchEnginesRepository.dispose());
                return searchEnginesRepository;
              },
            ),
            userSearchEngineRepositoryProvider.overrideWith(
              (ref) {
                ref.onDispose(() => userSearchEngineRepository.dispose());
                return userSearchEngineRepository;
              },
            ),
            shareRepositoryProvider.overrideWith(
              (ref) => SharePlusRepository(),
            ),
            aiSearchRepositoryProvider.overrideWith(
              (ref) => RemoteAiSearchRepository(
                repoUrl:
                    Uri.parse('https://focus-browser.vin047.com/api/v0/search'),
              ),
            ),
            aiSummaryRepositoryProvider.overrideWith(
              (ref) => RemoteAiSummaryRepository(
                repoUrl: Uri.parse(
                    'https://focus-browser.vin047.com/api/v0/summarise'),
              ),
            ),
          ],
          child: const App(),
        ),
      ),
    ),
  );
}
