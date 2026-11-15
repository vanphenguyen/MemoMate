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
    if (problem != null) throw FormatException(problem);
    return schedule;
  }

  /// Days above this are skipped in short months, so they are not offered.
  static const maxDayOfMonth = 28;

  final ScheduleType type;
  final List<ClockTime> times;
  final Set<int> weekdays;
  final int dayOfMonth;

  /// Returns what is wrong with this schedule, or null when it is usable.
  String? validate() {
    if (times.isEmpty) return 'Cần ít nhất một giờ nhắc.';
    if (type == ScheduleType.weekly) {
      if (weekdays.isEmpty) return 'Cần chọn ít nhất một ngày trong tuần.';
      if (weekdays.any((d) => d < 1 || d > 7)) return 'Ngày trong tuần phải từ 1 đến 7.';
    }
    if (type == ScheduleType.monthly &&
        (dayOfMonth < 1 || dayOfMonth > maxDayOfMonth)) {
      return 'Ngày trong tháng phải từ 1 đến $maxDayOfMonth.';
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

  static const _weekdayNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  static String weekdayName(int weekday) => _weekdayNames[weekday - 1];

  /// A short Vietnamese description, e.g. "Mỗi ngày · 8 lần (08:00–19:00)".
  String describe() {
    final String when = switch (type) {
      ScheduleType.daily => 'Mỗi ngày',
      ScheduleType.weekly => weekdays.length == 7
          ? 'Mỗi ngày'
          : (weekdays.toList()..sort()).map(weekdayName).join(', '),
      ScheduleType.monthly => 'Ngày $dayOfMonth hằng tháng',
    };
    if (times.length > 3) {
      return '$when · ${times.length} lần (${times.first.label}–${times.last.label})';
    }
    return '$when · ${times.map((t) => t.label).join(', ')}';
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'times': [for (final t in times) t.label],
        if (type == ScheduleType.weekly) 'weekdays': weekdays.toList()..sort(),
        if (type == ScheduleType.monthly) 'day': dayOfMonth,
      };
}
