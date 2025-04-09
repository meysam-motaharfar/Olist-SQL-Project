-- OLIST EXPLORATORY ANALYSIS

---------------------------------------------------------------------------------------------------------
-- 1) PRODUCT_CATEGORY_NAME_TRANSLATION:
-- Questions:
-- How many distinct category is there?
---------------------------------------------------------------------------------------------------------

SELECT * 
	FROM product_category_name_translation 
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT(COUNT(*)) 
FROM product_category_name_translation;

---------------------------------------------------------------------------------------------------------
-- 2) CUSTOMERS
-- Questions:
-- How many customers are there in total?
-- How many distinct cities and states are there?
-- What is the average number of customers per city and state?
-- Which are the top ten cities with the most customers?
-- How many cities have more than 500 customers?
-- Which are the top ten states with the most customers?
-- How many cities are there in each state?
-- What percentage of the total customer base do the top ten cities/states represent?
-- What are the top three cities with the most customers in each state?
-- What percentage of the total customer base do the top three cities in each state represent?
---------------------------------------------------------------------------------------------------------

SELECT * 
	FROM customer 
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
    COUNT(*) AS no_rows,  
    COUNT(DISTINCT customer_id) AS no_customer_id,  
    COUNT(DISTINCT customer_unique_id) AS no_unique_customer_id,  
    COUNT(DISTINCT customer_city) AS no_distinct_city,  
    COUNT(DISTINCT customer_unique_id) / COUNT(DISTINCT customer_city) AS avg_customers_per_city,  
    COUNT(DISTINCT customer_state) AS no_distinct_state,  
    COUNT(DISTINCT customer_unique_id) / COUNT(DISTINCT customer_state) AS avg_customers_per_state  
FROM 
    customer;

---------------------------------------------------------------------------------------------------------

SELECT 
    customer_city,  
    COUNT(DISTINCT customer_unique_id) AS no_customers  
FROM 
    customer  
GROUP BY 
    customer_city  
ORDER BY 
    no_customers DESC  
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
    COUNT(*) AS number_of_cities_with_more_than_500_customers 
FROM (
    SELECT
        customer_city  
    FROM 
        customer  
    GROUP BY 
        customer_city  
    HAVING 
        COUNT(DISTINCT customer_unique_id) > 500  
) AS cities_with_more_than_500_customers;

---------------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS no_customers
FROM 
    customer
GROUP BY 
    customer_state
ORDER BY 
    no_customers DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT
    customer_state,
    COUNT(DISTINCT customer_city) AS no_city_per_state
FROM 
    customer
GROUP BY 
    customer_state
ORDER BY 
    no_city_per_state DESC;
	
---------------------------------------------------------------------------------------------------------

SELECT 
    SUM(no_customers) * 100 / (
        SELECT COUNT(DISTINCT customer_unique_id)
        FROM customer
    ) AS percent_top_10_cities
FROM (
    SELECT
        customer_city,
        COUNT(DISTINCT customer_unique_id) AS no_customers
    FROM 
        customer
    GROUP BY 
        customer_city
    ORDER BY 
        no_customers DESC
    LIMIT 10
) AS top_ten_cities;

---------------------------------------------------------------------------------------------------------

SELECT 
    SUM(no_customers) * 100 / (
        SELECT COUNT(DISTINCT customer_unique_id)
        FROM customer
    ) AS percent_top_10_states
FROM (
    SELECT
        customer_state,
        COUNT(DISTINCT customer_unique_id) AS no_customers
    FROM 
        customer
    GROUP BY 
        customer_state
    ORDER BY 
        no_customers DESC
    LIMIT 10
) AS top_ten_states;

---------------------------------------------------------------------------------------------------------

SELECT 
    customer_state, 
    customer_city, 
    no_customers
FROM (
    SELECT 
        customer_state, 
        customer_city, 
        COUNT(DISTINCT customer_unique_id) AS no_customers, 
        RANK() OVER (PARTITION BY customer_state ORDER BY COUNT(customer_unique_id) DESC) AS city_rank
    FROM 
        customer
    GROUP BY 
        customer_state, customer_city
) AS ranked_cities
WHERE 
    city_rank <= 3
ORDER BY 
    customer_state, city_rank;

---------------------------------------------------------------------------------------------------------

SELECT 
    ranked_cities.customer_state, 
    SUM(no_customers) * 100.0 / total_customers AS percent_top_3_cities
FROM (
    SELECT 
        customer_state, 
        customer_city, 
        COUNT(DISTINCT customer_unique_id) AS no_customers, 
        RANK() OVER (PARTITION BY customer_state ORDER BY COUNT(customer_unique_id) DESC) AS city_rank
    FROM 
        customer
    GROUP BY 
        customer_state, customer_city
) AS ranked_cities
JOIN (
    SELECT 
        customer_state, 
        COUNT(DISTINCT customer_unique_id) AS total_customers
    FROM 
        customer
    GROUP BY 
        customer_state
) AS total_customers_per_state
ON ranked_cities.customer_state = total_customers_per_state.customer_state
WHERE 
    city_rank <= 3
GROUP BY 
    ranked_cities.customer_state, total_customers
ORDER BY 
    percent_top_3_cities ASC;

