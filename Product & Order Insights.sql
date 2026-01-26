-- Product & Order Insights
-- 1 What are the top 10 most sold products (by quantity)?
WITH ProductSales AS (
    SELECT
        P.ProductID,
        P.ProductName,
        SUM(OD.Quantity) AS TotalQuantitySold
    FROM OrderDetails OD
    JOIN Products P ON P.ProductID = OD.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName
)

SELECT
    ProductID,
    ProductName,
    TotalQuantitySold
FROM ProductSales
ORDER BY TotalQuantitySold DESC
LIMIT 10;


-- 2 What are the top 10 most sold products (by revenue)?
SELECT 
    P.ProductID,
    P.ProductName,
    SUM(OD.Quantity * P.Price) AS TotalRevenue
FROM OrderDetails OD
JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY 
    P.ProductID,
    P.ProductName
ORDER BY TotalRevenue DESC
LIMIT 10;


-- 3 Which products have the highest return rate?
-- Return Rate (%) =(Total Returned Quantity / Total Sold Quantity) × 100

WITH Sold AS (
    SELECT ProductID, SUM(Quantity) AS TotalSold
    FROM OrderDetails
    GROUP BY ProductID
),
Returned AS (
    SELECT ProductID, SUM(Quantity) AS TotalReturned
    FROM orderdetails OD 
    JOIN Orders O ON O.orderID = OD.OrderID
    WHERE IsReturned = 1
    GROUP BY ProductID
)

SELECT
    P.ProductID,
    P.ProductName,
    S.TotalSold,
    COALESCE(R.TotalReturned, 0) AS TotalReturned,
    (COALESCE(R.TotalReturned, 0) * 100.0 / S.TotalSold) AS ReturnRate
FROM Sold S
LEFT JOIN Returned R ON S.ProductID = R.ProductID
JOIN Products P ON P.ProductID = S.ProductID
ORDER BY ReturnRate DESC
LIMIT 10;


-- 4 Return Rate by Category
-- Return Rate (%) = (Total Returned Quantity / Total Sold Quantity) × 100
WITH Sold AS (
    SELECT 
        P.Category,
        SUM(OD.Quantity) AS TotalSold
    FROM OrderDetails OD
    JOIN Products P ON P.ProductID = OD.ProductID
    GROUP BY P.Category
),
Returned AS (
    SELECT 
        P.Category,
        SUM(OD.Quantity) AS TotalReturned
    FROM OrderDetails OD
    JOIN Products P ON P.ProductID = OD.ProductID
    JOIN Orders O ON O.OrderID = OD.OrderID
    WHERE IsReturned = 1
    GROUP BY P.Category
)

SELECT
    S.Category,
    S.TotalSold,
    COALESCE(R.TotalReturned, 0) AS TotalReturned,
    ROUND(
        (COALESCE(R.TotalReturned, 0) * 100.0 / S.TotalSold), 2
    ) AS ReturnRate
FROM Sold S
LEFT JOIN Returned R ON R.Category = S.Category
ORDER BY ReturnRate DESC
LIMIT 10;


-- 5 What is the average price of products per region?
SELECT
    R.RegionName,
    ROUND(SUM(OD.Quantity*P.Price)/SUM(OD.Quantity),2) AS AvgPrice
FROM Orders O
JOIN Customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
JOIN OrderDetails OD ON OD.OrderID = O.OrderID
JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY R.RegionName
ORDER BY AvgPrice DESC ;


-- 6 What is the sales trend for each product category?
   SELECT
    DATE_FORMAT(O.OrderDate, "%Y-%m") AS Period,
    Category,
    SUM(OD.Quantity * P.Price) AS MonthlyRevenue
FROM Orders O
JOIN OrderDetails OD ON OD.OrderID = O.OrderID
JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY
    Period,
    Category
ORDER BY
    Period,
    Category,
    MonthlyRevenue;
