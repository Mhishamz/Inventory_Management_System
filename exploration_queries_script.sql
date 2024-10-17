-- QUERIES for exploration 

--Customer_Order_Items 
SELECT TOP (1000) [Order_ID]
      ,[Product_ID]
      ,[Quantity]
      ,[Sales]
  FROM [InventoryManager].[dbo].[Customer_Order_Items]

--
SELECT SUM(Quantity) 
FROM Customer_Order_Items
WHERE Product_ID='OFF-FEL-10001405';

--
SELECT MAX(Quantity) 
FROM Customer_Order_Items
WHERE Product_ID='OFF-FEL-10001405';


-- Query 1: Current Stock Levels
SELECT 
    i.Product_ID, 
    p.Product_Name, 
    i.State, 
    i.City, 
    i.Country, 
    i.Quantity_In_Hand
FROM 
    dbo.INVENTORY i
JOIN 
    dbo.Products p 
ON 
    i.Product_ID = p.Product_ID

WHERE i.Quantity_In_Hand > 700 

ORDER BY 
    i.Quantity_In_Hand DESC;

-- Query 2: Low-Stock Products (Trigger Reorder)
SELECT 
    i.Product_ID, 
    p.Product_Name, 
    i.Quantity_In_Hand, 
    i.State, 
    i.City, 
    i.Country
FROM 
    dbo.INVENTORY i
JOIN 
    dbo.Products p 
ON 
    i.Product_ID = p.Product_ID
WHERE 
    i.Quantity_In_Hand < 10
ORDER BY 
    i.Quantity_In_Hand ASC;

-- Query 3: Daily Sales Breakdown
SELECT 
    co.Order_Date, 
    SUM(coi.Sales) AS Total_Sales
FROM 
    dbo.Customer_Orders co
JOIN 
    dbo.Customer_Order_Items coi 
ON 
    co.Order_ID = coi.Order_ID
GROUP BY 
    co.Order_Date
ORDER BY 
    co.Order_Date ASC;

-- Query 4: Weekly Sales Breakdown
SELECT 
    DATEPART(week, co.Order_Date) AS WeekNumber, 
    DATEPART(year, co.Order_Date) AS Year, 
    SUM(coi.Sales) AS Weekly_Sales
FROM 
    dbo.Customer_Orders co
JOIN 
    dbo.Customer_Order_Items coi 
ON 
    co.Order_ID = coi.Order_ID
GROUP BY 
    DATEPART(week, co.Order_Date), 
    DATEPART(year, co.Order_Date)
ORDER BY 
    Year, WeekNumber ASC;

-- Query 5: Monthly Sales Breakdown
SELECT 
    DATEPART(month, co.Order_Date) AS Month, 
    DATEPART(year, co.Order_Date) AS Year, 
    SUM(coi.Sales) AS Monthly_Sales
FROM 
    dbo.Customer_Orders co
JOIN 
    dbo.Customer_Order_Items coi 
ON 
    co.Order_ID = coi.Order_ID
GROUP BY 
    DATEPART(month, co.Order_Date), 
    DATEPART(year, co.Order_Date)
ORDER BY 
    Year, Month ASC;

-- Query 6: Sales by Product and Category
SELECT 
    p.Product_Name, 
    p.Category, 
    p.Sub_Category, 
    SUM(coi.Sales) AS Total_Sales
FROM 
    dbo.Products p
JOIN 
    dbo.Customer_Order_Items coi 
ON 
    p.Product_ID = coi.Product_ID
GROUP BY 
    p.Product_Name, 
    p.Category, 
    p.Sub_Category
ORDER BY 
    Total_Sales DESC;

-- Query 7: Customer Orders Overview
SELECT 
    co.Order_ID, 
    co.Order_Date, 
    co.Order_Status, 
    co.Order_Priority, 
    SUM(coi.Sales) AS Total_Sales
FROM 
    dbo.Customer_Orders co
JOIN 
    dbo.Customer_Order_Items coi 
ON 
    co.Order_ID = coi.Order_ID
WHERE 
    co.Customer_ID = 'CUSTOMER_ID_HERE' -- Replace with actual customer ID
GROUP BY 
    co.Order_ID, 
    co.Order_Date, 
    co.Order_Status, 
    co.Order_Priority
ORDER BY 
    co.Order_Date DESC;

-- Query 8: Top Customers by Sales Volume
SELECT 
    c.Customer_Name, 
    SUM(coi.Sales) AS Total_Purchases
FROM 
    dbo.Customers c
JOIN 
    dbo.Customer_Orders co 
ON 
    c.Customer_ID = co.Customer_ID
JOIN 
    dbo.Customer_Order_Items coi 
ON 
    co.Order_ID = coi.Order_ID
GROUP BY 
    c.Customer_Name
ORDER BY 
    Total_Purchases DESC;

-- Query 9.1: Stored Procedure for Daily Stock Updates

CREATE PROCEDURE CheckLowStock
AS
BEGIN
    SELECT 
        p.Product_Name, 
        i.State, 
        i.City, 
        i.Country, 
        i.Quantity_In_Hand
    FROM 
        dbo.INVENTORY i
    JOIN 
        dbo.Products p 
    ON 
        i.Product_ID = p.Product_ID
    WHERE 
        i.Quantity_In_Hand < 10; -- Replace 10 with your preferred threshold
END;
GO

-- Query 9.2: execute Stored procedure
EXEC CheckLowStock;

-- OPTIONAL Query 10: Sales by Supplier (Assuming Supplier_ID exists in Products)
SELECT 
    p.Product_Name, 
    p.Category, 
    SUM(coi.Sales) AS Total_Sales
FROM 
    dbo.Products p
JOIN 
    dbo.Customer_Order_Items coi 
ON 
    p.Product_ID = coi.Product_ID
WHERE 
    p.Supplier_ID = 'SUPPLIER_ID_HERE' -- Replace with actual supplier ID
GROUP BY 
    p.Product_Name, 
    p.Category
ORDER BY 
    Total_Sales DESC;
