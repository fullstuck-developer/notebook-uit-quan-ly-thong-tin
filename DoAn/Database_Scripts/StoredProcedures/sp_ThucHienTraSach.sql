USE QuanLyThuVien;
GO

-- Procedure Trả Sách
CREATE PROCEDURE sp_ThucHienTraSach
    @MaPM VARCHAR(10),
    @MaSach VARCHAR(10)
AS
BEGIN
    SET XACT_ABORT ON;
    BEGIN TRAN;

    DECLARE @TienPhat FLOAT;
    DECLARE @NgayTraThucTe DATE = GETDATE();

    -- Tính tiền phạt bằng cách gọi Function đã viết ở trên
    SET @TienPhat = dbo.fn_TinhTienPhat(@MaPM, @NgayTraThucTe);

    -- Cập nhật chi tiết phiếu mượn (Tự động kích hoạt Trigger tăng số lượng sách)
    UPDATE CTPHIEUMUON
    SET NgayTra = @NgayTraThucTe,
        TienPhat = @TienPhat
    WHERE MaPM = @MaPM AND MaSach = @MaSach AND NgayTra IS NULL;

    -- Cập nhật trạng thái phiếu mượn thành "Đã trả xong" nếu mọi sách trong phiếu đều đã trả
    IF NOT EXISTS (SELECT 1 FROM CTPHIEUMUON WHERE MaPM = @MaPM AND NgayTra IS NULL)
    BEGIN
        UPDATE PHIEUMUON SET TrangThai = N'Đã trả xong' WHERE MaPM = @MaPM;
    END

    -- Cộng dồn tiền phạt vào Tiền nợ của Độc giả (nếu có phạt)
    IF (@TienPhat > 0)
    BEGIN
        UPDATE DOCGIA
        SET TienNo = TienNo + @TienPhat
        FROM DOCGIA D JOIN PHIEUMUON P ON D.MaDG = P.MaDG
        WHERE P.MaPM = @MaPM;
    END

    COMMIT TRAN;
END;
GO