---------------------------------------------------------------------------------------------------------
-- 2) SELLERS
-- Questions:
-- How many sellers are there?
-- How many distinct cities and states are there?
-- What is the average number of sellers per city or state?
-- Which are the top ten cities with the most sellers?
-- How many cities have more than 10 sellers?
-- Which are the top ten states with the most sellers?
-- How many cities are there per state?
-- What percentage of the seller base do the top ten cities account for?
-- What percentage of the seller base do the top ten states account for?
-- What are the top three cities with the most sellers in each state?
-- What percentage of the total seller base does the top three cities in each state account for?
---------------------------------------------------------------------------------------------------------

SELECT *
	FROM sellers
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
    COUNT(*) AS no_rows, 
    COUNT(DISTINCT seller_id) AS no_sellers_id,
    COUNT(DISTINCT seller_city) AS no_distinct_city,
    COUNT(DISTINCT seller_id) / COUNT(DISTINCT seller_city) AS avg_sellers_per_city,
    COUNT(DISTINCT seller_state) AS no_distinct_state,
    COUNT(DISTINCT seller_id) / COUNT(DISTINCT seller_state) AS avg_sellers_per_state
FROM sellers;

---------------------------------------------------------------------------------------------------------

SELECT 
    seller_city, 
    COUNT(DISTINCT seller_id) AS no_sellers
FROM 
    sellers
GROUP BY 
    seller_city
ORDER BY 
    no_sellers DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
    COUNT(*) AS number_of_cities_with_more_than_10_sellers
FROM (
    SELECT
        seller_city
    FROM 
		sellers
    GROUP BY 
		seller_city
    HAVING 
		COUNT(DISTINCT seller_id) > 10
) AS cities_with_more_than_10_sellers;

---------------------------------------------------------------------------------------------------------

SELECT 
    seller_state, 
    COUNT(DISTINCT seller_id) AS no_sellers
FROM 
    sellers
GROUP BY 
    seller_state
ORDER BY 
    no_sellers DESC
LIMIT 
    10;

---------------------------------------------------------------------------------------------------------

SELECT 
    seller_state, 
    COUNT(DISTINCT seller_city) AS no_city_per_state
FROM 
    sellers
GROUP BY 
    seller_state
ORDER BY 
    no_city_per_state DESC;

---------------------------------------------------------------------------------------------------------

SELECT 
    SUM(no_sellers) * 100 / (
        SELECT COUNT(DISTINCT seller_id) 
        FROM sellers
    ) AS percent_top_10_cities
FROM (
    SELECT
        seller_city,
        COUNT(DISTINCT seller_id) AS no_sellers
    FROM 
		sellers
    GROUP BY 
		seller_city
    ORDER BY 
		no_sellers DESC
    LIMIT 
		10
) AS top_ten_cities;

---------------------------------------------------------------------------------------------------------

SELECT 
    SUM(no_sellers) * 100 / (
        SELECT COUNT(DISTINCT seller_id) 
        FROM sellers
    ) AS percent_top_10_states
FROM (
    SELECT
        seller_state,
        COUNT(DISTINCT seller_id) AS no_sellers
    FROM 
		sellers
    GROUP BY 
		seller_state
    ORDER BY 
		no_sellers DESC
    LIMIT 
		10
) AS top_ten_states;

---------------------------------------------------------------------------------------------------------

SELECT 
    seller_state, 
    seller_city, 
    no_sellers
FROM (
    SELECT 
        seller_state, 
        seller_city, 
        COUNT(DISTINCT seller_id) AS no_sellers,
        RANK() OVER (PARTITION BY seller_state ORDER BY COUNT(seller_id) DESC) AS city_rank
    FROM 
		sellers
    GROUP BY 
		seller_state, seller_city
) ranked_cities
WHERE 
	city_rank <= 3
ORDER BY 
	seller_state, city_rank;

---------------------------------------------------------------------------------------------------------

SELECT 
    ranked_cities.seller_state,
    SUM(no_sellers) * 100.0 / total_sellers AS percent_top_3_cities
FROM (
    SELECT 
        seller_state,
        seller_city, 
        COUNT(DISTINCT(seller_id)) AS no_sellers,
        RANK() OVER (PARTITION BY seller_state ORDER BY COUNT(seller_id) DESC) AS city_rank
    FROM 
		sellers
    GROUP BY 
		seller_state, seller_city
) ranked_cities
JOIN (
    SELECT 
        seller_state,
        COUNT(DISTINCT(seller_id)) AS total_sellers
    FROM 
		sellers
    GROUP BY 
		seller_state
) total_sellers_per_state
ON 
	ranked_cities.seller_state = total_sellers_per_state.seller_state
WHERE 
	city_rank <= 3
GROUP BY 
	ranked_cities.seller_state, total_sellers
ORDER BY 
	percent_top_3_cities ASC;

---------------------------------------------------------------------------------------------------------
-- 4) PRODUCTS
-- Questions:
-- How many products are there?
-- Which ten categories have the highest product counts?
-- What is the volume and density of each product?
-- What are the top ten categories for the largest, heaviest, and densest products?
-- What are the descriptive statistics for name_length, description_length, photos_quantity, weight_g, 
-- length_cm, height_cm, width_cm, volume_cm_cub, and density_g_per_cm_cub?
-- What are the descriptive statistics for name_length, description_length, photos_quantity, weight_g,
-- length_cm, height_cm, width_cm, volume_cm_cub, and density_g_per_cm_cub for top ten categories?
---------------------------------------------------------------------------------------------------------

