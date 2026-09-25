# Thư mục Triggers

Thư mục này chứa các `Trigger`, là một dạng thủ tục đặc biệt tự động kích hoạt khi có sự kiện DML (`INSERT`, `UPDATE`, `DELETE`) xảy ra trên bảng. Chúng đóng vai trò là chốt chặn cuối cùng bảo vệ tính toàn vẹn của cơ sở dữ liệu.

## 📜 Danh sách các Triggers

### 1. [TRG_CapNhatSoLuongSach.sql](./TRG_CapNhatSoLuongSach.sql)
- **Bảng áp dụng:** `CTPHIEUMUON`
- **Sự kiện:** `AFTER INSERT, UPDATE`
- **Mục đích:** 
  - Khi một dòng được `INSERT` vào `CTPHIEUMUON` (Độc giả mượn sách mới), Trigger tự động giảm `SoLuong` của cuốn sách đó trong bảng `SACH` đi 1.
  - Khi một dòng được `UPDATE` cập nhật `NgayTra` từ `NULL` sang một ngày cụ thể (Độc giả trả sách), Trigger tự động tăng `SoLuong` của sách đó lên 1.

### 2. [TRG_NganXoaSach.sql](./TRG_NganXoaSach.sql)
- **Bảng áp dụng:** `SACH`
- **Sự kiện:** `INSTEAD OF DELETE`
- **Mục đích:** Ngăn chặn việc thao tác xóa (Xóa nhầm, hoặc gian lận) một cuốn sách khỏi hệ thống nếu cuốn sách đó vẫn đang được một độc giả mượn và chưa trả (`NgayTra IS NULL`). 
- **Cách hoạt động:** Nếu sách đang được mượn, ném ra lỗi `RAISERROR` và `ROLLBACK`. Nếu sách không ai mượn, tiến hành xóa sạch sẽ dữ liệu liên quan (Cascade xoá trong `SACH_TACGIA`, `CTPHIEUMUON` rồi mới xóa bảng `SACH`).
