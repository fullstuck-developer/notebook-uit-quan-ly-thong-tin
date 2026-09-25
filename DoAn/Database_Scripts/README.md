# Database Scripts - Hệ thống Quản lý Thư viện

Thư mục này chứa toàn bộ các Script T-SQL phục vụ cho đồ án môn **Quản lý Thông tin (IE103)**. Kiến trúc mã nguồn được tổ chức theo tiêu chuẩn của các dự án Database, giúp dễ dàng quản lý và triển khai (Deploy).

## 🚀 Hướng dẫn thực thi (Execution Order)

Để khởi tạo hệ thống từ đầu, bạn vui lòng chạy các file Script theo đúng thứ tự sau trên SQL Server Management Studio (SSMS):

1. **[01_InitSchema.sql](./01_InitSchema.sql)**: Chạy đầu tiên để khởi tạo Database `QuanLyThuVien`, tạo các Table (Bảng) và các Ràng buộc toàn vẹn cơ bản (Primary Key, Foreign Key, Check).
2. **[02_MockData.sql](./02_MockData.sql)**: Chạy tiếp theo để Insert dữ liệu giả lập (Mock data) giúp test hệ thống.
3. Chạy tất cả các file trong thư mục **[Views](./Views/)**.
4. Chạy tất cả các file trong thư mục **[Functions](./Functions/)**.
5. Chạy tất cả các file trong thư mục **[Triggers](./Triggers/)**.
6. Chạy tất cả các file trong thư mục **[StoredProcedures](./StoredProcedures/)**. (Đã bao gồm `sp_CapNhatTienPhatTuDong` có sử dụng Cursor nâng cao).
7. **[04_SecurityAndXML.sql](./04_SecurityAndXML.sql)**: Chạy cuối cùng để thiết lập Phân quyền (Roles), Backup/Restore và test XQuery.

## 📁 Cấu trúc thư mục (Đạt 100% Yêu cầu Đồ án IE103)

Hệ thống đã được thiết kế và bổ sung đầy đủ các object theo đúng chuẩn barem điểm của môn học:

*   📂 **[Views/](./Views/) (5 Report)**: Chứa các View tạo báo cáo và thống kê (Thống kê mượn sách, Doanh thu phạt, Độc giả thân thiết...).
*   📂 **[Functions/](./Functions/) (3 Function)**: Chứa các UDF xử lý tính toán (Tính tiền phạt, Lấy thông tin độc giả, Kiểm tra trạng thái sách).
*   📂 **[StoredProcedures/](./StoredProcedures/) (8 SP, 2 Cursor)**: Chứa các thủ tục lưu trữ thực hiện nghiệp vụ phức tạp (Mượn/Trả, Gia hạn, Thêm mới) và các thủ tục **Phân trang dữ liệu (Pagination)** cho Backend. Bao gồm 2 Procedure (`sp_CapNhatTienPhatTuDong` và `sp_CapNhatTrangThaiPhieuMuon`) sử dụng **Cursor** nâng cao.
*   📂 **[Triggers/](./Triggers/) (5 Trigger)**: Chứa các Trigger đảm bảo toàn vẹn dữ liệu (Cập nhật số lượng, Ngăn xóa sách, Giới hạn mượn, Kiểm tra ngày hẹn trả, Ghi log thao tác).

## 📊 Ánh xạ Chức năng Phần mềm và Cơ sở dữ liệu

Dưới đây là danh sách mapping trực tiếp giữa các chức năng trên phần mềm (Backend/UI) và các Object tương ứng trong CSDL:

### I. Phân hệ Quản lý Độc giả
| Tên chức năng trên phần mềm | Database Object tương ứng | Loại Object | Mô tả |
| :--- | :--- | :--- | :--- |
| **Lấy danh sách độc giả** | `sp_LayDanhSachDocGia_PhanTrang` | `Stored Procedure` | Trả về danh sách độc giả kết hợp phân trang và tìm kiếm. |
| **Đăng ký thẻ mới** | `sp_ThemMoiDocGia` | `Stored Procedure` | Thêm Độc giả, tự động cấp ngày lập thẻ, ngày hết hạn (4 năm). |
| **Xem nhanh thông tin thẻ** | `fn_LayThongTinDocGia` | `Function (Table)` | Trả về bảng tóm tắt thông tin nợ và hạn thẻ. |
| **Ghi nhận lịch sử thao tác** | `TRG_LogThaoTacDocGia` | `Trigger` | Tự động ghi log mỗi khi có nhân viên Thêm/Sửa/Xóa độc giả. |

