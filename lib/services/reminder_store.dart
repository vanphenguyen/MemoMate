import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../logic/today.dart';
import '../models/reminder.dart';

/// Active reminders and daily ticks, saved on the device only.
class ReminderStore {
  ReminderStore(this._prefs);

  static Future<ReminderStore> load() async =>
      ReminderStore(await SharedPreferences.getInstance());

  static const _remindersKey = 'reminders';
  static const _donePrefix = 'done.';
  static const _askedPermissionKey = 'askedPermission';

  /// Ticks older than this are deleted so storage never grows without limit.
  static const keepDays = 60;

  final SharedPreferences _prefs;

  /// Picks up ticks written by the notification "Xong" button, which runs
  /// in a separate background isolate.
  Future<void> reload() => _prefs.reload();

  List<Reminder> reminders() {
    final raw = _prefs.getString(_remindersKey);
    if (raw == null) return [];
    final result = <Reminder>[];
    for (final item in jsonDecode(raw) as List) {
      try {
        result.add(Reminder.fromJson(item as Map<String, dynamic>));
      } on Object {
        // One unreadable entry must not hide the others.
      }
    }
    return result;
  }

  Future<void> saveReminders(List<Reminder> reminders) => _prefs.setString(
        _remindersKey,
        jsonEncode([for (final r in reminders) r.toJson()]),
      );

  Set<String> doneKeys(DateTime day) =>
      (_prefs.getStringList('$_donePrefix${dayKey(day)}') ?? const []).toSet();

  Future<void> setDone(DateTime day, String key, bool done) async {
    final keys = doneKeys(day);
    if (done ? !keys.add(key) : !keys.remove(key)) return;
    await _prefs.setStringList('$_donePrefix${dayKey(day)}', keys.toList());
  }

  bool get askedPermission => _prefs.getBool(_askedPermissionKey) ?? false;

  Future<void> markAskedPermission() => _prefs.setBool(_askedPermissionKey, true);

  /// The app language last shown, for notification buttons pressed while
  /// the app is closed.
  String? get language => _prefs.getString('language');

  Future<void> saveLanguage(String language) => _prefs.setString('language', language);

  /// Deletes ticks from more than [keepDays] days before [today].
  Future<void> pruneOld(DateTime today) async {
    final cutoff = dayKey(DateTime(today.year, today.month, today.day - keepDays));
    for (final key in _prefs.getKeys().toList()) {
      if (key.startsWith(_donePrefix) &&
          key.substring(_donePrefix.length).compareTo(cutoff) < 0) {
        await _prefs.remove(key);
      }
    }
  }
}
