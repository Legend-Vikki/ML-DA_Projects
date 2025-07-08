-- Create database and use it
CREATE DATABASE IF NOT EXISTS car24;
USE car24;

-- Assuming table 'cars' already exists and is populated.

-- Sample structure assumed:
-- Manufacturer, Varient, Details, IndiaLocations, Model, DistanceTravelled,
-- FuelType, EngineCapacity, Transmission, Price

-- ===============================
-- 1. List all distinct manufacturers
SELECT DISTINCT Manufacturer FROM cars;

-- 2. Count of cars per manufacturer
SELECT Manufacturer, COUNT(*) AS Total_Cars
FROM cars
GROUP BY Manufacturer
ORDER BY Total_Cars DESC;

-- 3. Average price of cars by manufacturer
SELECT Manufacturer, AVG(Price) AS Avg_Price
FROM cars
GROUP BY Manufacturer
ORDER BY Avg_Price DESC;

-- 4. Top 5 most expensive cars
SELECT * FROM cars
ORDER BY Price DESC
LIMIT 5;

-- 5. Cars with more than 500,000 km travelled
SELECT * FROM cars
WHERE DistanceTravelled > 500000;

-- 6. Average engine capacity by transmission type
SELECT Transmission, AVG(EngineCapacity) AS Avg_Engine
FROM cars
GROUP BY Transmission;

-- 7. Number of cars by fuel type
SELECT FuelType, COUNT(*) AS Count
FROM cars
GROUP BY FuelType;

-- 8. Most common variant per manufacturer
SELECT Manufacturer, Varient, COUNT(*) AS Count
FROM cars
GROUP BY Manufacturer, Varient
ORDER BY Manufacturer, Count DESC;

-- 9. Cars made after the year 2015
SELECT * FROM cars
WHERE Model > 2015;

-- 10. Add and update Engine Size Category
ALTER TABLE cars
ADD COLUMN IF NOT EXISTS Engine_Size_Category TEXT;

SET SQL_SAFE_UPDATES = 0;

UPDATE cars
SET Engine_Size_Category = CASE
    WHEN EngineCapacity <= 1000 THEN 'Small'
    WHEN EngineCapacity > 1000 AND EngineCapacity <= 1600 THEN 'Medium'
    WHEN EngineCapacity > 1600 THEN 'Large'
    ELSE 'Unknown'
END;

SET SQL_SAFE_UPDATES = 1;

-- 11. Average price by engine size category
SELECT Engine_Size_Category, AVG(Price) AS Avg_Price
FROM cars
GROUP BY Engine_Size_Category;

-- 12. Count of cars per city
SELECT IndiaLocations, COUNT(*) AS Total
FROM cars
GROUP BY IndiaLocations
ORDER BY Total DESC;

-- 13. Compare average price between automatic and manual cars
SELECT Transmission, AVG(Price) AS Avg_Price
FROM cars
GROUP BY Transmission;

-- 14. Get car with the minimum engine capacity > 0
SELECT * FROM cars
WHERE EngineCapacity > 0
ORDER BY EngineCapacity ASC
LIMIT 1;

-- 15. Manufacturers with average price > 2 million INR
SELECT Manufacturer, AVG(Price) AS Avg_Price
FROM cars
GROUP BY Manufacturer
HAVING AVG(Price) > 2000000;

-- 16. Total distance travelled per fuel type
SELECT FuelType, SUM(DistanceTravelled) AS Total_Distance
FROM cars
GROUP BY FuelType;

-- 17. Cars priced between 1M and 3M INR
SELECT * FROM cars
WHERE Price BETWEEN 1000000 AND 3000000;

-- 18. Oldest car in the dataset
SELECT * FROM cars
ORDER BY Model ASC
LIMIT 1;

-- 19. Top 3 cities with highest average car price
SELECT IndiaLocations, AVG(Price) AS Avg_Price
FROM cars
GROUP BY IndiaLocations
ORDER BY Avg_Price DESC
LIMIT 3;

-- 20. Manufacturer and variant with the highest priced car
SELECT Manufacturer, Varient, Price
FROM cars
ORDER BY Price DESC
LIMIT 1;

-- ===============================
-- ADDITIONAL ANALYSIS
-- ===============================

-- 21. Year-wise car count to identify trends
SELECT Model, COUNT(*) AS Car_Count
FROM cars
GROUP BY Model
ORDER BY Model ASC;

-- 22. Most popular transmission per manufacturer
SELECT Manufacturer, Transmission, COUNT(*) AS Count
FROM cars
GROUP BY Manufacturer, Transmission
ORDER BY Manufacturer, Count DESC;

-- 23. Fuel type distribution per transmission type
SELECT Transmission, FuelType, COUNT(*) AS Count
FROM cars
GROUP BY Transmission, FuelType
ORDER BY Transmission, Count DESC;

-- 24. Top 3 most driven cars
SELECT * FROM cars
ORDER BY DistanceTravelled DESC
LIMIT 3;

-- 25. Most fuel-efficient (smallest engine > 0)
SELECT * FROM cars
WHERE EngineCapacity > 0
ORDER BY EngineCapacity ASC, Price ASC
LIMIT 1;

-- 26. Median car price (approximate)
WITH OrderedPrices AS (
    SELECT Price,
           ROW_NUMBER() OVER (ORDER BY Price) AS RowNum,
           COUNT(*) OVER () AS TotalRows
    FROM cars
)
SELECT AVG(Price) AS Median_Price
FROM OrderedPrices
WHERE RowNum IN (FLOOR((TotalRows + 1)/2), CEIL((TotalRows + 1)/2));

-- 27. Duplicate entries (by manufacturer, variant, model)
SELECT Manufacturer, Varient, Model, COUNT(*) AS Duplicate_Count
FROM cars
GROUP BY Manufacturer, Varient, Model
HAVING COUNT(*) > 1;

-- 28. Engine size distribution by fuel type
SELECT FuelType, Engine_Size_Category, COUNT(*) AS Count
FROM cars
GROUP BY FuelType, Engine_Size_Category
ORDER BY FuelType, Count DESC;

-- 29. Cars priced below their brand's average price
SELECT *
FROM cars c
JOIN (
    SELECT Manufacturer, AVG(Price) AS Avg_Manufacturer_Price
    FROM cars
    GROUP BY Manufacturer
) avg_price ON c.Manufacturer = avg_price.Manufacturer
WHERE c.Price < avg_price.Avg_Manufacturer_Price;

-- 30. Highest priced car per engine size category
SELECT Engine_Size_Category, Manufacturer, Varient, MAX(Price) AS Max_Price
FROM cars
GROUP BY Engine_Size_Category, Manufacturer, Varient;
