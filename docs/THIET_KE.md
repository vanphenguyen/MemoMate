# Thiết kế Nhớ Nhé

## Ý tưởng

Người hay quên cũng quên mở app và ngại nhập liệu. Vì vậy:

1. **Không phải tự tạo.** Chọn lời nhắc có sẵn, gạt công tắc là chạy với giờ mặc định hợp lý.
2. **Không phải mở app.** Bấm "Xong" hoặc "Nhắc lại sau 15 phút" ngay trên thông báo.
3. **Nhìn là biết.** Màn hình "Hôm nay" có một vòng tiến độ: đã xong mấy việc trên tổng số.

## Thêm hoặc sửa lời nhắc có sẵn

Mỗi nhóm là một file trong `assets/templates/`, ví dụ `suc-khoe.json`:

```json
{
  "id": "suc-khoe",
  "title": { "vi": "Sức khỏe", "en": "Health", "ja": "健康" },
  "icon": "favorite",
  "color": "#2E9E6B",
  "templates": [
    {
      "id": "uong-thuoc",
      "title": { "vi": "Uống thuốc", "en": "Take medicine", "ja": "薬を飲む" },
      "icon": "medication",
      "message": { "vi": "Đến giờ uống thuốc rồi.", "en": "Time to take your medicine.", "ja": "薬を飲む時間です。" },
      "schedule": { "type": "daily", "times": ["08:00", "20:00"] }
    }
  ]
}
```

- `id` của nhóm phải trùng tên file; `id` của lời nhắc không được trùng nhau trong toàn bộ thư viện
  và **không đổi sau khi phát hành** (app dùng nó để nhớ lời nhắc nào đang bật).
- `title` và `message` phải có đủ 10 ngôn ngữ (ví dụ trên rút gọn còn 3). `message` là dòng chữ hiện trong thông báo.
- `icon` phải có trong `lib/widgets/reminder_icons.dart`.
- Thêm nhóm mới: tạo file JSON rồi thêm `id` vào `assets/templates/index.json`.

Ba kiểu lịch (`schedule`):

| Kiểu | Ví dụ | Ý nghĩa |
|---|---|---|
| `daily` | `{ "type": "daily", "times": ["08:00", "20:00"] }` | Mỗi ngày, vào các giờ đã ghi |
| `weekly` | `{ "type": "weekly", "times": ["20:00"], "weekdays": [7] }` | 1 là thứ Hai ... 7 là Chủ nhật |
| `monthly` | `{ "type": "monthly", "times": ["09:00"], "day": 5 }` | Ngày 1 đến 28 hằng tháng |

Sau khi sửa, chạy `flutter test` để kiểm tra dữ liệu.

## Ngôn ngữ

App có 10 ngôn ngữ: Việt, Anh, Trung (giản thể), Tây Ban Nha, Bồ Đào Nha, Pháp, Đức, Nhật, Hàn, Indonesia.
App tự theo ngôn ngữ của điện thoại; máy dùng ngôn ngữ khác thì hiện tiếng Anh. Chưa có nút đổi ngôn ngữ trong app.

- Chữ giao diện: `lib/l10n/app_<mã>.arb`, mỗi ngôn ngữ một file. Sửa xong chạy `flutter gen-l10n`.
- Tên và nội dung lời nhắc có sẵn: trong các file JSON ở trên.
- Lời nhắc tự tạo giữ nguyên chữ người dùng gõ.
- Giờ luôn hiện dạng 24 giờ (08:00, 20:00) ở mọi ngôn ngữ.

Các bản dịch do AI viết, **chưa có người bản xứ soát lại**. Nên nhờ người bản xứ đọc trước khi quảng bá ở từng nước.

## Giới hạn đã biết

- **iPhone giữ tối đa 64 thông báo đã lên lịch cho mỗi app.** App chặn ở 60 lần nhắc
  (mỗi giờ nhắc tính một lần; lịch theo tuần tính theo từng ngày). Bật cả thư viện hiện dùng khoảng 40.
- **Android có thể nhắc trễ vài phút** khi máy tiết kiệm pin, vì app dùng chế độ hẹn giờ không cần xin quyền đặc biệt.
  Một số hãng (Xiaomi, Oppo, Vivo, Huawei) còn tự tắt app chạy nền; người dùng phải tắt "tối ưu pin" cho app.
- Bấm "Xong" trên thông báo luôn tính cho **ngày hôm nay**. Thông báo từ hôm qua bấm hôm nay sẽ tính vào hôm nay.
- Bản web chỉ để xem giao diện, không gửi thông báo.
- Đổi ngôn ngữ máy khi app đang mở: trên iPhone, chữ trên hai nút của thông báo chỉ đổi sau khi mở lại app.
- Bộ lời nhắc giống nhau ở mọi nước; vài lời nhắc (khóa gas, ngày đóng tiền điện) hợp với Việt Nam hơn.

## Chưa làm (để sau)

- Biểu tượng app và màn hình chờ riêng (đang dùng mặc định của Flutter).
- Chuỗi ngày liên tiếp, widget màn hình chính.
- Nhắc theo vị trí, nhắc người thân khi bỏ lỡ.
- Thu phí. Dự kiến: miễn phí một số lời nhắc đang bật, trả tiền để mở không giới hạn.
- Ký app bằng khóa phát hành để đưa lên Google Play; build iOS cần máy Mac hoặc dịch vụ build iOS và tài khoản Apple Developer.
