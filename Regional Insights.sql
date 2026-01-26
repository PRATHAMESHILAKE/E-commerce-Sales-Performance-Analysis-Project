
-- Regional Insights

-- 1 Which regions have the highest order volume and which have the lowest?
-- Highest Order Volume (Top 1)
SELECT
    R.RegionName,
    COUNT(DISTINCT O.OrderID) AS OrderVolume
FROM Orders O
JOIN Customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
GROUP BY R.RegionName
ORDER BY OrderVolume DESC
;
-- Lowest Order Volume (Bottom 1)
SELECT
    R.RegionName,
    COUNT(DISTINCT O.OrderID) AS OrderVolume
FROM Orders O
JOIN Customers C ON C.CustomerID = O.CustomerID
JOIN Regions R ON R.RegionID = C.RegionID
GROUP BY R.RegionName
ORDER BY OrderVolume ASC;

-- 2 What is the revenue per region and how does it compare across different regions?

WITH T1 AS (
    SELECT
        R.RegionName,
        COUNT(DISTINCT O.OrderID) AS OrderVolume
    FROM Orders O
    JOIN Customers C ON C.CustomerID = O.CustomerID
    JOIN Regions R ON R.RegionID = C.RegionID
    GROUP BY R.RegionName
),
T2 AS (
    SELECT
        R.RegionName,
        SUM(OD.Quantity * P.Price) AS TotalRevenue
    FROM Orders O
    JOIN Customers C ON C.CustomerID = O.CustomerID
    JOIN Regions R ON R.RegionID = C.RegionID
    JOIN OrderDetails OD ON OD.OrderID = O.OrderID
    JOIN Products P ON P.ProductID = OD.ProductID
    GROUP BY R.RegionName
)
SELECT
    T1.RegionName,
    T1.OrderVolume,
    T2.TotalRevenue
FROM T1
JOIN T2 ON T2.RegionName = T1.RegionName
ORDER BY T2.TotalRevenue DESC;



