-- ============================================================
-- File: QuanLyBanHang.sql
-- Sinh viên: .....................
-- Lớp: .....................
-- ============================================================

IF DB_ID('QuanLyBanHang') IS NOT NULL
    DROP DATABASE QuanLyBanHang;
GO

CREATE DATABASE QuanLyBanHang;
GO

USE QuanLyBanHang;
GO

-- Bảng Customer
CREATE TABLE Customer (
    cID        INT           NOT NULL,
    cName      NVARCHAR(100) NOT NULL,
    cAddress   NVARCHAR(200) NULL,
    cPhone     VARCHAR(20)   NULL,
    cEmail     VARCHAR(100)  NULL,
    CONSTRAINT PK_Customer PRIMARY KEY (cID)
);
GO

-- Bảng Product
CREATE TABLE Product (
    pID           INT           NOT NULL,
    pName         NVARCHAR(150) NOT NULL,
    pPrice        DECIMAL(10,2) NOT NULL,
    pDescription  NVARCHAR(500) NULL,
    CONSTRAINT PK_Product PRIMARY KEY (pID),
    CONSTRAINT CHK_Product_Price CHECK (pPrice > 0)
);
GO

-- Bảng Order
CREATE TABLE [Order] (
    oID    INT  NOT NULL,
    cID    INT  NOT NULL,
    oDate  DATE NOT NULL,
    CONSTRAINT PK_Order PRIMARY KEY (oID),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (cID)
        REFERENCES Customer(cID)
);
GO

-- Bảng Orderdetail
CREATE TABLE Orderdetail (
    oID       INT NOT NULL,
    pID       INT NOT NULL,
    quantity  INT NOT NULL,
    CONSTRAINT PK_Orderdetail PRIMARY KEY (oID, pID),
    CONSTRAINT FK_Orderdetail_Order FOREIGN KEY (oID)
        REFERENCES [Order](oID),
    CONSTRAINT FK_Orderdetail_Product FOREIGN KEY (pID)
        REFERENCES Product(pID),
    CONSTRAINT CHK_Orderdetail_Quantity CHECK (quantity > 0)
);
GO

-- Dữ liệu mẫu
INSERT INTO Customer (cID, cName, cAddress, cPhone, cEmail) VALUES
(1, N'Nguyễn Văn A', N'123 Lê Lợi, Q.1', '0901234567', 'a.nguyen@example.com'),
(2, N'Trần Thị B',   N'456 Nguyễn Huệ, Q.3', '0912345678', 'b.tran@example.com'),
(3, N'Lê Văn C',     N'789 Hai Bà Trưng, Q.1', NULL, NULL);
GO

INSERT INTO Product (pID, pName, pPrice, pDescription) VALUES
(101, N'Bút bi',        5000,  N'Bút bi xanh'),
(102, N'Vở 200 trang',  25000, N'Vở học sinh'),
(103, N'Thước kẻ',      10000, N'Thước nhựa 20cm');
GO

INSERT INTO [Order] (oID, cID, oDate) VALUES
(1001, 1, '2024-01-15'),
(1002, 2, '2024-01-16');
GO

INSERT INTO Orderdetail (oID, pID, quantity) VALUES
(1001, 101, 5),
(1001, 102, 2),
(1002, 101, 3),
(1002, 103, 1);
GO