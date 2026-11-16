import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'app_controller.dart';
import 'data/template_repository.dart';
import 'services/reminder_notifier.dart';
import 'services/reminder_store.dart';
import 'texts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // The app follows the phone's language (English if it has no translation).
  // unless a language was picked in the app.
  final store = await ReminderStore.load();
  final choice = store.languageChoice;
  final texts = AppTexts(
    choice != null ? Locale(choice) : resolveLocale(PlatformDispatcher.instance.locales),
  );
  // Browsers cannot schedule notifications, so the web build is a preview.
  final ReminderNotifier notifier =
      kIsWeb ? NoopReminderNotifier() : LocalReminderNotifier();
  // A problem in the notification system must never keep the app from
  // opening, so setting it up is given a time limit and may fail quietly.
  await _guarded(() => notifier.init(NotificationLabels.of(texts.l10n)));
  final controller = AppController(
    groups: await TemplateRepository().loadAll(),
    store: store,
    notifier: notifier,
    texts: texts,
  );
  LocalReminderNotifier.onTicked = controller.refresh;
  runApp(NhoNheApp(controller: controller));
  // Re-scheduling reminders happens after the first screen is up.
  await _guarded(controller.start);
  await _guarded(controller.refresh);
}

Future<void> _guarded(Future<void> Function() work) async {
  try {
    await work().timeout(const Duration(seconds: 8));
  } on Object catch (error, stack) {
    debugPrint('Startup step failed: $error\n$stack');
  }
}
