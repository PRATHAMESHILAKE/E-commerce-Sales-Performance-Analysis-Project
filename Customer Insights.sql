-- Customer Insights

-- 1 Who are the top 10 customers by total revenue spent?
SELECT 
    C.CustomerID,
    C.CustomerName,
    SUM(OD.Quantity * P.Price) AS Total_Revenue
FROM Customers C
JOIN Orders O        ON O.CustomerID = C.CustomerID
JOIN OrderDetails OD ON OD.OrderID = O.OrderID
JOIN Products P      ON P.ProductID = OD.ProductID
GROUP BY 
    C.CustomerID,
    C.CustomerName
ORDER BY 
    Total_Revenue DESC
LIMIT 10;


-- 2 What is the repeat customer rate? ( Repeat Customer Rate = (Number of customers with 2+ orders ÷ Total number of customers) × 100)

SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN order_count > 1 THEN CustomerID END) 
         * 100.0
        / COUNT(DISTINCT CustomerID),
        2
    ) AS Repeat_Customer_Rate
FROM (
    SELECT 
        CustomerID,
        COUNT(OrderID) AS order_count
    FROM Orders
    GROUP BY CustomerID
) customer_orders;


-- 3 What is the average time between two consecutive orders for the same customer Region-wise?

SELECT 
    R.RegionName,
    AVG(DATEDIFF(CO.OrderDate, CO.prev_order_date)) AS Avg_Days_Between_Orders
FROM (
    SELECT 
        O.CustomerID,
        O.OrderDate,
        C.RegionID,
        LAG(O.OrderDate) OVER (
            PARTITION BY O.CustomerID 
            ORDER BY O.OrderDate
        ) AS prev_order_date
    FROM Orders O
    JOIN Customers C ON C.CustomerID = O.CustomerID
) CO
JOIN Regions R ON R.RegionID = CO.RegionID
WHERE CO.prev_order_date IS NOT NULL
GROUP BY R.RegionName
ORDER BY Avg_Days_Between_Orders;



-- 4 Customer Segment (based on total spend)
--  Platinum: Total Spend > 1500
-- Gold: 1000–1500
-- Silver: 500–999
-- Bronze: < 500

SELECT 
    C.CustomerID,
    C.CustomerName,
    TotalSpend,
    CASE
        WHEN TotalSpend > 1500 THEN 'Platinum'
        WHEN TotalSpend BETWEEN 1000 AND 1500 THEN 'Gold'
        WHEN TotalSpend BETWEEN 500 AND 999 THEN 'Silver'
        ELSE 'Bronze'
    END AS CustomerSegment
FROM (
    SELECT 
        O.CustomerID,
        SUM(OD.Quantity * P.Price) AS TotalSpend
    FROM Orders O
    JOIN OrderDetails OD ON OD.OrderID = O.OrderID
    JOIN Products P ON P.ProductID = OD.ProductID
    GROUP BY O.CustomerID
) AS CustomerSpend
JOIN Customers C ON C.CustomerID = CustomerSpend.CustomerID
ORDER BY TotalSpend DESC;


-- 5 What is the customer lifetime value (CLV)?
SELECT 
    C.CustomerID,
    C.CustomerName,
    SUM(OD.Quantity * P.Price) AS CLV
FROM Customers C
JOIN Orders O ON O.CustomerID = C.CustomerID
JOIN OrderDetails OD ON OD.OrderID = O.OrderID

JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY 
    C.CustomerID,
    C.CustomerName
ORDER BY CLV DESC;
