import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../logic/today.dart';
import '../models/reminder.dart';
import '../models/schedule.dart';
import 'reminder_store.dart';

/// Puts reminders on the phone's notification schedule.
abstract class ReminderNotifier {
  /// False where scheduled notifications do not exist (the web preview).
  bool get supported;

  Future<void> init();

  /// Asks the user to allow notifications. Returns whether they are allowed.
  Future<bool> requestPermission();

  /// Replaces everything scheduled with one repeating notification per
  /// time slot of [reminders].
  Future<void> sync(List<Reminder> reminders);
}

/// Used on the web and in tests: remembers what was asked, shows nothing.
class NoopReminderNotifier implements ReminderNotifier {
  List<Reminder> lastSynced = const [];
  int permissionRequests = 0;

  @override
  bool get supported => false;

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return true;
  }

  @override
  Future<void> sync(List<Reminder> reminders) async => lastSynced = List.of(reminders);
}

const _channelId = 'reminders';
const _categoryId = 'reminder';
const _actionDone = 'done';
const _actionSnooze = 'snooze';
const _snoozeMinutes = 15;

/// Snoozed notifications use ids from here up, clear of the repeating ones.
const _snoozeIdBase = 1 << 20;

const _details = NotificationDetails(
  android: AndroidNotificationDetails(
    _channelId,
    'Lời nhắc',
    channelDescription: 'Các lời nhắc bạn đã bật trong Nhớ Nhé',
    importance: Importance.high,
    priority: Priority.high,
    actions: [
      AndroidNotificationAction(_actionDone, 'Xong'),
      AndroidNotificationAction(_actionSnooze, 'Nhắc lại sau $_snoozeMinutes phút'),
    ],
  ),
  iOS: DarwinNotificationDetails(categoryIdentifier: _categoryId),
);

final _plugin = FlutterLocalNotificationsPlugin();

Future<void> _initTimeZone() async {
  tzdata.initializeTimeZones();
  try {
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
  } on Object {
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  }
}

Future<void> _initPlugin({required bool withBackgroundHandler}) => _plugin.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          // Permission is asked later, when the first reminder is switched on.
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              _categoryId,
              actions: [
                DarwinNotificationAction.plain(_actionDone, 'Xong'),
                DarwinNotificationAction.plain(
                  _actionSnooze,
                  'Nhắc lại sau $_snoozeMinutes phút',
                ),
              ],
            ),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: _handleResponse,
      onDidReceiveBackgroundNotificationResponse:
          withBackgroundHandler ? onBackgroundNotificationResponse : null,
    );

/// Runs when a notification button is pressed while the app is closed.
/// It lives in its own isolate, so everything it needs is set up here.
@pragma('vm:entry-point')
Future<void> onBackgroundNotificationResponse(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  if (response.actionId == _actionSnooze) {
    await _initTimeZone();
    await _initPlugin(withBackgroundHandler: false);
  }
  await _handleResponse(response);
}

Future<void> _handleResponse(NotificationResponse response) async {
  final occurrence = parseOccurrenceKey(response.payload);
  if (occurrence == null) return;
  switch (response.actionId) {
    case _actionDone:
      final store = await ReminderStore.load();
      await store.reload();
      await store.setDone(DateTime.now(), response.payload!, true);
      LocalReminderNotifier.onTicked?.call();
    case _actionSnooze:
      final reminder = (await ReminderStore.load())
          .reminders()
          .where((r) => r.id == occurrence.reminderId)
          .firstOrNull;
      if (reminder == null) return;
      await _plugin.zonedSchedule(
        id: _snoozeIdBase + (response.id ?? 0),
        title: reminder.title,
        body: reminder.message,
        payload: response.payload,
        scheduledDate:
            tz.TZDateTime.now(tz.local).add(const Duration(minutes: _snoozeMinutes)),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
  }
}

/// The real notifier for Android and iOS.
class LocalReminderNotifier implements ReminderNotifier {
  /// Called after "Xong" is pressed on a notification while the app is open.
  static VoidCallback? onTicked;

  @override
  bool get supported => true;

  @override
  Future<void> init() async {
    await _initTimeZone();
    await _initPlugin(withBackgroundHandler: true);
  }

  @override
  Future<bool> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(alert: true, sound: true, badge: true) ?? false;
  }

  @override
  Future<void> sync(List<Reminder> reminders) async {
    await _plugin.cancelAllPendingNotifications();
    final now = DateTime.now();
    var id = 0;
    for (final reminder in reminders) {
      final schedule = reminder.schedule;
      // A weekly reminder needs one repeating notification per weekday.
      final days = schedule.type == ScheduleType.weekly
          ? (schedule.weekdays.toList()..sort())
          : const [0];
      for (final weekday in days) {
        for (final time in schedule.times) {
          final first = _firstOccurrence(schedule, weekday, time, now);
          await _plugin.zonedSchedule(
            id: id++,
            title: reminder.title,
            body: reminder.message,
            payload: occurrenceKey(reminder.id, time),
            scheduledDate: tz.TZDateTime.from(first, tz.local),
            notificationDetails: _details,
            // Inexact timing needs no special permission; reminders may
            // arrive a few minutes late when the phone is saving battery.
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: switch (schedule.type) {
              ScheduleType.daily => DateTimeComponents.time,
              ScheduleType.weekly => DateTimeComponents.dayOfWeekAndTime,
              ScheduleType.monthly => DateTimeComponents.dayOfMonthAndTime,
            },
          );
        }
      }
    }
  }

  /// The next moment the slot ([weekday], [time]) of [schedule] comes up.
  static DateTime _firstOccurrence(
    Schedule schedule,
    int weekday,
    ClockTime time,
    DateTime now,
  ) {
    final single = switch (schedule.type) {
      ScheduleType.daily => Schedule.daily([time]),
      ScheduleType.weekly => Schedule.weekly([time], {weekday}),
      ScheduleType.monthly => Schedule.monthly([time], schedule.dayOfMonth),
    };
    return single.nextAfter(now);
  }
}
