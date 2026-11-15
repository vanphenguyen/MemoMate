// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tabToday => 'Aujourd\'hui';

  @override
  String get tabReminders => 'Rappels';

  @override
  String get webPreviewNotice =>
      'Ceci est un aperçu web : aucune notification n\'est envoyée. Elles ne fonctionnent que dans l\'appli sur téléphone.';

  @override
  String get notificationsOffNotice =>
      'Les notifications sont désactivées. Activez-les pour cette appli dans les Réglages du téléphone pour recevoir vos rappels.';

  @override
  String get emptyNoRemindersTitle => 'Aucun rappel pour le moment';

  @override
  String get emptyNoRemindersBody =>
      'Choisissez quelques rappels tout prêts et activez-les. C\'est tout.';

  @override
  String get emptyBrowseAction => 'Voir les rappels tout prêts';

  @override
  String get emptyNothingTodayTitle => 'Rien pour aujourd\'hui';

  @override
  String get emptyNothingTodayBody => 'Vos rappels tombent d\'autres jours.';

  @override
  String get ringDone => 'faits';

  @override
  String ringSemantics(int done, int total) {
    return '$done sur $total faits aujourd\'hui';
  }

  @override
  String get summaryAllDoneTitle => 'Tout est fait !';

  @override
  String get summaryAllDoneBody => 'Vous n\'avez rien oublié aujourd\'hui.';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count en retard',
      one: '1 en retard',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody =>
      'Touchez un cercle pour le marquer comme fait.';

  @override
  String summaryNextTitle(String time) {
    return 'Prochain à $time';
  }

  @override
  String get sectionTodo => 'À faire';

  @override
  String get sectionDone => 'Fait';

  @override
  String itemOverdue(String time) {
    return '$time · en retard';
  }

  @override
  String itemAt(String title, String time) {
    return '$title à $time';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rappels actifs',
      one: '1 rappel actif',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => 'Créer votre propre rappel';

  @override
  String get groupMine => 'Les miens';

  @override
  String get tooManyNotifications =>
      'Trop d\'heures de rappel. Désactivez un rappel ou réduisez le nombre d\'heures.';

  @override
  String get editNewTitle => 'Nouveau rappel';

  @override
  String get editEditTitle => 'Modifier le rappel';

  @override
  String get fieldTitleLabel => 'Que faut-il rappeler ?';

  @override
  String get fieldTitleHint => 'Par exemple : Nourrir le chat';

  @override
  String get labelIcon => 'Icône';

  @override
  String get labelRepeat => 'Répéter';

  @override
  String get repeatDaily => 'Chaque jour';

  @override
  String get repeatWeekly => 'Chaque semaine';

  @override
  String get repeatMonthly => 'Chaque mois';

  @override
  String get labelOnDays => 'Ces jours-là';

  @override
  String get labelOnDay => 'Le jour';

  @override
  String dayOfMonthOption(int day) {
    return 'Le $day de chaque mois';
  }

  @override
  String get dayOfMonthHelper =>
      'Jusqu\'au 28 seulement, car tous les mois l\'ont.';

  @override
  String get labelTimes => 'Heures';

  @override
  String removeTime(String time) {
    return 'Retirer $time';
  }

  @override
  String get addTime => 'Ajouter une heure';

  @override
  String get pickTimeHelp => 'Choisissez une heure';

  @override
  String get save => 'Enregistrer';

  @override
  String get turnOffReminder => 'Désactiver ce rappel';

  @override
  String get deleteReminder => 'Supprimer ce rappel';

  @override
  String get errorNoTitle => 'Donnez un nom au rappel.';

  @override
  String get errorNoTimes => 'Ajoutez au moins une heure.';

  @override
  String get errorNoWeekdays => 'Choisissez au moins un jour de la semaine.';

  @override
  String get scheduleEveryDay => 'Chaque jour';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count fois ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return 'C\'est l\'heure : $title';
  }

  @override
  String get notifChannelName => 'Rappels';

  @override
  String get notifChannelDescription => 'Les rappels que vous avez activés';

  @override
  String get actionDone => 'Fait';

  @override
  String actionSnooze(int minutes) {
    return 'Rappeler dans $minutes min';
  }
}
