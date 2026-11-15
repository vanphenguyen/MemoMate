import '../models/reminder.dart';
import '../models/schedule.dart';

/// One thing to do today: a reminder at a specific time.
class TodayItem {
  const TodayItem({required this.reminder, required this.time, required this.done});

  final Reminder reminder;
  final ClockTime time;
  final bool done;

  /// Identifies this occurrence within a day; also the notification payload.
  String get key => occurrenceKey(reminder.id, time);

  /// True when the time has passed and it is still not ticked.
  bool isOverdue(DateTime now) => !done && time.on(now).isBefore(now);
}

String occurrenceKey(String reminderId, ClockTime time) => '$reminderId@${time.label}';

/// Splits an [occurrenceKey] back into its parts, or null if malformed.
({String reminderId, ClockTime time})? parseOccurrenceKey(String? key) {
  if (key == null) return null;
  final at = key.lastIndexOf('@');
  if (at <= 0) return null;
  try {
    return (reminderId: key.substring(0, at), time: ClockTime.parse(key.substring(at + 1)));
  } on FormatException {
    return null;
  }
}

/// "yyyy-MM-dd" for [day], used to file ticks under the day they belong to.
String dayKey(DateTime day) =>
    '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

/// Everything scheduled for [day], earliest first. Times from before a
/// reminder was switched on are left out: they were never missed.
List<TodayItem> buildToday(
  Iterable<Reminder> reminders,
  DateTime day,
  Set<String> doneKeys,
) {
  final items = <TodayItem>[
    for (final reminder in reminders)
      if (reminder.schedule.occursOn(day))
        for (final time in reminder.schedule.times)
          if (reminder.since == null || !time.on(day).isBefore(reminder.since!))
            TodayItem(
              reminder: reminder,
              time: time,
              done: doneKeys.contains(occurrenceKey(reminder.id, time)),
            ),
  ];
  items.sort((a, b) {
    final byTime = a.time.compareTo(b.time);
    return byTime != 0 ? byTime : a.reminder.title.compareTo(b.reminder.title);
  });
  return items;
}

/// iPhones keep at most 64 scheduled notifications per app; stay under it
/// with room for a few "remind me later" ones.
const maxNotificationSlots = 60;

int totalNotificationSlots(Iterable<Reminder> reminders) =>
    reminders.fold(0, (sum, r) => sum + r.schedule.notificationSlots);
