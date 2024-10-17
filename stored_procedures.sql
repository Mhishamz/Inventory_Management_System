-- Stored procedures

-- Stored Procedure 1: Low Stock Report
-- This procedure reports products that are below the defined reorder level.
USE InventoryManager;
GO

CREATE PROCEDURE GetLowStockReport
AS
BEGIN
    SELECT 
        p.Product_ID, 
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
        i.Quantity_In_Hand < 10 -- Threshold for low stock
    ORDER BY 
        i.Quantity_In_Hand ASC;
END;
GO



EXEC GetLowStockReport;

-- Stored Procedure 2: Daily Sales Report
-- This procedure summarizes the total sales for each day.
CREATE PROCEDURE GetDailySalesReport
AS
BEGIN
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
END;
GO

EXEC GetDailySalesReport;

-- Stored Procedure 3: Weekly Sales Report
-- This procedure provides a summary of sales on a weekly basis.
CREATE PROCEDURE GetWeeklySalesReport
AS
BEGIN
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
END;
GO

EXEC GetWeeklySalesReport;

-- Stored Procedure 4: Monthly Sales Report
-- This procedure generates a monthly sales report.
CREATE PROCEDURE GetMonthlySalesReport
AS
BEGIN
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
END;
GO

EXEC GetMonthlySalesReport;

-- Stored Procedure 5: Product Sales by Category
-- This procedure reports total sales for each product category.
CREATE PROCEDURE GetSalesByCategory
AS
BEGIN
    SELECT 
        p.Category, 
        SUM(coi.Sales) AS Total_Sales
    FROM 
        dbo.Products p
    JOIN 
        dbo.Customer_Order_Items coi 
    ON 
        p.Product_ID = coi.Product_ID
    GROUP BY 
        p.Category
    ORDER BY 
        Total_Sales DESC;
END;
GO

EXEC GetSalesByCategory;

-- Stored Procedure 6: Top Selling Products
-- This procedure generates a report of the top-selling products based on sales.
CREATE PROCEDURE GetTopSellingProducts
AS
BEGIN
    SELECT 
        p.Product_Name, 
        SUM(coi.Sales) AS Total_Sales
    FROM 
        dbo.Products p
    JOIN 
        dbo.Customer_Order_Items coi 
    ON 
        p.Product_ID = coi.Product_ID
    GROUP BY 
        p.Product_Name
    ORDER BY 
        Total_Sales DESC
    OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; -- Limit to top 10
END;
GO

EXEC GetTopSellingProducts;

-- Stored Procedure 7: Top Customers by Sales
-- This procedure reports the top customers by total purchase amount.
CREATE PROCEDURE GetTopCustomers
AS
BEGIN
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
        Total_Purchases DESC
    OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY; -- Limit to top 10
END;
GO

EXEC GetTopCustomers;

-- Stored Procedure 8: Customer Order History
-- This procedure returns the order history for a specific customer.
CREATE PROCEDURE GetCustomerOrderHistory
    @CustomerID NVARCHAR(255)
AS
BEGIN
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
        co.Customer_ID = @CustomerID
    GROUP BY 
        co.Order_ID, 
        co.Order_Date, 
        co.Order_Status, 
        co.Order_Priority
    ORDER BY 
        co.Order_Date DESC;
END;
GO

EXEC GetCustomerOrderHistory;

-- Stored Procedure 9: Inventory Status by Location
-- This procedure generates a report of inventory levels across different locations (state/city).
CREATE PROCEDURE GetInventoryByLocation
AS
BEGIN
    SELECT 
        i.State, 
        i.City, 
        i.Country, 
        p.Product_Name, 
        i.Quantity_In_Hand
    FROM 
        dbo.INVENTORY i
    JOIN 
        dbo.Products p 
    ON 
        i.Product_ID = p.Product_ID
    ORDER BY 
        i.State, i.City, p.Product_Name ASC;
END;
GO

EXEC GetInventoryByLocation;

-- Stored Procedure 10: Daily Stock Update Trigger
-- This procedure checks stock levels daily and can be used for automated stock reorder triggers.
CREATE PROCEDURE CheckAndUpdateStock
AS
BEGIN
    -- Fetch products with low stock
    DECLARE @LowStockProducts TABLE (
        Product_ID NVARCHAR(255),
        Product_Name NVARCHAR(255),
        Quantity_In_Hand INT
    );

    INSERT INTO @LowStockProducts
    SELECT 
        p.Product_ID, 
        p.Product_Name, 
        i.Quantity_In_Hand
    FROM 
        dbo.INVENTORY i
    JOIN 
        dbo.Products p 
    ON 
        i.Product_ID = p.Product_ID
    WHERE 
        i.Quantity_In_Hand < 10; -- Low stock threshold

    -- Output result or trigger reordering process here
    SELECT * FROM @LowStockProducts;
END;
GO

EXEC CheckAndUpdateStock;
