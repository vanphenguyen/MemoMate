import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Checks lib/l10n/app_*.arb. Run after editing a translation.
void main() {
  Map<String, dynamic> read(File f) => jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  Set<String> keys(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();
  Set<String> placeholders(String text) =>
      RegExp(r'\{(\w+)[,}]').allMatches(text).map((m) => m[1]!).toSet();

  final english = read(File('lib/l10n/app_en.arb'));
  final files = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .toList();

  test('there are several languages', () => expect(files.length, greaterThanOrEqualTo(10)));

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    test('$name has every string, with the same placeholders as English', () {
      final arb = read(file);
      expect(keys(arb), keys(english));
      for (final key in keys(english)) {
        final text = arb[key] as String;
        expect(text.trim(), isNotEmpty, reason: key);
        expect(placeholders(text), placeholders(english[key] as String), reason: key);
      }
    });
  }
}
