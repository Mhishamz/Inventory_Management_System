
use master;
GO

create database InventoryManager;
GO

use InventoryManager;

	
-- Create Products Table
CREATE TABLE Products (
    Product_ID NVARCHAR(20) PRIMARY KEY,
    Product_Name VARCHAR(75) NOT NULL,
	Category VARCHAR(50) NOT NULL,
	Sub_Category VARCHAR(50) NOT NULL,
	Price DECIMAL(10, 2) NOT NULL,
	Size DECIMAL(10, 2) NOT NULL
);

-- Create Customers Table
CREATE TABLE Customers (
    Customer_ID NVARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(50) NOT NULL,
    Segment VARCHAR(50),
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password_hash VARCHAR(255) NOT NULL
);


-- Create Customer_Orders Table
CREATE TABLE Customer_Orders (
    Order_ID NVARCHAR(20) PRIMARY KEY,
    Customer_ID NVARCHAR(20),
    Order_Date DATETIME DEFAULT GETDATE(),
    Order_Status VARCHAR(25),
	Order_Priority VARCHAR(25),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

-- Create Customer_Order_Items Table
CREATE TABLE Customer_Order_Items (
    Order_ID NVARCHAR(20),
    Product_ID NVARCHAR(20),
    Quantity INT NOT NULL,
    Sales DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Customer_Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

CREATE TABLE INVENTORY (
    Product_ID NVARCHAR(20),
	Statee NVARCHAR(30),
    Quantity_In_Hand INT NOT NULL,
	Country NVARCHAR(30),
	City NVARCHAR(30),
	PRIMARY KEY (Statee, Product_ID),
	FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)

);
Go

ALTER TABLE Products ALTER COLUMN  Product_Name VARCHAR(150) NOT NULL;
Go


ALTER TABLE INVENTORY ALTER COLUMN  Country VARCHAR(75) NOT NULL;
ALTER TABLE INVENTORY ALTER COLUMN  City VARCHAR(75) NOT NULL;
ALTER TABLE INVENTORY ALTER COLUMN  Statee NVARCHAR(75) NOT NULL;

Go