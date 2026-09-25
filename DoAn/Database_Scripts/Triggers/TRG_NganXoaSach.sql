USE QuanLyThuVien;
GO

CREATE TRIGGER TRG_NganXoaSach
ON SACH
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM CTPHIEUMUON CT
        JOIN deleted d ON CT.MaSach = d.MaSach
        WHERE CT.NgayTra IS NULL -- Đang mượn
    )
    BEGIN
        RAISERROR(N'Không được xóa sách vì đang có độc giả mượn chưa trả!', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Nếu không ai mượn, tiến hành xóa theo cascade
        DELETE FROM SACH_TACGIA WHERE MaSach IN (SELECT MaSach FROM deleted);
        DELETE FROM CTPHIEUMUON WHERE MaSach IN (SELECT MaSach FROM deleted);
        DELETE FROM SACH WHERE MaSach IN (SELECT MaSach FROM deleted);
    END
END;
GO
