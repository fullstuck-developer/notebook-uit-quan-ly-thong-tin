USE QuanLyThuVien;
GO

-- Đảm bảo ngày hẹn trả không quá 14 ngày kể từ ngày mượn
CREATE TRIGGER TRG_KiemTraNgayHenTra
ON PHIEUMUON
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE DATEDIFF(DAY, NgayMuon, NgayHenTra) > 14
    )
    BEGIN
        RAISERROR(N'Ngày hẹn trả không được quá 14 ngày kể từ ngày mượn!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