### II. Phân hệ Quản lý Sách
| Tên chức năng trên phần mềm | Database Object tương ứng | Loại Object | Mô tả |
| :--- | :--- | :--- | :--- |
| **Tra cứu danh mục sách** | `sp_LayDanhSachSach_PhanTrang` | `Stored Procedure` | Trả về danh mục sách có phân trang, lọc theo Thể loại. |
| **Kiểm tra tồn kho** | `fn_KiemTraTrangThaiSach` | `Function (Scalar)`| Hàm trả về nhãn `"Sẵn sàng cho mượn"` hoặc `"Tạm hết hàng"`. |
| **Bảo vệ dữ liệu sách** | `TRG_NganXoaSach` | `Trigger` | Chặn xóa sách trên UI nếu cuốn sách đó đang có người mượn. |

### III. Phân hệ Nghiệp vụ Mượn - Trả
| Tên chức năng trên phần mềm | Database Object tương ứng | Loại Object | Mô tả |
| :--- | :--- | :--- | :--- |
| **Xem lịch sử mượn trả** | `sp_LayDanhSachPhieuMuon_PhanTrang`| `Stored Procedure` | Lấy danh sách phiếu mượn (có phân trang) và lọc theo trạng thái. |
| **Lập phiếu mượn sách** | `sp_ThucHienMuonSach` | `Stored Procedure` | Thực thi logic mượn sách khắt khe (Kiểm tra thẻ, tiền nợ). |
| **Ràng buộc mượn sách** | `TRG_GioiHanSoSachMuon`<br>`TRG_KiemTraNgayHenTra` | `Trigger` | Ném lỗi nếu số lượng mượn > 5 cuốn hoặc hẹn trả > 14 ngày. |
| **Trả sách & Tính phạt** | `sp_ThucHienTraSach` | `Stored Procedure` | Nhận trả sách. Tự động gọi `fn_TinhTienPhat` để thu nợ nếu trễ hạn. |
| **Cập nhật tồn kho tự động**| `TRG_CapNhatSoLuongSach` | `Trigger` | Tự động trừ/cộng số lượng trong kho khi mượn/trả sách. |
| **Gia hạn thời gian mượn** | `sp_GiaHanSach` | `Stored Procedure` | Cộng thêm số ngày gia hạn vào ngày hẹn trả cũ. |

### IV. Phân hệ Tác vụ Tự động hóa (Background Jobs)
| Tên chức năng trên phần mềm | Database Object tương ứng | Loại Object | Mô tả |
| :--- | :--- | :--- | :--- |
| **Đánh dấu phiếu trễ hạn** | `sp_CapNhatTrangThaiPhieuMuon`| `SP (Cursor)` | Quét các phiếu quá hạn để đổi trạng thái thành `"Trễ hạn"`. |
| **Cộng dồn nợ phạt tự động** | `sp_CapNhatTienPhatTuDong` | `SP (Cursor)` | Quét sách chưa trả, tính toán và cộng dồn phạt vào tổng nợ. |

### V. Phân hệ Báo cáo & Thống kê (Dashboards)
| Tên chức năng trên phần mềm | Database Object tương ứng | Loại Object | Mô tả |
| :--- | :--- | :--- | :--- |
| **DS Độc giả nợ phạt** | `vw_DocGia_NoPhat` | `View` | Danh sách các độc giả đang có tiền nợ hoặc đang giữ sách. |
| **Thống kê mượn theo Thể loại**| `vw_SachThongKe` | `View` | Dữ liệu vẽ biểu đồ tròn đầu sách được mượn nhiều theo thể loại. |
| **Thống kê Doanh thu Phạt** | `vw_BaoCaoDoanhThuPhat` | `View` | Dữ liệu vẽ biểu đồ cột doanh thu tiền phạt theo tháng. |
| **Thống kê Lượt mượn sách** | `vw_ThongKeMuonTheoThang` | `View` | Dữ liệu vẽ biểu đồ đường xu hướng mượn sách. |
| **Bảng vàng Độc giả VIP** | `vw_DocGiaThanThiet` | `View` | Report Top 10 độc giả mượn nhiều sách nhất thư viện. |
