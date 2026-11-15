// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabToday => '今日';

  @override
  String get tabReminders => 'リマインダー';

  @override
  String get webPreviewNotice =>
      'これはウェブ版のプレビューのため、通知は送られません。通知はスマホのアプリでのみ動作します。';

  @override
  String get notificationsOffNotice =>
      '通知がオフになっています。リマインダーを受け取るには、スマホの「設定」でこのアプリの通知をオンにしてください。';

  @override
  String get emptyNoRemindersTitle => 'リマインダーはまだありません';

  @override
  String get emptyNoRemindersBody => '用意されたリマインダーを選んでオンにするだけです。';

  @override
  String get emptyBrowseAction => '用意されたリマインダーを見る';

  @override
  String get emptyNothingTodayTitle => '今日の予定はありません';

  @override
  String get emptyNothingTodayBody => 'リマインダーは別の日に設定されています。';

  @override
  String get ringDone => '完了';

  @override
  String ringSemantics(int done, int total) {
    return '今日は$total件中$done件完了';
  }

  @override
  String get summaryAllDoneTitle => 'すべて完了！';

  @override
  String get summaryAllDoneBody => '今日は何も忘れませんでした。';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件が時間を過ぎています',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody => '丸をタップして完了にします。';

  @override
  String summaryNextTitle(String time) {
    return '次は $time';
  }

  @override
  String get sectionTodo => 'やること';

  @override
  String get sectionDone => '完了';

  @override
  String itemOverdue(String time) {
    return '$time · 時間超過';
  }

  @override
  String itemAt(String title, String time) {
    return '$time $title';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のリマインダーがオン',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => '自分でリマインダーを作る';

  @override
  String get groupMine => '自分用';

  @override
  String get tooManyNotifications => 'リマインダーの回数が多すぎます。1つオフにするか、時刻を減らしてください。';

  @override
  String get editNewTitle => '新しいリマインダー';

  @override
  String get editEditTitle => 'リマインダーを編集';

  @override
  String get fieldTitleLabel => '何をリマインドしますか？';

  @override
  String get fieldTitleHint => '例：猫にごはんをあげる';

  @override
  String get labelIcon => 'アイコン';

  @override
  String get labelRepeat => '繰り返し';

  @override
  String get repeatDaily => '毎日';

  @override
  String get repeatWeekly => '毎週';

  @override
  String get repeatMonthly => '毎月';

  @override
  String get labelOnDays => '曜日';

  @override
  String get labelOnDay => '日付';

  @override
  String dayOfMonthOption(int day) {
    return '毎月$day日';
  }

  @override
  String get dayOfMonthHelper => 'どの月にもある28日までを選べます。';

  @override
  String get labelTimes => '時刻';

  @override
  String removeTime(String time) {
    return '$time を削除';
  }

  @override
  String get addTime => '時刻を追加';

  @override
  String get pickTimeHelp => '時刻を選択';

  @override
  String get save => '保存';

  @override
  String get turnOffReminder => 'このリマインダーをオフにする';

  @override
  String get deleteReminder => 'このリマインダーを削除';

  @override
  String get errorNoTitle => 'リマインダーに名前を付けてください。';

  @override
  String get errorNoTimes => '時刻を1つ以上追加してください。';

  @override
  String get errorNoWeekdays => '曜日を1つ以上選んでください。';

  @override
  String get scheduleEveryDay => '毎日';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count回（$first–$last）';
  }

  @override
  String customMessage(String title) {
    return '時間です：$title';
  }

  @override
  String get notifChannelName => 'リマインダー';

  @override
  String get notifChannelDescription => 'オンにしたリマインダー';

  @override
  String get actionDone => '完了';

  @override
  String actionSnooze(int minutes) {
    return '$minutes分後に再通知';
  }
}
