-- ==============================================================================
-- CƠ SỞ DỮ LIỆU QUẢN LÝ THƯ VIỆN
-- Tác giả: Sinh viên thực hiện
-- Mô tả: Script khởi tạo CSDL, tạo bảng và các ràng buộc cơ bản (Phase 1 & 2)
-- ==============================================================================

CREATE DATABASE QuanLyThuVien;
GO
USE QuanLyThuVien;
GO

-- =============================================
-- 1. TẠO CÁC BẢNG DANH MỤC (Không có Khóa ngoại)
-- =============================================

-- Bảng THELOAI
CREATE TABLE THELOAI (
    MaTheLoai VARCHAR(10) PRIMARY KEY,
    TenTheLoai NVARCHAR(100) NOT NULL
);

-- Bảng TACGIA
CREATE TABLE TACGIA (
    MaTG VARCHAR(10) PRIMARY KEY,
    TenTG NVARCHAR(100) NOT NULL
);

-- Bảng DOCGIA
CREATE TABLE DOCGIA (
    MaDG VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    DiaChi NVARCHAR(200),
    SoDT VARCHAR(15),
    NgayLapThe DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    TienNo FLOAT DEFAULT 0,
    -- Ràng buộc cơ bản
    CONSTRAINT CHK_NgayHopLe CHECK (NgayLapThe <= NgayHetHan),
    CONSTRAINT CHK_TienNo CHECK (TienNo >= 0)
);

-- Bảng NHANVIEN
CREATE TABLE NHANVIEN (
    MaNV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SoDT VARCHAR(15),
    VaiTro NVARCHAR(50) DEFAULT 'ThuThu', -- Admin, ThuThu
    TaiKhoan VARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(255) NOT NULL
);

-- =============================================
-- 2. TẠO CÁC BẢNG NGHIỆP VỤ (Có Khóa ngoại)
-- =============================================

-- Bảng SACH
CREATE TABLE SACH (
    MaSach VARCHAR(10) PRIMARY KEY,
    TenSach NVARCHAR(200) NOT NULL,
    MaTheLoai VARCHAR(10) NOT NULL,
    NamXB INT,
    NhaXuatBan NVARCHAR(100),
    SoLuong INT DEFAULT 0,
    ChiTietMucLuc XML, -- Cột XML lưu trữ cấu trúc chương/mục
    -- Ràng buộc
    CONSTRAINT CHK_SoLuong CHECK (SoLuong >= 0),
    CONSTRAINT FK_SACH_THELOAI FOREIGN KEY (MaTheLoai) REFERENCES THELOAI(MaTheLoai)
);

-- Bảng SACH_TACGIA (Quan hệ N-N giữa Sách và Tác giả)
CREATE TABLE SACH_TACGIA (
    MaSach VARCHAR(10) NOT NULL,
    MaTG VARCHAR(10) NOT NULL,
    PRIMARY KEY (MaSach, MaTG),
    CONSTRAINT FK_ST_SACH FOREIGN KEY (MaSach) REFERENCES SACH(MaSach) ON DELETE CASCADE,
    CONSTRAINT FK_ST_TACGIA FOREIGN KEY (MaTG) REFERENCES TACGIA(MaTG) ON DELETE CASCADE
);

-- Bảng PHIEUMUON
CREATE TABLE PHIEUMUON (
    MaPM VARCHAR(10) PRIMARY KEY,
    MaDG VARCHAR(10) NOT NULL,
    MaNV VARCHAR(10) NOT NULL,
    NgayMuon DATE NOT NULL DEFAULT GETDATE(),
    NgayHenTra DATE NOT NULL,
    TrangThai NVARCHAR(50) DEFAULT N'Đang mượn', -- Các trạng thái: Đang mượn, Đã trả xong, Trễ hạn
    -- Ràng buộc
    CONSTRAINT CHK_NgayHenTra CHECK (NgayMuon <= NgayHenTra),
    CONSTRAINT FK_PM_DOCGIA FOREIGN KEY (MaDG) REFERENCES DOCGIA(MaDG),
    CONSTRAINT FK_PM_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);

-- Bảng CTPHIEUMUON (Chi tiết phiếu mượn)
CREATE TABLE CTPHIEUMUON (
    MaPM VARCHAR(10) NOT NULL,
    MaSach VARCHAR(10) NOT NULL,
    NgayTra DATE,
    TienPhat FLOAT DEFAULT 0,
    GhiChu NVARCHAR(255),
    PRIMARY KEY (MaPM, MaSach),
    -- Ràng buộc
    CONSTRAINT CHK_TienPhat CHECK (TienPhat >= 0),
    CONSTRAINT FK_CTPM_PM FOREIGN KEY (MaPM) REFERENCES PHIEUMUON(MaPM) ON DELETE CASCADE,
    CONSTRAINT FK_CTPM_SACH FOREIGN KEY (MaSach) REFERENCES SACH(MaSach)
);
GO
