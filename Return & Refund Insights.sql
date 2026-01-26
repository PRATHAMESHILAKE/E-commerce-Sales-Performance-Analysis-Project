-- Return & Refund Insights
-- 1 What is the overall return rate by product category?

SELECT 
    Category,
    ROUND(
        SUM(CASE WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) * 1.0
        / COUNT(*),
        2
    ) AS ReturnRate
FROM Orders O
LEFT JOIN OrderDetails OD ON OD.OrderID = O.OrderID
LEFT JOIN ProductS P ON P.ProductID = OD.ProductID
GROUP BY Category
ORDER BY ReturnRate DESC;

-- 2 What is the overall return rate by region?
SELECT 
    RegionName,
    ROUND(
        SUM(CASE WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) * 1.0
        / COUNT(O.OrderID),
        2
    ) AS ReturnRate
FROM Orders O
JOIN Customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
GROUP BY RegionName 
ORDER BY ReturnRate DESC;


-- 3 Which customers are making frequent returns?
SELECT 
    C.CustomerID,
    C.CustomerName,
    COUNT(*) AS TotalReturns
FROM Orders O
JOIN Customers C ON C.CustomerID = O.CustomerID
WHERE O.IsReturned = 1
GROUP BY C.CustomerID, C.CustomerName
HAVING COUNT(*) > 1
ORDER BY TotalReturns DESC;
