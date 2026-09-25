USE QuanLyThuVien;
GO

CREATE TRIGGER TRG_CapNhatSoLuongSach
ON CTPHIEUMUON
AFTER INSERT, UPDATE
AS
BEGIN
    -- Khi mượn sách (INSERT) -> Giảm số lượng sách
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE SACH
        SET SoLuong = SACH.SoLuong - 1
        FROM SACH JOIN inserted i ON SACH.MaSach = i.MaSach;

        -- Kiểm tra nếu số lượng < 0 thì Rollback
        IF EXISTS (SELECT 1 FROM SACH JOIN inserted i ON SACH.MaSach = i.MaSach WHERE SACH.SoLuong < 0)
        BEGIN
            RAISERROR(N'Số lượng sách không đủ để mượn!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END

    -- Khi trả sách (UPDATE cập nhật NgayTra khác NULL) -> Tăng số lượng sách
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Chỉ tăng nếu NgayTra ban đầu là NULL và mới được update thành có giá trị
        UPDATE SACH
        SET SoLuong = SACH.SoLuong + 1
        FROM SACH 
        JOIN inserted i ON SACH.MaSach = i.MaSach
        JOIN deleted d ON SACH.MaSach = d.MaSach
        WHERE d.NgayTra IS NULL AND i.NgayTra IS NOT NULL;
    END
END;
GO
