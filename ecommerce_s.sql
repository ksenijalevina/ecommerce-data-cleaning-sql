

-- Data Cleaning 

SELECT * 
FROM ecommerce_sales.messy_ecommerce_sales_data;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values and blank values
-- 4. Remove Any Columns
-- Data Cleaning 
SELECT * FROM messy_ecommerce_sales_data;

# make a copy of the dataset

create table e_com 
like messy_ecommerce_sales_data;

insert e_com
select * from messy_ecommerce_sales_data;

select * from e_com;

#remove duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Customer_name, Order_ID, Order_Date, Product, category, quantity, price, total) AS row_num
FROM  e_com;






select * from e_com
where customer_name = 'Customer_146'; 

# different total, maybe it was some discount??? 

select * from e_com
where customer_name = 'Customer_142'; 

select * from e_com
where customer_name = 'Customer_175'; 

## 

select * from e_com;
insert into e_com


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Customer_name, Order_ID, Order_Date, Product, category, quantity, price, total) AS row_num
FROM  e_com;

#create a new table for deleting duplicates

CREATE TABLE `e_com2` (
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



insert into e_com2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY id, customer_name, order_id, order_date, product,
                 category, quantity, price, payment_method, status, total) AS row_num
FROM  e_com;

select * from e_com2
where row_num > 1;

#checking
select * from e_com2
where ID = 146;

#duplicated rows is deleted

delete from e_com2
where row_num > 1;

#delee column row_num

alter table e_com2
drop column row_num;

select * from e_com2;

select ID from e_com2;

WITH duplicate_s AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY id) AS row_num
FROM  ecommerce_sales
)
SELECT * 
FROM duplicate_s
WHERE row_num > 1;


select * from e_com2
where id in(142,146,175);  #we can notice totals differneces (maybe it was discount)

#lets get move on standardize 

select customer_name from e_com2;


#standardize a date column

alter table e_com2 
add column order_date2 text;


update e_com2
set order_date2 = case
    when order_date like '%/%' then str_to_date(order_date, '%m/%d/%Y')
    else str_to_date(order_date, '%b %e %Y')
end;


alter table e_com2
drop column order_date;

alter table e_com2
change order_date2 Order_date date;

# product column
select distinct product from e_com2;

alter table e_com2 
modify column product text after order_date;
# quantity column
select Quantity from e_com2;

alter table e_com2
add column quan int;

update e_com2
set quan = case
	when quantity < 0 then abs(quantity)
    else 
		quantity
end;

alter table e_com2
drop column quantity;

alter table e_com2
change quan Quantity int;

select category from e_com2;

select * from e_com2;

#column category
select distinct category from e_com2;

update e_com2 
set category = lower(category);

UPDATE e_com2 
SET category = 'electronics'
WHERE category LIKE 'electronic%';

UPDATE e_com2 
SET category = null
WHERE category in('nan', '');

alter table e_com2 
modify column category text after quantity;

#column price

select price from e_com2;

select * from e_com2;
alter table ecommerce_sales2
add column cl

select * from ecommerce_sales2;ecommerce_sales2
