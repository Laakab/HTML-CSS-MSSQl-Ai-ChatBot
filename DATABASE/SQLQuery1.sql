CREATE DATABASE CLOTHS_ECOMMERCE_SITE1
USE CLOTHS_ECOMMERCE_SITE1



CREATE TABLE SIGN_UP(
SUserID INT PRIMARY KEY IDENTITY(1,1),
SIGN_UP_Name VARCHAR(60),
SIGN_UP_Email VARCHAR(255) UNIQUE NOT NULL,
CONSTRAINT CHK11_Email CHECK (SIGN_UP_Email LIKE '%_@_%._%'),
SIGN_UP_Password VARCHAR(20) UNIQUE NOT NULL,
SIGN_UP_DOB varchar(60) NOT NULL,
SIGN_UP_Gender VARCHAR(60),
SIGN_UP_administration VARCHAR(60) not null,
SIGN_UP_AGE INT,
OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP
)
ALTER TABLE SIGN_UP drop COLUMN ProfilePicture ;
ALTER TABLE SIGN_UP ADD ProfilePicture VARCHAR(MAX);
-- Update the SIGN_UP table to better identify admins
alter table SIGN_UP
add Msgdattime DATETIME DEFAULT GETDATE()
INSERT INTO SIGN_UP (SIGN_UP_Name, SIGN_UP_Email, SIGN_UP_Password, SIGN_UP_DOB, SIGN_UP_Gender, SIGN_UP_administration, SIGN_UP_AGE)
        VALUES ('Usama', 'su92-bscsm-f23-500@superior.edu.pk', '500', '2000-01-01', 'male', 'Admin', '25')
SELECT*FROM SIGN_UP



CREATE TABLE LOG_IN(
UserID INT PRIMARY KEY IDENTITY(1,1),
LOG_IN_Email VARCHAR(255)  NOT NULL,
CONSTRAINT CHK_Email CHECK (LOG_IN_Email LIKE '%_@_%._%'),
LOG_IN_Password VARCHAR(20)  NOT NULL,
LOG_IN_captchaAnswer INT,
OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP
)

TRUNCATE TABLE LOG_IN;
SELECT*FROM LOG_IN



create table Categories(
categoryid int identity(1,1) primary key ,
CategoryName VARCHAR(60)
)
TRUNCATE TABLE Categories;
select*from Categories



create table Products(
productid int identity(1,1) primary key,
ProductName VARCHAR(60),
CategoryName VARCHAR(60),
productImage VARCHAR(MAX),
productColor VARCHAR(60),
productQuantity VARCHAR(60),
productDescription VARCHAR(60),
productSize VARCHAR(60)
)
alter table Products
add Price int 
alter table Products
add  delvery_price int not null
alter table Products
add  Returnday VARCHAR(265) not null

alter table Products
add  productDiscount int not null
TRUNCATE TABLE Products;
select*from Products

-- Messages table
CREATE TABLE Messages (
    MessageID INT PRIMARY KEY IDENTITY(1,1),
    SenderID INT NOT NULL,
    RecipientID INT NOT NULL,
    MessageText TEXT NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0,
    FOREIGN KEY (SenderID) REFERENCES SIGN_UP(SUserID),
    FOREIGN KEY (RecipientID) REFERENCES SIGN_UP(SUserID)
)
GO
select*from Messages
-- Indexes for better performance
CREATE INDEX idx_messages_sender ON Messages(SenderID)
CREATE INDEX idx_messages_recipient ON Messages(RecipientID)
CREATE INDEX idx_messages_unread ON Messages(RecipientID, IsRead) WHERE IsRead = 0



-- Add Cart table without UserID
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    SessionID VARCHAR(255) NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT DEFAULT 1,
    FOREIGN KEY (ProductID) REFERENCES Products(productid)
)
TRUNCATE TABLE Cart;
select*from Cart
-- Add Orders table without UserID
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    SessionID VARCHAR(255) ,
    CustomerName VARCHAR(100) ,
    CustomerEmail VARCHAR(255) ,
    CustomerPhone VARCHAR(20) ,
    Country VARCHAR(100) ,
    Province VARCHAR(100) ,
    City VARCHAR(100) ,
    District VARCHAR(100) ,
	Zipcode VARCHAR(100) ,
    Address1 VARCHAR(100) ,
    PaymentMethod VARCHAR(50) ,
    Subtotal DECIMAL(10,2) ,
    Delivery DECIMAL(10,2) ,
    Total DECIMAL(10,2) ,
    Status1 VARCHAR(20) DEFAULT 'Pending',
    OrderDate DATETIME DEFAULT GETDATE()
)

select*from Orders

