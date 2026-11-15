// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tabToday => '今天';

  @override
  String get tabReminders => '提醒';

  @override
  String get webPreviewNotice => '这是网页预览版，不会发送通知。通知只在手机应用中有效。';

  @override
  String get notificationsOffNotice => '通知已关闭。请在手机“设置”中为本应用开启通知，才能收到提醒。';

  @override
  String get emptyNoRemindersTitle => '还没有提醒';

  @override
  String get emptyNoRemindersBody => '选几个现成的提醒，打开开关即可。';

  @override
  String get emptyBrowseAction => '查看现成的提醒';

  @override
  String get emptyNothingTodayTitle => '今天没有事项';

  @override
  String get emptyNothingTodayBody => '你的提醒都在其他日子。';

  @override
  String get ringDone => '已完成';

  @override
  String ringSemantics(int done, int total) {
    return '今天已完成 $done/$total';
  }

  @override
  String get summaryAllDoneTitle => '全部完成！';

  @override
  String get summaryAllDoneBody => '今天什么都没忘。';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项已过时间',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody => '点按圆圈标记为已完成。';

  @override
  String summaryNextTitle(String time) {
    return '下一项 $time';
  }

  @override
  String get sectionTodo => '待办';

  @override
  String get sectionDone => '已完成';

  @override
  String itemOverdue(String time) {
    return '$time · 已过时间';
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
      other: '已开启 $count 个提醒',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => '自己创建提醒';

  @override
  String get groupMine => '我的';

  @override
  String get tooManyNotifications => '提醒次数过多。请关闭一个提醒或减少提醒时间。';

  @override
  String get editNewTitle => '新建提醒';

  @override
  String get editEditTitle => '编辑提醒';

  @override
  String get fieldTitleLabel => '提醒什么？';

  @override
  String get fieldTitleHint => '例如：喂猫';

  @override
  String get labelIcon => '图标';

  @override
  String get labelRepeat => '重复';

  @override
  String get repeatDaily => '每天';

  @override
  String get repeatWeekly => '每周';

  @override
  String get repeatMonthly => '每月';

  @override
  String get labelOnDays => '在这些日子';

  @override
  String get labelOnDay => '日期';

  @override
  String dayOfMonthOption(int day) {
    return '每月 $day 日';
  }

  @override
  String get dayOfMonthHelper => '最多只能选到 28 日，因为每个月都有这一天。';

  @override
  String get labelTimes => '提醒时间';

  @override
  String removeTime(String time) {
    return '删除 $time';
  }

  @override
  String get addTime => '添加时间';

  @override
  String get pickTimeHelp => '选择时间';

  @override
  String get save => '保存';

  @override
  String get turnOffReminder => '关闭此提醒';

  @override
  String get deleteReminder => '删除此提醒';

  @override
  String get errorNoTitle => '请给提醒起个名字。';

  @override
  String get errorNoTimes => '请至少添加一个时间。';

  @override
  String get errorNoWeekdays => '请至少选择一天。';

  @override
  String get scheduleEveryDay => '每天';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count 次（$first–$last）';
  }

  @override
  String customMessage(String title) {
    return '时间到了：$title';
  }

  @override
  String get notifChannelName => '提醒';

  @override
  String get notifChannelDescription => '你已开启的提醒';

  @override
  String get actionDone => '完成';

  @override
  String actionSnooze(int minutes) {
    return '$minutes 分钟后再提醒';
  }
}
