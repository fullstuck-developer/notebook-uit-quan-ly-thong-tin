USE QuanLyThuVien;
GO

-- Procedure Mượn Sách (Kèm kiểm tra điều kiện khắt khe và Isolation Level)
CREATE PROCEDURE sp_ThucHienMuonSach
    @MaPM VARCHAR(10),
    @MaDG VARCHAR(10),
    @MaNV VARCHAR(10),
    @MaSach VARCHAR(10),
    @SoNgayMuon INT
AS
BEGIN
    -- Bật XACT_ABORT để tự động Rollback nếu có lỗi Runtime
    SET XACT_ABORT ON;
    -- Ngăn chặn Phantom Read và Dirty Read khi kiểm tra số lượng sách
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @NgayHetHan DATE;
        DECLARE @TienNo FLOAT;
        DECLARE @SoLuongSach INT;

        -- Kiểm tra độc giả có tồn tại không và lấy thông tin
        IF NOT EXISTS (SELECT 1 FROM DOCGIA WHERE MaDG = @MaDG)
        BEGIN
            RAISERROR(N'Độc giả không tồn tại!', 16, 1);
        END
        SELECT @NgayHetHan = NgayHetHan, @TienNo = TienNo FROM DOCGIA WHERE MaDG = @MaDG;

        -- Kiểm tra thẻ độc giả còn hạn không
        IF (@NgayHetHan < GETDATE())
        BEGIN
            RAISERROR(N'Thẻ độc giả đã hết hạn, vui lòng gia hạn thẻ!', 16, 1);
        END

        -- Kiểm tra tiền nợ (VD: Nợ > 50.000 không cho mượn)
        IF (@TienNo > 50000)
        BEGIN
            RAISERROR(N'Độc giả đang nợ tiền phạt quá giới hạn cho phép!', 16, 1);
        END

        -- Kiểm tra số lượng sách trong kho
        SELECT @SoLuongSach = SoLuong FROM SACH WHERE MaSach = @MaSach;
        IF (@SoLuongSach <= 0)
        BEGIN
            RAISERROR(N'Sách này đã hết trong kho!', 16, 1);
        END

        -- Thực hiện Mượn (Insert vào PHIEUMUON và CTPHIEUMUON)
        -- Nếu Phiếu mượn chưa tồn tại trong ngày, tạo mới phiếu mượn
        IF NOT EXISTS (SELECT 1 FROM PHIEUMUON WHERE MaPM = @MaPM)
        BEGIN
            INSERT INTO PHIEUMUON (MaPM, MaDG, MaNV, NgayMuon, NgayHenTra, TrangThai)
            VALUES (@MaPM, @MaDG, @MaNV, GETDATE(), DATEADD(DAY, @SoNgayMuon, GETDATE()), N'Đang mượn');
        END

        -- Insert vào chi tiết phiếu mượn (Sẽ tự động kích hoạt Trigger giảm số lượng sách)
        INSERT INTO CTPHIEUMUON (MaPM, MaSach, NgayTra, TienPhat, GhiChu)
        VALUES (@MaPM, @MaSach, NULL, 0, N'Mượn mới');

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
