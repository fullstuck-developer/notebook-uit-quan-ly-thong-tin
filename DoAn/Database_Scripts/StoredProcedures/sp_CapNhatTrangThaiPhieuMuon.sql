USE QuanLyThuVien;
GO

-- Procedure sử dụng Cursor để tự động quét và cập nhật trạng thái phiếu mượn thành 'Trễ hạn'
-- Mục đích: Chạy cuối ngày để đánh dấu các phiếu mượn đã quá hạn mà chưa trả sách.
CREATE PROCEDURE sp_CapNhatTrangThaiPhieuMuon
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaPM VARCHAR(10);
    
    -- Lấy danh sách các phiếu mượn đã quá hạn nhưng trạng thái vẫn là 'Đang mượn'
    DECLARE cur_TreHan CURSOR FOR
    SELECT MaPM
    FROM PHIEUMUON
    WHERE TrangThai = N'Đang mượn' AND NgayHenTra < CAST(GETDATE() AS DATE);
    
    OPEN cur_TreHan;
    FETCH NEXT FROM cur_TreHan INTO @MaPM;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Cập nhật trạng thái
        UPDATE PHIEUMUON
        SET TrangThai = N'Trễ hạn'
        WHERE MaPM = @MaPM;
        
        FETCH NEXT FROM cur_TreHan INTO @MaPM;
    END
    
    CLOSE cur_TreHan;
    DEALLOCATE cur_TreHan;
    
    PRINT N'Đã cập nhật trạng thái các phiếu mượn trễ hạn thành công!';
END;
GO
