

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
FROM ecommerce_sales; #blogas formatas, netinkamas total stulpelis

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

CREATE TABLE `ecommerce_sales2` (
  `ID` int DEFAULT NULL,
  `Customer_Name` text,
  `Order_ID` text,
  `Order_Date` text,
  `Product` text,
  `Category` text,
  `Quantity` int DEFAULT NULL,
  `Price` text,
  `Payment_Method` text,
  `Status` text,
  `Total` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM ecommerce_sales2;

INSERT INTO ecommerce_sales2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY id, customer_name, order_id, order_date, product,
                 category, quantity, price, payment_method, status, total) AS row_num
FROM  ecommerce_sales;
SELECT *
FROM ecommerce_sales2
WHERE row_num > 1;



DELETE
FROM ecommerce_sales2
WHERE row_num > 1;

SELECT *
FROM ecommerce_sales2;

-- Standardizing data

SELECT Category
from ecommerce_sales2
order by 1;
select distinct Category
from ecommerce_sales2;

SELECT LOWER(Category)
FROM ecommerce_sales2
ORDER BY 1;

UPDATE ecommerce_sales2
SET category = LOWER(Category);


select distinct category
from ecommerce_sales2;

select distinct category
from ecommerce_sales2;

SELECT * 
FROM ecommerce_sales2
WHERE Category LIKE 'electronic%'; 

UPDATE ecommerce_sales2 
SET Category = 'electronics'
WHERE category LIKE 'electronic%';

select distinct category
from ecommerce_sales2;

SELECT *
FROM ecommerce_sales2;

-- DELETING THE COLUMN
ALTER TABLE ecommerce_sales2
DROP COLUMN row_num;

select category
from ecommerce_sales2
ORDER BY 1;

SELECT DISTINCT Status
FROM ecommerce_sales2
ORDER BY 1;

select order_date
from ecommerce_sales2
ORDER BY 1;

SELECT 'Order_date'
STR_TO_DATE('Order_date', '%m/%d/%Y')
FROM ecommerce_sales2



select order_date,
case
    when order_date like '%/%' then str_to_date(order_date, '%m/%d/%Y')
    else str_to_date(order_date, '%b %e %Y')
end as cleaned_date
from ecommerce_sales2;

update ecommerce_sales2
set order_date = case
    when order_date like '%/%' then str_to_date(order_date, '%m/%d/%Y')
    else str_to_date(order_date, '%b %e %Y')
end as cleaned_date;

-- create a new column

alter table ecommerce_sales2
add column cl

select * from ecommerce_sales2;ecommerce_sales2
