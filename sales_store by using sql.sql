                       --CREATING TABLE TO STORE DATA

CREATE TABLE sales_store(
transaction_id varchar(15),
customer_id varchar(15),
customer_name varchar(30),
customer_age int,
gender varchar(15),
product_id varchar(15),
product_name varchar(15),
product_category varchar(15),
quantiy int,
prce float,
payment_mode varchar(15),
purchase_date date,
time_of_purchase time,
status varchar(15)
);

                        --BULK INSERT METHOD FOR DATA IMPORT
SET DATESTYLE TO 'ISO, DMY';
COPY sales_store FROM 'C:\Users\islam\Desktop\project sql\sales_store.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM sales_store

                        --CREATING COPYING OF DATASET
--first thing we want  to do is create a staging table.this is the one we will work in and clean the data
--we want a table with raw data in case something happens.

SELECT * INTO sale FROM sales_store;

SELECT * FROM sale;
                        --DATA CLEANING
--step 1:- to check for duplicate (1st method)
SELECT transaction_id,COUNT(*)
	  FROM sale
	  GROUP BY transaction_id
	  HAVING COUNT(*)>1

  'TXN855235'
  'TXN240646'
  'TXN342128'
  'TXN981773'
                   --2nd method by using window function
 WITH duplicate_data AS
	(SELECT *,
	ROW_NUMBER()OVER(PARTITION BY transaction_id ORDER BY transaction_id ) AS rnk
	FROM sale)
SELECT * FROM duplicate_data
WHERE rnk>1;
                    --AFTER CONFORMING BY BOTH METHOD NOW STEP TO DELETE THAT RECORD
DELETE FROM sale
WHERE ctid IN (
    WITH duplicate_data AS (
        SELECT 
            ctid,
            ROW_NUMBER() OVER(
                PARTITION BY transaction_id 
                ORDER BY ctid
            ) AS rnk
        FROM sale
    )
    SELECT ctid
    FROM duplicate_data
    WHERE rnk > 1
);

                          --DATA CLEANING STEP 2:-CORRECTION OF HEADERS
ALTER TABLE sale
RENAME COLUMN quantiy TO quantity;

ALTER TABLE sale
RENAME COLUMN prce TO price;
                          --DATA CLEANING STEP 3:- TO CHECK DATA TYPE
SELECT 
    COLUMN_NAME,
	DATA_TYPE
	FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='sale'
ORDER BY 
    ORDINAL_POSITION;
	                     -- STEP 4:- TO CHECK FOR NULL VALUE
SELECT* FROM sale
WHERE transaction_id IS NULL
OR customer_id IS NULL
OR customer_name IS NULL
OR customer_age IS NULL
OR gender IS NULL
OR product_id IS NULL
OR product_name IS NULL
OR product_category IS NULL
OR quantity IS NULL
OR price IS NULL
OR payment_mode IS NULL
OR purchase_date IS NULL
OR time_of_purchase IS NULL
OR status IS NULL;
                               --DELETING THE OUTLIER
DELETE FROM sale
WHERE transaction_id is null;
                               --TREATING NULL VALUES
SELECT * FROM sale
WHERE customer_name ='Ehsaan Ram';

UPDATE sale
SET customer_id='CUST9494'
WHERE transaction_id='TXN977900';

SELECT * FROM sale
WHERE customer_name ='Damini Raju';

UPDATE sale
SET customer_id='CUST1401'
WHERE transaction_id='TXN985663';

SELECT * FROM sale
WHERE customer_id='CUST1003';

UPDATE sale
SET customer_name='Mahika Saini',customer_age=35,gender='Male'
WHERE transaction_id='TXN432798';

SELECT * FROM sale

                                 --STEP 5:-DATA CLEANING
								 
SELECT DISTINCT gender
FROM sale;
                                 --CLEANING GENDER COLUMN
UPDATE sale
SET gender='M'
WHERE gender='Male';

UPDATE sale
SET gender='F'
WHERE gender='Female';

                                --CLEANING PAYMENT MODE
SELECT DISTINCT payment_mode
FROM sale;

UPDATE sale
SET payment_mode='Credit Card'
WHERE payment_mode='CC';

                             --DATA ANALYSIS-SOLVING BUSINESS INSIGHT QUESTIONS--

--Q1.WHAT ARE THE TOP 5 MOST SELLING PRODUCTS BY QUANTITY?
SELECT * FROM sale;
SELECT DISTINCT status
FROM sale

SELECT product_name,SUM(quantity)as total_quantity
FROM sale
WHERE status ='delivered'
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 5;
             --BUSINESS PROBLEM & BUSINESS IMPACT
--Business Problem :We don't know which products are most in demand
--Business Impact:Helps prioritize stock and boost sales through targeted promotion.

--Q2.WHICH PRODUCTS ARE MOST FREQUENTLY CANCELLED?

SELECT product_name,COUNT(*)AS total_cancelled
FROM sale
WHERE status ='cancelled'
GROUP BY product_name
ORDER BY total_cancelled DESC
LIMIT 5;

--Business Problem:Frequent cancellation affect revenue and customer trust.
--Business Impact:Identify poor-performing products to improve quality or remove from catalog.

--Q3.WHAT TIME OF THE DAY HAS THE HIGHEST NUMBER OF PURCHASE?

SELECT * FROM sale;

SELECT 
      CASE
	      WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		  WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		  WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		  WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
	 END AS time_of_day,
	 COUNT(*)AS total_orders
