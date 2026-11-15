import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nho_nhe/app.dart';
import 'package:nho_nhe/app_controller.dart';
import 'package:nho_nhe/data/template_repository.dart';
import 'package:nho_nhe/models/reminder.dart';
import 'package:nho_nhe/models/schedule.dart';
import 'package:nho_nhe/services/reminder_notifier.dart';
import 'package:nho_nhe/services/reminder_store.dart';
import 'package:nho_nhe/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Monday 16 Nov 2026, 10:00.
  final now = DateTime(2026, 11, 16, 10, 0);
  late NoopReminderNotifier notifier;

  Future<AppController> boot(
    WidgetTester tester, {
    String language = 'vi',
    bool forceLanguage = true,
  }) async {
    SharedPreferences.setMockInitialValues({});
    notifier = NoopReminderNotifier();
    // Asset loading is real I/O, which only completes inside runAsync.
    final controller = (await tester.runAsync(() async => AppController(
          groups: await TemplateRepository().loadAll(),
          store: await ReminderStore.load(),
          notifier: notifier,
          texts: AppTexts(Locale(language)),
          clock: () => now,
        )))!;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    // Start from nothing, so a second boot in one test is a fresh app.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(NhoNheApp(
      controller: controller,
      locale: forceLanguage ? Locale(language) : null,
    ));
    await tester.pumpAndSettle();
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
    expect(notifier.lastSynced.single.reminder.id, 'uong-thuoc');
    expect(notifier.lastSynced.single.title, 'Uống thuốc');
    expect(notifier.lastSynced.single.body, 'Đến giờ uống thuốc rồi.');

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
    await tester.tap(find.byKey(const ValueKey('icon-pets')));
    await tester.tap(find.text('Theo tuần'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save')));
    await tester.pumpAndSettle();

    final made = controller.reminders.single;
    expect(made.isCustom, isTrue);
    expect(made.title, 'Cho mèo ăn');
    expect(made.icon, 'pets');
    expect(notifier.lastSynced.single.body, 'Đến giờ: Cho mèo ăn');
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
      texts: AppTexts(const Locale('vi')),
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

  testWidgets('the whole app follows the language', (tester) async {
    final controller = await boot(tester, language: 'en');
    expect(find.text('No reminders yet'), findsOneWidget);
    expect(find.text('Monday, November 16'), findsOneWidget);

    await tester.tap(find.text('Reminders'));
    await tester.pumpAndSettle();
    expect(find.text('Take medicine'), findsOneWidget);
    expect(find.text('Every day · 08:00, 20:00'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('reminder-uong-thuoc')));
    await tester.pumpAndSettle();
    expect(find.text('1 reminder on'), findsOneWidget);
    expect(notifier.lastSynced.single.title, 'Take medicine');

    // Switching the phone to Japanese rewrites the scheduled notifications,
    // because a library reminder keeps no fixed name of its own.
    await tester.runAsync(() => controller.setLocale(const Locale('ja')));
    expect(notifier.lastSynced.single.title, '薬を飲む');
    expect(controller.store.language, 'ja');
  });

  testWidgets('every language builds both screens without overflow', (tester) async {
    for (final locale in AppTexts.supportedLocales) {
      final controller = await boot(tester, language: locale.languageCode);
      final group = controller.groups.first;
      await tester.runAsync(() => controller.enableTemplate(group.templates.first, group));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'today, $locale');
      await tester.tap(find.text(controller.texts.l10n.tabReminders).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'library, $locale');
      await tester.tap(find.text(controller.texts.l10n.createOwn));
      await tester.pumpAndSettle();
      await tester.tap(find.text(controller.texts.l10n.repeatMonthly));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'editor, $locale');
    }
  });

  testWidgets('pick a language in the app, then go back to the phone language',
      (tester) async {
    // The test phone speaks English.
    final controller = await boot(tester, language: 'en', forceLanguage: false);
    final group = controller.groups.first;
    await tester.runAsync(() => controller.enableTemplate(group.templates[1], group));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('language-button')).first);
    await tester.pumpAndSettle();
    expect(find.text('Same as phone'), findsOneWidget);
    for (final name in languageNames.values) {
      expect(find.text(name), findsOneWidget);
    }
    await tester.ensureVisible(find.byKey(const ValueKey('language-ko')));
    await tester.tap(find.byKey(const ValueKey('language-ko')));
    await tester.pumpAndSettle();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));

    expect(find.text('오늘'), findsWidgets);
    expect(controller.store.languageChoice, 'ko');
    expect(controller.store.language, 'ko');
    expect(notifier.lastSynced.single.title, '약 먹기');

    await tester.tap(find.byKey(const ValueKey('language-button')).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('language-phone')));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsWidgets);
    expect(controller.store.languageChoice, isNull);
  });

  testWidgets('a test notification asks for permission, then is sent', (tester) async {
    final controller = await boot(tester);
    final sent = await tester.runAsync(controller.sendTestNotification);
    expect(sent, isTrue);
    expect(notifier.permissionRequests, 1);
    expect(notifier.testsSent, 1);
    expect(controller.store.askedPermission, isTrue);
  });

  test('every app language is in the language list', () {
    expect(
      languageNames.keys.toSet(),
      {for (final l in AppTexts.supportedLocales) l.languageCode},
    );
  });

  test('the app is Nhớ Nhé in Vietnamese and ForgetNot elsewhere', () {
    expect(appNameFor('vi'), 'Nhớ Nhé');
    for (final language in languageNames.keys.where((l) => l != 'vi')) {
      expect(appNameFor(language), 'ForgetNot');
    }
  });

  test('picks the phone language when translated, English otherwise', () {
    expect(resolveLocale(const [Locale('ko', 'KR')]).languageCode, 'ko');
    expect(resolveLocale(const [Locale('sv'), Locale('de', 'AT')]).languageCode, 'de');
    expect(resolveLocale(const [Locale('sv')]).languageCode, 'en');
    expect(resolveLocale(null).languageCode, 'en');
  });
}
