// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get tabToday => 'Hari ini';

  @override
  String get tabReminders => 'Pengingat';

  @override
  String get webPreviewNotice =>
      'Ini pratinjau web, jadi tidak ada notifikasi yang dikirim. Notifikasi hanya berfungsi di aplikasi pada ponsel.';

  @override
  String get notificationsOffNotice =>
      'Notifikasi dimatikan. Aktifkan notifikasi untuk aplikasi ini di Pengaturan ponsel agar pengingat bisa masuk.';

  @override
  String get emptyNoRemindersTitle => 'Belum ada pengingat';

  @override
  String get emptyNoRemindersBody =>
      'Pilih beberapa pengingat siap pakai, lalu aktifkan. Selesai.';

  @override
  String get emptyBrowseAction => 'Lihat pengingat siap pakai';

  @override
  String get emptyNothingTodayTitle => 'Tidak ada untuk hari ini';

  @override
  String get emptyNothingTodayBody => 'Pengingat Anda jatuh pada hari lain.';

  @override
  String get ringDone => 'selesai';

  @override
  String ringSemantics(int done, int total) {
    return '$done dari $total selesai hari ini';
  }

  @override
  String get summaryAllDoneTitle => 'Semua selesai!';

  @override
  String get summaryAllDoneBody => 'Hari ini tidak ada yang terlupa.';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count terlewat',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody => 'Ketuk lingkaran untuk menandai selesai.';

  @override
  String summaryNextTitle(String time) {
    return 'Berikutnya pukul $time';
  }

  @override
  String get sectionTodo => 'Perlu dilakukan';

  @override
  String get sectionDone => 'Selesai';

  @override
  String itemOverdue(String time) {
    return '$time · terlewat';
  }

  @override
  String itemAt(String title, String time) {
    return '$title pukul $time';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pengingat aktif',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => 'Buat pengingat sendiri';

  @override
  String get groupMine => 'Milik saya';

  @override
  String get tooManyNotifications =>
      'Terlalu banyak waktu pengingat. Matikan satu pengingat atau kurangi waktunya.';

  @override
  String get editNewTitle => 'Pengingat baru';

  @override
  String get editEditTitle => 'Ubah pengingat';

  @override
  String get fieldTitleLabel => 'Ingatkan apa?';

  @override
  String get fieldTitleHint => 'Contoh: Beri makan kucing';

  @override
  String get labelRepeat => 'Ulangi';

  @override
  String get repeatDaily => 'Harian';

  @override
  String get repeatWeekly => 'Mingguan';

  @override
  String get repeatMonthly => 'Bulanan';

  @override
  String get labelOnDays => 'Pada hari';

  @override
  String get labelOnDay => 'Pada tanggal';

  @override
  String dayOfMonthOption(int day) {
    return 'Tanggal $day setiap bulan';
  }

  @override
  String get dayOfMonthHelper =>
      'Hanya sampai tanggal 28, karena setiap bulan memilikinya.';

  @override
  String get labelTimes => 'Waktu';

  @override
  String removeTime(String time) {
    return 'Hapus $time';
  }

  @override
  String get addTime => 'Tambah waktu';

  @override
  String get pickTimeHelp => 'Pilih waktu';

  @override
  String get save => 'Simpan';

  @override
  String get turnOffReminder => 'Matikan pengingat ini';

  @override
  String get deleteReminder => 'Hapus pengingat ini';

  @override
  String get errorNoTitle => 'Beri nama pengingat.';

  @override
  String get errorNoTimes => 'Tambahkan setidaknya satu waktu.';

  @override
  String get errorNoWeekdays => 'Pilih setidaknya satu hari.';

  @override
  String get scheduleEveryDay => 'Setiap hari';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count kali ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return 'Sudah waktunya: $title';
  }

  @override
  String get notifChannelName => 'Pengingat';

  @override
  String get notifChannelDescription => 'Pengingat yang Anda aktifkan';

  @override
  String get actionDone => 'Selesai';

  @override
  String actionSnooze(int minutes) {
    return 'Ingatkan lagi $minutes menit';
  }
}
