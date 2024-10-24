Create Database Inventory_DW
GO
Use Inventory_DW
GO

CREATE TABLE [dbo].[DimCustomer] (
	Customer_SurrogateKey INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID nvarchar(20),
    Customer_Name varchar(50) NOT NULL,
    Segment varchar(50),
	Email varchar(255) NOT NULL,
	Password_hash varchar(255) NOT NULL
);
GO

CREATE TABLE [dbo].[DimProductsInventory] (
	Product_SurrogateKey INT IDENTITY(1,1) PRIMARY KEY,
    Product_ID nvarchar(20),
    Product_Name varchar(150) NOT NULL,
	Category varchar(50) NOT NULL,
	Sub_Category varchar(50) NOT NULL,
	Price decimal(10, 2) NOT NULL,
	Size decimal(10, 2) NOT NULL,
	Quantity_In_Hand int NOT NULL,
	Statee nvarchar(75) NOT NULL,
	Country varchar(75) NOT NULL,
	City varchar(75) NOT NULL
);
GO

CREATE TABLE [dbo].[DimDate] (
	DateKay int PRIMARY KEY,
    FullDate date,
    TheDay int,
	TheMonth int,
	TheMonthName varchar(20),
	TheQuarter int,
	TheYear int,
	TheDayName varchar(20)
);
GO

CREATE TABLE [dbo].[FactOrders] (
	Order_SurrogateKey INT IDENTITY(1,1) PRIMARY KEY,
    Order_ID nvarchar(20),
    Customer_ID nvarchar(20),
	Product_ID nvarchar(20),
	DateKay int,
	Order_Status varchar(25),
	Order_Priority varchar(25),
	Sales decimal(10, 2) NOT NULL,
	Quantity int NOT NULL
);