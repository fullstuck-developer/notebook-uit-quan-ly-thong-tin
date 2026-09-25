USE QuanLyThuVien;
GO

-- Procedure lấy danh sách Phiếu mượn có phân trang và lọc theo Trạng thái
CREATE PROCEDURE sp_LayDanhSachPhieuMuon_PhanTrang
    @TrangThai NVARCHAR(50) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy tổng số dòng (Result Set 1)
    SELECT COUNT(*) AS TotalRecords
    FROM PHIEUMUON 
    WHERE (@TrangThai IS NULL OR TrangThai = @TrangThai);

    -- Trả về dữ liệu phân trang
    SELECT PM.MaPM, DG.HoTen AS TenDocGia, NV.HoTen AS TenThuThu, PM.NgayMuon, PM.NgayHenTra, PM.TrangThai
    FROM PHIEUMUON PM
    JOIN DOCGIA DG ON PM.MaDG = DG.MaDG
    JOIN NHANVIEN NV ON PM.MaNV = NV.MaNV
    WHERE (@TrangThai IS NULL OR PM.TrangThai = @TrangThai)
    ORDER BY PM.NgayMuon DESC, PM.MaPM DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO
