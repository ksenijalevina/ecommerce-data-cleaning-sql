-- Check the dataset
SELECT * FROM messy_ecommerce_sales_data;

-- Create a working copy of the raw dataset

create table e_com 
like messy_ecommerce_sales_data;

insert into e_com
select * from messy_ecommerce_sales_data;


-- Create a second working table with row numbers for duplicate detection

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

-- Check duplicate rows
select * from e_com2
where row_num > 1;

-- Remove duplicate rows

delete from e_com2
where row_num > 1;


alter table e_com2
drop column row_num;

-- Check possible total differences/possible discounts

select * from e_com2
where id in(142,146,175);  

-- Standardize date column

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

-- Check product column 

select distinct product from e_com2;

alter table e_com2 
modify column product text after order_date;

-- Clean quantity

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

-- Clean category

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

-- Clean price column / delete rows without data

delete from e_com2 
where order_id = 'ORD-35783';


alter table e_com2
add column price2 text;

update e_com2
set price2 = 400
where ID = 110;

UPDATE e_com2
SET price2 = REPLACE(price2, '$', '');

update e_com2
set price2 = abs(round(price2,2));

alter table e_com2
change price2 Price decimal(10,2);


-- Calculate discount 
alter table e_com2
add column total_copy decimal(10,2);

update e_com2
set total_copy = total;

update e_com2
set total_copy = null
where total_copy = '';
	
update e_com2
set total_copy = abs(total_copy);


alter table e_com2
add column discount decimal(5,2);

update e_com2
set discount = case
	when price = 0 then null
	when total_copy = price*quantity then 0
    else  round(1 - (total_copy/(price*quantity)),2)
end;


alter table e_com2
drop column total_copy;


alter table e_com2
add column total decimal(10,2);


update e_com2
set total = case
	when price = 0 and (discount = 0 or discount is null) then null
    else  price*quantity*(1-discount)
end;

-- Delete specific rows without discount

delete from e_com2
where id = 142 and discount = 0;

delete from e_com2
where id = 175 and discount = 0;

WITH duplicate_s AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY id) AS row_num
FROM  e_com2
)
SELECT * 
FROM duplicate_s
WHERE row_num > 1;

-- Check cleaned dataset

select * from e_com2;


