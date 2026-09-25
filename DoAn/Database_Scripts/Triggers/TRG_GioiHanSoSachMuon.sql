USE QuanLyThuVien;
GO

-- Ngăn độc giả mượn quá 5 cuốn sách cùng lúc trong một phiếu
CREATE TRIGGER TRG_GioiHanSoSachMuon
ON CTPHIEUMUON
AFTER INSERT
AS
BEGIN
    DECLARE @MaPM VARCHAR(10);
    SELECT @MaPM = i.MaPM FROM inserted i;
    
    DECLARE @TongSach INT;
    SELECT @TongSach = COUNT(*) FROM CTPHIEUMUON WHERE MaPM = @MaPM AND NgayTra IS NULL;
    
    IF (@TongSach > 5)
    BEGIN
        RAISERROR(N'Một phiếu mượn không được vượt quá 5 cuốn sách!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
