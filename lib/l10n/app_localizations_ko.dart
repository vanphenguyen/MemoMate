// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tabToday => '오늘';

  @override
  String get tabReminders => '알림';

  @override
  String get webPreviewNotice => '웹 미리보기라서 알림이 전송되지 않습니다. 알림은 휴대폰 앱에서만 작동합니다.';

  @override
  String get notificationsOffNotice =>
      '알림이 꺼져 있습니다. 알림을 받으려면 휴대폰 설정에서 이 앱의 알림을 켜 주세요.';

  @override
  String get emptyNoRemindersTitle => '아직 알림이 없습니다';

  @override
  String get emptyNoRemindersBody => '준비된 알림을 고르고 켜기만 하면 됩니다.';

  @override
  String get emptyBrowseAction => '준비된 알림 보기';

  @override
  String get emptyNothingTodayTitle => '오늘은 할 일이 없습니다';

  @override
  String get emptyNothingTodayBody => '알림이 다른 날에 설정되어 있습니다.';

  @override
  String get ringDone => '완료';

  @override
  String ringSemantics(int done, int total) {
    return '오늘 $total개 중 $done개 완료';
  }

  @override
  String get summaryAllDoneTitle => '모두 완료!';

  @override
  String get summaryAllDoneBody => '오늘은 아무것도 잊지 않았어요.';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개가 시간이 지났습니다',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody => '원을 눌러 완료로 표시하세요.';

  @override
  String summaryNextTitle(String time) {
    return '다음은 $time';
  }

  @override
  String get sectionTodo => '할 일';

  @override
  String get sectionDone => '완료';

  @override
  String itemOverdue(String time) {
    return '$time · 시간 지남';
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
      other: '알림 $count개 켜짐',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => '나만의 알림 만들기';

  @override
  String get groupMine => '내 알림';

  @override
  String get tooManyNotifications => '알림 횟수가 너무 많습니다. 알림 하나를 끄거나 시간을 줄여 주세요.';

  @override
  String get editNewTitle => '새 알림';

  @override
  String get editEditTitle => '알림 수정';

  @override
  String get fieldTitleLabel => '무엇을 알릴까요?';

  @override
  String get fieldTitleHint => '예: 고양이 밥 주기';

  @override
  String get labelIcon => '아이콘';

  @override
  String get labelRepeat => '반복';

  @override
  String get repeatDaily => '매일';

  @override
  String get repeatWeekly => '매주';

  @override
  String get repeatMonthly => '매월';

  @override
  String get labelOnDays => '요일';

  @override
  String get labelOnDay => '날짜';

  @override
  String dayOfMonthOption(int day) {
    return '매월 $day일';
  }

  @override
  String get dayOfMonthHelper => '모든 달에 있는 28일까지만 선택할 수 있습니다.';

  @override
  String get labelTimes => '시간';

  @override
  String removeTime(String time) {
    return '$time 삭제';
  }

  @override
  String get addTime => '시간 추가';

  @override
  String get pickTimeHelp => '시간 선택';

  @override
  String get save => '저장';

  @override
  String get turnOffReminder => '이 알림 끄기';

  @override
  String get deleteReminder => '이 알림 삭제';

  @override
  String get errorNoTitle => '알림 이름을 입력해 주세요.';

  @override
  String get errorNoTimes => '시간을 하나 이상 추가해 주세요.';

  @override
  String get errorNoWeekdays => '요일을 하나 이상 선택해 주세요.';

  @override
  String get scheduleEveryDay => '매일';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count회 ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return '시간이 됐어요: $title';
  }

  @override
  String get notifChannelName => '알림';

  @override
  String get notifChannelDescription => '켜 둔 알림';

  @override
  String get actionDone => '완료';

  @override
  String actionSnooze(int minutes) {
    return '$minutes분 후 다시 알림';
  }
}
