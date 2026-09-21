/*==============================================================
PROJECT: SUPERMARKET SALES ANALYSIS
================================================================

OBJECTIVE: 
Analyze Supermarket Sales data to understand sales performance,
customer behivour, product performance, revenue trends. 

Tools: 
My SQL Workbench

Dataset:
Supermarket Sales Dataset

Author:
Akanksha Shukla
==================================================================*/

/*================================================================
1. DATABASE SETUP
==================================================================*/

CREATE DATABASE supermarket_sales_db;
USE supermarket_sales_db;
SELECT DATABASE();

/*==========================================================
2. TABLE CREATION
==========================================================*/

CREATE TABLE supermarket_sales (
invoice_id VARCHAR(20),
branch VARCHAR(10),
city VARCHAR(50),
customer_type VARCHAR(20),
gender VARCHAR(10),
product_line VARCHAR(100),
unit_price DECIMAL(10,2),
quantity INT,
tax_5 DECIMAL(10,4),
sales DECIMAL(10,4),
sale_date VARCHAR(20),
sale_time VARCHAR(20),
payment VARCHAR(20),
cogs DECIMAL(10,2),
gross_margin_percentage DECIMAL(15,6),
gross_income DECIMAL(10,4),
rating DECIMAL(10,3)
);
/*=========================================================
3. DATA VALIDATION
=========================================================*/

-- Check total number of records
DESCRIBE supermarket_sales;
SELECT COUNT(*) total_rows
FROM supermarket_sales;

-- Preview the dataset
SELECT *
FROM supermarket_sales
LIMIT 10;

/*========================================================
4. DATA CLEANING 
========================================================*/

-- Check number of rows
SELECT COUNT(*) AS total_rows
FROM supermarket_sales;

-- Check for Dublicate Invoice IDs 
SELECT invoice_id, COUNT(*)
FROM supermarket_sales
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- Check for missing values
SELECT *
FROM supermarket_sales
WHERE invoice_id IS NULL;
SELECT 
SUM(invoice_id IS NULL) AS invoice_missing,
SUM(branch IS NULL) AS branch_missing,
SUM(city IS NULL) AS city_missing,
SUM(product_line IS NULL) AS product_missing,
SUM(unit_price IS NULL) AS price_missing,
SUM(quantity IS NULL) AS quantity_missing,
SUM(sales IS NULL) AS sales_missing,
SUM(payment IS NULL) AS payment_missing,
SUM(rating IS NULL) AS rating_missing
FROM supermarket_sales;

-- Review Categorial Values 
SELECT DISTINCT branch
FROM supermarket_sales;

SELECT DISTINCT city
FROM supermarket_sales;

SELECT DISTINCT product_line
FROM supermarket_sales;

SELECT DISTINCT payment
FROM supermarket_sales;

/*=====================================================
5. DATE CLEANING
=====================================================*/

SELECT
sale_date,
STR_TO_DATE(sale_date, '%m/%d/%y') AS converted_date
FROM supermarket_sales
LIMIT 10;
-- Convert sale_date from text to MySQL DATE format
ALTER TABLE supermarket_sales
ADD COLUMN new_sale_date DATE;

UPDATE supermarket_sales
SET new_sale_date = STR_TO_DATE(sale_date, '%m/%d/%y');

-- Varify conversion before removing original column
SELECT 
    sale_date,
    LENGTH(sale_date) AS date_length,
    HEX(sale_date) AS date_hex
FROM supermarket_sales
LIMIT 10;

SELECT sale_date
FROM supermarket_sales
WHERE STR_TO_DATE(TRIM(sale_date), '%m/%d/%Y') IS NULL;
UPDATE supermarket_sales
SET new_sale_date = STR_TO_DATE(TRIM(sale_date), '%m/%d/%Y');
SELECT sale_date, new_sale_date
FROM supermarket_sales
LIMIT 10;
SELECT COUNT(*) AS converted_rows
FROM supermarket_sales
WHERE new_sale_date IS NOT NULL;

-- Replace old text date column
ALTER TABLE supermarket_sales
DROP COLUMN sale_date;

ALTER TABLE supermarket_sales
CHANGE COLUMN new_sale_date sale_date DATE;

DESCRIBE supermarket_sales;

/*============================================================
6. Exploratory data analysis
============================================================*/

-- Q1: WHAT IS THE TOTAL REVENUE?
SELECT
ROUND(SUM(sales), 2) AS total_revenue
FROM supermarket_sales;

-- Q2: WHAT IS TOTAL GROSS INCOME?
SELECT
ROUND(SUM(gross_income), 2) AS total_gross_income
FROM supermarket_sales;

