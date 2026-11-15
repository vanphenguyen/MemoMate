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
  await notifier.init(NotificationLabels.of(texts.l10n));
  final controller = AppController(
    groups: await TemplateRepository().loadAll(),
    store: store,
    notifier: notifier,
    texts: texts,
  );
  LocalReminderNotifier.onTicked = controller.refresh;
  await controller.start();
  runApp(NhoNheApp(controller: controller));
}
