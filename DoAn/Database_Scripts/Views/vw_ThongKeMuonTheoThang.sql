USE QuanLyThuVien;
GO

-- Report 3: Thống kê số lượng sách được mượn theo từng tháng
CREATE VIEW vw_ThongKeMuonTheoThang
AS
SELECT 
    YEAR(PM.NgayMuon) AS Nam,
    MONTH(PM.NgayMuon) AS Thang,
    COUNT(CT.MaSach) AS TongSoSachDaMuon
FROM PHIEUMUON PM
JOIN CTPHIEUMUON CT ON PM.MaPM = CT.MaPM
GROUP BY YEAR(PM.NgayMuon), MONTH(PM.NgayMuon);
GO