SELECT *
	FROM products
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
	COUNT(*) AS no_rows, 
	COUNT(DISTINCT(product_id)) AS no_product_id,
	COUNT(DISTINCT(product_category_name)) AS no_product_category
FROM products;

---------------------------------------------------------------------------------------------------------

SELECT 
    product_category_name_translation.product_category_name_english, 
    COUNT(DISTINCT products.product_id) AS no_products
FROM 
    products
LEFT JOIN 
    product_category_name_translation 
ON 
    products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
    product_category_name_translation.product_category_name_english
ORDER BY 
    no_products DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
    products.product_id,
    product_category_name_translation.product_category_name_english,
    ROUND(products.product_length_cm * products.product_height_cm * products.product_width_cm, 2) AS product_volume_cm_cub,
    ROUND(products.product_weight_g / (products.product_length_cm * products.product_height_cm * products.product_width_cm), 2) AS product_density_g_per_cm_cub
FROM 
    products
LEFT JOIN 
    product_category_name_translation 
ON 
    products.product_category_name = product_category_name_translation.product_category_name;

---------------------------------------------------------------------------------------------------------

SELECT 
	product_category_name_translation.product_category_name_english,
	ROUND(AVG(product_weight_g), 2) AS avg_weight_g
FROM 
	products
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	avg_weight_g DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT 
	product_category_name_translation.product_category_name_english,
	ROUND(AVG(product_length_cm*product_height_cm*product_width_cm), 2) AS avg_product_volume_cm_cub
FROM products
LEFT JOIN
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	avg_product_volume_cm_cub DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT 
	product_category_name_translation.product_category_name_english,
	ROUND(AVG(product_weight_g / (product_length_cm*product_height_cm*product_width_cm)), 2) AS avg_density_g_per_cm_cub
FROM 
	products
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	avg_density_g_per_cm_cub DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT 
	'name_lenght' AS variable,
	COUNT(DISTINCT (product_name_lenght)) AS N,
	ROUND(AVG(product_name_lenght), 0) AS mean,
	ROUND(STDDEV(product_name_lenght), 0) AS STD,
	MAX(product_name_lenght) AS max,
	MIN(product_name_lenght) AS min,
	MODE() WITHIN GROUP (ORDER BY product_name_lenght) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_name_lenght) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_name_lenght) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_name_lenght) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_name_lenght) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_name_lenght) AS "99_percentile"
FROM 
	products
UNION
SELECT 
	'description_lenght' AS variable,
	COUNT(DISTINCT (product_description_lenght)) AS N,
	ROUND(AVG(product_description_lenght), 0) AS mean,
	ROUND(STDDEV(product_description_lenght), 0) AS STD,
	MAX(product_description_lenght) AS max,
	MIN(product_description_lenght) AS min,
	MODE() WITHIN GROUP (ORDER BY product_description_lenght) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_description_lenght) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_description_lenght) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_description_lenght) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_description_lenght) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_description_lenght) AS "99_percentile"
FROM 
	products
UNION
SELECT 
	'no_photos' AS variable,
	COUNT(DISTINCT (product_photos_qty)) AS N,
	ROUND(AVG(product_photos_qty), 0) AS mean,
	ROUND(STDDEV(product_photos_qty), 0) AS STD,
	MAX(product_photos_qty) AS max,
	MIN(product_photos_qty) AS min,
	MODE() WITHIN GROUP (ORDER BY product_photos_qty) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_photos_qty) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_photos_qty) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_photos_qty) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_photos_qty) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_photos_qty) AS "99_percentile"
FROM 
	products
UNION
SELECT 
	'weight_g' AS variable,
	COUNT(DISTINCT (product_weight_g)) AS N,
	ROUND(AVG(product_weight_g), 0) AS mean,
	ROUND(STDDEV(product_weight_g), 0) AS STD,
	MAX(product_weight_g) AS max,
	MIN(product_weight_g) AS min,
	MODE() WITHIN GROUP (ORDER BY product_weight_g) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_weight_g) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_weight_g) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_weight_g) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_weight_g) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_weight_g) AS "99_percentile"
FROM 
	products
UNION
SELECT 
	'length_cm' AS variable,
	COUNT(DISTINCT (product_length_cm)) AS N,
	ROUND(AVG(product_length_cm), 0) AS mean,
	ROUND(STDDEV(product_length_cm), 0) AS STD,
	MAX(product_length_cm) AS max,
	MIN(product_length_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY product_length_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_length_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_length_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_length_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_length_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_length_cm) AS "99_percentile"
FROM 
	products
UNION
SELECT 
	'height_cm' AS variable,
	COUNT(DISTINCT (product_height_cm)) AS N,
	ROUND(AVG(product_height_cm), 0) AS mean,
	ROUND(STDDEV(product_height_cm), 0) AS STD,
	MAX(product_height_cm) AS max,
	MIN(product_height_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY product_height_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_height_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_height_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_height_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_height_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_height_cm) AS "99_percentile"
