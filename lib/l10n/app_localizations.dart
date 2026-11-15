import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get tabReminders;

  /// No description provided for @webPreviewNotice.
  ///
  /// In en, this message translates to:
  /// **'This is a web preview, so no notifications are sent. Notifications only work in the app on a phone.'**
  String get webPreviewNotice;

  /// No description provided for @notificationsOffNotice.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off. Turn them on for this app in your phone\'s Settings to get reminders.'**
  String get notificationsOffNotice;

  /// No description provided for @emptyNoRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet'**
  String get emptyNoRemindersTitle;

  /// No description provided for @emptyNoRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a few ready-made reminders and switch them on. That is all.'**
  String get emptyNoRemindersBody;

  /// No description provided for @emptyBrowseAction.
  ///
  /// In en, this message translates to:
  /// **'Browse ready-made reminders'**
  String get emptyBrowseAction;

  /// No description provided for @emptyNothingTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing for today'**
  String get emptyNothingTodayTitle;

  /// No description provided for @emptyNothingTodayBody.
  ///
  /// In en, this message translates to:
  /// **'Your reminders fall on other days.'**
  String get emptyNothingTodayBody;

  /// No description provided for @ringDone.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get ringDone;

  /// No description provided for @ringSemantics.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done today'**
  String ringSemantics(int done, int total);

  /// No description provided for @summaryAllDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get summaryAllDoneTitle;

  /// No description provided for @summaryAllDoneBody.
  ///
  /// In en, this message translates to:
  /// **'You did not forget anything today.'**
  String get summaryAllDoneBody;

  /// No description provided for @summaryOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 overdue} other{{count} overdue}}'**
  String summaryOverdueTitle(int count);

  /// No description provided for @summaryOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'Tap a circle to mark it as done.'**
  String get summaryOverdueBody;

  /// No description provided for @summaryNextTitle.
  ///
  /// In en, this message translates to:
  /// **'Next at {time}'**
  String summaryNextTitle(String time);

  /// No description provided for @sectionTodo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get sectionTodo;

  /// No description provided for @sectionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sectionDone;

  /// No description provided for @itemOverdue.
  ///
  /// In en, this message translates to:
  /// **'{time} · overdue'**
  String itemOverdue(String time);

  /// No description provided for @itemAt.
  ///
  /// In en, this message translates to:
  /// **'{title} at {time}'**
  String itemAt(String title, String time);

  /// No description provided for @activeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reminder on} other{{count} reminders on}}'**
  String activeCount(int count);

  /// No description provided for @createOwn.
  ///
  /// In en, this message translates to:
  /// **'Create your own reminder'**
  String get createOwn;

  /// No description provided for @groupMine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get groupMine;

  /// No description provided for @tooManyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Too many reminder times. Switch one reminder off or use fewer times.'**
  String get tooManyNotifications;

  /// No description provided for @editNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get editNewTitle;

  /// No description provided for @editEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get editEditTitle;

  /// No description provided for @fieldTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Remind me to…'**
  String get fieldTitleLabel;

  /// No description provided for @fieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Feed the cat'**
  String get fieldTitleHint;

  /// No description provided for @labelIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get labelIcon;

  /// No description provided for @labelRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get labelRepeat;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get repeatMonthly;

  /// No description provided for @labelOnDays.
  ///
  /// In en, this message translates to:
  /// **'On these days'**
  String get labelOnDays;

  /// No description provided for @labelOnDay.
  ///
  /// In en, this message translates to:
  /// **'On day'**
  String get labelOnDay;

  /// No description provided for @dayOfMonthOption.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of every month'**
  String dayOfMonthOption(int day);

  /// No description provided for @dayOfMonthHelper.
  ///
  /// In en, this message translates to:
  /// **'Only up to day 28, because every month has it.'**
  String get dayOfMonthHelper;

  /// No description provided for @labelTimes.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get labelTimes;

  /// No description provided for @removeTime.
  ///
  /// In en, this message translates to:
  /// **'Remove {time}'**
  String removeTime(String time);

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// No description provided for @pickTimeHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick a time'**
  String get pickTimeHelp;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @turnOffReminder.
  ///
  /// In en, this message translates to:
  /// **'Turn this reminder off'**
  String get turnOffReminder;

  /// No description provided for @deleteReminder.
  ///
  /// In en, this message translates to:
  /// **'Delete this reminder'**
  String get deleteReminder;

  /// No description provided for @errorNoTitle.
  ///
  /// In en, this message translates to:
  /// **'Give the reminder a name.'**
  String get errorNoTitle;

  /// No description provided for @errorNoTimes.
  ///
  /// In en, this message translates to:
  /// **'Add at least one time.'**
  String get errorNoTimes;

  /// No description provided for @errorNoWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one day of the week.'**
  String get errorNoWeekdays;

  /// No description provided for @scheduleEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get scheduleEveryDay;

  /// No description provided for @scheduleManyTimes.
  ///
  /// In en, this message translates to:
  /// **'{count} times ({first}–{last})'**
  String scheduleManyTimes(int count, String first, String last);

  /// No description provided for @customMessage.
  ///
  /// In en, this message translates to:
  /// **'It\'s time: {title}'**
  String customMessage(String title);

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notifChannelName;

  /// No description provided for @notifChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'The reminders you switched on'**
  String get notifChannelDescription;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionSnooze.
  ///
  /// In en, this message translates to:
  /// **'Remind me in {minutes} min'**
  String actionSnooze(int minutes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'id',
    'ja',
    'ko',
    'pt',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
