USE QuanLyThuVien;
GO

-- Hàm tính tiền phạt khi độc giả trả sách trễ hạn
-- Giả sử: Trễ 1 ngày phạt 5,000 VNĐ
CREATE FUNCTION fn_TinhTienPhat (
    @MaPM VARCHAR(10),
    @NgayTraThucTe DATE
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TienPhat FLOAT = 0;
    DECLARE @NgayHenTra DATE;

    SELECT @NgayHenTra = NgayHenTra 
    FROM PHIEUMUON 
    WHERE MaPM = @MaPM;

    IF (@NgayTraThucTe > @NgayHenTra)
    BEGIN
        -- DATEDIFF: Tính số ngày trễ
        SET @TienPhat = DATEDIFF(DAY, @NgayHenTra, @NgayTraThucTe) * 5000;
    END

    RETURN @TienPhat;
END;
GO