FROM 
	products
UNION
SELECT 
	'width_cm' AS variable,
	COUNT(DISTINCT (product_width_cm)) AS N,
	ROUND(AVG(product_width_cm), 0) AS mean,
	ROUND(STDDEV(product_width_cm), 0) AS STD,
	MAX(product_width_cm) AS max,
	MIN(product_width_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY product_width_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_width_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_width_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_width_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_width_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_width_cm) AS "99_percentile"
FROM 
	products
UNION
SELECT 
	'volume_cm_cub' AS variable,
	COUNT(DISTINCT (product_volume_cm_cub)) AS N,
	ROUND(AVG(product_volume_cm_cub), 0) AS mean,
	ROUND(STDDEV(product_volume_cm_cub), 0) AS STD,
	MAX(product_volume_cm_cub) AS max,
	MIN(product_volume_cm_cub) AS min,
	MODE() WITHIN GROUP (ORDER BY product_volume_cm_cub) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_volume_cm_cub) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_volume_cm_cub) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_volume_cm_cub) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_volume_cm_cub) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_volume_cm_cub) AS "99_percentile"
FROM
	(SELECT
		product_length_cm*product_height_cm*product_width_cm AS product_volume_cm_cub
	FROM 
	 	products
	LEFT JOIN
		product_category_name_translation 
	ON 
	 	products.product_category_name = product_category_name_translation.product_category_name) calculated_volume
UNION
SELECT 
	'density_g_per_cm_cub' AS variable,
	COUNT(DISTINCT (product_density_g_per_cm_cub)) AS N,
	ROUND(AVG(product_density_g_per_cm_cub), 0) AS mean,
	ROUND(STDDEV(product_density_g_per_cm_cub), 0) AS STD,
	MAX(product_density_g_per_cm_cub) AS max,
	MIN(product_density_g_per_cm_cub) AS min,
	MODE() WITHIN GROUP (ORDER BY product_density_g_per_cm_cub) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_density_g_per_cm_cub) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_density_g_per_cm_cub) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_density_g_per_cm_cub) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_density_g_per_cm_cub) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_density_g_per_cm_cub) AS "99_percentile"
FROM
	(SELECT 
		product_id,
		product_weight_g / (product_length_cm*product_height_cm*product_width_cm) AS product_density_g_per_cm_cub
	FROM 
	 	products
	LEFT JOIN 
	 	product_category_name_translation 
	ON 
	 	products.product_category_name = product_category_name_translation.product_category_name) calculated_volume;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (product_name_lenght)) AS N,
	ROUND(AVG(product_name_lenght), 0) AS mean,
	ROUND(STDDEV(product_name_lenght), 0) AS STD,
	MAX(product_name_lenght) AS max,
	MIN(product_name_lenght) AS min,
	MODE() WITHIN GROUP (ORDER BY product_name_lenght) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_name_lenght) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_name_lenght) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_name_lenght) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_name_lenght) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_name_lenght) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (product_description_lenght)) AS N,
	ROUND(AVG(product_description_lenght), 0) AS mean,
	ROUND(STDDEV(product_description_lenght), 0) AS STD,
	MAX(product_description_lenght) AS max,
	MIN(product_description_lenght) AS min,
	MODE() WITHIN GROUP (ORDER BY product_description_lenght) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_description_lenght) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_description_lenght) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_description_lenght) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_description_lenght) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_description_lenght) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (product_photos_qty)) AS N,
	ROUND(AVG(product_photos_qty), 0) AS mean,
	ROUND(STDDEV(product_photos_qty), 0) AS STD,
	MAX(product_photos_qty) AS max,
	MIN(product_photos_qty) AS min,
	MODE() WITHIN GROUP (ORDER BY product_photos_qty) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_photos_qty) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_photos_qty) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_photos_qty) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_photos_qty) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_photos_qty) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (product_weight_g)) AS N,
	ROUND(AVG(product_weight_g), 0) AS mean,
	ROUND(STDDEV(product_weight_g), 0) AS STD,
	MAX(product_weight_g) AS max,
	MIN(product_weight_g) AS min,
	MODE() WITHIN GROUP (ORDER BY product_weight_g) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_weight_g) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_weight_g) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_weight_g) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_weight_g) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_weight_g) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (product_length_cm)) AS N,
	ROUND(AVG(product_length_cm), 0) AS mean,
	ROUND(STDDEV(product_length_cm), 0) AS STD,
	MAX(product_length_cm) AS max,
	MIN(product_length_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY product_length_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_length_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_length_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_length_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_length_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_length_cm) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (product_height_cm)) AS N,
	ROUND(AVG(product_height_cm), 0) AS mean,
	ROUND(STDDEV(product_height_cm), 0) AS STD,
	MAX(product_height_cm) AS max,
	MIN(product_height_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY product_height_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_height_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_height_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_height_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_height_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_height_cm) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (product_width_cm)) AS N,
	ROUND(AVG(product_width_cm), 0) AS mean,
	ROUND(STDDEV(product_width_cm), 0) AS STD,
	MAX(product_width_cm) AS max,
	MIN(product_width_cm) AS min,
	MODE() WITHIN GROUP (ORDER BY product_width_cm) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY product_width_cm) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY product_width_cm) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY product_width_cm) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY product_width_cm) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY product_width_cm) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (ROUND(product_length_cm*product_height_cm*product_width_cm, 2))) AS N,
	ROUND(AVG(ROUND(product_length_cm*product_height_cm*product_width_cm, 2)), 0) AS mean,
	ROUND(STDDEV(ROUND(product_length_cm*product_height_cm*product_width_cm, 2)), 0) AS STD,
	MAX(ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS max,
	MIN(ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS min,
	MODE() WITHIN GROUP (ORDER BY ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ROUND(product_length_cm*product_height_cm*product_width_cm, 2)) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT
	product_category_name_translation.product_category_name_english,
	COUNT(DISTINCT(product_id)) AS no_prodcuts,
	COUNT(DISTINCT (ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2))) AS N,
	ROUND(AVG(ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)), 0) AS mean,
	ROUND(STDDEV(ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)), 0) AS STD,
	MAX(ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS max,
	MIN(ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS min,
	MODE() WITHIN GROUP (ORDER BY ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2)) AS "99_percentile"
FROM 
	products 
LEFT JOIN 
	product_category_name_translation 
ON 
	products.product_category_name = product_category_name_translation.product_category_name
GROUP BY 
	product_category_name_translation.product_category_name_english
ORDER BY 
	no_prodcuts DESC
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------
-- 5) ORDERS
-- Questions:
-- What is the overall delivery rate?
-- For how many years do the orders span?
-- How does the delivery rate change across years, quarters, and months?
-- When are customers most likely to make purchases during the day (hour of the day)?
-- What is the average approval time, and how does it change across years, quarters, and months?
-- What is the average carrier delivery time since approval, and how does it change over years, quarters, and months?
-- What is the average delivery time of the carrier, and how does it change across years, quarters, and months?
-- What are the most frequent purchase days of the week?
-- What are the most frequent delivery days of the week?
-- How accurate is the estimated delivery date, and how does this accuracy change over time (years, quarters, and months)?
---------------------------------------------------------------------------------------------------------

