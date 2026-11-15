# Nhớ Nhé: ghi chú cho Claude

App Flutter cho người hay quên: một thư viện lời nhắc có sẵn (uống nước, uống thuốc, đóng tiền điện...), bật là chạy,
bấm "Xong" ngay trên thông báo. Cùng kiểu dự án với `frog-pond-english`.
Chủ dự án không phải lập trình viên: trả lời bằng tiếng Việt, đơn giản, kèm ảnh chụp màn hình khi đổi giao diện.

## Cấu trúc
- `assets/templates/*.json`: các nhóm lời nhắc có sẵn. **Thêm, sửa lời nhắc hay nhóm thì chỉ sửa JSON**, không sửa code.
  Định dạng xem `docs/THIET_KE.md`. Icon mới phải thêm vào `lib/widgets/reminder_icons.dart` trước.
- `assets/templates/index.json`: danh sách và thứ tự nhóm trong thư viện.
- `lib/l10n/app_*.arb`: chữ giao diện cho từng ngôn ngữ (`app_en.arb` là bản gốc). Các file `app_localizations*.dart`
  cùng thư mục là code tự sinh: **không sửa tay**, chạy `flutter gen-l10n` sau khi sửa file `.arb`.
- `lib/texts.dart`: chọn ngôn ngữ theo máy (`resolveLocale`) và các câu ghép bằng code (mô tả lịch, ngày tháng).
- `lib/models/`: `Schedule` (lịch lặp: ngày, tuần, tháng) và `Reminder` (lời nhắc đang bật).
- `lib/logic/today.dart`: danh sách việc hôm nay, thuần logic, không phụ thuộc giao diện.
- `lib/app_controller.dart`: trạng thái app (bật, tắt, đánh dấu xong); các màn hình lắng nghe nó.
- `lib/services/reminder_store.dart`: lưu trên máy bằng `shared_preferences`.
- `lib/services/reminder_notifier.dart`: lên lịch thông báo (`flutter_local_notifications`) và xử lý nút "Xong", "Nhắc lại".
- `lib/screens/`: Hôm nay, Lời nhắc (thư viện), màn hình sửa.

## Lệnh
- Kiểm tra trước khi commit: `flutter analyze && flutter test`. Cả hai phải sạch.
- `test/template_assets_test.dart` kiểm tra mọi file JSON và `test/translations_test.dart` kiểm tra mọi file `.arb`;
  luôn chạy sau khi sửa dữ liệu hoặc bản dịch.
- Phiên cloud: nếu chưa có lệnh `flutter`, chạy `CLAUDE_CODE_REMOTE=true bash scripts/claude_session_start.sh`
  (cài Flutter vào `~/flutter`), rồi thêm `~/flutter/bin` vào `PATH`.
- Xem giao diện trên cloud: `flutter build web --no-web-resources-cdn`, phục vụ `build/web` bằng `python3 -m http.server`,
  chụp bằng Playwright (Node) khung 390x844 và đặt `locale: 'vi-VN'`.
- Repo GitHub: `vanphenguyen/MemoMate`. Mỗi lần đẩy lên `main`, `.github/workflows/pages.yml` đăng bản web lên
  https://vanphenguyen.github.io/MemoMate/ (đổi tên repo thì phải sửa `--base-href` trong file đó).
- Bản web chỉ để xem giao diện: trình duyệt không lên lịch thông báo được, nên web dùng `NoopReminderNotifier`.
- Container cloud không tải được Android SDK; APK được build bởi GitHub Actions (`.github/workflows/build.yml`).
  **Thông báo chỉ thử được trên điện thoại thật.**

## Quy ước
- Mã định danh app: `com.phenv.nhonhe` (Android và iOS). Không đổi sau khi đã lên store.
- Không thu thập dữ liệu, không cần mạng, không tài khoản. Không thêm thư viện gửi dữ liệu ra ngoài nếu chủ dự án chưa đồng ý.
- Đa ngôn ngữ: vi, en, zh, es, pt, fr, de, ja, ko, id. App theo ngôn ngữ của máy, không có thì dùng tiếng Anh.
  **Không viết chữ hiển thị thẳng trong code**: thêm vào mọi file `.arb`; tên và nội dung lời nhắc có sẵn nằm trong JSON,
  đủ cả 10 ngôn ngữ. Thêm ngôn ngữ mới: thêm `app_xx.arb`, thêm `xx` vào mọi chỗ trong JSON và vào
  `CFBundleLocalizations` của `ios/Runner/Info.plist`.
- Lời nhắc từ thư viện không lưu tên riêng (`Reminder.title` là null) nên tự đổi theo ngôn ngữ; chỉ lưu tên khi người dùng tự sửa.
- iPhone chỉ giữ 64 thông báo đã lên lịch cho mỗi app. Tổng số lần nhắc bị chặn ở 60 (`maxNotificationSlots`);
  bật cả thư viện phải nằm trong giới hạn này (có bài kiểm tra).
- Lịch theo tháng chỉ cho chọn ngày 1 đến 28, vì ngày 29 đến 31 bị bỏ qua ở tháng ngắn.
- Mỗi thay đổi đáng kể: cập nhật `CHANGELOG.md`; khi phát hành tăng `version` trong `pubspec.yaml`
  (`x.y.z+build`, số build luôn tăng).
- Làm trên nhánh riêng, mở Pull Request vào `main`.
