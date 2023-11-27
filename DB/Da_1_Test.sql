Create database Da_1_Test
GO

USE Da_1_Test
GO


CREATE TABLE DanhMuc(
ID int IDENTITY (1,1) PRIMARY KEY,
ten_danh_muc nvarchar(255) not null
)
Go

CREATE TABLE ThuongHieu(
ID int IDENTITY (1,1) PRIMARY KEY,
ten_thuong_hieu nvarchar(255) not null
)
Go

CREATE TABLE PhanLoai(
ID int IDENTITY (1,1) PRIMARY KEY,
phan_loai nvarchar(255) not null
)
Go

CREATE TABLE ChatLieu(
ID int IDENTITY (1,1) PRIMARY KEY,
chat_lieu nvarchar(255) not null
)
GO


CREATE TABLE MauSac(
ID int IDENTITY (1,1) PRIMARY KEY,
ten_mau nvarchar(255) not null
)
Go

CREATE TABLE HinhDang(
ID int IDENTITY (1,1) PRIMARY KEY,
kieu_dang nvarchar(255) not null,
)
Go

CREATE TABLE Anh(
ID int IDENTITY (1,1) PRIMARY KEY,
link varchar(255)
)
Go


CREATE TABLE SanPham(
ID int IDENTITY (1,1) PRIMARY KEY,
ma_san_pham varchar(255) UNIQUE,
ten nvarchar(255) not null,
mo_ta nvarchar(255),
ngay_tao DATETIME DEFAULT GETDATE(),
ngay_sua DATETIME DEFAULT GETDATE(),
danh_muc_id int foreign key (danh_muc_id) references DanhMuc(ID),
thuong_hieu_id int foreign key (thuong_hieu_id) references ThuongHieu(ID),
phan_loai_id int foreign key (phan_loai_id) references PhanLoai(ID),
chat_lieu_id int foreign key (chat_lieu_id) references ChatLieu(ID)
)
Go

CREATE TABLE SPCT(
ID int IDENTITY (1,1) PRIMARY KEY,
gia Float not null,
so_luong int not null,
trang_thai int not null,
san_pham_id int foreign key (san_pham_id) references SanPham(ID),
mau_sac_id int foreign key(mau_sac_id) references MauSac(ID),
hinh_dang_id int foreign key (hinh_dang_id) references HinhDang(ID),
anh_id int foreign key (anh_id) references Anh(ID)
)
Go

CREATE TABLE Taikhoan(
ID int IDENTITY (1,1) PRIMARY KEY,
tai_khoan varchar(255) not null UNIQUE,
mat_khau varchar(255) not null,
ten nvarchar(255) not null,
dia_chi nvarchar(255),
SDT varchar(255),
email varchar(255),
vai_tro int not null
)
Go

CREATE TABLE KhuyenMai(
ID int IDENTITY (1,1) PRIMARY KEY,
ma_khuyen_mai varchar(255) not null UNIQUE,
ten nvarchar(255),
mo_ta nvarchar(255),
ngay_tao DATETIME DEFAULT GETDATE(),
tai_khoan_id int foreign key (tai_khoan_id) references TaiKhoan(ID),
)
Go

CREATE TABLE KMCT(
ID int IDENTITY (1,1) PRIMARY KEY,
ngay_bat_dau DATE not null,
ngay_ket_thuc DATE not null,
so_luong int,
kieu_giam int,
trang_thai int not null,
khuyen_mai_id int foreign key (khuyen_mai_id) references KhuyenMai(ID)
)
GO

CREATE TABLE KhachHang(
ID int IDENTITY (1,1) PRIMARY KEY,
ma_khach_hang varchar(255) UNIQUE,
ten varchar(255) not null,
SDT varchar(20) not null
)
Go

CREATE TABLE HoaDon(
ID int IDENTITY (1,1) PRIMARY KEY,
ma_hoa_don Varchar(10) UNIQUE,
ngay_tao DATETIME DEFAULT GETDATE(),
tong_gia Float,
trang_thai int,
tai_khoan_id int foreign key (tai_khoan_id) references TaiKhoan(ID),
khach_hang_id int foreign key (khach_hang_id) references KhachHang(ID),
KMCT_id int foreign key(KMCT_id) references KMCT(ID)
)
GO

CREATE TABLE HDCT(
ID int IDENTITY (1,1) PRIMARY KEY,
hoa_don_id int foreign key(hoa_don_id) references HoaDon(ID),
SPCT_id int foreign key(SPCT_id) references SPCT(ID),
so_luong int not null,
gia Float
)
GO


