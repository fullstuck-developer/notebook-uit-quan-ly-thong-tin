USE QuanLyThuVien;
GO

-- Report 4: Hiển thị Top 10 Độc giả mượn nhiều sách nhất
CREATE VIEW vw_DocGiaThanThiet
AS
SELECT TOP 10 
    DG.MaDG,
    DG.HoTen,
    COUNT(CT.MaSach) AS SoLanMuonSach
FROM DOCGIA DG
JOIN PHIEUMUON PM ON DG.MaDG = PM.MaDG
JOIN CTPHIEUMUON CT ON PM.MaPM = CT.MaPM
GROUP BY DG.MaDG, DG.HoTen
ORDER BY SoLanMuonSach DESC;
GO
