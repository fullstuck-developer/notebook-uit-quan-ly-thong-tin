# Thư mục Stored Procedures (Thủ tục lưu trữ)

Thư mục này chứa các `Stored Procedure` (SP). Theo chiến lược **All-in-SQL** của đồ án, tất cả các logic nghiệp vụ phức tạp đều được xử lý bên trong các SP này. Backend (ASP.NET Core + Dapper) chỉ cần truyền tham số (Parameters) và nhận kết quả, không viết logic `if-else` trên C#.

Mỗi SP ở đây đều được bọc trong một `TRANSACTION` để bảo toàn tính ACID (hoặc thành công toàn bộ, hoặc Rollback khi có một thao tác thất bại).

## 📜 Danh sách các Stored Procedures

### 1. [sp_ThucHienMuonSach.sql](./sp_ThucHienMuonSach.sql)
- **Mục đích:** Xử lý nghiệp vụ cho độc giả mượn sách với các ràng buộc khắt khe.
- **Logic kiểm tra (Validation):**
  1. Độc giả có tồn tại không.
  2. Thẻ độc giả còn hạn không.
  3. Độc giả có đang nợ tiền phạt quá giới hạn không (> 50.000 VNĐ).
  4. Sách trong kho có còn không (`SoLuong > 0`).
- **Thực thi:** Tạo phiếu mượn mới (nếu chưa có) và ghi nhận chi tiết sách được mượn. Báo lỗi `RAISERROR` rõ ràng nếu vi phạm.

### 2. [sp_ThucHienTraSach.sql](./sp_ThucHienTraSach.sql)
- **Mục đích:** Xử lý nghiệp vụ trả sách.
- **Thực thi:** 
  - Gọi hàm `fn_TinhTienPhat` để kiểm tra có bị trễ hạn không.
  - Cập nhật ngày trả sách.
  - Nếu tất cả sách trong phiếu đã được trả, tự động chuyển Trạng thái phiếu mượn sang "Đã trả xong".
  - Tự động cộng dồn tiền phạt (nếu có) vào cột `TienNo` của Độc giả.