CREATE TRIGGER Tr_Generate_MaHD ON HoaDon
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO HoaDon (ma_hoa_don, ngay_tao, tong_gia, trang_thai, tai_khoan_id, khach_hang_id, KMCT_id)
    SELECT 
        COALESCE(ma_hoa_don, 'HD' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        ngay_tao, tong_gia, trang_thai, tai_khoan_id, khach_hang_id, KMCT_id
    FROM inserted;
END
Go


CREATE TRIGGER Tr_Generate_KH ON KhachHang
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO KhachHang ([ma_khach_hang], [ten], [SDT])
    SELECT 
        COALESCE([ma_khach_hang], 'KH' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        [ten], [SDT]
    FROM inserted;
END
Go

INSERT INTO DANHMUC values 
(N'Gọng kính'),
(N'Tròng Kính'),
(N'Kính râm')
Go


INSERT INTO ThuongHieu values
('Chemi'),
('Elements'),
('Essilor'),
('Hoga')
Go

INSERT INTO PhanLoai values
(N'Kính cận'),
(N'Kính râm')
Go

INSERT INTO ChatLieu values 
(N'Nhựa'),
(N'Kim loại'),
(N'Nhựa mix kim loại')
Go

INSERT INTO MauSac
VALUES  (N'Đỏ'),
		(N'Trắng'),
		(N'Đen'),
		(N'Hồng')
Go

insert into HinhDang values 
(N'Vuông'), 
(N'Mắt mèo'), 
('oval'), 
('browline')
Go

insert into Anh values 
(N'image1.jpg'),
(N'image2.jpg'),
(N'image3.jpg')
Go

insert into SanPham (ma_san_pham, ten, mo_ta, danh_muc_id, thuong_hieu_id, phan_loai_id, chat_lieu_id) values 
('SP01', N'Kính báo hồng', '', 3, 2, 2, 2),
('SP02', N'Gọng kính cận', '', 1, 1, 1, 1),
('SP03', N'Tròng kính cận', '', 2, 1, 1, 1),
('SP04', N'Gọng kính râm', '', 1, 4, 1, 3),
('SP05', N'Kính râm thời trang', '', 3, 3, 2, 3)
Go


INSERT INTO [dbo].[SPCT]([gia],[so_luong],[trang_thai],[san_pham_id],[mau_sac_id],[hinh_dang_id],[anh_id])
VALUES (100, 10, 1, 1, 1, 1, 1),
		(200, 20, 1, 2, 3, 1, 1)
Go

INSERT INTO [dbo].[Taikhoan]([tai_khoan], [mat_khau], [ten], [dia_chi], [SDT], [email], [vai_tro])
     VALUES ('PH40152', '123456', N'Lê Đình Huy', null, null, null, 1)
Go
	 
INSERT INTO [dbo].[KhachHang]([ma_khach_hang] ,[ten] ,[SDT])
     VALUES ('KH01', N'Lê Đình Huy', '0987654321')
Go

	 INSERT INTO [dbo].[HoaDon]([ma_hoa_don], [ngay_tao], [tong_gia], [trang_thai], [tai_khoan_id] ,[khach_hang_id], [KMCT_id])
     VALUES (null, Default, 0, 2, 1, 1, null)
Go

	 INSERT INTO [dbo].[HDCT]([hoa_don_id] ,[SPCT_id] ,[so_luong] ,[gia])
     VALUES (2, 1, 2, 100)
Go

INSERT INTO [dbo].[KhuyenMai] ([ma_khuyen_mai] ,[ten]  ,[mo_ta] ,[ngay_tao] ,[tai_khoan_id])
     VALUES ('KH01', N'Khuyến mãi 20/11', N'Oke',  default, 1)

Go

INSERT INTO [dbo].[KMCT] ([ngay_bat_dau] ,[ngay_ket_thuc] ,[so_luong] ,[kieu_giam] , [trang_thai], [khuyen_mai_id])
     VALUES ( '2023-11-20', '2023-11-30', 20, 1, 1, 1)


SELECT dbo.KhuyenMai.ID, 
       dbo.KhuyenMai.ma_khuyen_mai, 
       dbo.KhuyenMai.ten, 
       dbo.KhuyenMai.mo_ta, 
       dbo.KhuyenMai.ngay_tao, 
       dbo.Taikhoan.ten AS Expr1
FROM dbo.KhuyenMai 
INNER JOIN dbo.Taikhoan ON dbo.KhuyenMai.tai_khoan_id = dbo.Taikhoan.ID
where 11 between Month(dbo.KhuyenMai.ngay_tao) and month(dbo.KhuyenMai.ngay_tao)
and 2023 Between year(dbo.KhuyenMai.ngay_tao) and year(dbo.KhuyenMai.ngay_tao)
