USE QuanLyThuVien;
GO

-- Scalar function trả về trạng thái sách
CREATE FUNCTION fn_KiemTraTrangThaiSach (@MaSach VARCHAR(10))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @SoLuong INT;
    DECLARE @TrangThai NVARCHAR(50);
    
    SELECT @SoLuong = SoLuong FROM SACH WHERE MaSach = @MaSach;
    
    IF (@SoLuong > 0)
        SET @TrangThai = N'Sẵn sàng cho mượn';
    ELSE
        SET @TrangThai = N'Tạm hết hàng';
        
    RETURN @TrangThai;
END;
GO
