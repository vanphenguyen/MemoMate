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
  "title": "Sức khỏe",
  "icon": "favorite",
  "color": "#2E9E6B",
  "templates": [
    {
      "id": "uong-thuoc",
      "title": "Uống thuốc",
      "icon": "medication",
      "message": "Đến giờ uống thuốc rồi.",
      "schedule": { "type": "daily", "times": ["08:00", "20:00"] }
    }
  ]
}
```

- `id` của nhóm phải trùng tên file; `id` của lời nhắc không được trùng nhau trong toàn bộ thư viện
  và **không đổi sau khi phát hành** (app dùng nó để nhớ lời nhắc nào đang bật).
- `message` là dòng chữ hiện trong thông báo.
- `icon` phải có trong `lib/widgets/reminder_icons.dart`.
- Thêm nhóm mới: tạo file JSON rồi thêm `id` vào `assets/templates/index.json`.

Ba kiểu lịch (`schedule`):

| Kiểu | Ví dụ | Ý nghĩa |
|---|---|---|
| `daily` | `{ "type": "daily", "times": ["08:00", "20:00"] }` | Mỗi ngày, vào các giờ đã ghi |
| `weekly` | `{ "type": "weekly", "times": ["20:00"], "weekdays": [7] }` | 1 là thứ Hai ... 7 là Chủ nhật |
| `monthly` | `{ "type": "monthly", "times": ["09:00"], "day": 5 }` | Ngày 1 đến 28 hằng tháng |

Sau khi sửa, chạy `flutter test` để kiểm tra dữ liệu.

## Giới hạn đã biết

- **iPhone giữ tối đa 64 thông báo đã lên lịch cho mỗi app.** App chặn ở 60 lần nhắc
  (mỗi giờ nhắc tính một lần; lịch theo tuần tính theo từng ngày). Bật cả thư viện hiện dùng khoảng 40.
- **Android có thể nhắc trễ vài phút** khi máy tiết kiệm pin, vì app dùng chế độ hẹn giờ không cần xin quyền đặc biệt.
  Một số hãng (Xiaomi, Oppo, Vivo, Huawei) còn tự tắt app chạy nền; người dùng phải tắt "tối ưu pin" cho app.
- Bấm "Xong" trên thông báo luôn tính cho **ngày hôm nay**. Thông báo từ hôm qua bấm hôm nay sẽ tính vào hôm nay.
- Bản web chỉ để xem giao diện, không gửi thông báo.

## Chưa làm (để sau)

- Biểu tượng app và màn hình chờ riêng (đang dùng mặc định của Flutter).
- Chuỗi ngày liên tiếp, widget màn hình chính.
- Nhắc theo vị trí, nhắc người thân khi bỏ lỡ.
- Thu phí. Dự kiến: miễn phí một số lời nhắc đang bật, trả tiền để mở không giới hạn.
- Ký app bằng khóa phát hành để đưa lên Google Play; build iOS cần máy Mac hoặc dịch vụ build iOS và tài khoản Apple Developer.
