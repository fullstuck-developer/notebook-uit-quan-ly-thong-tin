USE QuanLyThuVien;
GO

-- View liệt kê danh sách độc giả đang nợ tiền phạt và số sách đang giữ
CREATE VIEW vw_DocGia_NoPhat
AS
SELECT 
    DG.MaDG, 
    DG.HoTen, 
    DG.SoDT, 
    DG.TienNo,
    COUNT(CT.MaSach) AS SoSachDangMuon
FROM DOCGIA DG
LEFT JOIN PHIEUMUON PM ON DG.MaDG = PM.MaDG
LEFT JOIN CTPHIEUMUON CT ON PM.MaPM = CT.MaPM AND CT.NgayTra IS NULL
WHERE DG.TienNo > 0 OR CT.MaSach IS NOT NULL
GROUP BY DG.MaDG, DG.HoTen, DG.SoDT, DG.TienNo;
GO
