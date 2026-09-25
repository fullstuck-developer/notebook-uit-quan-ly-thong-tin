-- ==============================================================================
-- QUẢN TRỊ CSDL & TRUY VẤN NÂNG CAO (XML)
-- Tác giả: Sinh viên thực hiện
-- Mô tả: Chứa các script Phân quyền (Security) và Truy vấn XML (XQuery)
-- ==============================================================================

USE QuanLyThuVien;
GO

-- ======================================================
-- 1. BẢO MẬT & PHÂN QUYỀN (SECURITY)
-- ======================================================

-- 1.1. Tạo Role cho hệ thống
CREATE ROLE Role_ThuThu;
CREATE ROLE Role_DocGia;
GO

-- 1.2. Phân quyền cho Role_ThuThu
-- Thủ thư được phép thao tác DML trên các bảng nhưng không được DROP bảng
GRANT SELECT, INSERT, UPDATE, DELETE ON SACH TO Role_ThuThu;
GRANT SELECT, INSERT, UPDATE, DELETE ON DOCGIA TO Role_ThuThu;
GRANT SELECT, INSERT, UPDATE, DELETE ON PHIEUMUON TO Role_ThuThu;
GRANT SELECT, INSERT, UPDATE, DELETE ON CTPHIEUMUON TO Role_ThuThu;

-- Cấp quyền thực thi các Procedure nghiệp vụ cho Thủ thư
GRANT EXECUTE ON OBJECT::sp_ThucHienMuonSach TO Role_ThuThu;
GRANT EXECUTE ON OBJECT::sp_ThucHienTraSach TO Role_ThuThu;

-- Tuy nhiên, không cho phép Thủ thư tự ý xóa lịch sử mượn trả (CTPHIEUMUON)
DENY DELETE ON CTPHIEUMUON TO Role_ThuThu;
GO

-- 1.3. Phân quyền cho Role_DocGia
-- Độc giả chỉ được xem danh sách sách và thông tin thể loại, tác giả
GRANT SELECT ON SACH TO Role_DocGia;
GRANT SELECT ON THELOAI TO Role_DocGia;
GRANT SELECT ON TACGIA TO Role_DocGia;

-- Độc giả KHÔNG ĐƯỢC PHÉP xem thông tin của độc giả khác (Cần ứng dụng lọc theo ID)
DENY SELECT ON DOCGIA TO Role_DocGia;
GO


-- ======================================================
-- 2. TRUY VẤN XML (XQUERY & XPATH)
-- ======================================================

-- 2.1. Sử dụng XQuery để trích xuất Mục Lục sách
-- Đề bài: Lấy ra Tên Sách và Tên các Chương (Chỉ lấy Chương 1) từ cột XML 'ChiTietMucLuc'
SELECT 
    MaSach,
    TenSach,
    -- Trích xuất giá trị thuộc tính 'Ten' của thẻ <Chuong ID="1">
    ChiTietMucLuc.value('(/MucLuc/Chuong[@ID="1"]/@Ten)[1]', 'NVARCHAR(100)') AS TenChuong1
FROM SACH
WHERE ChiTietMucLuc IS NOT NULL;
GO

-- 2.2. Kiểm tra sách có chứa chương nào liên quan đến "T-SQL" không bằng phương thức exist()
SELECT 
    MaSach,
    TenSach
FROM SACH
WHERE ChiTietMucLuc.exist('/MucLuc/Chuong[contains(@Ten, "T-SQL")]') = 1;
GO

-- 2.3. Trả về toàn bộ Sách dưới định dạng XML (Dùng FOR XML)
SELECT 
    MaSach AS '@MaSach',
    TenSach AS 'TenSach',
    SoLuong AS 'SoLuong'
FROM SACH
FOR XML PATH('Sach'), ROOT('DanhSachSach');
GO

-- ======================================================
-- 3. SAO LƯU (BACKUP) MẪU
-- ======================================================
/*
-- Script chạy thủ công hoặc bỏ vào SQL Server Agent để chạy định kỳ
BACKUP DATABASE QuanLyThuVien 
TO DISK = 'D:\Backup\QuanLyThuVien_Full.bak'
WITH FORMAT, MEDIANAME = 'QLTV_Backup', NAME = 'Full Backup QuanLyThuVien';

-- RESTORE DATABASE
-- (Lưu ý: Chỉ chạy khi cần phục hồi)
/*
USE master;
GO
ALTER DATABASE QuanLyThuVien SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE QuanLyThuVien
FROM DISK = 'D:\Backup\QuanLyThuVien_Full.bak'
WITH REPLACE;
ALTER DATABASE QuanLyThuVien SET MULTI_USER;
*/
