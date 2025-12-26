--- Q1. What is monthly revenue, and how is revenue trending over time?

SELECT
	d.year,
	d.month,
	d.month_name,
	SUM(f.total_amount) AS monthly_revenue
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_date d
	ON f.date_key = d.date_key
GROUP BY
	d.year,
	d.month,
	d.month_name
ORDER BY d.month;



-- Q2. What is the cumulative (running) revenue over time?
WITH monthly_revenue AS (
SELECT
	d.year,
	d.month,
	d.month_name,
	SUM(f.total_amount) AS total_revenue
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_date d
	ON f.date_key = d.date_key
GROUP BY
	d.year,
	d.month,
	d.month_name
)
SELECT
	year,
	month,
	month_name,
	total_revenue,
	SUM(total_revenue) OVER(
	ORDER BY month ASC
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_total
FROM monthly_revenue
ORDER BY month;



-- Q3. Which months performed best and worst?
WITH monthly_revenue AS (
SELECT
	d.year,
	d.month,
	d.month_name,
	SUM(f.total_amount) AS total_revenue
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_date d
	ON f.date_key = d.date_key
GROUP BY
	d.year,
	d.month,
	d.month_name
),
ranked AS (
SELECT
	year,
	month,
	month_name,
	total_revenue,
	RANK() OVER (
	ORDER BY total_revenue DESC
	) AS row_rank
FROM monthly_revenue
)
SELECT
	year,
	month,
	month_name,
	total_revenue,
	row_rank
FROM ranked
WHERE row_rank = 1;






-- Q4. Top 10 products by total revenue (and units sold)
SELECT
	p.product_key,
	p.product,
	p.brand,
	p.category,
	SUM(f.total_amount) AS total_revenue,
	SUM(f.quantity) AS total_quantity
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_products p
	ON f.product_key = p.product_key
GROUP BY
	p.product_key,
	p.product,
	p.brand,
	p.category
ORDER BY total_revenue DESC
LIMIT 10;



-- Q5. What are the top 3 products by revenue per category?
WITH category_revenue AS (
SELECT
	p.category,
	p.product_key,
	p.product,
	SUM(f.total_amount) AS total_revenue
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_products p
	ON f.product_key = p.product_key
GROUP BY
	p.category,
	p.product_key,
	p.product
),
ranked AS (
SELECT
	category,
	product_key,
	product,
	total_revenue,
	RANK() OVER (
	PARTITION BY category
	ORDER BY total_revenue DESC
	)AS row_rank
FROM category_revenue
)
SELECT
	category,
	product_key,
	product,
	total_revenue,
	row_rank
FROM ranked
WHERE row_rank <= 3;




-- Q6. Which platforms contribute the most revenue?

SELECT
	p.platform_key,
	p.platform,
	SUM(f.total_amount) AS total_revenue,
	SUM(f.quantity) AS total_quantity_sold
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_platform p
	ON f.platform_key = p.platform_key
GROUP BY 
	p.platform_key,
	p.platform
ORDER BY SUM(f.total_amount) DESC;





-- Q7. How does revenue vary by city?
SELECT
	c.city_key,
	c.city,
	SUM(f.total_amount) AS total_revenue,
	SUM(f.quantity) AS total_quantity_sold
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_city c
	ON f.city_key = c.city_key
GROUP BY 
	c.city_key,
	c.city
ORDER BY total_revenue DESC
LIMIT 5;








--q8 What are the top cities for each platform by revenue?
WITH city_revenue AS (
SELECT
	p.platform,
	c.city,
	SUM(f.total_amount) AS total_revenue,
	SUM(f.quantity) AS total_quantity_sold
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_city c
	ON f.city_key = c.city_key
JOIN ecommerce.dim_platform p
	ON f.platform_key = p.platform_key
GROUP BY 
	p.platform,
	c.city
),
ranked AS (
SELECT
	platform,
	city,
	total_revenue,
	total_quantity_sold,
	RANK() OVER (
	PARTITION BY platform
	ORDER BY total_revenue DESC
	) AS row_rank
FROM city_revenue
)
SELECT
	platform,
	city,
	total_revenue,
	total_quantity_sold,
	row_rank
FROM ranked
WHERE row_rank <= 3
ORDER BY 
	platform,
	row_rank,
	total_revenue DESC;



















-- Q9. Which products have high revenue but low ratings? (quality risk)

SELECT
	p.product,
	p.brand,
	p.category,
	SUM(f.total_amount) AS total_revenue,
	ROUND(AVG(rating),2) AS average_rating
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_products p
	ON f.product_key = p.product_key
GROUP BY 
	p.product,
	p.brand,
	p.category
HAVING AVG(rating)< 3
ORDER BY total_revenue DESC;



--- Q10. Which products have high ratings but low revenue? (growth opportunity)


SELECT
	p.product,
	p.brand,
	p.category,
	SUM(f.total_amount) AS total_revenue,
	ROUND(AVG(rating),2) AS average_rating
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_products p
	ON f.product_key = p.product_key
GROUP BY 
	p.product,
	p.brand,
	p.category
HAVING AVG(rating) >= 3.5
ORDER BY total_revenue ASC;



-- Q11 Does rating relate to revenue?
SELECT
	p.category,
	SUM(f.total_amount) AS total_revenue,
	ROUND(AVG(f.rating),3) AS average_rating
FROM ecommerce.fact_sales f
JOIN ecommerce.dim_products p
ON f.product_key = p.product_key
GROUP BY
	p.category
ORDER BY total_revenue DESC;














-- Q12. What is the rolling 3-month revenue trend overall?
WITH monthly_revenue AS (
	SELECT
		d.year,
		d.month,
		SUM(f.total_amount) AS total_revenue
	FROM ecommerce.fact_sales f
	JOIN ecommerce.dim_date d
		ON f.date_key = d.date_key
	GROUP BY 
		d.year,
		d.month
)
SELECT
	year,
	month,
	total_revenue,
	SUM(total_revenue) OVER (
		ORDER BY year, month
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS running_total,
	SUM(total_revenue) OVER (
		ORDER BY month
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
	) AS rolling_3_month_total
FROM monthly_revenue
ORDER BY 
	year, 
	month;




















































