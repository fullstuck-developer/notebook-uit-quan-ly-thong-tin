USE QuanLyThuVien;
GO

-- View thống kê số lượng sách theo từng thể loại và số lần mượn
CREATE VIEW vw_SachThongKe
AS
SELECT 
    S.MaSach,
    S.TenSach,
    TL.TenTheLoai,
    S.SoLuong AS TonKho,
    COUNT(CT.MaSach) AS SoLanDuocMuon
FROM SACH S
JOIN THELOAI TL ON S.MaTheLoai = TL.MaTheLoai
LEFT JOIN CTPHIEUMUON CT ON S.MaSach = CT.MaSach
GROUP BY S.MaSach, S.TenSach, TL.TenTheLoai, S.SoLuong;
GO
