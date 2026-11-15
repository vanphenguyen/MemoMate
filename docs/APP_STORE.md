# Đưa Nhớ Nhé lên App Store bằng Codemagic

Codemagic thay cho máy Mac: nó build bản iPhone và tải lên App Store Connect. Cấu hình nằm trong `codemagic.yaml`.
Các bước dưới đây chỉ làm một lần. Tên nút trên web của Apple và Codemagic có thể đổi chút ít theo thời gian.

## Cần có trước
- Tài khoản **Apple Developer Program** (99 USD mỗi năm), đã được Apple duyệt.
- Quyết định xong **tên app** và **mã app** (`com.phenv.nhonhe`). Mã app không đổi được sau khi đăng ký.

## 1. Đăng ký mã app với Apple
developer.apple.com > Account > Certificates, Identifiers & Profiles > **Identifiers** > dấu **+** > App IDs > App.
- Description: tên app. Bundle ID: chọn **Explicit**, nhập `com.phenv.nhonhe`.
- Không cần tích khả năng (capability) nào. App chỉ dùng thông báo tại máy, không dùng Push Notifications.

## 2. Tạo app trên App Store Connect
appstoreconnect.apple.com > Apps > dấu **+** > New App.
- Platform: iOS. Name: tên hiện trên App Store (phải chưa ai dùng). Primary language: tùy bạn.
- Bundle ID: chọn mã vừa đăng ký. SKU: ví dụ `nhonhe`.

## 3. Tạo khóa API cho Codemagic
App Store Connect > Users and Access > **Integrations** > App Store Connect API > Team Keys > dấu **+**.
- Name: `codemagic`. Access: **App Manager**.
- Tải file `.p8` về (chỉ tải được một lần), ghi lại **Issuer ID** và **Key ID**.
- **Không gửi file này hay nội dung của nó cho ai, kể cả vào khung chat.**

Trong Codemagic: Teams > (tài khoản của bạn) > **Integrations** > Developer Portal > Manage keys > Add key.
- **Đặt tên đúng là `codemagic`** (file `codemagic.yaml` gọi khóa theo tên này), nhập Issuer ID, Key ID, tải file `.p8` lên.

## 4. Chứng chỉ ký app
Codemagic: Teams > (tài khoản của bạn) > **codemagic.yaml settings** > Code signing identities.
- Tab **iOS certificates** > Generate certificate: loại **Apple Distribution**, chọn khóa `codemagic`, đặt tên tham chiếu
  bất kỳ. Tải file chứng chỉ về và cất giữ cùng mật khẩu Codemagic hiện ra.

## 5. Hồ sơ cấp phép (provisioning profile)
developer.apple.com > Profiles > dấu **+** > Distribution > **App Store Connect**.
- Chọn App ID `com.phenv.nhonhe`, chọn chứng chỉ vừa tạo ở bước 4, đặt tên (ví dụ `nhonhe appstore`), Generate.

Quay lại Codemagic > Code signing identities > tab **iOS provisioning profiles** > Fetch profiles > chọn hồ sơ đó,
đặt tên tham chiếu bất kỳ.

## 6. Chạy build
Codemagic > app MemoMate > **Start new build** > nhánh `main` > workflow **iOS - App Store**.
- Nếu Codemagic hỏi kiểu cấu hình, chọn dùng `codemagic.yaml`.
- Build mất khoảng 10 đến 20 phút. Xong, bản build tự được tải lên App Store Connect, mục **TestFlight**
  (Apple xử lý thêm 10 đến 30 phút mới hiện).
- Nếu build lỗi: gửi cho Claude phần nhật ký của bước bị đỏ.

## 7. Thử trên iPhone bằng TestFlight
App Store Connect > app > TestFlight > Internal Testing > tạo nhóm, thêm Apple ID của bạn.
Cài app **TestFlight** trên iPhone và cài bản thử. **Đây là lúc thử thông báo thật**: bật vài lời nhắc, đợi đến giờ,
thử nút "Xong" và "Nhắc lại sau 15 phút" khi app đang đóng.

## 8. Điền thông tin trang App Store
App Store Connect > app > tab Distribution (App Store):
- **Ảnh chụp màn hình**: bắt buộc cho iPhone màn hình 6.9 inch (hoặc 6.5 inch). Chụp từ iPhone thật hoặc nhờ Claude dựng.
- **Mô tả, từ khóa, danh mục** (gợi ý: Productivity hoặc Health & Fitness).
- **Support URL**: `https://github.com/vanphenguyen/MemoMate/issues`
- **Privacy Policy URL**: `https://vanphenguyen.github.io/MemoMate/privacy.html`
- **App Privacy**: chọn **Data Not Collected** (app không thu thập gì).
- **Age Rating**: trả lời bảng hỏi; app không có nội dung nhạy cảm.
- **Giá**: Free.
- Mục Build: chọn bản build đã tải lên ở bước 6.

## 9. Gửi duyệt
Bấm **Add for Review** rồi **Submit**. Apple thường duyệt trong 1 đến 3 ngày. Nếu bị từ chối, Apple ghi rõ lý do;
gửi nội dung đó cho Claude để sửa.

## Mỗi lần ra bản mới
Tăng `version` trong `pubspec.yaml`, đẩy lên `main`, chạy lại bước 6, rồi tạo phiên bản mới trên App Store Connect
và gửi duyệt.
