// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get tabToday => 'Hôm nay';

  @override
  String get tabReminders => 'Lời nhắc';

  @override
  String get webPreviewNotice =>
      'Đây là bản xem thử trên web nên không gửi thông báo. Thông báo chỉ hoạt động trong app trên điện thoại.';

  @override
  String get notificationsOffNotice =>
      'Thông báo đang bị tắt. Hãy bật thông báo cho app này trong phần Cài đặt của điện thoại để nhận lời nhắc.';

  @override
  String get emptyNoRemindersTitle => 'Chưa có lời nhắc nào';

  @override
  String get emptyNoRemindersBody =>
      'Chọn vài lời nhắc có sẵn, bật lên là xong.';

  @override
  String get emptyBrowseAction => 'Xem lời nhắc có sẵn';

  @override
  String get emptyNothingTodayTitle => 'Hôm nay không có việc gì';

  @override
  String get emptyNothingTodayBody =>
      'Các lời nhắc của bạn rơi vào những ngày khác.';

  @override
  String get ringDone => 'đã xong';

  @override
  String ringSemantics(int done, int total) {
    return 'Đã xong $done trên $total việc hôm nay';
  }

  @override
  String get summaryAllDoneTitle => 'Xong hết rồi!';

  @override
  String get summaryAllDoneBody => 'Bạn không quên việc nào hôm nay.';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count việc đã qua giờ',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody => 'Chạm vào ô tròn để đánh dấu đã làm.';

  @override
  String summaryNextTitle(String time) {
    return 'Tiếp theo lúc $time';
  }

  @override
  String get sectionTodo => 'Cần làm';

  @override
  String get sectionDone => 'Đã xong';

  @override
  String itemOverdue(String time) {
    return '$time · đã qua giờ';
  }

  @override
  String itemAt(String title, String time) {
    return '$title lúc $time';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lời nhắc đang bật',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => 'Tự tạo lời nhắc';

  @override
  String get groupMine => 'Của tôi';

  @override
  String get tooManyNotifications =>
      'Đã quá nhiều lần nhắc. Hãy tắt bớt một lời nhắc hoặc giảm số giờ nhắc.';

  @override
  String get editNewTitle => 'Lời nhắc mới';

  @override
  String get editEditTitle => 'Sửa lời nhắc';

  @override
  String get fieldTitleLabel => 'Nhắc việc gì?';

  @override
  String get fieldTitleHint => 'Ví dụ: Cho mèo ăn';

  @override
  String get labelRepeat => 'Lặp lại';

  @override
  String get repeatDaily => 'Mỗi ngày';

  @override
  String get repeatWeekly => 'Theo tuần';

  @override
  String get repeatMonthly => 'Theo tháng';

  @override
  String get labelOnDays => 'Vào các ngày';

  @override
  String get labelOnDay => 'Vào ngày';

  @override
  String dayOfMonthOption(int day) {
    return 'Ngày $day hằng tháng';
  }

  @override
  String get dayOfMonthHelper =>
      'Chỉ chọn được đến ngày 28 vì tháng nào cũng có.';

  @override
  String get labelTimes => 'Giờ nhắc';

  @override
  String removeTime(String time) {
    return 'Bỏ giờ $time';
  }

  @override
  String get addTime => 'Thêm giờ';

  @override
  String get pickTimeHelp => 'Chọn giờ nhắc';

  @override
  String get save => 'Lưu';

  @override
  String get turnOffReminder => 'Tắt lời nhắc này';

  @override
  String get deleteReminder => 'Xóa lời nhắc này';

  @override
  String get errorNoTitle => 'Hãy đặt tên cho lời nhắc.';

  @override
  String get errorNoTimes => 'Cần ít nhất một giờ nhắc.';

  @override
  String get errorNoWeekdays => 'Cần chọn ít nhất một ngày trong tuần.';

  @override
  String get scheduleEveryDay => 'Mỗi ngày';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count lần ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return 'Đến giờ: $title';
  }

  @override
  String get notifChannelName => 'Lời nhắc';

  @override
  String get notifChannelDescription => 'Các lời nhắc bạn đã bật';

  @override
  String get actionDone => 'Xong';

  @override
  String actionSnooze(int minutes) {
    return 'Nhắc lại sau $minutes phút';
  }
}