SELECT * 
FROM 
	orders
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT 
	COUNT(*) AS no_rows,
	COUNT(DISTINCT(order_id)) AS no_order_id,
	COUNT(DISTINCT(customer_id)) AS no_customer_id,
	COUNT(*) - COUNT(order_status) AS no_missing_order_status,
	COUNT(*) - COUNT(order_purchase_timestamp) AS no_missing_order_purchase_timestamp,
	COUNT(*) - COUNT(order_approved_at) AS no_order_approved_at,
	COUNT(*) - COUNT(order_delivered_carrier_date) AS no_order_delivered_carrier_date,
	COUNT(*) - COUNT(order_delivered_customer_date) AS no_order_delivered_customer_date,
	COUNT(*) - COUNT(order_estimated_delivery_date) AS no_order_estimated_delivery_date
FROM 
	orders;

---------------------------------------------------------------------------------------------------------

SELECT 
    order_status,
    ROUND(status_count / SUM(status_count) OVER (), 2) AS percent_of_status
FROM
    (SELECT 
        order_status, 
        COUNT(order_status) AS status_count
    FROM 
	 	orders
    GROUP BY 
	 	order_status) counted_status
	ORDER BY 
		percent_of_status DESC;

---------------------------------------------------------------------------------------------------------

SELECT 
	DISTINCT(DATE_PART('year', order_purchase_timestamp)) AS number_of_years
FROM 
	orders;

---------------------------------------------------------------------------------------------------------

SELECT 
	counted_total_order_status.year,
	total_order_status,
	ROUND(sub_total_order_status * 100.0 / total_order_status, 2) AS percent_sub_total_status
FROM
	(SELECT 
		DATE_PART('year', order_purchase_timestamp) AS year,
		order_status,
		COUNT(order_status) AS sub_total_order_status
	FROM 
	 	orders
	GROUP BY 
	 	year, order_status) counted_sub_total_order_status
JOIN
	(SELECT 
		DATE_PART('year', order_purchase_timestamp) AS year,
		COUNT(order_status) AS total_order_status
	FROM 
	 	orders
	GROUP BY 
	 	year) counted_total_order_status
ON 
	counted_sub_total_order_status.year = counted_total_order_status.year
WHERE 
	counted_sub_total_order_status.order_status = 'delivered'
ORDER BY 
	year;

---------------------------------------------------------------------------------------------------------

SELECT 
    counted_total_order_status.year,
    counted_total_order_status.quarter,
    total_order_status,
    ROUND(sub_total_order_status * 100.0 / total_order_status, 2) AS percent_sub_total_status
FROM
    (SELECT 
        DATE_PART('year', order_purchase_timestamp) AS year,
        DATE_PART('quarter', order_purchase_timestamp) AS quarter,
        order_status,
        COUNT(order_status) AS sub_total_order_status
    FROM 
	 	orders
    GROUP BY
	 	year, quarter, order_status) counted_sub_total_order_status
JOIN
    (SELECT 
        DATE_PART('year', order_purchase_timestamp) AS year,
        DATE_PART('quarter', order_purchase_timestamp) AS quarter,
        COUNT(order_status) AS total_order_status
    FROM 
	 	orders
    GROUP BY
	 	year, quarter) counted_total_order_status
