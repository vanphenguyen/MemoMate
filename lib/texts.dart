import 'dart:ui';

import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';
import 'models/reminder.dart';
import 'models/schedule.dart';

/// Picks the app language: the first of the phone's languages that the app
/// has a translation for, otherwise English.
Locale resolveLocale(List<Locale>? deviceLocales) {
  for (final device in deviceLocales ?? const <Locale>[]) {
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode == device.languageCode) return supported;
    }
  }
  return const Locale(LocalizedText.fallbackLanguage);
}

/// Everything the app says, in one language: the translated interface
/// strings ([l10n]) plus text that is put together in code.
class AppTexts {
  AppTexts(this.locale) : l10n = lookupAppLocalizations(locale);

  static const supportedLocales = AppLocalizations.supportedLocales;

  final Locale locale;
  final AppLocalizations l10n;

  String get language => locale.languageCode;

  /// Short weekday name; 1 = Monday ... 7 = Sunday.
  String weekdayName(int weekday) =>
      // 1 January 2024 was a Monday.
      DateFormat.E(language).format(DateTime(2024, 1, weekday));

  /// e.g. "Monday, November 16".
  String dateLabel(DateTime day) => DateFormat.MMMMEEEEd(language).format(day);

  /// A short description, e.g. "Every day · 8 times (08:00–19:00)".
  String describeSchedule(Schedule schedule) {
    final String when = switch (schedule.type) {
      ScheduleType.daily => l10n.scheduleEveryDay,
      ScheduleType.weekly => schedule.weekdays.length == 7
          ? l10n.scheduleEveryDay
          : (schedule.weekdays.toList()..sort()).map(weekdayName).join(', '),
      ScheduleType.monthly => l10n.dayOfMonthOption(schedule.dayOfMonth),
    };
    final times = schedule.times;
    if (times.length > 3) {
      return '$when · '
          '${l10n.scheduleManyTimes(times.length, times.first.label, times.last.label)}';
    }
    return '$when · ${times.map((t) => t.label).join(', ')}';
  }

  String scheduleProblem(ScheduleProblem problem) => switch (problem) {
        ScheduleProblem.noTimes => l10n.errorNoTimes,
        ScheduleProblem.noWeekdays || ScheduleProblem.badWeekday => l10n.errorNoWeekdays,
        ScheduleProblem.badDayOfMonth => l10n.dayOfMonthHelper,
      };

  /// The name to show for [reminder]; [template] is its library entry, if any.
  String reminderTitle(Reminder reminder, ReminderTemplate? template) =>
      reminder.title ?? template?.title.resolve(language) ?? '';

  /// The notification text for [reminder].
  String reminderMessage(Reminder reminder, ReminderTemplate? template) =>
      template?.message.resolve(language) ??
      l10n.customMessage(reminderTitle(reminder, template));
}
