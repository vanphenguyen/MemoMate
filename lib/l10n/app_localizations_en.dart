// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabToday => 'Today';

  @override
  String get tabReminders => 'Reminders';

  @override
  String get webPreviewNotice =>
      'This is a web preview, so no notifications are sent. Notifications only work in the app on a phone.';

  @override
  String get notificationsOffNotice =>
      'Notifications are turned off. Turn them on for this app in your phone\'s Settings to get reminders.';

  @override
  String get emptyNoRemindersTitle => 'No reminders yet';

  @override
  String get emptyNoRemindersBody =>
      'Pick a few ready-made reminders and switch them on. That is all.';

  @override
  String get emptyBrowseAction => 'Browse ready-made reminders';

  @override
  String get emptyNothingTodayTitle => 'Nothing for today';

  @override
  String get emptyNothingTodayBody => 'Your reminders fall on other days.';

  @override
  String get ringDone => 'done';

  @override
  String ringSemantics(int done, int total) {
    return '$done of $total done today';
  }

  @override
  String get summaryAllDoneTitle => 'All done!';

  @override
  String get summaryAllDoneBody => 'You did not forget anything today.';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overdue',
      one: '1 overdue',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody => 'Tap a circle to mark it as done.';

  @override
  String summaryNextTitle(String time) {
    return 'Next at $time';
  }

  @override
  String get sectionTodo => 'To do';

  @override
  String get sectionDone => 'Done';

  @override
  String itemOverdue(String time) {
    return '$time · overdue';
  }

  @override
  String itemAt(String title, String time) {
    return '$title at $time';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders on',
      one: '1 reminder on',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => 'Create your own reminder';

  @override
  String get groupMine => 'Mine';

  @override
  String get tooManyNotifications =>
      'Too many reminder times. Switch one reminder off or use fewer times.';

  @override
  String get editNewTitle => 'New reminder';

  @override
  String get editEditTitle => 'Edit reminder';

  @override
  String get fieldTitleLabel => 'Remind me to…';

  @override
  String get fieldTitleHint => 'For example: Feed the cat';

  @override
  String get labelIcon => 'Icon';

  @override
  String get labelRepeat => 'Repeat';

  @override
  String get repeatDaily => 'Daily';

  @override
  String get repeatWeekly => 'Weekly';

  @override
  String get repeatMonthly => 'Monthly';

  @override
  String get labelOnDays => 'On these days';

  @override
  String get labelOnDay => 'On day';

  @override
  String dayOfMonthOption(int day) {
    return 'Day $day of every month';
  }

  @override
  String get dayOfMonthHelper =>
      'Only up to day 28, because every month has it.';

  @override
  String get labelTimes => 'Times';

  @override
  String removeTime(String time) {
    return 'Remove $time';
  }

  @override
  String get addTime => 'Add time';

  @override
  String get pickTimeHelp => 'Pick a time';

  @override
  String get save => 'Save';

  @override
  String get turnOffReminder => 'Turn this reminder off';

  @override
  String get deleteReminder => 'Delete this reminder';

  @override
  String get errorNoTitle => 'Give the reminder a name.';

  @override
  String get errorNoTimes => 'Add at least one time.';

  @override
  String get errorNoWeekdays => 'Pick at least one day of the week.';

  @override
  String get scheduleEveryDay => 'Every day';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count times ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return 'It\'s time: $title';
  }

  @override
  String get notifChannelName => 'Reminders';

  @override
  String get notifChannelDescription => 'The reminders you switched on';

  @override
  String get actionDone => 'Done';

  @override
  String actionSnooze(int minutes) {
    return 'Remind me in $minutes min';
  }

  @override
  String get languageTitle => 'Language';

  @override
  String get languageFollowPhone => 'Same as phone';
}
