import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nho_nhe/app.dart';
import 'package:nho_nhe/app_controller.dart';
import 'package:nho_nhe/data/template_repository.dart';
import 'package:nho_nhe/models/reminder.dart';
import 'package:nho_nhe/models/schedule.dart';
import 'package:nho_nhe/services/reminder_notifier.dart';
import 'package:nho_nhe/services/reminder_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Monday 16 Nov 2026, 10:00.
  final now = DateTime(2026, 11, 16, 10, 0);
  late NoopReminderNotifier notifier;

  Future<AppController> boot(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    notifier = NoopReminderNotifier();
    // Asset loading is real I/O, which only completes inside runAsync.
    final controller = (await tester.runAsync(() async => AppController(
          groups: await TemplateRepository().loadAll(),
          store: await ReminderStore.load(),
          notifier: notifier,
          clock: () => now,
        )))!;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(NhoNheApp(controller: controller));
    return controller;
  }

  Future<void> openLibrary(WidgetTester tester) async {
    await tester.tap(find.text('Lời nhắc'));
    await tester.pumpAndSettle();
  }

  testWidgets('switch a reminder on, tick it today, switch it off', (tester) async {
    final controller = await boot(tester);
    expect(find.text('Chưa có lời nhắc nào'), findsOneWidget);

    await openLibrary(tester);
    await tester.tap(find.byKey(const ValueKey('reminder-uong-thuoc')));
    await tester.pumpAndSettle();
    expect(controller.reminders.single.id, 'uong-thuoc');
    expect(notifier.permissionRequests, 1);
    expect(notifier.lastSynced.single.id, 'uong-thuoc');

    await tester.tap(find.text('Hôm nay').last);
    await tester.pumpAndSettle();
    // Switched on at 10:00, so the 08:00 dose is not shown as missed.
    expect(find.text('0/1'), findsOneWidget);
    expect(find.text('Tiếp theo lúc 20:00'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('today-uong-thuoc@20:00')));
    await tester.pumpAndSettle();
    expect(find.text('Xong hết rồi!'), findsOneWidget);
    expect(controller.store.doneKeys(now), {'uong-thuoc@20:00'});

    // Tapping again undoes a mistaken tick.
    await tester.tap(find.byKey(const ValueKey('today-uong-thuoc@20:00')));
    await tester.pumpAndSettle();
    expect(find.text('0/1'), findsOneWidget);

    await openLibrary(tester);
    await tester.tap(find.byKey(const ValueKey('reminder-uong-thuoc')));
    await tester.pumpAndSettle();
    expect(controller.reminders, isEmpty);
    expect(notifier.lastSynced, isEmpty);
    // Permission is only asked the first time.
    expect(notifier.permissionRequests, 1);
  });

  testWidgets('create a reminder of your own', (tester) async {
    final controller = await boot(tester);
    await openLibrary(tester);
    await tester.tap(find.text('Tự tạo lời nhắc'));
    await tester.pumpAndSettle();

    // Saving without a name explains what is missing.
    await tester.tap(find.byKey(const ValueKey('save')));
    await tester.pumpAndSettle();
    expect(find.text('Hãy đặt tên cho lời nhắc.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('title-field')), 'Cho mèo ăn');
    await tester.tap(find.text('Theo tuần'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save')));
    await tester.pumpAndSettle();

    final made = controller.reminders.single;
    expect(made.isCustom, isTrue);
    expect(made.title, 'Cho mèo ăn');
    expect(made.schedule.type, ScheduleType.weekly);
    expect(find.text('Của tôi'), findsOneWidget);
    expect(find.text('Cho mèo ăn'), findsOneWidget);
  });

  testWidgets('reminders are still there after restarting the app', (tester) async {
    final controller = await boot(tester);
    final group = controller.groups.first;
    await tester.runAsync(() => controller.enableTemplate(group.templates.first, group));

    final store = (await tester.runAsync(ReminderStore.load))!;
    final restarted = AppController(
      groups: controller.groups,
      store: store,
      notifier: NoopReminderNotifier(),
      clock: () => now,
    );
    expect(restarted.reminders.single.id, group.templates.first.id);
  });

  testWidgets('refuses to go past the notification limit', (tester) async {
    final controller = await boot(tester);
    final huge = Reminder(
      id: 'custom-huge',
      title: 'Quá nhiều',
      icon: Reminder.customIcon,
      message: '',
      color: Reminder.customColor,
      schedule: Schedule.weekly(
        [for (var h = 8; h < 17; h++) ClockTime(h, 0)],
        {1, 2, 3, 4, 5, 6, 7},
      ),
    );
    final problem = await tester.runAsync(() => controller.saveReminder(huge));
    expect(problem, SaveProblem.tooManyNotifications);
    expect(controller.reminders, isEmpty);
  });
}
