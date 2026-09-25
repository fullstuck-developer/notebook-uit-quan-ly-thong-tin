USE QuanLyThuVien;
GO

-- Report 5: Báo cáo tổng doanh thu thu được từ tiền phạt theo tháng
CREATE VIEW vw_BaoCaoDoanhThuPhat
AS
SELECT 
    YEAR(NgayTra) AS Nam,
    MONTH(NgayTra) AS Thang,
    SUM(TienPhat) AS TongTienPhatThuDuoc
FROM CTPHIEUMUON
WHERE NgayTra IS NOT NULL AND TienPhat > 0
GROUP BY YEAR(NgayTra), MONTH(NgayTra);
GO
