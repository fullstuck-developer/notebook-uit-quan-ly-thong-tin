USE QuanLyThuVien;
GO

-- Procedure lấy danh sách Độc giả có phân trang và tìm kiếm
CREATE PROCEDURE sp_LayDanhSachDocGia_PhanTrang
    @TuKhoa NVARCHAR(100) = '',
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy tổng số dòng (Result Set 1) để Dapper dùng ReadFirst<int>()
    SELECT COUNT(*) AS TotalRecords
    FROM DOCGIA 
    WHERE HoTen LIKE N'%' + @TuKhoa + N'%' OR MaDG LIKE '%' + @TuKhoa + '%';

    -- Trả về dữ liệu của trang hiện tại
    SELECT MaDG, HoTen, NgaySinh, DiaChi, SoDT, NgayLapThe, NgayHetHan, TienNo
    FROM DOCGIA
    WHERE HoTen LIKE N'%' + @TuKhoa + N'%' OR MaDG LIKE '%' + @TuKhoa + '%'
    ORDER BY MaDG
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO
