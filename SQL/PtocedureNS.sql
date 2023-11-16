use PKNHAKHOA 
GO
-- XEM CÁC CA ĐỦ 2 NG TRỰC TRỪ CA MÌNH ĐÃ ĐẶT (TỪ NGÀY HIỆN TẠI ĐẾN 30 NGÀY SAU)

CREATE PROCEDURE SP_XEMCADU2NGTRUC_NS
    @MANS VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT L1.MACA, L1.NGAY, C.GIOBATDAU, C.GIOKETTHUC
    FROM LICHRANH L1
        JOIN LICHRANH L2 ON L1.MACA = L2.MACA AND L1.NGAY = L2.NGAY AND L1.SOTT <> L2.SOTT
        JOIN CA C ON L1.MACA = C.MACA
    WHERE L1.MANS = @MANS
        AND L1.NGAY BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE())
    GROUP BY L1.MACA, L1.NGAY, C.GIOBATDAU, C.GIOKETTHUC
    HAVING COUNT(DISTINCT L1.SOTT) = 2;
END;
GO
-- TRUY VẤN CÁC LỊCH HẸN CỦA MÌNH (TỪ NGÀY HIỆN TẠI ĐẾN 30 NGÀY SAU)
CREATE PROCEDURE SP_XEMLICHHENNS_NS
    @MANS VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        LH.SOTT,
        LR.MACA,
        LR.NGAY,
        C.GIOBATDAU,
        C.GIOKETTHUC,
        KH.SODT AS SDT_KHACH,
        KH.HOTEN AS TEN_KHACH,
        LH.LYDOKHAM
    FROM
        LICHHEN LH
        JOIN
        LICHRANH LR ON LH.MANS = LR.MANS AND LH.SOTT = LR.SOTT
        JOIN
        CA C ON LR.MACA = C.MACA
        JOIN
        KHACHHANG KH ON LH.SODT = KH.SODT
    WHERE 
        LH.MANS = @MANS
        AND LR.NGAY BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE());
END;
GO

-- TRUY VẤN CÁC LỊCH RẢNH CỦA MÌNH MÀ CHƯA ĐƯỢC ĐẶT LỊCH (TỪ NGÀY HIỆN TẠI ĐẾN 30 NGÀY SAU)
CREATE PROCEDURE SP_LICHRANHCHUADUOCDAT_NS
    @MANS VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        LR.MANS,
        LR.SOTT,
        LR.MACA,
        LR.NGAY,
        C.GIOBATDAU,
        C.GIOKETTHUC
    FROM
        LICHRANH LR
        JOIN
        CA C ON LR.MACA = C.MACA
    WHERE 
        LR.MANS = @MANS
        AND NOT EXISTS (
            SELECT 1
        FROM LICHHEN LHEN
        WHERE LHEN.MANS = LR.MANS AND LHEN.SOTT = LR.SOTT
        )
        AND LR.NGAY BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE());
END;
GO
-- ĐĂNG KÝ LỊCH RẢNH
CREATE PROCEDURE SP_DANGKYLR_NS
    @MANS VARCHAR(10),
    @MACA VARCHAR(10),
    @NGAY DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NextSOTT INT;


    SELECT @NextSOTT = ISNULL(MAX(SOTT), 0) + 1
    FROM LICHRANH
    WHERE MANS = @MANS;


    INSERT INTO LICHRANH
        (MANS, MACA, NGAY, SOTT)
    VALUES
        (@MANS, @MACA, @NGAY, @NextSOTT);
END;
GO

-- HỦY LỊCH RẢNH
CREATE PROCEDURE SP_HUYLR_NS
    @MANS VARCHAR(10),
    @SOTT INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (
        SELECT 1
    FROM LICHHEN
    WHERE MANS = @MANS
        AND SOTT = @SOTT
    )
    BEGIN
        DELETE FROM LICHRANH
        WHERE MANS = @MANS
            AND SOTT = @SOTT;
    END
    ELSE
    BEGIN
        PRINT 'Lịch rảnh đã được hẹn, không thể hủy.';
    END
END;
go
-- XEM TẤT CẢ BỆNH ÁN CỦA 1 KHÁCH
CREATE PROCEDURE SP_XEMBENHAN_NS
    @SoDienThoai VARCHAR(10)
AS
BEGIN
    SELECT
        H.SODT,
        KH.HOTEN AS TENKHACH,
        H.SOTT AS STTHOSO,
        H.NGAYKHAM,
        H.MANS,
        NS.HOTEN AS TENNS,
        H.DANDO,
        DV.MADV,
        DV.TENDV,
        CTDV.SOLUONG AS SLDV,
        T.MATHUOC,
        T.TENTHUOC,
        CTT.SOLUONG AS SLTHUOC,
        T.DONVITINH,
        CTT.THOIDIEMDUNG
    FROM
        HOSOBENH H
        JOIN
        KHACHHANG KH ON H.SODT = KH.SODT
        JOIN
        NHASI NS ON H.MANS = NS.MANS
        LEFT JOIN
        CHITIETDV CTDV ON H.SODT = CTDV.SODT AND H.SOTT = CTDV.SOTT
        LEFT JOIN
        LOAIDICHVU DV ON CTDV.MADV = DV.MADV
        LEFT JOIN
        CHITIETTHUOC CTT ON H.SODT = CTT.SODT AND H.SOTT = CTT.SOTT
        LEFT JOIN
        LOAITHUOC T ON CTT.MATHUOC = T.MATHUOC
    WHERE
        H.SODT = @SoDienThoai;
END;
GO

-- @MaDV VARCHAR(10),
--     @SoLuongDV INT,
--     @MaThuoc VARCHAR(10),
--     @SoLuongThuoc INT,
--     @ThoiDiemDung NVARCHAR(200)


-- TẠO BỆNH ÁN MỚI
CREATE PROCEDURE SP_TAOBENHAN_NS
    @SoDienThoai VARCHAR(10),
    @NgayKham DATE,
    @MaNS VARCHAR(10),
    @DanDo NVARCHAR(500)
AS
BEGIN
    DECLARE @Sott INT;
    SELECT @Sott = ISNULL(MAX(SOTT), 0) + 1
    FROM HOSOBENH
    WHERE SODT = @SoDienThoai;
    INSERT INTO HOSOBENH
        (SODT, SOTT, NGAYKHAM, MANS, DANDO)
    VALUES
        (@SoDienThoai, @Sott, @NgayKham, @MaNS, @DanDo);

END;
GO

-- THÊM CTDV VÀO BỆNH ÁN
CREATE PROCEDURE SP_THEMCTDV_NS
    @MaDV VARCHAR(10),
    @SOTT INT,
    @SoDienThoai VARCHAR(10),
    @SoLuongDV INT

AS
BEGIN
    INSERT INTO CHITIETDV 
       (MADV, SOTT, SODT,SOLUONG)
    VALUES
        (@MaDV, @SOTT,@SoDienThoai, @SoLuongDV);

END;
GO
-- THÊM CTTHUOC VÀO BỆNH ÁN
CREATE PROCEDURE SP_THEMCTTHUOC_NS
    @MATHUOC VARCHAR(10),
	@SOTT INT,
	@SODT VARCHAR(10),
	@SOLUONG INT,
	@THOIDIEMDUNG NVARCHAR(200)

AS
BEGIN
    INSERT INTO CHITIETTHUOC
       (MATHUOC,SOTT,SODT,SOLUONG,THOIDIEMDUNG)
    VALUES
        (@MATHUOC,@SOTT,@SODT,@SOLUONG,@THOIDIEMDUNG);

END;
GO

