// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tabToday => 'Heute';

  @override
  String get tabReminders => 'Erinnerungen';

  @override
  String get webPreviewNotice =>
      'Dies ist eine Web-Vorschau, daher werden keine Mitteilungen gesendet. Sie funktionieren nur in der App auf dem Handy.';

  @override
  String get notificationsOffNotice =>
      'Mitteilungen sind ausgeschaltet. Schalte sie für diese App in den Einstellungen deines Handys ein, um Erinnerungen zu erhalten.';

  @override
  String get emptyNoRemindersTitle => 'Noch keine Erinnerungen';

  @override
  String get emptyNoRemindersBody =>
      'Wähle ein paar fertige Erinnerungen und schalte sie ein. Das ist alles.';

  @override
  String get emptyBrowseAction => 'Fertige Erinnerungen ansehen';

  @override
  String get emptyNothingTodayTitle => 'Heute steht nichts an';

  @override
  String get emptyNothingTodayBody =>
      'Deine Erinnerungen fallen auf andere Tage.';

  @override
  String get ringDone => 'erledigt';

  @override
  String ringSemantics(int done, int total) {
    return 'Heute $done von $total erledigt';
  }

  @override
  String get summaryAllDoneTitle => 'Alles erledigt!';

  @override
  String get summaryAllDoneBody => 'Du hast heute nichts vergessen.';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count überfällig',
      one: '1 überfällig',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody =>
      'Tippe auf einen Kreis, um ihn als erledigt zu markieren.';

  @override
  String summaryNextTitle(String time) {
    return 'Als Nächstes um $time';
  }

  @override
  String get sectionTodo => 'Zu erledigen';

  @override
  String get sectionDone => 'Erledigt';

  @override
  String itemOverdue(String time) {
    return '$time · überfällig';
  }

  @override
  String itemAt(String title, String time) {
    return '$title um $time';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen aktiv',
      one: '1 Erinnerung aktiv',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => 'Eigene Erinnerung erstellen';

  @override
  String get groupMine => 'Meine';

  @override
  String get tooManyNotifications =>
      'Zu viele Erinnerungszeiten. Schalte eine Erinnerung aus oder verwende weniger Zeiten.';

  @override
  String get editNewTitle => 'Neue Erinnerung';

  @override
  String get editEditTitle => 'Erinnerung bearbeiten';

  @override
  String get fieldTitleLabel => 'Woran erinnern?';

  @override
  String get fieldTitleHint => 'Zum Beispiel: Katze füttern';

  @override
  String get labelIcon => 'Symbol';

  @override
  String get labelRepeat => 'Wiederholen';

  @override
  String get repeatDaily => 'Täglich';

  @override
  String get repeatWeekly => 'Wöchentlich';

  @override
  String get repeatMonthly => 'Monatlich';

  @override
  String get labelOnDays => 'An diesen Tagen';

  @override
  String get labelOnDay => 'Am Tag';

  @override
  String dayOfMonthOption(int day) {
    return 'Am $day. jedes Monats';
  }

  @override
  String get dayOfMonthHelper => 'Nur bis zum 28., weil jeder Monat ihn hat.';

  @override
  String get labelTimes => 'Uhrzeiten';

  @override
  String removeTime(String time) {
    return '$time entfernen';
  }

  @override
  String get addTime => 'Zeit hinzufügen';

  @override
  String get pickTimeHelp => 'Zeit wählen';

  @override
  String get save => 'Speichern';

  @override
  String get turnOffReminder => 'Diese Erinnerung ausschalten';

  @override
  String get deleteReminder => 'Diese Erinnerung löschen';

  @override
  String get errorNoTitle => 'Gib der Erinnerung einen Namen.';

  @override
  String get errorNoTimes => 'Füge mindestens eine Zeit hinzu.';

  @override
  String get errorNoWeekdays => 'Wähle mindestens einen Wochentag.';

  @override
  String get scheduleEveryDay => 'Jeden Tag';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count-mal ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return 'Es ist Zeit: $title';
  }

  @override
  String get notifChannelName => 'Erinnerungen';

  @override
  String get notifChannelDescription =>
      'Die Erinnerungen, die du eingeschaltet hast';

  @override
  String get actionDone => 'Erledigt';

  @override
  String actionSnooze(int minutes) {
    return 'In $minutes Min. erinnern';
  }

  @override
  String get languageTitle => 'Sprache';

  @override
  String get languageFollowPhone => 'Wie das Handy';
}
