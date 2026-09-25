USE QuanLyThuVien;
GO

-- Cập nhật gia hạn phiếu mượn sách
CREATE PROCEDURE sp_GiaHanSach
    @MaPM VARCHAR(10),
    @SoNgayGiaHan INT
AS
BEGIN
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRAN;
        -- Kiểm tra phiếu mượn
        IF NOT EXISTS (SELECT 1 FROM PHIEUMUON WHERE MaPM = @MaPM)
        BEGIN
            RAISERROR(N'Phiếu mượn không tồn tại!', 16, 1);
        END
        
        -- Cập nhật ngày hẹn trả (chỉ áp dụng nếu chưa trả)
        UPDATE PHIEUMUON
        SET NgayHenTra = DATEADD(DAY, @SoNgayGiaHan, NgayHenTra)
        WHERE MaPM = @MaPM AND TrangThai = N'Đang mượn';
        
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
