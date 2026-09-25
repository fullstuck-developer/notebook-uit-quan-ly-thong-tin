USE QuanLyThuVien;
GO

-- Procedure sử dụng CURSOR để cập nhật tiền phạt tự động cho những người trễ hạn
-- Mục đích: Chạy cuối ngày để tính tiền phạt những sách quá hạn mà chưa trả.
CREATE PROCEDURE sp_CapNhatTienPhatTuDong
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MaPM VARCHAR(10);
    DECLARE @MaSach VARCHAR(10);
    DECLARE @MaDG VARCHAR(10);
    DECLARE @NgayHenTra DATE;
    DECLARE @TienPhatCu FLOAT;
    DECLARE @TienPhatMoi FLOAT;

    -- Khai báo CURSOR lấy danh sách các sách đang mượn và đã quá hạn
    DECLARE cur_QuaHan CURSOR FOR
    SELECT 
        CT.MaPM, 
        CT.MaSach, 
        PM.MaDG, 
        PM.NgayHenTra,
        CT.TienPhat
    FROM CTPHIEUMUON CT
    JOIN PHIEUMUON PM ON CT.MaPM = PM.MaPM
    WHERE CT.NgayTra IS NULL AND PM.NgayHenTra < GETDATE();

    OPEN cur_QuaHan;

    FETCH NEXT FROM cur_QuaHan INTO @MaPM, @MaSach, @MaDG, @NgayHenTra, @TienPhatCu;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tính tiền phạt mới (5000/ngày)
        SET @TienPhatMoi = DATEDIFF(DAY, @NgayHenTra, GETDATE()) * 5000;

        -- Nếu tiền phạt có tăng lên so với trước đó
        IF (@TienPhatMoi > @TienPhatCu)
        BEGIN
            -- Cập nhật vào chi tiết phiếu mượn
            UPDATE CTPHIEUMUON 
            SET TienPhat = @TienPhatMoi
            WHERE MaPM = @MaPM AND MaSach = @MaSach;

            -- Cập nhật cộng thêm phần chênh lệch vào tổng nợ của Độc giả
            UPDATE DOCGIA
            SET TienNo = TienNo + (@TienPhatMoi - @TienPhatCu)
            WHERE MaDG = @MaDG;
        END

        FETCH NEXT FROM cur_QuaHan INTO @MaPM, @MaSach, @MaDG, @NgayHenTra, @TienPhatCu;
    END

    CLOSE cur_QuaHan;
    DEALLOCATE cur_QuaHan;

    PRINT N'Cập nhật tiền phạt tự động thành công!';
END;
GO
