import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';
import '../logic/today.dart';
import '../models/reminder.dart';
import '../models/schedule.dart';
import '../texts.dart';
import 'reminder_store.dart';

/// The few words a notification needs besides the reminder itself.
class NotificationLabels {
  const NotificationLabels({
    required this.channelName,
    required this.channelDescription,
    required this.done,
    required this.snooze,
  });

  factory NotificationLabels.of(AppLocalizations l10n) => NotificationLabels(
        channelName: l10n.notifChannelName,
        channelDescription: l10n.notifChannelDescription,
        done: l10n.actionDone,
        snooze: l10n.actionSnooze(snoozeMinutes),
      );

  final String channelName;
  final String channelDescription;
  final String done;
  final String snooze;
}

/// A reminder together with the words its notification shows.
class PlannedReminder {
  const PlannedReminder({required this.reminder, required this.title, required this.body});

  final Reminder reminder;
  final String title;
  final String body;
}

/// Puts reminders on the phone's notification schedule.
abstract class ReminderNotifier {
  /// False where scheduled notifications do not exist (the web preview).
  bool get supported;

  Future<void> init(NotificationLabels labels);

  /// Asks the user to allow notifications. Returns whether they are allowed.
  Future<bool> requestPermission();

  /// Whether the phone currently lets the app show notifications.
  Future<bool> isAllowed();

  /// Shows one notification now and schedules another a minute from now,
  /// so the user can see that both kinds arrive.
  Future<void> sendTest({
    required String title,
    required String body,
    required String laterBody,
    required NotificationLabels labels,
  });

  /// Replaces everything scheduled with one repeating notification per
  /// time slot of [reminders].
  Future<void> sync(List<PlannedReminder> reminders, NotificationLabels labels);
}

/// Used on the web and in tests: remembers what was asked, shows nothing.
class NoopReminderNotifier implements ReminderNotifier {
  NoopReminderNotifier({this.supported = false});

  List<PlannedReminder> lastSynced = const [];
  int permissionRequests = 0;

  @override
  final bool supported;

  @override
  Future<void> init(NotificationLabels labels) async {}

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return true;
  }

  @override
  Future<bool> isAllowed() async => true;

  int testsSent = 0;

  @override
  Future<void> sendTest({
    required String title,
    required String body,
    required String laterBody,
    required NotificationLabels labels,
  }) async =>
      testsSent++;

  @override
  Future<void> sync(List<PlannedReminder> reminders, NotificationLabels labels) async =>
      lastSynced = List.of(reminders);
}

const _channelId = 'reminders';
const _categoryId = 'reminder';
const _actionDone = 'done';
const _actionSnooze = 'snooze';
const snoozeMinutes = 15;

/// The status-bar icon: `android/app/src/main/res/drawable/ic_stat_bell.xml`.
const _androidIcon = 'ic_stat_bell';

/// Test notifications use these two ids.
const _testIdBase = 1 << 21;

/// Reminders must arrive on time, so exact alarms are used when the phone
/// allows them. Otherwise Android may deliver a notification much later.
Future<AndroidScheduleMode> _scheduleMode() async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return AndroidScheduleMode.exactAllowWhileIdle;
  }
  final android = _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  final exact = await android?.canScheduleExactNotifications() ?? false;
  return exact
      ? AndroidScheduleMode.exactAllowWhileIdle
      : AndroidScheduleMode.inexactAllowWhileIdle;
}

/// Snoozed notifications use ids from here up, clear of the repeating ones.
const _snoozeIdBase = 1 << 20;

NotificationDetails _details(NotificationLabels labels) => NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        labels.channelName,
        channelDescription: labels.channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        actions: [
          AndroidNotificationAction(_actionDone, labels.done),
          AndroidNotificationAction(_actionSnooze, labels.snooze),
        ],
      ),
      iOS: const DarwinNotificationDetails(categoryIdentifier: _categoryId),
    );

/// What travels with a notification: which occurrence it is, plus its words
/// so "remind me later" can show it again without looking anything up.
String encodePayload(String occurrence, String title, String body) =>
    jsonEncode({'k': occurrence, 't': title, 'b': body});

