import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'app_controller.dart';
import 'data/template_repository.dart';
import 'services/reminder_notifier.dart';
import 'services/reminder_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Browsers cannot schedule notifications, so the web build is a preview.
  final ReminderNotifier notifier =
      kIsWeb ? NoopReminderNotifier() : LocalReminderNotifier();
  await notifier.init();
  final controller = AppController(
    groups: await TemplateRepository().loadAll(),
    store: await ReminderStore.load(),
    notifier: notifier,
  );
  LocalReminderNotifier.onTicked = controller.refresh;
  await controller.start();
  runApp(NhoNheApp(controller: controller));
}
