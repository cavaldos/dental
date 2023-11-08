USE master;
GO

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'PKNHAKHOA')
BEGIN
    CREATE DATABASE PKNHAKHOA;
END
GO



-- 2. PHÂN QUYỀN-------------------------------------------------------------------------------------------------
USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginKH')
BEGIN
    CREATE LOGIN loginKH WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginNS')
BEGIN
    CREATE LOGIN loginNS WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginNV')
BEGIN
    CREATE LOGIN loginNV WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginQTV')
BEGIN
    CREATE LOGIN loginQTV WITH PASSWORD = 'password123@';
END

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'loginServer')
BEGIN
    CREATE LOGIN loginServer WITH PASSWORD = 'password123@';
END


SELECT name, type_desc, create_date, is_disabled
FROM sys.sql_logins;

SELECT name
FROM sys.sql_logins;

SELECT name, type_desc, is_disabled
FROM sys.sql_logins;

ALTER LOGIN loginKH ENABLE;




USE PKNHAKHOA;
GO
SELECT name FROM sys.sql_logins;


USE master;
GO
EXEC sp_helpuser 'loginKH';


USE master;
GO
CREATE USER [loginKH] FOR LOGIN [loginKH];    --  cau lenh nay ne
GO

USE master;
GO
ALTER LOGIN loginQTV WITH PASSWORD = 'password123@';
GO

USE master;
GO
SELECT name FROM sys.sql_logins;

USE PKNHAKHOA;
GO

-- kieemr tra cac login cua master
SELECT name FROM sys.sql_logins;
-- kiem tra cac login cua PKNHAKHOA
SELECT name FROM sys.database_principals;
--- cap quyen cho loginKH trong PKNHAKHOA

USE master;
EXEC sp_addrolemember 'PKNHAKHOA', 'loginKH';




IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userKH')
BEGIN
    CREATE USER userKH FOR LOGIN loginKH;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userNS')
BEGIN
    CREATE USER userNS FOR LOGIN loginNS;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userNV')
BEGIN
    CREATE USER userNV FOR LOGIN loginNV;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userQTV')
BEGIN
    CREATE USER userQTV FOR LOGIN loginQTV;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'userServer')
BEGIN
    CREATE USER userServer FOR LOGIN loginServer;
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'QTV')
BEGIN
    EXEC SP_ADDROLE 'QTV';
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'KHACHHANG')
BEGIN
    EXEC SP_ADDROLE 'KHACHHANG';
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'NHANVIEN')
BEGIN
    EXEC SP_ADDROLE 'NHANVIEN';
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'NHASI')
BEGIN
    EXEC SP_ADDROLE 'NHASI';
END

EXEC sp_addrolemember 'QTV', 'userQTV'
EXEC sp_addrolemember 'KHACHHANG', 'userKH'
EXEC sp_addrolemember 'NHANVIEN', 'userNV'
EXEC sp_addrolemember 'NHASI', 'userNS'
EXEC sp_addrolemember db_datareader, 'userServer'

USE master
GO
--I/ Phân quyền cho role QTV
--1. Quyền quản lý tài khoản KH
GRANT SELECT (SODT, HOTEN, PHAI, NGAYSINH, DIACHI, _DAKHOA), UPDATE (_DAKHOA)
ON KHACHHANG
TO QTV

--2. Quyền quản lý tài khoản NV
GRANT SELECT (MANV, HOTEN, PHAI, VITRICV, _DAKHOA), INSERT, UPDATE (_DAKHOA)
ON NHANVIEN
TO QTV

--3. Quyền quản lý tài khoản NS
GRANT SELECT (MANS, HOTEN, PHAI, GIOITHIEU, _DAKHOA), INSERT, UPDATE (_DAKHOA)
ON NHASI
TO QTV

--4. Quyền quản lý tài khoản QTV
GRANT SELECT, INSERT, UPDATE(HOTEN, PHAI, MATKHAU)
ON QTV
TO QTV

--5. Quyền quản lý dịch vụ 
GRANT SELECT, INSERT, DELETE, UPDATE(TENDV, MOTA, DONGIA)
ON LOAIDICHVU
TO QTV

--6. Quyền quản lý các loại thuốc
GRANT SELECT, INSERT, DELETE, UPDATE (TENTHUOC, DONVITINH, CHIDINH, SLTON, SLNHAP, SLDAHUY, NGAYHETHAN, DONGIA)
ON LOAITHUOC
TO QTV

--7. Quyền quản lý các ca
GRANT SELECT, INSERT, DELETE, UPDATE(GIOBATDAU, GIOKETTHUC)
ON CA
TO QTV

--II/ Phân quyền cho KHACHHANG 
--1. Mọi quyền trên tài khoản KH trừ xóa tài khoản
GRANT SELECT, INSERT, UPDATE(HOTEN, PHAI, NGAYSINH, DIACHI, MATKHAU)
ON KHACHHANG
TO KHACHHANG

