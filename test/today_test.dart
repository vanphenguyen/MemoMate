import 'package:flutter_test/flutter_test.dart';
import 'package:nho_nhe/logic/today.dart';
import 'package:nho_nhe/models/reminder.dart';
import 'package:nho_nhe/models/schedule.dart';

Reminder reminder(String id, Schedule schedule) => Reminder(
      id: id,
      title: id,
      icon: 'notifications',
      message: '',
      color: 0xFF000000,
      schedule: schedule,
    );

void main() {
  final monday = DateTime(2026, 11, 16, 10, 0);
  final water = reminder('nuoc', Schedule.daily(const [ClockTime(14, 0), ClockTime(8, 0)]));
  final call = reminder('goi', Schedule.weekly(const [ClockTime(20, 0)], {7}));
  final bill = reminder('dien', Schedule.monthly(const [ClockTime(9, 0)], 16));

  test('lists only what falls on the day, earliest first', () {
    final items = buildToday([water, call, bill], monday, {});
    expect(items.map((i) => i.key), ['nuoc@08:00', 'dien@09:00', 'nuoc@14:00']);
  });

  test('marks ticked occurrences as done', () {
    final items = buildToday([water], monday, {'nuoc@08:00'});
    expect(items.map((i) => i.done), [true, false]);
  });

  test('overdue means past its time and not ticked', () {
    final items = buildToday([water], monday, {});
    expect(items[0].isOverdue(monday), isTrue); // 08:00, now 10:00
    expect(items[1].isOverdue(monday), isFalse); // 14:00
    final ticked = buildToday([water], monday, {'nuoc@08:00'});
    expect(ticked[0].isOverdue(monday), isFalse);
  });

  test('times from before the reminder was switched on are not listed', () {
    final late = Reminder(
      id: 'nuoc',
      title: 'nuoc',
      icon: 'notifications',
      message: '',
      color: 0xFF000000,
      schedule: water.schedule,
      since: monday, // switched on at 10:00
    );
    expect(buildToday([late], monday, {}).map((i) => i.key), ['nuoc@14:00']);
    // The next day everything counts again.
    final tuesday = DateTime(2026, 11, 17, 7);
    expect(buildToday([late], tuesday, {}).length, 2);
  });

  test('occurrence keys round trip, even with @ in the id', () {
    final parsed = parseOccurrenceKey(occurrenceKey('a@b', const ClockTime(7, 30)))!;
    expect(parsed.reminderId, 'a@b');
    expect(parsed.time, const ClockTime(7, 30));
    expect(parseOccurrenceKey(null), isNull);
    expect(parseOccurrenceKey('khong-co-gio'), isNull);
    expect(parseOccurrenceKey('x@25:00'), isNull);
  });

  test('dayKey is sortable text', () {
    expect(dayKey(DateTime(2026, 3, 7)), '2026-03-07');
  });

  test('totals notification slots across reminders', () {
    expect(totalNotificationSlots([water, call, bill]), 4);
  });
}
