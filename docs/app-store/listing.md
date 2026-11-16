# Nội dung trang App Store

Sao chép từng mục vào App Store Connect > app ForgetNot > tab Distribution. Ảnh nằm trong `docs/app-store/screenshots/`.
Bản tiếng Anh là ngôn ngữ chính; bản tiếng Việt thêm bằng nút chọn ngôn ngữ ở góc trên bên phải trang đó
(Add localization > Vietnamese).

## Cách chọn từ khóa (đọc trước khi sửa)

Trên App Store, Apple chỉ dùng ba ô để xếp hạng tìm kiếm: **Name** (nặng nhất), **Subtitle** và **Keywords**.
Phần Description không được tính vào tìm kiếm; nó chỉ để thuyết phục người đã mở trang app.

- Không lặp lại một từ ở cả ba ô: Apple tự ghép từ giữa các ô, lặp lại là phí chỗ.
- Ô Keywords: cách nhau bằng dấu phẩy, không có dấu cách, không dùng tên app khác.
- Bản tiếng Việt có thêm vài từ không dấu, vì nhiều người gõ tìm kiếm không dấu.
- Các từ dưới đây được chọn theo suy luận về cách người dùng tìm, **chưa dựa trên số liệu lượt tìm kiếm thật**.
  Sau khi app lên store vài tuần, xem mục App Analytics > Search terms trong App Store Connect rồi chỉnh lại.

## Thông tin chung (không theo ngôn ngữ)

| Mục | Giá trị |
|---|---|
| Category | Primary: **Productivity**. Secondary: **Health & Fitness** |
| Price | Free |
| Age Rating | Trả lời "None / No" cho mọi câu hỏi, kết quả sẽ là **4+** |
| App Privacy | **Data Not Collected** |
| Support URL | `https://github.com/vanphenguyen/MemoMate/issues` |
| Marketing URL | để trống |
| Privacy Policy URL | `https://vanphenguyen.github.io/MemoMate/privacy.html` |
| Copyright | `2026` kèm tên bạn hoặc tên công ty |
| Sign-in required | No (app không có đăng nhập) |

**App Review Information > Notes** (ghi chú cho người duyệt của Apple, viết bằng tiếng Anh):

```
ForgetNot is an offline reminder app. It has no account, no sign-in, no in-app purchases and does not connect to the internet.

To try it: open the Reminders tab, switch on any reminder, then tap "Send a test notification" at the bottom of that tab. One notification arrives immediately and another about a minute later. Notifications have "Done" and "Remind me in 15 min" buttons.

All notifications are local notifications scheduled on the device. The app does not use push notifications.
```

## English (U.S.), ngôn ngữ chính

**Name** (tối đa 30 ký tự)

```
ForgetNot: Daily Reminders
```

**Subtitle** (tối đa 30 ký tự)

```
Water, meds, bills & chores
```

**Promotional Text** (tối đa 170 ký tự, sửa được bất cứ lúc nào)

```
Ready-made reminders for the things you keep forgetting. Switch one on and you're done: water, medicine, bills, chores and more.
```

**Description**

```
ForgetNot is a reminder app for forgetful people. You don't have to set anything up: pick from a library of ready-made reminders, flip a switch, and it starts working.

READY-MADE REMINDERS
• Health: drink water, take medicine, take vitamins, rest your eyes, stand up and stretch, go to bed on time
• Home: take out the trash, water the plants, wash the bed sheets, check the water filter
• Money: rent, electricity, water, internet and credit card bills
• Family & friends: call your parents, check in with a friend
• Leaving home: keys, wallet, phone, stove off

Each one comes with a sensible schedule. Change the times and days whenever you like.

DONE IN ONE TAP
Mark a reminder as done right on the notification, or ask to be reminded again in 15 minutes. No need to open the app.

SEE YOUR DAY AT A GLANCE
The Today screen shows everything due today and a progress ring that fills as you tick things off.

MAKE YOUR OWN
Create reminders that repeat every day, on chosen weekdays, or on a day of the month. Pick an icon for each.

PRIVATE BY DESIGN
No account. No ads. No tracking. ForgetNot works offline and everything stays on your phone.

10 LANGUAGES
English, Vietnamese, Chinese (Simplified), Spanish, Portuguese, French, German, Japanese, Korean and Indonesian. The app follows your phone's language, or you can choose one in the app.
```

