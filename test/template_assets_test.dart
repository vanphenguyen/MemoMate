import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nho_nhe/l10n/app_localizations.dart';
import 'package:nho_nhe/logic/today.dart';
import 'package:nho_nhe/models/reminder.dart';
import 'package:nho_nhe/widgets/reminder_icons.dart';

/// Checks every file in assets/templates. Run after editing the JSON.
void main() {
  const dir = 'assets/templates';
  final index = jsonDecode(File('$dir/index.json').readAsStringSync()) as Map<String, dynamic>;
  final ids = (index['groups'] as List).cast<String>();
  final groups = [
    for (final id in ids)
      TemplateGroup.fromJson(
        jsonDecode(File('$dir/$id.json').readAsStringSync()) as Map<String, dynamic>,
      ),
  ];

  test('index lists every group file exactly once', () {
    final files = Directory(dir)
        .listSync()
        .map((f) => f.uri.pathSegments.last)
        .where((name) => name.endsWith('.json') && name != 'index.json')
        .map((name) => name.substring(0, name.length - 5))
        .toSet();
    expect(ids.toSet(), files);
    expect(ids.length, ids.toSet().length);
  });

  test('each group file is named after its id', () {
    for (var i = 0; i < ids.length; i++) {
      expect(groups[i].id, ids[i]);
      expect(groups[i].templates, isNotEmpty, reason: ids[i]);
    }
  });

  test('template ids are unique across the whole library', () {
    final all = [for (final g in groups) for (final t in g.templates) t.id];
    expect(all.length, all.toSet().length);
  });

  test('every template has text and a known icon', () {
    for (final group in groups) {
      expect(reminderIcons, contains(group.icon), reason: group.id);
      for (final t in group.templates) {
        expect(reminderIcons, contains(t.icon), reason: '${t.id}: icon "${t.icon}"');
      }
    }
  });

  test('every name and message is written in every app language', () {
    final languages = {for (final l in AppLocalizations.supportedLocales) l.languageCode};
    void check(LocalizedText text, String where) {
      expect(text.byLanguage.keys.toSet(), languages, reason: where);
      for (final entry in text.byLanguage.entries) {
        expect(entry.value.trim(), isNotEmpty, reason: '$where (${entry.key})');
      }
    }

    for (final group in groups) {
      check(group.title, 'group ${group.id}');
      for (final t in group.templates) {
        check(t.title, '${t.id} title');
        check(t.message, '${t.id} message');
      }
    }
  });

  test('every icon offered for your own reminders exists', () {
    for (final name in customIconChoices) {
      expect(reminderIcons, contains(name));
    }
    expect(customIconChoices, contains(Reminder.customIcon));
  });

  test('switching on the whole library stays within the iPhone limit', () {
    final all = [
      for (final g in groups)
        for (final t in g.templates) Reminder.fromTemplate(t, g),
    ];
    expect(totalNotificationSlots(all), lessThanOrEqualTo(maxNotificationSlots));
  });
}
