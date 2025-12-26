-- validate data integrity

-- Let me do a quick check to see if there is any null:

SELECT
	order_date,
	COUNT(*)
FROM ecommerce.orders_clean
WHERE order_date IS NULL
GROUP BY order_date;

--- validate data integrity and confirm data is complete

SELECT
  (SELECT COUNT(*) FROM ecommerce.orders_clean) AS clean_rows,
  (SELECT COUNT(*) FROM ecommerce.fact_sales) AS fact_rows,
  (SELECT COUNT(*) FROM ecommerce.dim_products) AS dim_product_rows,
  (SELECT COUNT(*) FROM ecommerce.dim_platform) AS dim_platform_rows,
  (SELECT COUNT(*) FROM ecommerce.dim_city) AS dim_city_rows,
  (SELECT COUNT(*) FROM ecommerce.dim_date) AS dim_date_rows;


-- lets check if there is any missing data

SELECT COUNT(*) AS missing_product
FROM ecommerce.fact_sales f
LEFT JOIN ecommerce.dim_products p ON p.product_key = f.product_key
WHERE p.product_key IS NULL;

SELECT COUNT(*) AS missing_platform
FROM ecommerce.fact_sales f
LEFT JOIN ecommerce.dim_platform p ON p.platform_key = f.platform_key
WHERE p.platform_key IS NULL;

SELECT COUNT(*) AS missing_city
FROM ecommerce.fact_sales f
LEFT JOIN ecommerce.dim_city c ON c.city_key = f.city_key
WHERE c.city_key IS NULL;

SELECT COUNT(*) AS missing_date
FROM ecommerce.fact_sales f
LEFT JOIN ecommerce.dim_date d ON d.date_key = f.date_key
WHERE d.date_key IS NULL;



