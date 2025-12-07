-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales;
LIMIT 10


alter table retail_sales rename quantiy to quantity;
commit;
    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
-- How many sales we have

select count (*) as total_sale from retail_sales;

-- how many unique customers
select count (distinct customer_id) as totalsales from retail_sales;

-- how many unique categories
select count (distinct category) as categories from retail_sales;

--Data Analysis and Business Problems
--1. Write a query to retrieve all columns for sales on 2022-11-05

select * from retail_sales where sale_date ='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

select * from retail_sales 
where category='Clothing' and
to_char(sale_date,'yyyy-mm')='2022-11'
and quantity >2;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale) as net_sale,
count (*) as total_orders
from retail_sales group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select  round (avg(age)) as AVG_AGE
from retail_sales where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender, count (*) as total_trans
from retail_sales
group by category, gender
order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select round(avg(total_sale)),
to_char(sale_date,'YYYY-MM') as BEST_SELL_MONTH
from retail_sales
group by sale_date
order by BEST_SELL_MONTH ;


select year,month,avg_sale
from (
SELECT 
EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
ROUND (AVG(TOTAL_SALE)) AS AVG_SALE,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE)DESC) AS RANK
FROM RETAIL_SALES
GROUP BY 1,2
 ) AS T1
 WHERE RANK=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT CUSTOMER_ID,
	   SUM(TOTAL_SALE) AS TOTAL_SALES
FROM RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT COUNT (DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTS,
CATEGORY
FROM RETAIL_SALES
GROUP BY 2;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH HOURLY_SALES
AS (
SELECT *,
CASE 
WHEN EXTRACT (HOUR FROM SALE_TIME) <12 THEN 'MORNING'
WHEN EXTRACT (HOUR FROM SALE_TIME) BETWEEN 12 AND 17  THEN 'AFTERNOON'
ELSE 'EVENING'
END AS SHIFT
FROM RETAIL_SALES)
SELECT
SHIFT,
COUNT (*) AS TOTAL_ORDERS
FROM HOURLY_SALES
GROUP BY SHIFT;

-- END OF PROJECT




	