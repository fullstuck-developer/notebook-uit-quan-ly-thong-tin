USE QuanLyThuVien;
GO

-- Procedure lấy danh sách Sách có phân trang và lọc theo Thể loại
CREATE PROCEDURE sp_LayDanhSachSach_PhanTrang
    @TuKhoa NVARCHAR(100) = '',
    @MaTheLoai VARCHAR(10) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy tổng số dòng (Result Set 1)
    SELECT COUNT(*) AS TotalRecords
    FROM SACH 
    WHERE (TenSach LIKE N'%' + @TuKhoa + N'%' OR MaSach LIKE '%' + @TuKhoa + '%')
      AND (@MaTheLoai IS NULL OR MaTheLoai = @MaTheLoai);

    -- Trả về dữ liệu phân trang
    SELECT S.MaSach, S.TenSach, TL.TenTheLoai, S.NamXB, S.NhaXuatBan, S.SoLuong
    FROM SACH S
    JOIN THELOAI TL ON S.MaTheLoai = TL.MaTheLoai
    WHERE (S.TenSach LIKE N'%' + @TuKhoa + N'%' OR S.MaSach LIKE '%' + @TuKhoa + '%')
      AND (@MaTheLoai IS NULL OR S.MaTheLoai = @MaTheLoai)
    ORDER BY S.MaSach
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO
