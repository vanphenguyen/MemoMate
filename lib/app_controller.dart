import 'package:flutter/widgets.dart';

import 'logic/today.dart';
import 'models/reminder.dart';
import 'services/reminder_notifier.dart';
import 'services/reminder_store.dart';
import 'texts.dart';

/// Why a reminder could not be switched on or saved.
enum SaveProblem { tooManyNotifications }

/// The app's state: which reminders are on and what has been ticked today.
/// Screens listen to it and rebuild when it changes.
class AppController extends ChangeNotifier {
  AppController({
    required this.groups,
    required this.store,
    required this.notifier,
    required AppTexts texts,
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        // ignore: prefer_initializing_formals
        _texts = texts {
    _reminders = store.reminders();
    _templates = {
      for (final group in groups)
        for (final template in group.templates) template.id: template,
    };
  }

  final List<TemplateGroup> groups;
  final ReminderStore store;
  final ReminderNotifier notifier;
  final DateTime Function() _clock;

  late List<Reminder> _reminders;
  late final Map<String, ReminderTemplate> _templates;
  AppTexts _texts;

  /// Everything the app says, in the current language.
  AppTexts get texts => _texts;

  /// The language picked in the app; null means "same as the phone".
  String? get languageChoice => store.languageChoice;

  /// Picks a language by code, or null to follow the phone again. The app
  /// rebuilds in that language, which then reaches [setLocale].
  Future<void> chooseLanguage(String? language) async {
    await store.saveLanguageChoice(language);
    notifyListeners();
  }

  /// Switches language. Notifications are rewritten in the new language.
  Future<void> setLocale(Locale locale) async {
    if (locale == _texts.locale) return;
    // No notifyListeners: this is called while the app is being built, and
    // every screen below reads the new texts in that same build.
    _texts = AppTexts(locale);
    await store.saveLanguage(_texts.language);
    await _syncNotifications();
  }

  String titleOf(Reminder reminder) =>
      _texts.reminderTitle(reminder, _templates[reminder.templateId]);

  String messageOf(Reminder reminder) =>
      _texts.reminderMessage(reminder, _templates[reminder.templateId]);

  /// False after the user refused notifications; the app then says so.
  bool notificationsAllowed = true;

  DateTime get now => _clock();

  List<Reminder> get reminders => List.unmodifiable(_reminders);

  List<Reminder> get customReminders => [
        for (final r in _reminders)
          if (r.isCustom) r,
      ];

  Reminder? reminderById(String id) {
    for (final r in _reminders) {
      if (r.id == id) return r;
    }
    return null;
  }

  bool isActive(ReminderTemplate template) => reminderById(template.id) != null;

  List<TodayItem> today() => buildToday(_reminders, now, store.doneKeys(now));

  /// Call at startup: puts the saved reminders back on the phone's schedule
  /// (they are lost if the app's data was restored or the OS dropped them).
  Future<void> start() async {
    await store.pruneOld(now);
    await store.saveLanguage(_texts.language);
    if (_reminders.isNotEmpty) await _syncNotifications();
  }

  /// Re-reads ticks made from notification buttons while the app was away.
  Future<void> refresh() async {
    await store.reload();
    _reminders = store.reminders();
    notifyListeners();
  }

  Future<SaveProblem?> enableTemplate(ReminderTemplate template, TemplateGroup group) =>
      saveReminder(Reminder.fromTemplate(template, group, since: now));

  Future<void> disable(String reminderId) async {
    _reminders = [
      for (final r in _reminders)
        if (r.id != reminderId) r,
    ];
    await _persist();
  }

  /// Adds [reminder], or replaces the one with the same id.
  Future<SaveProblem?> saveReminder(Reminder reminder) async {
    final next = [
      for (final r in _reminders)
        if (r.id != reminder.id) r,
      reminder,
    ];
    if (totalNotificationSlots(next) > maxNotificationSlots) {
      return SaveProblem.tooManyNotifications;
    }
    if (!store.askedPermission) {
      notificationsAllowed = await notifier.requestPermission();
      await store.markAskedPermission();
    }
    _reminders = next;
    await _persist();
    return null;
  }

  Future<void> toggleDone(TodayItem item) async {
    await store.setDone(now, item.key, !item.done);
    notifyListeners();
  }

  Future<void> _persist() async {
    await store.saveReminders(_reminders);
    notifyListeners();
    await _syncNotifications();
  }

  Future<void> _syncNotifications() => notifier.sync(
        [
          for (final r in _reminders)
            PlannedReminder(reminder: r, title: titleOf(r), body: messageOf(r)),
        ],
        NotificationLabels.of(_texts.l10n),
      );
}