CREATE TABLE PaymentDetails (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    AccountNumber VARCHAR(100),
    TransactionID VARCHAR(100),
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    PaymentDate DATETIME DEFAULT GETDATE(),
    AdditionalInfo TEXT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

DROP TABLE Orders;
-- Or with IF EXISTS
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderItems;


CREATE TABLE Feedback (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    subject NVARCHAR(200) NOT NULL,
    message NVARCHAR(MAX) NOT NULL,
    rating INT NOT NULL,
    date DATETIME NOT NULL
);

select*from Feedback
TRUNCATE TABLE Feedback;
-- Add this to your existing SQL file
CREATE TABLE Ads (
    id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    phone NVARCHAR(20),
    email NVARCHAR(100),
    companyName NVARCHAR(100),
    link NVARCHAR(255),
    image NVARCHAR(MAX),  -- For storing base64 encoded images
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME DEFAULT GETDATE()
);


select*from Ads
TRUNCATE TABLE Ads;
CREATE TABLE Offers (
    id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    product_id INT,
    description NVARCHAR(MAX),
    discount INT NOT NULL,
    image NVARCHAR(MAX),  -- For storing base64 encoded images
    start_date DATETIME,
    end_date DATETIME,
    status NVARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (product_id) REFERENCES Products(productid)
);
select*from Feedback
-- Create backup tables for each existing table

-- Backup table for SIGN_UP
CREATE TABLE SIGN_UP_BACKUP (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(10) NOT NULL, -- 'UPDATE' or 'DELETE'
    BackupTimestamp DATETIME DEFAULT GETDATE(),
    SUserID INT,
    SIGN_UP_Name VARCHAR(60),
    SIGN_UP_Email VARCHAR(255),
    SIGN_UP_Password VARCHAR(20),
    SIGN_UP_DOB varchar(60),
    SIGN_UP_Gender VARCHAR(60),
    SIGN_UP_administration VARCHAR(60),
    SIGN_UP_AGE INT,
    OrderDate DATETIME,
    ProfilePicture VARCHAR(MAX),
    Msgdattime DATETIME
);

-- Backup table for LOG_IN
CREATE TABLE LOG_IN_BACKUP (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(10) NOT NULL,
    BackupTimestamp DATETIME DEFAULT GETDATE(),
    UserID INT,
    LOG_IN_Email VARCHAR(255),
    LOG_IN_Password VARCHAR(20),
    LOG_IN_captchaAnswer INT,
    OrderDate DATETIME
);

-- Backup table for Categories
CREATE TABLE Categories_BACKUP (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(10) NOT NULL,
    BackupTimestamp DATETIME DEFAULT GETDATE(),
    categoryid INT,
    CategoryName VARCHAR(60)
);

-- Backup table for Products
CREATE TABLE Products_BACKUP (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(10) NOT NULL,
    BackupTimestamp DATETIME DEFAULT GETDATE(),
    productid INT,
    ProductName VARCHAR(60),
    CategoryName VARCHAR(60),
    productImage VARCHAR(MAX),
    productColor VARCHAR(60),
    productQuantity VARCHAR(60),
    productDescription VARCHAR(60),
    productSize VARCHAR(60),
    Price INT,
    delvery_price INT,
    Returnday VARCHAR(265),
    productDiscount INT
);

-- Backup table for Messages
CREATE TABLE Messages_BACKUP (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(10) NOT NULL,
    BackupTimestamp DATETIME DEFAULT GETDATE(),
    MessageID INT,
    SenderID INT,
    RecipientID INT,
    MessageText TEXT,
    Timestamp DATETIME,
    IsRead BIT
);


-- Backup table for PaymentDetails
CREATE TABLE PaymentDetails_BACKUP (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(10) NOT NULL,
    BackupTimestamp DATETIME DEFAULT GETDATE(),
    PaymentID INT,
    OrderID INT,
    PaymentMethod VARCHAR(50),
    AccountNumber VARCHAR(100),
    TransactionID VARCHAR(100),
    PaymentAmount DECIMAL(10,2),
    PaymentStatus VARCHAR(20),
    PaymentDate DATETIME,
    AdditionalInfo TEXT
);

-- Backup table for Feedback
CREATE TABLE Feedback_BACKUP (
    BackupID INT PRIMARY KEY IDENTITY(1,1),
    BackupType VARCHAR(10) NOT NULL,
    BackupTimestamp DATETIME DEFAULT GETDATE(),
    id INT,
    name NVARCHAR(100),
    email NVARCHAR(100),
    subject NVARCHAR(200),
    message NVARCHAR(MAX),
    rating INT,
    date DATETIME
);



-- Create triggers for each table

-- Triggers for SIGN_UP
CREATE TRIGGER tr_SIGN_UP_UPDATE
ON SIGN_UP
AFTER UPDATE
AS
BEGIN
    INSERT INTO SIGN_UP_BACKUP (
        BackupType, SUserID, SIGN_UP_Name, SIGN_UP_Email, SIGN_UP_Password, 
        SIGN_UP_DOB, SIGN_UP_Gender, SIGN_UP_administration, SIGN_UP_AGE, 
        OrderDate, ProfilePicture, Msgdattime
    )
    SELECT 
        'UPDATE', 
        d.SUserID, d.SIGN_UP_Name, d.SIGN_UP_Email, d.SIGN_UP_Password, 
        d.SIGN_UP_DOB, d.SIGN_UP_Gender, d.SIGN_UP_administration, d.SIGN_UP_AGE, 
        d.OrderDate, d.ProfilePicture, d.Msgdattime
    FROM deleted d;
END;
GO

CREATE TRIGGER tr_SIGN_UP_DELETE
ON SIGN_UP
AFTER DELETE
AS
BEGIN
    INSERT INTO SIGN_UP_BACKUP (
        BackupType, SUserID, SIGN_UP_Name, SIGN_UP_Email, SIGN_UP_Password, 
        SIGN_UP_DOB, SIGN_UP_Gender, SIGN_UP_administration, SIGN_UP_AGE, 
        OrderDate, ProfilePicture, Msgdattime
    )
    SELECT 
        'DELETE', 
        d.SUserID, d.SIGN_UP_Name, d.SIGN_UP_Email, d.SIGN_UP_Password, 
        d.SIGN_UP_DOB, d.SIGN_UP_Gender, d.SIGN_UP_administration, d.SIGN_UP_AGE, 
        d.OrderDate, d.ProfilePicture, d.Msgdattime
    FROM deleted d;
END;
GO

-- Triggers for LOG_IN
CREATE TRIGGER tr_LOG_IN_UPDATE
ON LOG_IN
AFTER UPDATE
AS
BEGIN
    INSERT INTO LOG_IN_BACKUP (
        BackupType, UserID, LOG_IN_Email, LOG_IN_Password, 
        LOG_IN_captchaAnswer, OrderDate
    )
    SELECT 
        'UPDATE', 
        d.UserID, d.LOG_IN_Email, d.LOG_IN_Password, 
        d.LOG_IN_captchaAnswer, d.OrderDate
    FROM deleted d;
END;
GO

CREATE TRIGGER tr_LOG_IN_DELETE
ON LOG_IN
AFTER DELETE
AS
BEGIN
    INSERT INTO LOG_IN_BACKUP (
        BackupType, UserID, LOG_IN_Email, LOG_IN_Password, 
        LOG_IN_captchaAnswer, OrderDate
    )
    SELECT 
        'DELETE', 
        d.UserID, d.LOG_IN_Email, d.LOG_IN_Password, 
        d.LOG_IN_captchaAnswer, d.OrderDate
    FROM deleted d;
END;
GO

-- Triggers for Categories
CREATE TRIGGER tr_Categories_UPDATE
ON Categories
AFTER UPDATE
AS
BEGIN
    INSERT INTO Categories_BACKUP (
        BackupType, categoryid, CategoryName
    )
    SELECT 'UPDATE', d.categoryid, d.CategoryName
    FROM deleted d;
END;
GO

CREATE TRIGGER tr_Categories_DELETE
ON Categories
AFTER DELETE
AS
BEGIN
    INSERT INTO Categories_BACKUP (
        BackupType, categoryid, CategoryName
    )
    SELECT 'DELETE', d.categoryid, d.CategoryName
    FROM deleted d;
END;
GO

-- Triggers for Products
CREATE TRIGGER tr_Products_UPDATE
ON Products
AFTER UPDATE
AS
BEGIN
    INSERT INTO Products_BACKUP (
        BackupType, productid, ProductName, CategoryName, productImage, 
        productColor, productQuantity, productDescription, productSize, 
        Price, delvery_price, Returnday, productDiscount
    )
    SELECT 
        'UPDATE', 
        d.productid, d.ProductName, d.CategoryName, d.productImage, 
        d.productColor, d.productQuantity, d.productDescription, d.productSize, 
        d.Price, d.delvery_price, d.Returnday, d.productDiscount
    FROM deleted d;
END;
GO

CREATE TRIGGER tr_Products_DELETE
ON Products
AFTER DELETE
AS
BEGIN
    INSERT INTO Products_BACKUP (
        BackupType, productid, ProductName, CategoryName, productImage, 
        productColor, productQuantity, productDescription, productSize, 
        Price, delvery_price, Returnday, productDiscount
    )
    SELECT 
        'DELETE', 
        d.productid, d.ProductName, d.CategoryName, d.productImage, 
        d.productColor, d.productQuantity, d.productDescription, d.productSize, 
        d.Price, d.delvery_price, d.Returnday, d.productDiscount
    FROM deleted d;
END;
GO

-- Triggers for Messages
CREATE TRIGGER tr_Messages_UPDATE
ON Messages
AFTER UPDATE
AS
BEGIN
    INSERT INTO Messages_BACKUP (
        BackupType, MessageID, SenderID, RecipientID, MessageText, 
        Timestamp, IsRead
    )
    SELECT 
        'UPDATE', 
        d.MessageID, d.SenderID, d.RecipientID, d.MessageText, 
        d.Timestamp, d.IsRead
    FROM deleted d;
END;
GO

CREATE TRIGGER tr_Messages_DELETE
ON Messages
AFTER DELETE
AS
BEGIN
    INSERT INTO Messages_BACKUP (
        BackupType, MessageID, SenderID, RecipientID, MessageText, 
        Timestamp, IsRead
    )
    SELECT 
        'DELETE', 
        d.MessageID, d.SenderID, d.RecipientID, d.MessageText, 
        d.Timestamp, d.IsRead
    FROM deleted d;
END;
GO

