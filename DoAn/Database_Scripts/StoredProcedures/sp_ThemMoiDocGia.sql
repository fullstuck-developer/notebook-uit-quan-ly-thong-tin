USE QuanLyThuVien;
GO

-- Thêm mới Độc giả (tự động tạo ngày lập thẻ và ngày hết hạn)
CREATE PROCEDURE sp_ThemMoiDocGia
    @MaDG VARCHAR(10),
    @HoTen NVARCHAR(100),
    @NgaySinh DATE,
    @DiaChi NVARCHAR(200),
    @SoDT VARCHAR(15)
AS
BEGIN
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRAN;
        INSERT INTO DOCGIA (MaDG, HoTen, NgaySinh, DiaChi, SoDT, NgayLapThe, NgayHetHan, TienNo)
        VALUES (@MaDG, @HoTen, @NgaySinh, @DiaChi, @SoDT, GETDATE(), DATEADD(YEAR, 4, GETDATE()), 0);
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
