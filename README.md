# Sales Store Analysis by PostgreSQL
## Brief Summary
A comprehensive data analysis project using PostgreSQL to clean sales data, extract key business insights, and optimize sales and inventory strategies. 
## Overview
This project involves a detailed analysis of a retail store's sales database (sales_store). The goal is to transform raw transactional data into actionable business intelligence. The analysis covers sales trends, customer behavior, product performance, and logistical pain points (cancellations/returns) to provide data-driven recommendations for improving profitability and operational efficiency. 
## Problem Statement
The store management lacks a clear understanding of several critical business areas, leading to inefficient operations and missed revenue opportunities. The core problems addressed by this analysis include: 
1. **Product Performance:** Lack of clarity on which products sell the most and which are frequently cancelled or returned.
2.  **Customer Preferences:** Inadequate insight into customer demographics (age groups) and preferred payment methods.
3.  **Profit & Loss Areas:** Inability to identify which product categories generate the highest revenue and where operational issues are causing losses (high return/cancellation rates).
## Dataset
The analysis is based on a single table named sales_store (copied into a working table sale), which contains transactional data. Key columns include:

transaction_id, customer_id, product_id (Identifiers)

customer_name, customer_age, gender (Customer Demographics)

product_name, product_category (Product Details)

quantity, price (Sales Metrics)

payment_mode, purchase_date, time_of_purchase, status (Transaction Details) 
## Tools and Technology
**Database:** PostgreSQL (PSQL)
**Language:** SQL (for data cleaning, transformation, analysis, and querying)
**Environment:** pgAdmin
## Methodology
The project followed a standard data analysis pipeline:

1.**Data Import & Staging:** Bulk import of data from a .csv file into a raw table (sales_store), followed by creating a staging table (sale) for safe manipulation.

2.**Data Cleaning & Preprocessing:**
Identified and removed duplicate records using window functions (ROW_NUMBER()).

Corrected column headers (quantiy to quantity, prce to price).

Checked and treated NULL values by updating missing customer details.

Standardized categorical data (gender to 'M'/'F', payment_mode to full names like 'Credit Card').

3.**Data Analysis & Business Insight Generation:** Executed specific SQL queries to answer the business questions outlined in the problem statement, utilizing GROUP BY, CASE statements, aggregation functions, and formatting functions (TO_CHAR).
## Key Insights and Results
The analysis provided several critical insights:

1.**Top Performing Products:** Identified the top 5 most sold products when the status is 'delivered', enabling optimized stock management.

2.**Peak Purchase Times:** Determined that the 'Afternoon' (12 PM - 5 PM) is the busiest shopping period, allowing for better staff optimization and targeted promotions during these hours.

3.**High Cancellation & Return Rates:** Books had a very high cancellation rate( ~26%), suggesting long or inaccurate shipping estimates needed improvement.Accessories had the highest return rate (~31.5%), indicating    potential issues with product descriptions or quality perception.

3.**Preferred Payment Method:** 'Credit Card' was the most popular payment mode, highlighting an opportunity for exclusive cashback rewards or streamlining the CC processing pipeline
## Conclusion
By leveraging PostgreSQL for data cleaning and analysis, the project successfully transformed raw sales data into actionable business intelligence. The insights derived help the store move from reactive management to a proactive, data-driven strategy focusing on inventory optimization, targeted marketing campaigns for specific age groups, and crucial operational fixes in logistics for the Books and Accessories categories.
## Author and Contact
**Author:** MD Asim

**Email:** mdasim573@gmail.com

**LinkedIn:** https://www.linkedin.com/in/md-asim-56385017a