-- Q3: WHAT IS THE AVERAGE TRANSACTION VALUE?
SELECT
ROUND(AVG(sales), 2) AS total_transaction_value
FROM supermarket_sales;

-- Q4: HOW MANY TRANSACTION OCCURED?
SELECT
COUNT(*) AS total_transaction
FROM supermarket_sales;

/*==========================================================
7. BRANCH ANALYSIS
==========================================================*/

-- Q5: WHICH BRANCH GENRATED THE HIGHEST VALUE?
SELECT
branch,
ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY branch
ORDER BY revenue DESC;

-- Q6: REVENUE BY CITY?
SELECT
city,
ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY city
ORDER BY revenue DESC;

/*==========================================================
8. PRODUCT ANALYSIS
==========================================================*/
-- Q7: WHICH PRODUCT LINE GENRATED THE MOST REVENUE?
SELECT
product_line,
ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY product_line
ORDER BY revenue DESC;

-- Q8: WHICH PRODUCT CATEGORY SOLD THE HIGHEST QUANTITY?
SELECT 
product_line,
ROUND(SUM(quantity), 2) AS quantity_sold
FROM supermarket_sales
GROUP BY product_line
ORDER BY quantity_sold; 

/*=======================================================
9. CUSTOMER ANALYSIS
======================================================*/

-- Q9: MEMBER Vs NORMAL CUSTOMERS
SELECT 
customer_type,
COUNT(*) AS transaction,
ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Q10: AVERAGE SPENDING BY CUSTOMER TYPE?
SELECT
customer_type,
ROUND(AVG(sales), 2) AS average_spending
FROM supermarket_sales
GROUP BY customer_type;

/*=============================================================
10. PAYMENT ANALYSIS
=============================================================*/

-- Q11: MOST FREQUENTLY USED PAYMENT METHODE?
SELECT
payment,
COUNT(*) AS transactions
FROM supermarket_sales
GROUP BY payment
ORDER BY transactions DESC;

-- Q12: REVENUE BY PAYMENT METHOD?
SELECT
payment,
ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY payment
ORDER BY revenue DESC;

/*=========================================================
11. RATING ANALYSIS
=========================================================*/

-- Q13: AVERAGE CUSTOMER RATING
SELECT
ROUND(AVG(rating), 2) AS average_rating
FROM supermarket_sales;

-- Q14: AVERAGE RATING BY PRODUCT CATEGORY?
SELECT 
product_line,
ROUND(AVG(rating), 2) AS average_rating
FROM supermarket_sales
GROUP BY product_line
ORDER BY average_rating DESC; 

/*==========================================================
12. DATE ANALYSIS
==========================================================*/

-- MONTHLY REVENUE
SELECT
MONTH(sale_date) AS month_number,
MONTHNAME(sale_date) AS month_name,
ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY MONTH(sale_date), MONTHNAME(sale_date)
ORDER BY month_number;

/*=========================================================
13. DAY-OF-WEEK ANALYSIS
=========================================================*/
-- 1: WHICH DAY GENRATE HIGHEST SALES?
SELECT
DAYNAME(sale_date) AS day_name,
ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY DAYNAME(sale_date)
ORDER BY revenue DESC;

/*=========================================================
14. TIME OF DAY ANALYSIS
=========================================================*/
SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_period,
    COUNT(*) AS transactions,
    ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY time_period
ORDER BY revenue DESC;

/*=============================================================
14. FIND THE TOP 5 HIGHEST VALUE TRANSACTIONS
=============================================================*/
SELECT
    invoice_id,
    branch,
    city,
    product_line,
    quantity,
    sales
FROM supermarket_sales
ORDER BY sales DESC
LIMIT 5;

/*=============================================================
15. Find product categories earning above-average revenue.
=============================================================*/
WITH product_revenue AS (
    SELECT
        product_line,
        SUM(sales) AS revenue
    FROM supermarket_sales
    GROUP BY product_line
)

SELECT
    product_line,
    ROUND(revenue, 2) AS revenue
FROM product_revenue
WHERE revenue > (
    SELECT AVG(revenue)
    FROM product_revenue
)
ORDER BY revenue DESC;

/*============================================================
16. Add RANKING
============================================================*/

-- RANK PRODUCT CATEGORIES
SELECT
    product_line,
    ROUND(SUM(sales), 2) AS revenue,
    RANK() OVER (
        ORDER BY SUM(sales) DESC
    ) AS revenue_rank
FROM supermarket_sales
GROUP BY product_line;