--2. Quyền xem,thêm, xóa lịch hẹn
GRANT SELECT, DELETE, INSERT
ON LICHHEN
TO KHACHHANG

--3. Quyền xem trên lịch rảnh của nha sĩ
GRANT SELECT
ON LICHRANH
TO KHACHHANG

--4. Quyền xem trên CA
GRANT SELECT
ON CA
TO KHACHHANG

--5. Quyền xem thông tin nha sĩ
GRANT SELECT (MANS, HOTEN, PHAI, GIOITHIEU)
ON NHASI
TO KHACHHANG

--6. Quyền xem hồ sơ bệnh 
GRANT SELECT (SODT, SOTT, NGAYKHAM, DANDO, MANS)
ON HOSOBENH
TO KHACHHANG

--7. Quyền xem hóa đơn 
GRANT SELECT
ON HOADON
TO KHACHHANG

--8. Quyền xem tên nhân viên trong hóa đơn 
GRANT SELECT(MANV, HOTEN)
ON NHANVIEN
TO KHACHHANG

--9. Quyền xem chi tiết dịch vụ
GRANT SELECT
ON CHITIETDV
TO KHACHHANG

--10. Quyền xem loại dịch vụ
GRANT SELECT
ON LOAIDICHVU
TO KHACHHANG

--11. Quyền xem chi tiết nhân thuốc trong mỗi đơn thuốc
GRANT SELECT
ON CHITIETTHUOC
TO KHACHHANG

--12. Quyền xem tên các loại thuốc
GRANT SELECT (MATHUOC, TENTHUOC, DONVITINH, CHIDINH, DONGIA, NGAYHETHAN)
ON LOAITHUOC
TO KHACHHANG

--III/ Phân quyền cho role NHASI
--1. Quyền xem, sửa trên bảng nha sĩ.
GRANT SELECT, UPDATE (HOTEN, PHAI, GIOITHIEU, MATKHAU)
ON NHASI
TO NHASI

--2. Quyền quản lý lịch rảnh.
GRANT SELECT, INSERT, DELETE, UPDATE(MACA, NGAY)
ON LICHRANH
TO NHASI

--3. Quyền xem ca
GRANT SELECT
ON CA
TO NHASI

--4. Quyền xem lịch hẹn
GRANT SELECT
ON LICHHEN
TO NHASI

--5. Quyền xem, tạo hồ sơ bệnh án của bệnh nhân
GRANT SELECT, INSERT
ON HOSOBENH
TO NHASI

--6. Quyền xem và tạo chi tiết dịch vụ
GRANT SELECT, INSERT
ON CHITIETDV
TO NHASI

--7. Quyền xem loại dịch vụ
GRANT SELECT
ON LOAIDICHVU
TO NHASI

--8. Quyền xem và tạo chi tiết thuốc
GRANT SELECT, INSERT
ON CHITIETTHUOC
TO NHASI

--9. Quyền xem loại thuốc
GRANT SELECT
ON LOAITHUOC
TO NHASI

--10. Quyền xem thông tin khách hàng
GRANT SELECT(SODT, HOTEN, PHAI, NGAYSINH, DIACHI)
ON KHACHHANG
TO NHASI

--IV/ Phân quyền cho role NHANVIEN
--1. Quyền xem, sửa thông tin nhân viên
GRANT SELECT, UPDATE(HOTEN, PHAI)
ON NHANVIEN
TO NHANVIEN

--2. Quyền xem, tạo hóa đơn
GRANT SELECT, INSERT
ON HOADON
TO NHANVIEN

--3. Quyền xem hồ sơ bệnh án
GRANT SELECT
ON HOSOBENH
TO NHANVIEN

--4. Quyền xem trên chi tiết dịch vụ
GRANT SELECT
ON CHITIETDV
TO NHANVIEN

--5. Quyền xem trên loại dịch vụ
GRANT SELECT
ON LOAIDICHVU
TO NHANVIEN

--6. Quyền xem trên chi tiết thuốc
GRANT SELECT
ON CHITIETTHUOC
TO NHANVIEN

--7. Quyền xem các loại thuốc
GRANT SELECT
ON LOAITHUOC
TO NHANVIEN

--8. Quyền xem và tạo tài khoản khách hàng
GRANT SELECT(SODT, HOTEN, PHAI, NGAYSINH, _DAKHOA), INSERT 
ON KHACHHANG
TO NHANVIEN

--9. Quyền xem thông tin nha sĩ
GRANT SELECT(MANS, HOTEN, PHAI, GIOITHIEU, _DAKHOA) 
ON NHASI
TO NHANVIEN

--10. Quyền xem,thêm, xóa lịch hẹn
GRANT SELECT, DELETE, INSERT
ON LICHHEN
TO NHANVIEN

--11. Quyền xem trên lịch rảnh của nha sĩ
GRANT SELECT
ON LICHRANH
TO NHANVIEN




--12. Quyền xem trên CA
GRANT SELECT
ON CA
TO NHANVIEN
GO
