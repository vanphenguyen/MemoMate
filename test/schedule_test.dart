import 'package:flutter_test/flutter_test.dart';
import 'package:nho_nhe/models/schedule.dart';

void main() {
  group('ClockTime', () {
    test('parses and prints HH:mm', () {
      expect(ClockTime.parse('8:05').label, '08:05');
      expect(ClockTime.parse('23:59').minutesOfDay, 23 * 60 + 59);
    });

    test('rejects bad times', () {
      for (final bad in ['24:00', '10:60', '8h', '', '1030']) {
        expect(() => ClockTime.parse(bad), throwsFormatException, reason: bad);
      }
    });
  });

  group('Schedule', () {
    final nine = [const ClockTime(9, 0)];

    test('sorts times and drops duplicates', () {
      final s = Schedule.daily(const [ClockTime(20, 0), ClockTime(8, 0), ClockTime(20, 0)]);
      expect(s.times.map((t) => t.label), ['08:00', '20:00']);
    });

    test('occursOn follows the type', () {
      final monday = DateTime(2026, 11, 16); // a Monday
      expect(monday.weekday, DateTime.monday);
      expect(Schedule.daily(nine).occursOn(monday), isTrue);
      expect(Schedule.weekly(nine, {1, 3}).occursOn(monday), isTrue);
      expect(Schedule.weekly(nine, {2}).occursOn(monday), isFalse);
      expect(Schedule.monthly(nine, 16).occursOn(monday), isTrue);
      expect(Schedule.monthly(nine, 5).occursOn(monday), isFalse);
    });

    test('nextAfter finds the next firing time', () {
      final daily = Schedule.daily(const [ClockTime(8, 0), ClockTime(20, 0)]);
      expect(daily.nextAfter(DateTime(2026, 11, 16, 7)), DateTime(2026, 11, 16, 8));
      expect(daily.nextAfter(DateTime(2026, 11, 16, 8)), DateTime(2026, 11, 16, 20));
      expect(daily.nextAfter(DateTime(2026, 11, 16, 21)), DateTime(2026, 11, 17, 8));

      final sunday = Schedule.weekly(nine, {7});
      expect(sunday.nextAfter(DateTime(2026, 11, 16, 12)), DateTime(2026, 11, 22, 9));

      final fifth = Schedule.monthly(nine, 5);
      expect(fifth.nextAfter(DateTime(2026, 12, 5, 9)), DateTime(2027, 1, 5, 9));
    });

    test('validate explains what is missing', () {
      expect(Schedule.daily(const []).validate(), isNotNull);
      expect(Schedule.weekly(nine, {}).validate(), isNotNull);
      expect(Schedule.monthly(nine, 31).validate(), isNotNull);
      expect(Schedule.monthly(nine, 28).validate(), isNull);
    });

    test('counts notification slots', () {
      expect(Schedule.daily(const [ClockTime(8, 0), ClockTime(9, 0)]).notificationSlots, 2);
      expect(Schedule.weekly(nine, {1, 2, 3}).notificationSlots, 3);
      expect(Schedule.monthly(nine, 1).notificationSlots, 1);
    });

    test('describes itself in Vietnamese', () {
      expect(Schedule.daily(nine).describe(), 'Mỗi ngày · 09:00');
      expect(Schedule.weekly(nine, {7, 1}).describe(), 'T2, CN · 09:00');
      expect(Schedule.monthly(nine, 5).describe(), 'Ngày 5 hằng tháng · 09:00');
      final many = Schedule.daily([for (var h = 8; h < 12; h++) ClockTime(h, 0)]);
      expect(many.describe(), 'Mỗi ngày · 4 lần (08:00–11:00)');
    });

    test('survives a JSON round trip', () {
      for (final s in [
        Schedule.daily(nine),
        Schedule.weekly(nine, {2, 4}),
        Schedule.monthly(nine, 12),
      ]) {
        expect(Schedule.fromJson(s.toJson()).toJson(), s.toJson());
      }
    });

    test('fromJson rejects unusable schedules', () {
      expect(() => Schedule.fromJson({'type': 'yearly', 'times': ['09:00']}),
          throwsFormatException);
      expect(() => Schedule.fromJson({'type': 'weekly', 'times': ['09:00']}),
          throwsFormatException);
    });
  });
}
