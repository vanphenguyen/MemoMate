/// A time of day such as 08:30, independent of any date.
class ClockTime implements Comparable<ClockTime> {
  const ClockTime(this.hour, this.minute);

  /// Parses "HH:mm" (24-hour clock).
  factory ClockTime.parse(String text) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(text);
    if (match == null) throw FormatException('Giờ không hợp lệ: "$text"');
    final time = ClockTime(int.parse(match[1]!), int.parse(match[2]!));
    if (time.hour > 23 || time.minute > 59) {
      throw FormatException('Giờ không hợp lệ: "$text"');
    }
    return time;
  }

  final int hour;
  final int minute;

  int get minutesOfDay => hour * 60 + minute;

  /// "HH:mm", also the form stored on disk.
  String get label =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  DateTime on(DateTime day) => DateTime(day.year, day.month, day.day, hour, minute);

  @override
  int compareTo(ClockTime other) => minutesOfDay.compareTo(other.minutesOfDay);

  @override
  bool operator ==(Object other) =>
      other is ClockTime && other.minutesOfDay == minutesOfDay;

  @override
  int get hashCode => minutesOfDay;

  @override
  String toString() => label;
}

enum ScheduleType { daily, weekly, monthly }

/// What makes a schedule unusable. Screens turn this into a sentence.
enum ScheduleProblem { noTimes, noWeekdays, badWeekday, badDayOfMonth }

/// When a reminder repeats.
///
/// Every type has one or more [times]. A weekly schedule also has
/// [weekdays] (1 = Monday ... 7 = Sunday) and a monthly one has [dayOfMonth].
class Schedule {
  Schedule._(this.type, List<ClockTime> times, Set<int> weekdays, this.dayOfMonth)
      : times = List.unmodifiable(times.toSet().toList()..sort()),
        weekdays = Set.unmodifiable(weekdays);

  factory Schedule.daily(List<ClockTime> times) =>
      Schedule._(ScheduleType.daily, times, const {}, 1);

  factory Schedule.weekly(List<ClockTime> times, Set<int> weekdays) =>
      Schedule._(ScheduleType.weekly, times, weekdays, 1);

  factory Schedule.monthly(List<ClockTime> times, int dayOfMonth) =>
      Schedule._(ScheduleType.monthly, times, const {}, dayOfMonth);

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final type = ScheduleType.values.asNameMap()[json['type']];
    if (type == null) {
      throw FormatException('Kiểu lịch không hợp lệ: "${json['type']}"');
    }
    final times = [
      for (final t in (json['times'] as List? ?? const [])) ClockTime.parse(t as String),
    ];
    final schedule = Schedule._(
      type,
      times,
      {for (final d in (json['weekdays'] as List? ?? const [])) d as int},
      json['day'] as int? ?? 1,
    );
    final problem = schedule.validate();
    if (problem != null) throw FormatException('Lịch không hợp lệ: ${problem.name}');
    return schedule;
  }

  /// Days above this are skipped in short months, so they are not offered.
  static const maxDayOfMonth = 28;

  final ScheduleType type;
  final List<ClockTime> times;
  final Set<int> weekdays;
  final int dayOfMonth;

  /// Returns what is wrong with this schedule, or null when it is usable.
  ScheduleProblem? validate() {
    if (times.isEmpty) return ScheduleProblem.noTimes;
    if (type == ScheduleType.weekly) {
      if (weekdays.isEmpty) return ScheduleProblem.noWeekdays;
      if (weekdays.any((d) => d < 1 || d > 7)) return ScheduleProblem.badWeekday;
    }
    if (type == ScheduleType.monthly &&
        (dayOfMonth < 1 || dayOfMonth > maxDayOfMonth)) {
      return ScheduleProblem.badDayOfMonth;
    }
    return null;
  }

  bool occursOn(DateTime day) => switch (type) {
        ScheduleType.daily => true,
        ScheduleType.weekly => weekdays.contains(day.weekday),
        ScheduleType.monthly => day.day == dayOfMonth,
      };

  /// How many repeating notifications the phone must hold for this schedule.
  int get notificationSlots =>
      times.length * (type == ScheduleType.weekly ? weekdays.length : 1);

  /// The first moment strictly after [after] at which this reminder fires.
  DateTime nextAfter(DateTime after) {
    var day = DateTime(after.year, after.month, after.day);
    // 62 days always covers the longest gap (a monthly schedule).
    for (var i = 0; i < 62; i++) {
      if (occursOn(day)) {
        for (final time in times) {
          final moment = time.on(day);
          if (moment.isAfter(after)) return moment;
        }
      }
      day = DateTime(day.year, day.month, day.day + 1);
    }
    throw StateError('Lịch không có lần nhắc nào: ${toJson()}');
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'times': [for (final t in times) t.label],
        if (type == ScheduleType.weekly) 'weekdays': weekdays.toList()..sort(),
        if (type == ScheduleType.monthly) 'day': dayOfMonth,
      };
}
