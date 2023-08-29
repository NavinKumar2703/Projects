--SQL Advance Case Study


--Q1--BEGIN 
SELECT distinct l.State
FROM FACT_TRANSACTIONS as f
join
DIM_DATE as d
on d.DATE=f.Date
join
DIM_LOCATION as l
on f.IDLocation = l.IDLocation
WHERE d.YEAR >= 2005 





--Q1--END

--Q2--BEGIN
SELECT Top 1 State, COUNT(*) as num_samsung_phones
FROM DIM_MANUFACTURER AS M
JOIN 
DIM_MODEL as dmodel
ON dmodel.IDManufacturer = M.IDManufacturer
join
FACT_TRANSACTIONS as f
on f.IDModel = dmodel.IDModel
join
DIM_LOCATION AS L
ON L.IDLocation = f.IDLocation
WHERE Manufacturer_Name = 'SAMSUNG' and L.Country = 'US'
GROUP BY State 
order by num_samsung_phones DESC

--Q2--END

--Q3--BEGIN      
SELECT state, ZipCode,IDModel ,COUNT(*) as total_transactions
FROM DIM_LOCATION AS L
JOIN 
FACT_TRANSACTIONS AS F
ON F.IDLocation = L.IDLocation
GROUP BY State, ZipCode, IDModel
ORDER BY total_transactions DESC


--Q3--END

--Q4--BEGIN
SELECT top(1) m.IDModel, m.IDManufacturer, manu.Manufacturer_Name  , Unit_price
FROM FACT_TRANSACTIONS as f
join
DIM_MODEL as m
on m.IDModel = f.IDModel
join 
DIM_MANUFACTURER as manu
on manu.IDManufacturer = m.IDManufacturer
ORDER BY Unit_price ASC




--Q4--END

--Q5--BEGIN
SELECT top 5
    m.IDModel, d.Manufacturer_Name, m.Model_Name,
    AVG(TotalPrice/Quantity) AS avg_price
FROM 
FACT_TRANSACTIONS as f
join
DIM_MODEL as m
on m.IDModel = f.IDModel
join
DIM_MANUFACTURER as d
on m.IDManufacturer = d.IDManufacturer
WHERE Manufacturer_Name IN (
    SELECT top 5 Manufacturer_Name
    FROM 
	FACT_TRANSACTIONS as f
join
DIM_MODEL as m
on m.IDModel = f.IDModel
join
DIM_MANUFACTURER as d
on m.IDManufacturer = d.IDManufacturer
    GROUP BY d.Manufacturer_Name
    ORDER BY SUM(Quantity) DESC
    
)
GROUP BY m.IDModel, d.Manufacturer_Name, m.Model_Name
ORDER BY avg_price DESC;


--Q5--END

--Q6--BEGIN
SELECT Customer_Name, AVG(TotalPrice) as avg_amount
FROM FACT_TRANSACTIONS AS f
join 
DIM_CUSTOMER as c
on c.IDCustomer = f.IDCustomer
WHERE f.Date >= '2009'
GROUP BY Customer_Name
HAVING AVG(TotalPrice) > 500

--Q6--END
	
--Q7--BEGIN 
SELECT TOP 5 IDModel, COUNT(Quantity) as Quantity
FROM 
FACT_TRANSACTIONS as f
join DIM_DATE as dt
on dt.DATE=f.Date
WHERE YEAR IN (2008, 2009, 2010)
GROUP BY IDModel
HAVING COUNT(DISTINCT YEAR) = 3
ORDER BY IDModel DESC
;

--Q7--END	
--Q8--BEGIN
SELECT Year, Manufacturer_Name, TotalPrice
FROM (
    SELECT Year, Manufacturer_Name, TotalPrice, 
           ROW_NUMBER() OVER (PARTITION BY Year ORDER BY TotalPrice DESC) AS Rank
    FROM FACT_TRANSACTIONS as f
join
DIM_MODEL as d
on f.IDModel =d.IDModel
join
DIM_MANUFACTURER as m
on m.IDManufacturer =d.IDManufacturer
join DIM_DATE as dt
on dt.DATE=f.Date
    WHERE YEAR IN (2009, 2010)
) AS SalesRank
WHERE Rank = 2;





--Q8--END
--Q9--BEGIN
	SELECT DISTINCT m.Manufacturer_Name
FROM FACT_TRANSACTIONS as f
join 
DIM_MODEL as d
on d.IDModel = f.IDModel
join 
DIM_MANUFACTURER as m
on m.IDManufacturer = d.IDManufacturer
WHERE f.Date = '2010' AND m.Manufacturer_Name NOT IN (
    SELECT DISTINCT m.Manufacturer_Name
    FROM FACT_TRANSACTIONS as f
join 
DIM_MODEL as d
on d.IDModel = f.IDModel
join 
DIM_MANUFACTURER as m
on m.IDManufacturer = d.IDManufacturer
    WHERE f.Date = '2009'
)

--Q9--END

--Q10--BEGIN
	 
SELECT top 100
f.IDCustomer, c.Customer_Name, YEAR(d.date) AS year, AVG(f.TotalPrice) AS avg_spend, 
AVG(f.Quantity) AS avg_quantity, (MAX(f.TotalPrice) - MIN(f.TotalPrice)) / MIN(f.TotalPrice) * 100 AS AVGspend
FROM 
FACT_TRANSACTIONS as f
join
DIM_CUSTOMER as c
on c.IDCustomer = f.IDCustomer
join 
DIM_DATE as d
on d.DATE = f.Date
GROUP BY f.IDCustomer, YEAR(d.DATE), c.Customer_Name
ORDER BY AVGspend DESC;

--Q10--END
	