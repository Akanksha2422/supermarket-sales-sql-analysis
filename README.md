\# Supermarket Sales Analysis Using SQL



\## Project Overview



This project analyses supermarket sales transaction data using MySQL to identify sales trends, branch performance, product performance, customer behaviour, payment preferences, and sales patterns over time.



The objective of this project is to demonstrate how SQL can be used to clean, explore, analyse, and transform raw transactional data into meaningful business insights.



\---



\## Business Questions



The analysis focuses on the following questions:



1\. What is the overall sales performance?

2\. Which branch generates the highest revenue?

3\. Which product lines generate the most revenue?

4\. How do Member and Normal customers differ in their contribution to sales?

5\. Which payment methods are most frequently used?

6\. Which days generate the highest and lowest revenue?

7\. What time of day generates the most sales?

8\. How does revenue change from month to month?



\---



\## Dataset



The dataset contains 1,000 supermarket sales transactions.



Key fields used in the analysis include:



\- Branch

\- City

\- Customer Type

\- Product Line

\- Unit Price

\- Quantity

\- Total

\- Sale Date

\- Sale Time

\- Payment Method

\- Gross Income

\- Customer Rating



\---



\## Tools Used



\- MySQL

\- MySQL Workbench

\- Excel / CSV

\- GitHub



\---



\## SQL Skills Demonstrated



\- SELECT statements

\- WHERE clauses

\- GROUP BY

\- ORDER BY

\- HAVING

\- Aggregate functions (SUM, AVG, COUNT)

\- CASE statements

\- Date and time functions

\- STR\_TO\_DATE()

\- Subqueries

\- Common Table Expressions (CTEs)

\- Window functions

\- Data validation and cleaning



\---



\## Data Cleaning and Preparation



Before performing the analysis, the dataset was checked for data quality and consistency.



The following steps were performed:



\- Checked the total number of records.

\- Checked for duplicate invoice IDs.

\- Checked for missing values.

\- Reviewed unique values in categorical fields.

\- Converted and validated the sales date.

\- Investigated the sale time field and identified that it was stored as VARCHAR.

\- Converted 12-hour AM/PM time values using STR\_TO\_DATE() to ensure accurate time-of-day analysis.



\## Key Business Insights


1. Overall Sales Performance

The supermarket generated total revenue of 322,966.75 from 1,000 transactions.

2. Branch Performance

Giza was the highest-performing branch, generating 110,568.71 in revenue.

Alex and Cairo generated 106,200.37 and 106,197.67 respectively, showing very similar sales performance, while Giza maintained a modest revenue lead.

3. Product Performance

Food and Beverages was the highest-revenue product line at 56,144.84, followed by Sports and Travel at 55,122.83.

Health and Beauty generated the lowest revenue at 49,193.74, creating a revenue gap of 6,951.10 between the highest- and lowest-performing categories.

4. Customer Analysis

Member customers accounted for 565 of 1,000 transactions and generated 189,694.76, representing approximately 58.7% of total revenue.

Normal customers generated 133,271.99, indicating that members contributed a larger share of overall sales.

5. Payment Preferences

E-wallet was used for 345 transactions (34.5%), closely followed by cash with 344 transactions (34.4%) and credit card with 311 transactions (31.1%).

Payment usage was relatively evenly distributed, with no single payment method dominating customer transactions.

6. Sales by Day and Time

Saturday generated the highest revenue at 56,120.81, while Monday recorded the lowest revenue at 37,899.08.

Afternoon was the strongest time period, generating 148,023.34 from 454 transactions, representing approximately 45.8% of total revenue.

7. Monthly Sales Trend

January recorded the highest monthly revenue at 116,291.87 from 352 transactions.

March generated 109,455.51 from 345 transactions, while February recorded the lowest revenue at 97,219.37 from 303 transactions.



\## Example SQL Analysis


##Revenue by Branch

SELECT
    branch,
    ROUND(SUM(sales), 2) AS revenue
FROM supermarket_sales
GROUP BY branch
ORDER BY revenue DESC;

## Revenue by Product Line

SELECT
    product_line,
    ROUND(SUM(total), 2) AS revenue
FROM supermarket_sales
GROUP BY product_line
ORDER BY revenue DESC;

##Sales by Time of Day

SELECT
    CASE
        WHEN HOUR(STR_TO_DATE(sale_time, '%h:%i:%s %p')) < 12
            THEN 'Morning'
        WHEN HOUR(STR_TO_DATE(sale_time, '%h:%i:%s %p')) < 17
            THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_period,
    COUNT(*) AS transactions,
    ROUND(SUM(total), 2) AS revenue
FROM supermarket_sales
GROUP BY time_period
ORDER BY revenue DESC;

\## Conclusion

This project demonstrates how SQL can be used to analyse transactional retail data and convert raw sales records into meaningful business insights.

The analysis identified differences in branch and product performance, customer purchasing behaviour, payment preferences, and sales patterns across different days, times, and months.

The project also involved data validation and time-format correction to ensure that the analysis was based on correctly interpreted data.

\## Author

Akanksha Shukla

Data Analytics Portfolio Project