FROM sale
GROUP BY time_of_day
ORDER BY total_orders DESC;

--Business Problem:Find peak sales time.
--Business Impact:Optimize staffing ,promotions, and server loads.
		  

--Q4:WHO ARE THE TOP 5 HIGHEST SPENDING CUSTOMERS?

SELECT * FROM sale;

SELECT customer_name, 
 -- Formats with lakhs/crores grouping, assumes up to 99 crores 
'₹' || TO_CHAR(SUM(price * quantity), 'FM99,99,99,999.00') AS formatted_total_spend
FROM sale
GROUP BY customer_name
ORDER BY SUM(price * quantity)  DESC
LIMIT 5;
--The FM prefix is used to remove leading spaces from the output

--Business Problem:Identify VIP customers.
--Business Impact:Personalized offers,loyalty rewards and retention.

--Q5.WHICH PRODUCT CATEGORIES GENERATE THE HIGHEST REVENUE?

SELECT * FROM sale;

SELECT product_category,
'₹' || TO_CHAR(SUM(price * quantity), 'FM99,99,99,999.00') AS formatted_total_revenue
FROM sale
WHERE status='delivered'
--Revenue is recognized solely for completed deliveries.
GROUP BY product_category
ORDER BY SUM(price*quantity) DESC;

--Business Problem:Identify top-performing product categories.
--Business Impact:Refine product strategy,supply chain,and promotions.
--allowing the business to invest more in high-margin or high-demand categories

--Q6.WHAT IS THE RETURN /CANCELLATION RATE PER PRODUCT CATEGORIES?
--cancellation
SELECT product_category,
ROUND(COUNT(*)FILTER(WHERE status='cancelled')*100.0/count(*),2)||' %' as cancelled_perct
FROM sale
GROUP BY product_category
ORDER BY cancelled_perct DESC;

--Return

SELECT product_category,
ROUND(COUNT(*)FILTER(WHERE status='returned')*100.0/count(*),2)||' %' as returned_perct
FROM sale
GROUP BY product_category
ORDER BY returned_perct DESC;

--Business Problem:Monitor dissatisfaction trends per category.
--Business Impact:Reduce returns,improve product descriptions/expectations.
--helps identify and fix product or logistics issues.

--Q7.WHAT IS THE MOST PREFERRED PAYMENT MODE?

SELECT * FROM sale;

SELECT payment_mode,COUNT(payment_mode) as total_count
FROM sale
GROUP BY payment_mode
ORDER BY total_count DESC;

--Business Problem:know which payment option customers prefer.
--Business Impact:as our query return the most prefered payment mode to credit card so,we need to streamline 
--payment processing,The goal here is to reduce friction, minimize errors, and ensure high reliability,
--especially for network issues.
--we can also give Exclusive Discounts/Promotions,Cashback Rewards to the credit card users.

--Q8.HOW DOES AGE GROUP AFFECT PURCHASING BEHAVIOR ?

SELECT *FROM sale;
SELECT MIN(customer_age),MAX(customer_age)
FROM sale;

SELECT 
     CASE
	     WHEN customer_age BETWEEN 18 AND 25 THEN 'young'
		 WHEN customer_age BETWEEN 26 AND 35 THEN 'Adult/Millennial'
		 WHEN customer_age BETWEEN 36 AND 50 THEN 'Middle age'
		 ELSE 'old'
END AS age_bracket,
'₹' || TO_CHAR(SUM(price * quantity), 'FM99,99,99,999.00')AS total_purchase
FROM sale
GROUP BY age_bracket
ORDER BY SUM(price * quantity) DESC;

--Business Problem:Understand customer demographics.
--Business Impact:from our query we now know that 'middle age (36-50)'are purchasing more and our core 
--demographic.
--Insight: This group drives the highest revenue. People in this age range are typically in their peak earning years and have established purchasing habits.
--Action: Double down on this segment. Ensure that our product offerings, marketing campaigns, and loyalty programs strongly appeal to them. 
--They have the most disposable income to spend with our business.

--To add more clarity and showcase the percentage contribution of each age bracket to the total sales, the best approach is to use a Window Function 

SELECT 
    CASE
        WHEN customer_age BETWEEN 18 AND 25 THEN  'Young (18-25)'
        WHEN customer_age BETWEEN 26 AND 35 THEN 'Adult/Millennial (26-35)'
        WHEN customer_age BETWEEN 36 AND 50 THEN 'Middle Age (36-50)'
        ELSE 'Old (51+)'
    END AS age_bracket,
    '₹' || TO_CHAR(SUM(price * quantity), 'FM99,99,99,999.00') AS formatted_total_purchase,
	    -- Calculate Percentage using a Window Function
    ROUND(
        (SUM(price * quantity) * 100.0 / SUM(SUM(price * quantity)) OVER ())::numeric,
        2
    ) || '%' AS percentage_of_total
FROM 
    sale
GROUP BY 
    age_bracket
ORDER BY 
    SUM(price * quantity) DESC;

--Q9.WHAT IS THE MONTHLY SALES TREND?

SELECT * FROM sale;

SELECT TO_CHAR(purchase_date,'YYYY-MM')AS monthly_basis,
      '₹' || TO_CHAR(SUM(price*quantity), 'FM99,99,99,999.00')AS total_sales,
	   SUM(quantity)AS total_quantity
	   FROM sale
	   GROUP BY TO_CHAR(purchase_date,'YYYY-MM')
	   ORDER BY monthly_basis,total_quantity des
	   






	



