ON 
	counted_sub_total_order_status.year = counted_total_order_status.year
AND 
	counted_sub_total_order_status.quarter = counted_total_order_status.quarter
WHERE 
	counted_sub_total_order_status.order_status = 'delivered'
ORDER BY 
	year, quarter;

---------------------------------------------------------------------------------------------------------

SELECT 
    counted_total_order_status.year,
    counted_total_order_status.month,
    total_order_status,
    ROUND(sub_total_order_status * 100.0 / total_order_status, 2) AS percent_sub_total_status
FROM
    (SELECT 
        DATE_PART('year', order_purchase_timestamp) AS year,
        DATE_PART('month', order_purchase_timestamp) AS month,
        order_status,
        COUNT(order_status) AS sub_total_order_status
    FROM 
	 	orders
    GROUP BY
	 	year, month, order_status) counted_sub_total_order_status
JOIN
    (SELECT 
        DATE_PART('year', order_purchase_timestamp) AS year,
        DATE_PART('month', order_purchase_timestamp) AS month,
        COUNT(order_status) AS total_order_status
    FROM 
	 	orders
    GROUP BY
	 	year, month) counted_total_order_status
ON 
	counted_sub_total_order_status.year = counted_total_order_status.year
AND 
	counted_sub_total_order_status.month = counted_total_order_status.month
WHERE 
	counted_sub_total_order_status.order_status = 'delivered'
ORDER BY
	year, month;
	
---------------------------------------------------------------------------------------------------------

SELECT 
	DATE_PART('hour', order_purchase_timestamp) AS purchase_hour, 
	COUNT(order_id) AS no_purchase_per_hour
FROM 
	orders
GROUP BY 
	purchase_hour
ORDER BY 
	no_purchase_per_hour DESC;
	
---------------------------------------------------------------------------------------------------------
	
SELECT 
    AVG(order_approved_at - order_purchase_timestamp) AS avg_approve_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL;

---------------------------------------------------------------------------------------------------------

SELECT 
    DATE_PART('year', order_approved_at) AS year, 
    AVG(order_approved_at - order_purchase_timestamp) AS avg_approve_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 
	year
ORDER BY 
	year;
	
---------------------------------------------------------------------------------------------------------

SELECT 
    DATE_PART('year', order_approved_at) AS year, 
	DATE_PART('quarter', order_approved_at) AS quarter,
    AVG(order_approved_at - order_purchase_timestamp) AS avg_approve_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 
	year, quarter
ORDER BY
	year, quarter;

---------------------------------------------------------------------------------------------------------
	
SELECT 
    DATE_PART('year', order_approved_at) AS year, 
	DATE_PART('month', order_approved_at) AS month,
    AVG(order_approved_at - order_purchase_timestamp) AS avg_approve_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
GROUP BY 
	year, month
ORDER BY
	year, month;

---------------------------------------------------------------------------------------------------------
	
SELECT 
    AVG(order_delivered_carrier_date - order_approved_at) AS avg_delivered_carrier_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
AND
	order_delivered_carrier_date IS NOT NULL;

---------------------------------------------------------------------------------------------------------

SELECT 
    DATE_PART('year', order_approved_at) AS year, 
    AVG(order_delivered_carrier_date - order_approved_at) AS avg_delivered_carrier_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
AND
	order_delivered_carrier_date IS NOT NULL
GROUP BY 
	year
ORDER BY 
	year;
	
---------------------------------------------------------------------------------------------------------

SELECT 
    DATE_PART('year', order_approved_at) AS year,
	DATE_PART('quarter', order_approved_at) AS quarter,
    AVG(order_delivered_carrier_date - order_approved_at) AS avg_delivered_carrier_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
AND
	order_delivered_carrier_date IS NOT NULL
GROUP BY 
	year, quarter
ORDER BY 
	year, quarter;

---------------------------------------------------------------------------------------------------------

SELECT 
    DATE_PART('year', order_approved_at) AS year,
	DATE_PART('month', order_approved_at) AS month,
    AVG(order_delivered_carrier_date - order_approved_at) AS avg_delivered_carrier_time
FROM 
	orders
WHERE 
	order_approved_at IS NOT NULL
AND
	order_delivered_carrier_date IS NOT NULL
GROUP BY 
	year, month
ORDER BY 
	year, month;

---------------------------------------------------------------------------------------------------------

SELECT 
    AVG(order_delivered_customer_date - order_delivered_carrier_date) AS avg_delivered_customer_time
FROM 
	orders
WHERE 
	order_delivered_carrier_date IS NOT NULL
AND
	order_delivered_customer_date IS NOT NULL;

---------------------------------------------------------------------------------------------------------

SELECT 
    DATE_PART('year', order_delivered_carrier_date) AS year, 
    AVG(order_delivered_customer_date - order_delivered_carrier_date) AS avg_delivered_customer_time
FROM 
	orders
WHERE 
	order_delivered_carrier_date IS NOT NULL
AND
	order_delivered_customer_date IS NOT NULL
GROUP BY 
	year
ORDER BY 
	year;

---------------------------------------------------------------------------------------------------------

