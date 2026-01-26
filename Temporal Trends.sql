--   Temporal Trends
-- What are the monthly sales trends over the past year?
SELECT YEAR(OrderDate) AS `Year`,
       MONTH(OrderDate) AS `Month`,
       SUM(OD.Quantity * P.Price) AS Revenue
FROM Orders O
JOIN OrderDetails OD ON OD.OrderId = O.OrderId
JOIN Products P ON P.ProductId = OD.ProductId
WHERE OrderDate >= CURRENT_DATE() - INTERVAL 12 MONTH
GROUP BY `Year`, `Month`
ORDER BY `Year`, `Month`;


-- How does the average order value (AOV) change by month or week?
-- AOV by Month
SELECT
    DATE_FORMAT(O.OrderDate, '%Y-%m') AS Period,
    SUM(OD.Quantity * P.Price) / COUNT(DISTINCT O.OrderID) AS AOV
FROM Orders O
JOIN OrderDetails OD ON OD.OrderID = O.OrderID
JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY Period
ORDER BY Period;


-- AOV by Week
SELECT
    YEAR(O.OrderDate) AS Year,
    WEEK(O.OrderDate, 1) AS WeekNumber,   -- 1 = week starts Monday
    SUM(OD.Quantity * P.Price) / COUNT(DISTINCT O.OrderID) AS AOV
FROM Orders O
JOIN OrderDetails OD ON OD.OrderID = O.OrderID
JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY Year, WeekNumber
ORDER BY Year, WeekNumber;

