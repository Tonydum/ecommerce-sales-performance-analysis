
CREATE SCHEMA IF NOT EXISTS ecommerce;


-- staging >>>> clean >>>> dims/fact

DROP TABLE IF EXISTS ecommerce.stg_orders;

CREATE TABLE ecommerce.stg_orders (
order_id    	text,
product     	text,
category    	text,
brand       	text,
platform		text,
city			text,
price			numeric(12,2),
quantity		integer,
total_amount	numeric(14,2),
rating			numeric(4,2),
reviews			integer,
order_date		text
);


-- I am going to import my csv into this staging table
DROP TABLE IF EXISTS ecommerce.orders_clean;


-- I want to fix my date colum. I will create a clean base table with 
-- the fixed date column from text to date type.

CREATE TABLE ecommerce.orders_clean AS
SELECT
	order_id,    	
	product,    	
	category,    	
	brand,       	
	platform,		
	city,			
	price,			
	quantity,		
	total_amount,	
	rating,			
	reviews,			
	TO_DATE(order_date, 'YYYY/MM/DD') AS order_date
FROM ecommerce.stg_orders;



-- Let me do a quick check to see if there is any null:

SELECT
	order_date,
	COUNT(*)
FROM ecommerce.orders_clean
WHERE order_date IS NULL
GROUP BY order_date;




-- I will create the dimension tables.
-- dim_date, dim_product, dim_platform, and dim_city

DROP TABLE IF EXISTS ecommerce.dim_date;

--- I create the dim_date table. I will use the date_key as the primary key
CREATE TABLE ecommerce.dim_date (
date_key		integer PRIMARY KEY, --- yyyymmdd
full_date		date 	UNIQUE NOT NULL,
year			integer	NOT NULL,
month			integer	NOT NULL,
month_name		text	NOT NULL,
quarter			integer	NOT NULL
);


INSERT INTO ecommerce.dim_date (date_key, full_date, year, month, month_name, quarter)
SELECT DISTINCT
	(extract(year from order_date)::int * 10000
	+ extract(month from order_date)::int * 100
	+ extract(day from order_date)::int) AS date_key,
	order_date AS full_date,
	extract(year from order_date)::int,
	extract(month from order_date)::int,
	to_char(order_date, 'Mon') AS mont_name,
	extract(quarter from order_date)::int
FROM ecommerce.orders_clean
WHERE order_date IS NOT NULL;




SELECT
	*
FROM ecommerce.orders_clean;



--- Lets create the product dimension

DROP TABLE IF EXISTS ecommerce.dim_products;


CREATE TABLE ecommerce.dim_products (
product_key serial	PRIMARY KEY,
product		text	NOT NULL,
brand		text	NOT NULL,
category	text	NOT NULL,
UNIQUE	(product, brand, category)
);


-- Lets populate the table

INSERT INTO ecommerce.dim_products (product, brand, category)
SELECT DISTINCT product, brand, category
FROM ecommerce.orders_clean;



DROP TABLE IF EXISTS ecommerce.dim_platform;

-- lets create the platform table

CREATE TABLE ecommerce.dim_platform (
platform_key 	serial	PRIMARY KEY,
PLATFORM		text	UNIQUE NOT NULL 	
);

-- lets populate the table

INSERT INTO ecommerce.dim_platform (platform)
SELECT DISTINCT platform
FROM ecommerce.orders_clean;






DROP TABLE IF EXISTS ecommerce.dim_city;



-- lets create the city table

CREATE TABLE ecommerce.dim_city (
city_key	serial	PRIMARY KEY,
city		text	UNIQUE NOT NULL
);

-- lets populate the city table

INSERT INTO ecommerce.dim_city (city)
SELECT DISTINCT city
FROM ecommerce.orders_clean;







--- lets create the fact table. 1 row per order line


DROP TABLE IF EXISTS ecommerce.fact_sales;



-- lets create the fact sales table

CREATE TABLE ecommerce.fact_sales (
order_id		text	PRIMARY KEY,
date_key		integer	NOT NULL REFERENCES ecommerce.dim_date(date_key),
product_key		integer	NOT NULL REFERENCES ecommerce.dim_products(product_key),
platform_key	integer	NOT NULL REFERENCES ecommerce.dim_platform(platform_key),
city_key		integer NOT NULL REFERENCES ecommerce.dim_city(city_key),

price			numeric(12,2) NOT NULL,
quantity		integer NOT NULL,
total_amount	numeric(14,2) NOT NULL,
rating			numeric(4,2),
reviews			integer
);


-- lets populate the fact table

INSERT INTO ecommerce.fact_sales (
	order_id, date_key, product_key, platform_key, city_key,
	price, quantity, total_amount, rating, reviews
)
SELECT
	o.order_id,
	(extract(year from o.order_date)::int * 10000
	+ extract(month from o.order_date)::int * 100
	+ extract(day from o.order_date)::int) AS date_key,
	p.product_key,
	pl.platform_key,
	c.city_key,
	o.price,
	o.quantity,
	o.total_amount,
	o.rating,
	o.reviews
FROM ecommerce.orders_clean o
JOIN ecommerce.dim_products p
	ON p.product = o.product AND p.brand = o.brand AND p.category = o.category
JOIN ecommerce.dim_platform pl
	ON pl.platform = o.platform
JOIN ecommerce.dim_city c
	ON c.city = o.city
WHERE o.order_date IS NOT NULL;