SELECT 
    DATE_PART('year', order_delivered_carrier_date) AS year, 
	DATE_PART('quarter', order_delivered_carrier_date) AS quarter,
    AVG(order_delivered_customer_date - order_delivered_carrier_date) AS avg_delivered_customer_time
FROM 
	orders
WHERE 
	order_delivered_carrier_date IS NOT NULL
AND
	order_delivered_customer_date IS NOT NULL
GROUP BY 
	year, quarter
ORDER BY 
	year, quarter;

---------------------------------------------------------------------------------------------------------
	
SELECT 
    DATE_PART('year', order_delivered_carrier_date) AS year, 
	DATE_PART('month', order_delivered_carrier_date) AS month,
    AVG(order_delivered_customer_date - order_delivered_carrier_date) AS avg_delivered_customer_time
FROM 
	orders
WHERE 
	order_delivered_carrier_date IS NOT NULL
AND
	order_delivered_customer_date IS NOT NULL
GROUP BY 
	year, month
ORDER BY 
	year, month;
	
---------------------------------------------------------------------------------------------------------
	
SELECT 
    TO_CHAR(order_purchase_timestamp, 'Day') AS day_of_week,
	COUNT(order_id) AS no_orders
FROM 
	orders
GROUP BY
	day_of_week
ORDER BY
	no_orders DESC;
	
---------------------------------------------------------------------------------------------------------

SELECT
	DATE_pART('hour', order_delivered_customer_date) AS order_delivered_customer_hour,
	COUNT (order_id) AS no_orders
FROM
	orders
WHERE 
	order_delivered_customer_date IS NOT NULL
GROUP BY 
	order_delivered_customer_hour
ORDER BY 
	no_orders DESC;
	
---------------------------------------------------------------------------------------------------------

SELECT 
    TO_CHAR(order_delivered_customer_date, 'Day') AS day_of_week,
	COUNT(order_id) AS no_orders
FROM 
	orders
WHERE 
	order_delivered_customer_date IS NOT NULL
GROUP BY
	day_of_week
ORDER BY
	no_orders DESC;
	
---------------------------------------------------------------------------------------------------------

SELECT 
    ROUND(SUM(CASE WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 /COUNT(order_delivered_customer_date), 1) AS estimated_accuracy
FROM 
	orders
WHERE 
    order_delivered_customer_date IS NOT NULL
AND 
	order_estimated_delivery_date IS NOT NULL;

---------------------------------------------------------------------------------------------------------

SELECT 
	DATE_PART('year', order_delivered_customer_date) AS year,
    ROUND(SUM(CASE WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 /COUNT(order_delivered_customer_date), 1) AS estimated_accuracy
FROM 
	orders
WHERE 
    order_delivered_customer_date IS NOT NULL
AND 
	order_estimated_delivery_date IS NOT NULL
GROUP BY
	year
ORDER BY 
	year;
	
---------------------------------------------------------------------------------------------------------

SELECT 
	DATE_PART('year', order_delivered_customer_date) AS year,
	DATE_PART('quarter', order_delivered_customer_date) AS quarter,
    ROUND(SUM(CASE WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 /COUNT(order_delivered_customer_date), 1) AS estimated_accuracy
FROM 
	orders
WHERE 
    order_delivered_customer_date IS NOT NULL
AND 
	order_estimated_delivery_date IS NOT NULL
GROUP BY
	year, quarter
ORDER BY 
	year, quarter;

---------------------------------------------------------------------------------------------------------

SELECT 
	DATE_PART('year', order_delivered_customer_date) AS year,
	DATE_PART('month', order_delivered_customer_date) AS month,
    ROUND(SUM(CASE WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 /COUNT(order_delivered_customer_date), 1) AS estimated_accuracy
FROM 
	orders
WHERE 
    order_delivered_customer_date IS NOT NULL
AND 
	order_estimated_delivery_date IS NOT NULL
GROUP BY
	year, month
ORDER BY 
	year, month;

---------------------------------------------------------------------------------------------------------
-- 6) ORDER ITEMS:
-- Questions:
-- What are top 10 most expensive products and shiping cost?
-- What is the ratio of total products sold to the total number of orders (product-order ratio)?
-- Which sellers account for more than 1% of the total orders placed?
-- What are the descriptive statistics (mean, median, min, max, standard deviation) for the product prices?
-- What are the descriptive statistics (mean, median, min, max, standard deviation) for freight (shipping) value?
---------------------------------------------------------------------------------------------------------

SELECT *
FROM 
	order_items
ORDER BY 
	price DESc
LIMIT 
	10;

---------------------------------------------------------------------------------------------------------

SELECT *
FROM 
	order_items
ORDER BY 
	freight_value DESc
LIMIT 
	10;
	
---------------------------------------------------------------------------------------------------------

SELECT 
	COUNT(DISTINCT order_id) as no_orders,
	COUNT(DISTINCT product_id) as no_products,
	ROUND(COUNT(DISTINCT order_id) / COUNT(DISTINCT product_id) :: NUMERIC, 2) AS product_order_ratio
FROM 
	order_items;

--------------------------------------------------------------------------------------------------------

SELECT 
	seller_id,
	ROUND(no_product * 100.0 / SUM(no_product) OVER (), 2) AS percent_share
FROM
	(SELECT 
		seller_id,
		COUNT(product_id)  as no_product
	FROM 
	 	order_items
	GROUP BY 
	 	seller_id
	ORDER BY 
	 	no_product DESC
	) AS counting_product;
	
--------------------------------------------------------------------------------------------------------
	
SELECT 
	'price' AS price,
	SUM(price) AS total,
	COUNT(DISTINCT (price)) AS N,
	ROUND(AVG(price), 0) AS mean,
	ROUND(STDDEV(price), 0) AS STD,
	MAX(price) AS max,
	MIN(price) AS min,
	MODE() WITHIN GROUP (ORDER BY price) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY price) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY price) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY price) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY price) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY price) AS "99_percentile"
