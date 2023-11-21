import 'package:bouser/src/features/browser/presentation/browser_screen/browser_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
              .copyWith(color: materialDarkTheme.primaryColor),
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
        builder: (context) => PlatformApp(
          restorationScopeId: 'bouser',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          home: const Scaffold(
            body: SafeArea(
              child: ProviderScope(
                child: BrowserScreen(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
