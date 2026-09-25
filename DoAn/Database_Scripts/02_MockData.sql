-- ==============================================================================
-- DỮ LIỆU MẪU CƠ SỞ DỮ LIỆU QUẢN LÝ THƯ VIỆN
-- Tác giả: Sinh viên thực hiện
-- Mô tả: Script thêm dữ liệu (Mock data) để phục vụ việc test Trigger, Procedure.
-- ==============================================================================

USE QuanLyThuVien;
GO

-- 1. Insert THỂ LOẠI
INSERT INTO THELOAI (MaTheLoai, TenTheLoai) VALUES 
('TL01', N'Công nghệ thông tin'),
('TL02', N'Kinh tế học'),
('TL03', N'Văn học'),
('TL04', N'Kỹ năng sống');

-- 2. Insert TÁC GIẢ
INSERT INTO TACGIA (MaTG, TenTG) VALUES 
('TG01', N'Nguyễn Gia Tuấn Anh'),
('TG02', N'Đỗ Phúc'),
('TG03', N'Tony Buổi Sáng'),
('TG04', N'Nguyễn Nhật Ánh');

-- 3. Insert SÁCH (Bao gồm dữ liệu XML cho Cột ChiTietMucLuc)
INSERT INTO SACH (MaSach, TenSach, MaTheLoai, NamXB, NhaXuatBan, SoLuong, ChiTietMucLuc) VALUES 
('S01', N'Cơ sở dữ liệu nâng cao', 'TL01', 2019, N'NXB Đại học quốc gia TPHCM', 50, 
    '<MucLuc><Chuong ID="1" Ten="Tổng quan CSDL"/><Chuong ID="2" Ten="T-SQL Nâng cao"/></MucLuc>'),
('S02', N'Bài tập và bài giải SQL Server', 'TL01', 2005, N'NXB Thanh niên', 30, 
    '<MucLuc><Chuong ID="1" Ten="Store Procedure"/><Chuong ID="2" Ten="Trigger"/></MucLuc>'),
('S03', N'Trên đường băng', 'TL04', 2015, N'NXB Trẻ', 100, NULL),
('S04', N'Mắt biếc', 'TL03', 1990, N'NXB Trẻ', 20, NULL);

-- 4. Insert SACH_TACGIA
INSERT INTO SACH_TACGIA (MaSach, MaTG) VALUES 
('S01', 'TG01'),
('S02', 'TG01'),
('S02', 'TG02'),
('S03', 'TG03'),
('S04', 'TG04');

-- 5. Insert ĐỘC GIẢ
INSERT INTO DOCGIA (MaDG, HoTen, NgaySinh, DiaChi, SoDT, NgayLapThe, NgayHetHan, TienNo) VALUES 
('DG01', N'Nguyễn Văn A', '2000-01-01', N'Thủ Đức, TP.HCM', '0901234567', '2023-01-01', '2027-01-01', 0),
('DG02', N'Trần Thị B', '2002-05-15', N'Quận 1, TP.HCM', '0987654321', '2023-05-01', '2027-05-01', 0),
('DG03', N'Lê Văn C', '1995-10-10', N'Quận 9, TP.HCM', '0912222333', '2020-01-01', '2022-01-01', 100000); -- Thẻ đã hết hạn và đang nợ

-- 6. Insert NHÂN VIÊN
-- Lưu ý: Mật khẩu nên được hash khi tích hợp với ứng dụng (ASP.NET). Ở đây dùng chuỗi minh họa.
INSERT INTO NHANVIEN (MaNV, HoTen, SoDT, VaiTro, TaiKhoan, MatKhau) VALUES 
('NV01', N'Admin Tổng', '0900000000', 'Admin', 'admin', '123456'),
('NV02', N'Lê Nguyễn Thủ Thư', '0900000001', 'ThuThu', 'thuthu01', '123456');

-- 7. Insert PHIẾU MƯỢN
INSERT INTO PHIEUMUON (MaPM, MaDG, MaNV, NgayMuon, NgayHenTra, TrangThai) VALUES 
('PM01', 'DG01', 'NV02', '2023-10-01', '2023-10-15', N'Đã trả'),
('PM02', 'DG02', 'NV02', GETDATE(), DATEADD(day, 14, GETDATE()), N'Đang mượn');

-- 8. Insert CTPHIEUMUON
INSERT INTO CTPHIEUMUON (MaPM, MaSach, NgayTra, TienPhat, GhiChu) VALUES 
('PM01', 'S01', '2023-10-10', 0, N'Sách bình thường'),
('PM01', 'S02', '2023-10-10', 0, N'Sách bình thường'),
('PM02', 'S03', NULL, 0, NULL);
GO
