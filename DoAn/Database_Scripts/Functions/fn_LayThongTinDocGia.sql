USE QuanLyThuVien;
GO

-- Trả về bảng thông tin tóm tắt của Độc giả
CREATE FUNCTION fn_LayThongTinDocGia (@MaDG VARCHAR(10))
RETURNS TABLE
AS
RETURN (
    SELECT MaDG, HoTen, SoDT, TienNo, NgayHetHan
    FROM DOCGIA
    WHERE MaDG = @MaDG
);
GO