({String occurrence, String title, String body})? decodePayload(String? payload) {
  if (payload == null) return null;
  try {
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final occurrence = json['k'] as String;
    if (parseOccurrenceKey(occurrence) == null) return null;
    return (
      occurrence: occurrence,
      title: json['t'] as String? ?? '',
      body: json['b'] as String? ?? '',
    );
  } on Object {
    return null;
  }
}

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

Future<void> _initPlugin(
  NotificationLabels labels, {
  required bool withBackgroundHandler,
}) =>
    _plugin.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings(_androidIcon),
        iOS: DarwinInitializationSettings(
          // Permission is asked later, when the first reminder is switched on.
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              _categoryId,
              actions: [
                DarwinNotificationAction.plain(_actionDone, labels.done),
                DarwinNotificationAction.plain(_actionSnooze, labels.snooze),
              ],
            ),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: _handleResponse,
      onDidReceiveBackgroundNotificationResponse:
          withBackgroundHandler ? onBackgroundNotificationResponse : null,
    );

/// The labels in the language the app was last shown in.
Future<NotificationLabels> _savedLabels() async {
  final language =
      (await ReminderStore.load()).language ?? LocalizedText.fallbackLanguage;
  return NotificationLabels.of(AppTexts(Locale(language)).l10n);
}

/// Runs when a notification button is pressed while the app is closed.
/// It lives in its own isolate, so everything it needs is set up here.
@pragma('vm:entry-point')
Future<void> onBackgroundNotificationResponse(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  if (response.actionId == _actionSnooze) {
    await _initTimeZone();
    await _initPlugin(await _savedLabels(), withBackgroundHandler: false);
  }
  await _handleResponse(response);
}

Future<void> _handleResponse(NotificationResponse response) async {
  final payload = decodePayload(response.payload);
  if (payload == null) return;
  switch (response.actionId) {
    case _actionDone:
      final store = await ReminderStore.load();
      await store.reload();
      await store.setDone(DateTime.now(), payload.occurrence, true);
      LocalReminderNotifier.onTicked?.call();
    case _actionSnooze:
      await _plugin.zonedSchedule(
        id: _snoozeIdBase + (response.id ?? 0),
        title: payload.title,
        body: payload.body,
        payload: response.payload,
        scheduledDate:
            tz.TZDateTime.now(tz.local).add(const Duration(minutes: snoozeMinutes)),
        notificationDetails: _details(await _savedLabels()),
        androidScheduleMode: await _scheduleMode(),
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
  Future<void> init(NotificationLabels labels) async {
    await _initTimeZone();
    await _initPlugin(labels, withBackgroundHandler: true);
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
  Future<bool> isAllowed() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.areNotificationsEnabled() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    return (await ios?.checkPermissions())?.isEnabled ?? false;
  }

  @override
  Future<void> sendTest({
    required String title,
    required String body,
    required String laterBody,
    required NotificationLabels labels,
  }) async {
    // No buttons and no payload: a test is not something to tick off.
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        labels.channelName,
        channelDescription: labels.channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await _plugin.show(
      id: _testIdBase,
      title: title,
      body: body,
      notificationDetails: details,
    );
    await _plugin.zonedSchedule(
      id: _testIdBase + 1,
      title: title,
      body: laterBody,
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1)),
      notificationDetails: details,
      androidScheduleMode: await _scheduleMode(),
    );
  }

  @override
  Future<void> sync(List<PlannedReminder> reminders, NotificationLabels labels) async {
    await _plugin.cancelAllPendingNotifications();
    final now = DateTime.now();
    final details = _details(labels);
    final mode = await _scheduleMode();
    var id = 0;
    for (final planned in reminders) {
      final reminder = planned.reminder;
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
            title: planned.title,
            body: planned.body,
            payload: encodePayload(
              occurrenceKey(reminder.id, time),
              planned.title,
              planned.body,
            ),
            scheduledDate: tz.TZDateTime.from(first, tz.local),
            notificationDetails: details,
            androidScheduleMode: mode,
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
