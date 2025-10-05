--- SQL Retails Data Analysis Project - P1
CREATE DATABASE SQL_Project_P1;

--- CREATE TABLE
DROP TABLE IF EXISTS retail_sales_db;
CREATE TABLE retail_sales_db 
      (
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender	VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantiy	INT,
		price_per_unit	FLOAT,
		cogs FLOAT,
		total_sale FLOAT,
      );
	  
	SELECT * FROM retail_sales_db2;


	--- DATA CLEANING
	SELECT
		 COUNT(*) 
	FROM retail_sales_db2 

    --- LET SEE THE NULL
		SELECT * FROM retail_sales_db2
		WHERE 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;

--- LET DELETE THE MISSING ROWS
DELETE FROM retail_sales_db2
	WHERE 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;

--- DATA EXPLORATION (EDA)
--- how many sales we have?
SELECT COUNT(*) as total_Sales FROM retail_sales_db2

--- how many UNIQUE customers we have ?
SELECT COUNT(DISTINCT customer_id) as unique_customers FROM retail_sales_db2

--- how many UNIQUE category we have ?

SELECT COUNT(DISTINCT category) as unique_category FROM retail_sales_db2
SELECT DISTINCT category FROM retail_sales_db2

--- DATA ANALYSIS AND BUSINES KEY PROBLEMS AND ANSWERS

--- Q1:Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales_db2
WHERE sale_date = '2022-11-05';

--- Q2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT *
FROM retail_sales_db2
WHERE category = 'Clothing'
    AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND quantiy >= 4

--- Q3: Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category as Category,
    SUM(total_sale) as Total_Sales,
	COUNT(*) as Total_Orders
FROM retail_sales_db2
GROUP BY category;

--- Q4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
	ROUND(AVG(age), 2) as Avg_Age_Customers
	FROM retail_sales_db2
	WHERE category = 'Beauty';

--- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000.:
 
 SELECT *
	FROM retail_sales_db2
	WHERE total_sale > 1000

--- Q6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT
	category,
	gender,
	COUNT(*) as Total_Transaction
FROM retail_sales_db2
GROUP 
	BY
	category,
	gender
ORDER BY category

--- Q7 : Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT
  Year,
  Month,
  Average_Sales
FROM (
  SELECT 
    YEAR(sale_date) as Year,
    MONTH(sale_date) as Month,
    ROUND(AVG(total_sale), 2) as Average_Sales,
    RANK() OVER (
      PARTITION BY YEAR(sale_date) 
      ORDER BY ROUND(AVG(total_sale), 2) DESC
    ) as Rank
  FROM retail_sales_db2
  GROUP BY YEAR(sale_date), MONTH(sale_date)
) as table1
WHERE Rank = 1;


--- Q8: Write a SQL query to find the top 5 customers based on the highest total sales :

SELECT TOP 5
  customer_id,
  SUM(total_sale) as Total_Sales
FROM retail_sales_db2
GROUP BY customer_id
ORDER BY Total_Sales DESC;


--- Q9 : Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT
  category,
  COUNT(DISTINCT customer_id) as Count_Unique_Customers
FROM retail_sales_db2
GROUP BY category;


--- Q10: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sales AS (
  SELECT *,
     CASE
       WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
       WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
       ELSE 'Evening'
     END as Shift
  FROM retail_sales_db2
)
SELECT
  Shift,
  COUNT(*) as Total_Orders
FROM hourly_sales
GROUP BY Shift;

--- END PROJECT