FROM 
	order_items
UNION
SELECT 
	'freight_value' AS freight_value,
	SUM(freight_value) AS total,
	COUNT(DISTINCT (freight_value)) AS N,
	ROUND(AVG(freight_value), 0) AS mean,
	ROUND(STDDEV(freight_value), 0) AS STD,
	MAX(freight_value) AS max,
	MIN(freight_value) AS min,
	MODE() WITHIN GROUP (ORDER BY freight_value) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY freight_value) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY freight_value) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY freight_value) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY freight_value) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY freight_value) AS "99_percentile"
FROM 
	order_items;

--------------------------------------------------------------------------------------------------------
-- 7) ORDER PAYMENTS:
-- Questions:
-- What are the shares of payment types?
-- What are the descriptive statistics of payment_sequential?
-- What are the descriptive statistics of payment_installments?
-- What are the descriptive statistics of payment_value?
-- What is the total value of the top 1% order in terms of payment_value?
--------------------------------------------------------------------------------------------------------

SELECT *
FROM 
	order_payments
LIMIT 
	10;

--------------------------------------------------------------------------------------------------------

SELECT 
	payment_type,
	ROUND(no_payment_type * 100.0 / SUM(no_payment_type) OVER (), 2) AS share_of_payment_type
FROM 
	(SELECT 
		payment_type,
		COUNT(order_id)  AS no_payment_type
	FROM 
		order_payments
	GROUP BY
		payment_type
	ORDER BY 
		no_payment_type DESC) AS counting_payment_type;
		
--------------------------------------------------------------------------------------------------------	
		
SELECT 
	'payment_sequential' AS payment_sequential,
	COUNT(DISTINCT (payment_sequential)) AS N,
	ROUND(AVG(payment_sequential), 0) AS mean,
	ROUND(STDDEV(payment_sequential), 0) AS STD,
	MAX(payment_sequential) AS max,
	MIN(payment_sequential) AS min,
	MODE() WITHIN GROUP (ORDER BY payment_sequential) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY payment_sequential) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY payment_sequential) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY payment_sequential) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY payment_sequential) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY payment_sequential) AS "99_percentile"
FROM 
	order_payments
UNION
SELECT 
	'payment_installments' AS payment_installments,
	COUNT(DISTINCT (payment_installments)) AS N,
	ROUND(AVG(payment_installments), 0) AS mean,
	ROUND(STDDEV(payment_installments), 0) AS STD,
	MAX(payment_installments) AS max,
	MIN(payment_installments) AS min,
	MODE() WITHIN GROUP (ORDER BY payment_installments) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY payment_installments) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY payment_installments) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY payment_installments) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY payment_installments) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY payment_installments) AS "99_percentile"
FROM 
	order_payments
UNION
SELECT 
	'payment_value' AS payment_value,
	COUNT(DISTINCT (payment_value)) AS N,
	ROUND(AVG(payment_value), 0) AS mean,
	ROUND(STDDEV(payment_value), 0) AS STD,
	MAX(payment_value) AS max,
	MIN(payment_value) AS min,
	MODE() WITHIN GROUP (ORDER BY payment_value) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY payment_value) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY payment_value) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY payment_value) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY payment_value) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY payment_value) AS "99_percentile"
FROM 
	order_payments;

--------------------------------------------------------------------------------------------------------
-- 8) ORDER REVIEWS:
-- Questions:
-- What are the descriptive statistics of rating?
-- What is the average answering time?
-- How does the average answer time change over time?
--------------------------------------------------------------------------------------------------------

SELECT *
FROM
	order_reviews
LIMIT 
	10;

--------------------------------------------------------------------------------------------------------

SELECT 
	'review_score' AS review_score,
	COUNT(DISTINCT (review_score)) AS N,
	ROUND(AVG(review_score), 0) AS mean,
	ROUND(STDDEV(review_score), 0) AS STD,
	MAX(review_score) AS max,
	MIN(review_score) AS min,
	MODE() WITHIN GROUP (ORDER BY review_score) AS mode,
	PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY review_score) AS "01_percentile",
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY review_score) AS "25_percentile",
	PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY review_score) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY review_score) AS "75_percentile",
	PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY review_score) AS "99_percentile"
FROM 
	order_reviews;
	
--------------------------------------------------------------------------------------------------------

SELECT 
	AVG(review_answer_timestamp -  review_creation_date) AS AVG_answering_time
FROM
	order_reviews;
