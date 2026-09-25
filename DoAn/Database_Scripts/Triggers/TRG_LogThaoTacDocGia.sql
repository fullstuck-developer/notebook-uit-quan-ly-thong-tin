USE QuanLyThuVien;
GO

-- Tạo bảng Log nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LOG_DOCGIA')
BEGIN
    CREATE TABLE LOG_DOCGIA (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        MaDG VARCHAR(10),
        HanhDong NVARCHAR(50),
        ThoiGian DATETIME DEFAULT GETDATE()
    );
END
GO

-- Trigger log lại các thao tác liên quan tới Độc giả
CREATE TRIGGER TRG_LogThaoTacDocGia
ON DOCGIA
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_DOCGIA (MaDG, HanhDong)
        SELECT MaDG, N'Thêm mới' FROM inserted;
    END
    ELSE IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO LOG_DOCGIA (MaDG, HanhDong)
        SELECT MaDG, N'Cập nhật' FROM inserted;
    END
    ELSE IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO LOG_DOCGIA (MaDG, HanhDong)
        SELECT MaDG, N'Xóa' FROM deleted;
    END
END;
GO
