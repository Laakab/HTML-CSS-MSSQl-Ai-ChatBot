CREATE DATABASE CLOTHS_ECOMMERCE_SITE11
USE CLOTHS_ECOMMERCE_SITE11



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

ALTER TABLE SIGN_UP ADD ProfilePicture VARCHAR(MAX);
-- Update the SIGN_UP table to better identify admins
alter table SIGN_UP
add Msgdattime DATETIME DEFAULT GETDATE()
INSERT INTO SIGN_UP (SIGN_UP_Name, SIGN_UP_Email, SIGN_UP_Password, SIGN_UP_DOB, SIGN_UP_Gender, SIGN_UP_administration, SIGN_UP_AGE)
        VALUES ('Usama', 'su92-bscsm-f23-500@superior.edu.pk', '500', '2000-01-01', 'male', 'Admin', '20')
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
CategoryName VARCHAR(60) UNIQUE
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
productDescription VARCHAR(MAX),
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



