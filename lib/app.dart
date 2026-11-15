import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_shell.dart';
import 'texts.dart';

/// Gives every screen the [AppController] and rebuilds them when it changes.
class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// The app's words in the current language. Screens that call this are
  /// rebuilt when the phone's language changes.
  static AppTexts textsOf(BuildContext context) {
    Localizations.localeOf(context);
    return of(context).texts;
  }
}

class NhoNheApp extends StatelessWidget {
  const NhoNheApp({super.key, required this.controller, this.locale});

  final AppController controller;

  /// Forces a language (used by tests); normally the phone's is followed.
  final Locale? locale;

  static const appName = 'Nhớ Nhé';

  static const seedColor = Color(0xFF5B5BD6);

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      // Rebuilt when the controller changes, so picking a language in the
      // app takes effect at once.
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _app(),
      ),
    );
  }

  Widget _app() {
    final choice = controller.languageChoice;
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      // A language picked in the app wins; otherwise the phone's is used.
      locale: locale ?? (choice == null ? null : Locale(choice)),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (device, supported) =>
          resolveLocale(device),
      builder: (context, child) {
        // Keeps reminder names and notifications in the language shown.
        controller.setLocale(Localizations.localeOf(context));
        return child!;
      },
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: const HomeShell(),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surfaceContainerLowest,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
