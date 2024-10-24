use InventoryManager
Go

create view  DimCustomer
AS
	SELECT
		Customer_ID,
		Customer_Name,
		Segment, Email,
		Password_hash
	FROM
		dbo.Customers;
Go

create view  DimProductsInventory
AS
	SELECT
		dbo.INVENTORY.Product_ID,
		dbo.Products.Product_Name,
		dbo.Products.Category,
		dbo.Products.Sub_Category,
		dbo.Products.Price,
		dbo.Products.Size,
		dbo.INVENTORY.Quantity_In_Hand,
		dbo.INVENTORY.Statee, 
		dbo.INVENTORY.Country,
		dbo.INVENTORY.City
	FROM
		dbo.INVENTORY INNER JOIN dbo.Products
	ON 
		dbo.INVENTORY.Product_ID = dbo.Products.Product_ID;
Go

create view  DimDate
AS
	SELECT DISTINCT
		CONVERT(INT, FORMAT(dbo.Customer_Orders.Order_Date, 'yyyyMMdd')) AS DateKay,
		CAST(dbo.Customer_Orders.Order_Date AS Date) AS FullDate,
		DAY(dbo.Customer_Orders.Order_Date) AS TheDay,
		MONTH(dbo.Customer_Orders.Order_Date) AS TheMonth,
		DATENAME(MONTH, dbo.Customer_Orders.Order_Date) AS TheMonthName,
		DATEPART(MONTH, dbo.Customer_Orders.Order_Date) AS TheQuarter,
		YEAR(dbo.Customer_Orders.Order_Date) AS TheYear,
		DATENAME(WEEKDAY, dbo.Customer_Orders.Order_Date) AS TheDayName
	FROM
		dbo.Customer_Orders;
Go

create view  FactOrders
AS
	SELECT
		dbo.Customer_Orders.Order_ID,
		dbo.Customer_Orders.Customer_ID,
		dbo.Customer_Order_Items.Product_ID,
		CONVERT(INT, FORMAT(dbo.Customer_Orders.Order_Date, 'yyyymmdd')) AS DateKay,
		dbo.Customer_Orders.Order_Status,
		dbo.Customer_Orders.Order_Priority, 
		dbo.Customer_Order_Items.Sales,
		dbo.Customer_Order_Items.Quantity
	FROM
		dbo.Customer_Order_Items INNER JOIN dbo.Customer_Orders
	ON
		dbo.Customer_Order_Items.Order_ID = dbo.Customer_Orders.Order_ID;




