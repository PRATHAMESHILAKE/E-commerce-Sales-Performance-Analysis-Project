-- General Sales Insights

-- 1. What is the total revenue generated over the entire period? ( REVENUE = QUANTITY * PRICE )
SELECT SUM(OD.Quantity * P.Price) AS Total_Revenue 
FROM orderdetails OD
JOIN products P
ON P.ProductID = OD.ProductID ;


-- 2. Revenue Excluding Returned Orders
SELECT SUM(OD.Quantity * P.Price) AS Revenue_Excluding_Return 
FROM ORDERS O
JOIN orderdetails OD  ON OD.OrderID = O.OrderID 
-- FOR PRICE 
JOIN Products P       ON P.ProductID = OD.ProductID 
WHERE O.Isreturned = False ;
 

-- 3.Total Revenue per Year / Month

SELECT  
    YEAR(O.OrderDate)  AS OrderYear,
    MONTH(O.OrderDate) AS OrderMonth,
    SUM(OD.Quantity * P.Price) AS Monthly_Revenue
FROM Orders O
JOIN OrderDetails OD ON OD.OrderID = O.OrderID 
JOIN Products P     ON P.ProductID = OD.ProductID 
GROUP BY 
    YEAR(O.OrderDate),
    MONTH(O.OrderDate)
ORDER BY 
    OrderYear,
    OrderMonth;


-- 4. Revenue by Product / Category
SELECT ProductName ,Category ,  SUM(OD.Quantity * P.Price) AS Product_Revenue 
FROM OrderDetails OD
JOIN Products P ON P.ProductID = OD.ProductID 
GROUP BY ProductName,Category
ORDER BY Category,Product_Revenue DESC;

-- 5. What is the average order value (AOV) across all orders? [AOV = Total Revenue / Number of Orders]
SELECT AVG (TotalOrderValue) AS AverageOrderValue
FROM (SELECT   
      O.OrderID ,SUM(OD.Quantity * P.Price) AS TotalOrderValue
	
FROM Orders O
JOIN orderdetails OD  ON OD.OrderID = O.OrderID 
JOIN Products P       ON P.ProductID = OD.ProductID 
GROUP BY O.OrderID) T;

-- 6. AOV per Year / Month

SELECT 
    YEAR(OrderDate)  AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    AVG(TotalOrderValue) AS AverageOrderValue
FROM (
    SELECT  
        O.OrderID,
        O.OrderDate,
        SUM(OD.Quantity * P.Price) AS TotalOrderValue
    FROM Orders O
    JOIN OrderDetails OD ON OD.OrderID = O.OrderID
    JOIN Products P     ON P.ProductID = OD.ProductID
    GROUP BY O.OrderID, O.OrderDate
) T
GROUP BY 
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY 
    OrderYear,
    OrderMonth;





-- 7. What is the average order size by region?
SELECT 
R.RegionName,
    AVG(OrderSizes.total_order_size) AS average_order_size
FROM (
SELECT 
        O.OrderID,
        C.RegionID,
        SUM(OD.Quantity) AS total_order_size
    FROM Orders O
    JOIN Customers C ON C.CustomerID = O.CustomerID
    JOIN OrderDetails OD ON OD.OrderID = O.OrderID
    GROUP BY O.OrderID, C.RegionID
) AS OrderSizes
JOIN Regions R ON R.RegionID = OrderSizes.RegionID
GROUP BY R.RegionName
ORDER BY average_order_size desc;







