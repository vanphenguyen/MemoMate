import 'package:flutter_test/flutter_test.dart';
import 'package:nho_nhe/services/reminder_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('ticks are filed per day and can be undone', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await ReminderStore.load();
    final today = DateTime(2026, 11, 16);
    final tomorrow = DateTime(2026, 11, 17);

    await store.setDone(today, 'nuoc@08:00', true);
    expect(store.doneKeys(today), {'nuoc@08:00'});
    expect(store.doneKeys(tomorrow), isEmpty);

    await store.setDone(today, 'nuoc@08:00', false);
    expect(store.doneKeys(today), isEmpty);
  });

  test('pruneOld deletes only ticks older than the keep window', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await ReminderStore.load();
    final today = DateTime(2026, 11, 16);
    final old = DateTime(2026, 8, 1);
    final recent = DateTime(2026, 11, 1);

    await store.setDone(old, 'a@08:00', true);
    await store.setDone(recent, 'a@08:00', true);
    await store.pruneOld(today);

    expect(store.doneKeys(old), isEmpty);
    expect(store.doneKeys(recent), {'a@08:00'});
  });

  test('one unreadable saved reminder does not hide the others', () async {
    SharedPreferences.setMockInitialValues({
      'reminders': '[{"id":"hong"},{"id":"ok","title":"Ổn","icon":"key","color":1,'
          '"schedule":{"type":"daily","times":["09:00"]}}]',
    });
    final store = await ReminderStore.load();
    expect(store.reminders().map((r) => r.id), ['ok']);
  });
}
