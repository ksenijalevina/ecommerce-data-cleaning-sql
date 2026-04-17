-- Data Cleaning 

SELECT * 
FROM ecommerce_sales.messy_ecommerce_sales_data;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values and blank values
-- 4. Remove Any Columns

CREATE TABLE ecommerce_sales
LIKE ecommerce_sales.messy_ecommerce_sales_data;

SELECT * 
FROM ecommerce_sales;

INSERT ecommerce_sales 
SELECT * FROM 
ecommerce_sales.messy_ecommerce_sales_data;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Order_ID, Order_Date, Product) AS row_num
FROM  ecommerce_sales;

 -- DUPLICATES
WITH duplicate_s AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY id, customer_name, order_id, order_date, product,
                 category, quantity, price, payment_method, status, total) AS row_num
FROM  ecommerce_sales
)
SELECT * 
FROM duplicate_s
WHERE row_num > 1;

SELECT * FROM ecommerce_sales
WHERE Order_ID = 'ORD-32755';

SELECT * FROM ecommerce_sales
WHERE Order_ID = 'ORD-56651';

SELECT * FROM ecommerce_sales
WHERE Order_ID = 'ORD-69018';

SELECT * FROM ecommerce_sales
WHERE Order_ID = 'ORD-69018';