**Keywords** (tối đa 100 ký tự, cách nhau bằng dấu phẩy, không có dấu cách)

```
habit,pill,medicine,routine,forgetful,todo,checklist,alarm,task,adhd,hydration,schedule,tracker
```

**What's New in This Version**

```
First release.
```

**Ảnh chụp màn hình**: tải lên theo thứ tự `screenshots/en/1.png`, `2.png`, `3.png`, `4.png` (cỡ 1206x2622, đúng cỡ
mục "iPhone with Dynamic Island (medium display)" yêu cầu). Bản cỡ 1290x2796 cho màn hình lớn ở `screenshots/6.9-inch/`.

## Vietnamese

**Name**

```
Nhớ Nhé: Nhắc việc mỗi ngày
```

**Subtitle**

```
Uống nước, thuốc, hóa đơn
```

**Promotional Text**

```
Lời nhắc có sẵn cho những việc bạn hay quên. Bật lên là xong: uống nước, uống thuốc, đóng tiền điện, việc nhà và nhiều hơn nữa.
```

**Description**

```
Nhớ Nhé là app nhắc việc dành cho người hay quên. Bạn không phải cài đặt gì: chọn trong thư viện lời nhắc có sẵn, gạt công tắc là app bắt đầu nhắc.

LỜI NHẮC CÓ SẴN
• Sức khỏe: uống nước, uống thuốc, uống vitamin, cho mắt nghỉ, đứng dậy vươn vai, đi ngủ đúng giờ
• Nhà cửa: đổ rác, tưới cây, giặt ga giường, kiểm tra lõi lọc nước
• Tiền bạc: tiền nhà, tiền điện, tiền nước, internet, thẻ tín dụng
• Người thân: gọi điện cho bố mẹ, hỏi thăm một người bạn
• Ra khỏi nhà: chìa khóa, ví, điện thoại, khóa gas

Mỗi lời nhắc có sẵn lịch hợp lý. Bạn đổi giờ và ngày nhắc lúc nào cũng được.

XONG TRONG MỘT CHẠM
Đánh dấu đã làm ngay trên thông báo, hoặc hẹn nhắc lại sau 15 phút. Không cần mở app.

NHÌN LÀ BIẾT HÔM NAY CÒN GÌ
Màn hình Hôm nay liệt kê mọi việc trong ngày, kèm vòng tiến độ đầy dần khi bạn đánh dấu xong.

TỰ TẠO LỜI NHẮC
Tạo lời nhắc lặp lại mỗi ngày, theo thứ trong tuần hoặc theo ngày trong tháng. Chọn biểu tượng cho từng lời nhắc.

RIÊNG TƯ
Không tài khoản. Không quảng cáo. Không theo dõi. Nhớ Nhé chạy không cần mạng và mọi thứ nằm trên máy của bạn.

10 NGÔN NGỮ
Tiếng Việt, Anh, Trung (giản thể), Tây Ban Nha, Bồ Đào Nha, Pháp, Đức, Nhật, Hàn và Indonesia. App theo ngôn ngữ của máy, hoặc bạn tự chọn trong app.
```

**Keywords**

```
lời nhắc,nhắc nhở,thói quen,hay quên,việc nhà,báo thức,lịch,nhac viec,uong nuoc,uong thuoc,thoi quen
```

**What's New in This Version**

```
Phiên bản đầu tiên.
```

**Ảnh chụp màn hình**: `screenshots/vi/1.png` đến `4.png`.

## TestFlight

**Test Information > What to Test** (hiện cho người thử):

```
Switch on a few reminders, then tap "Send a test notification" at the bottom of the Reminders tab. Check that notifications arrive on time and that the Done and Remind me in 15 min buttons work while the app is closed.
```
