-- Show tables;

-- select * FROM sales;

-- DESC sales;

-- Q1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * 
FROM sales
WHERE Amount > 2000 AND Boxes < 100;


-- Q2. How many shipments (sales) each of the sales persons had in the month of January 2022? 
SELECT Salesperson, COUNT(PID)
FROM sales JOIN people
ON sales.spid = people.spid
WHERE YEAR(saledate) = 2022 AND MONTH(saledate) = 1
GROUP BY Salesperson;

-- Q3. Which product sells more boxes? Milk Bars or Eclairs?

SELECT SUM(sales.Boxes), Product 
FROM sales JOIN products
ON sales.pid = products.pid
WHERE product IN ('Milk Bars', 'Eclairs')
GROUP BY product;

-- Q4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

SELECT SUM(sales.boxes) AS BoxesSold, products.Product
FROM sales
JOIN products ON sales.pid = products.pid
WHERE products.Product IN ('Milk Bars', 'Eclairs') AND (sales.saledate BETWEEN '2022-02-01' AND '2022-02-07')
GROUP BY products.Product;

-- Q5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
SELECT *
FROM sales
WHERE Customers < 100 and Boxes <100 AND dayname(saledate) = 'Wednesday';

/*  



*/ 

-- Q1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
SELECT salesperson, COUNT(PID), sales.saledate 
FROM people JOIN sales
ON people.SPID = sales.SPID
WHERE sales.saledate BETWEEN '2022-01-01' AND '2022-01-07'
GROUP BY salesperson, sales.SaleDate;

-- Q2. Which salespersons did not make any shipments in the first 7 days of January 2022?
SELECT *
FROM people JOIN sales
ON people.SPID = sales.SPID
WHERE Amount = 0 AND sales.saledate BETWEEN '2022-01-01' AND '2022-01-07';

-- Q3. How many times we shipped more than 1,000 boxes in each month?

SELECT COUNT(PID), MONTH(saledate) AS Month, YEAR(saledate) AS Year
FROM sales
WHERE Boxes > 1000
GROUP BY MONTH(saledate), YEAR(saledate);

-- Q4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?

SELECT Product, Geo, MONTH(saleDate) AS Month, YEAR(saleDate) AS Year, SUM(Boxes) 
FROM sales 
JOIN products ON sales.PID = products.PID
JOIN geo ON sales.GeoID = Geo.GeoID
WHERE Product = 'After Nines' AND Geo = 'New Zealand' AND Boxes > 1
GROUP BY Product, Geo, MONTH(saleDate), YEAR(saleDate)
ORDER BY YEAR(saleDate), MONTH(saleDate);

-- Q5. India or Australia? Who buys more chocolate boxes on a monthly basis?

SELECT SUM(Boxes) AS Total_Boxes, GEO AS Country, MONTH(saledate) AS Month, Year(saledate) AS Year
FROM sales 
JOIN products ON sales.PID = products.PID
JOIN geo ON sales.GeoID = Geo.GeoID
WHERE Geo IN ('India', 'Australia')
GROUP BY GEO, YEAR(saledate), MONTH(saledate)

UNION

SELECT SUM(Boxes) AS Total_Boxes, Geo As country, MONTH(saledate) AS Month, Year(saledate) AS Year
FROM sales 
JOIN products ON sales.PID = products.PID
JOIN geo ON sales.GeoID = Geo.GeoID
WHERE Geo = 'Australia' 
GROUP BY YEAR(saledate), MONTH(saledate)
ORDER BY Country DESC, Year, MONTH;

-- Comparing chocolate boxes side by side for Indian and Australia

SELECT
  YEAR(s.saledate) AS Year,
  MONTH(s.saledate) AS Month,
  SUM(CASE WHEN g.geo = 'India' THEN s.Boxes ELSE 0 END) AS 'India Boxes',
  SUM(CASE WHEN g.geo = 'Australia' THEN s.boxes ELSE 0 END) AS 'Australia Boxes',
  (SUM(CASE WHEN g.geo = 'India' THEN s.Boxes ELSE 0 END) - SUM(CASE WHEN g.geo = 'Australia' THEN s.boxes ELSE 0 END)) AS Difference
  
FROM
  sales s
JOIN
  geo g ON g.GeoID = s.GeoID
GROUP BY
  YEAR(s.saledate), MONTH(s.saledate)
ORDER BY
  YEAR(s.saledate), MONTH(s.saledate);





