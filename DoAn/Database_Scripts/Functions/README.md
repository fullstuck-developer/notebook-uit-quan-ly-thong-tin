# Thư mục Functions (Hàm tự định nghĩa)

Thư mục này lưu trữ các User-Defined Functions (UDF) trong SQL Server, hỗ trợ việc tính toán logic và có thể được tái sử dụng trong các Stored Procedure, Trigger hoặc câu lệnh `SELECT`.

## 📜 Danh sách các Functions

### 1. [fn_TinhTienPhat.sql](./fn_TinhTienPhat.sql)
- **Loại hàm:** Scalar-valued Function (Trả về một giá trị duy nhất).
- **Mục đích:** Tính toán số tiền phạt khi một độc giả trả sách trễ hạn.
- **Tham số đầu vào:**
  - `@MaPM` (VARCHAR): Mã phiếu mượn tương ứng.
  - `@NgayTraThucTe` (DATE): Ngày khách hàng mang sách tới trả thực tế.
- **Giá trị trả về:** `FLOAT` (Số tiền phạt, mặc định 5,000 VNĐ / 1 ngày trễ).
- **Sử dụng tại:** Được gọi tự động bên trong Stored Procedure `sp_ThucHienTraSach` để cập nhật tiền phạt vào hóa đơn của khách.
