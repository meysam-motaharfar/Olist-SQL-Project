-- OLIST EXPLORATORY ANALYSIS

---------------------------------------------------------------------------------------------------------
-- 1) PRODUCT_CATEGORY_NAME_TRANSLATION:
-- Questions:
-- How many distinct category is there?
---------------------------------------------------------------------------------------------------------

SELECT * 
FROM product_category_name_translation 
ORDER BY product_category_name;

---------------------------------------------------------------------------------------------------------

SELECT 
DISTINCT(COUNT(*)) 
FROM product_category_name_translation;

---------------------------------------------------------------------------------------------------------
-- 2) CUSTOMERS
-- Questions:
-- How many customers are there?
-- How many distinct cities and states are there?
-- What is the average number of customers per city or state?
-- Which are the top ten cities with the most customers?
-- How many cities have more than 500 customers?
-- Which are the top ten states with the most customers?
-- How many cities are there per state?
-- What percentage of the customer base do the top ten cities account for?
-- What percentage of the customer base do the top ten states account for?
-- What are the top three cities with the most customers in each state?
-- What percentage of the total customer base does the top three cities in each state account for?
---------------------------------------------------------------------------------------------------------

SELECT * 
FROM customer 
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS no_rows, 
COUNT(DISTINCT(customer_id)) AS no_customer_id,
COUNT(DISTINCT(customer_unique_id)) AS no_unique_customer_id,
COUNT(DISTINCT(customer_city)) AS no_distinct_city,
COUNT(DISTINCT(customer_unique_id)) / 
    COUNT(DISTINCT(customer_city)) AS avg_customers_per_city,
COUNT(DISTINCT(customer_state)) AS no_distinct_state,
COUNT(DISTINCT(customer_unique_id)) / 
    COUNT(DISTINCT(customer_state)) AS avg_customers_per_state
FROM customer;

---------------------------------------------------------------------------------------------------------

SELECT
customer_city,
COUNT(DISTINCT(customer_unique_id)) AS no_customers
FROM customer
GROUP BY customer_city
ORDER BY no_customers DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
    COUNT(*) AS number_of_cities_with_more_than_500_customers
FROM (
    SELECT
        customer_city
    FROM customer
    GROUP BY customer_city
    HAVING COUNT(DISTINCT(customer_unique_id)) > 500
) AS cities_with_more_than_500_customer;

---------------------------------------------------------------------------------------------------------

SELECT
customer_state,
COUNT(DISTINCT(customer_unique_id)) AS no_customers
FROM customer
GROUP BY customer_state
ORDER BY no_customers DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT
customer_state, COUNT(DISTINCT(customer_city)) AS no_city_per_state
FROM customer
GROUP BY customer_state
ORDER BY no_city_per_state DESC;

---------------------------------------------------------------------------------------------------------

SELECT SUM(no_customers) * 100 / (SELECT COUNT(DISTINCT(customer_unique_id)) FROM customer) AS percent_top_10_cities FROM (
SELECT
customer_city,
COUNT(DISTINCT(customer_unique_id)) AS no_customers
FROM customer
GROUP BY customer_city
ORDER BY no_customers DESC
LIMIT 10) AS to_ten_cities;

---------------------------------------------------------------------------------------------------------

SELECT SUM(no_customers) * 100 / (SELECT COUNT(DISTINCT(customer_unique_id)) FROM customer) AS percent_top_10_states FROM (
SELECT
customer_state,
COUNT(DISTINCT(customer_unique_id)) AS no_customers
FROM customer
GROUP BY customer_state
ORDER BY no_customers DESC
LIMIT 10) AS to_ten_states;

---------------------------------------------------------------------------------------------------------

SELECT customer_state, 
       customer_city, 
       no_customers
FROM (
    SELECT customer_state, 
           customer_city, 
           COUNT(DISTINCT(customer_unique_id)) AS no_customers,
           RANK() OVER (PARTITION BY customer_state ORDER BY COUNT(customer_unique_id) DESC) AS city_rank
    FROM customer
    GROUP BY customer_state, customer_city
) ranked_cities
WHERE city_rank <= 3
ORDER BY customer_state, city_rank;

---------------------------------------------------------------------------------------------------------

SELECT 
    ranked_cities.customer_state,
    SUM(no_customers) * 100.0 / total_customers AS percent_top_3_cities
FROM (
    SELECT 
        customer_state,
        customer_city, 
        COUNT(DISTINCT(customer_unique_id)) AS no_customers,
        RANK() OVER (PARTITION BY customer_state ORDER BY COUNT(customer_unique_id) DESC) AS city_rank
    FROM customer
    GROUP BY customer_state, customer_city
) ranked_cities
JOIN (
    SELECT 
        customer_state,
        COUNT(DISTINCT(customer_unique_id)) AS total_customers
    FROM customer
    GROUP BY customer_state
) total_customers_per_state
ON ranked_cities.customer_state = total_customers_per_state.customer_state
WHERE city_rank <= 3
GROUP BY ranked_cities.customer_state, total_customers
ORDER BY percent_top_3_cities ASC;

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

SELECT COUNT(*) AS no_rows, 
COUNT(DISTINCT(seller_id)) AS no_sellers_id,
COUNT(DISTINCT(seller_city)) AS no_distinct_city,
COUNT(DISTINCT(seller_id)) / 
    COUNT(DISTINCT(seller_city)) AS avg_sellers_per_city,
COUNT(DISTINCT(seller_state)) AS no_distinct_state,
COUNT(DISTINCT(seller_id)) / 
    COUNT(DISTINCT(seller_state)) AS avg_seller_per_state
FROM sellers;

---------------------------------------------------------------------------------------------------------

SELECT 
seller_city, 
COUNT(DISTINCT (seller_id)) AS no_sellers
FROM sellers
GROUP BY seller_city 
ORDER BY no_sellers DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
    COUNT(*) AS number_of_cities_with_more_than_10_sellers
FROM (
    SELECT
        seller_city, COUNT(DISTINCT(seller_id)) AS no_sellers
    FROM sellers
    GROUP BY seller_city
    HAVING COUNT(DISTINCT(seller_id)) > 10
) AS cities_with_more_than_10_sellers;

---------------------------------------------------------------------------------------------------------

SELECT 
seller_state, 
COUNT(DISTINCT (seller_id)) AS no_sellers
FROM sellers
GROUP BY seller_state
ORDER BY no_sellers DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT
seller_state, COUNT(DISTINCT(seller_city)) AS no_city_per_state
FROM sellers
GROUP BY seller_state
ORDER BY no_city_per_state DESC;

---------------------------------------------------------------------------------------------------------

SELECT SUM(no_sellers) * 100 / (SELECT COUNT(DISTINCT(seller_id)) FROM sellers) AS percent_top_10_cities FROM (
SELECT
seller_city,
COUNT(DISTINCT(seller_id)) AS no_sellers
FROM sellers
GROUP BY seller_city
ORDER BY no_sellers DESC
LIMIT 10) AS to_ten_cities;

---------------------------------------------------------------------------------------------------------

SELECT SUM(no_sellers) * 100 / (SELECT COUNT(DISTINCT(seller_id)) FROM sellers) AS percent_top_10_states FROM (
SELECT
seller_state,
COUNT(DISTINCT(seller_id)) AS no_sellers
FROM sellers
GROUP BY seller_state
ORDER BY no_sellers DESC
LIMIT 10) AS to_ten_states;

---------------------------------------------------------------------------------------------------------

SELECT seller_state, 
       seller_city, 
       no_sellers
FROM (
    SELECT seller_state, 
           seller_city, 
           COUNT(DISTINCT(seller_id)) AS no_sellers,
           RANK() OVER (PARTITION BY seller_state ORDER BY COUNT(seller_id) DESC) AS city_rank
    FROM sellers
    GROUP BY seller_state, seller_city
) ranked_cities
WHERE city_rank <= 3
ORDER BY seller_state, city_rank;

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
    FROM sellers
    GROUP BY seller_state, seller_city
) ranked_cities
JOIN (
    SELECT 
        seller_state,
        COUNT(DISTINCT(seller_id)) AS total_sellers
    FROM sellers
    GROUP BY seller_state
) total_sellers_per_state
ON ranked_cities.seller_state = total_sellers_per_state.seller_state
WHERE city_rank <= 3
GROUP BY ranked_cities.seller_state, total_sellers
ORDER BY percent_top_3_cities ASC;

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
FROM products ;

---------------------------------------------------------------------------------------------------------

SELECT
product_category_name_translation.product_category_name_english,
COUNT(DISTINCT(product_id)) AS no_prodcuts
FROM 
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
product_id,
product_category_name_translation.product_category_name_english,
ROUND(product_length_cm*product_height_cm*product_width_cm, 2) AS product_volume_cm_cub,
ROUND(product_weight_g / (product_length_cm*product_height_cm*product_width_cm), 2) AS product_density_g_per_cm_cub
FROM products
LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name;

---------------------------------------------------------------------------------------------------------

SELECT 
product_category_name_translation.product_category_name_english,
ROUND(AVG(product_weight_g), 2) AS avg_weight_g
FROM products
LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY avg_weight_g DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
product_category_name_translation.product_category_name_english,
ROUND(AVG(product_length_cm*product_height_cm*product_width_cm), 2) AS avg_product_volume_cm_cub
FROM products
LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY avg_product_volume_cm_cub DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT 
product_category_name_translation.product_category_name_english,
ROUND(AVG(product_weight_g / (product_length_cm*product_height_cm*product_width_cm)), 2) AS avg_density_g_per_cm_cub
FROM products
LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY avg_density_g_per_cm_cub DESC
LIMIT 10;

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
FROM products
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
FROM products
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
FROM products
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
FROM products
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
FROM products
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
FROM products
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
FROM products
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
FROM products
LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name) calculated_volume
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
(SELECT product_id,
product_weight_g / (product_length_cm*product_height_cm*product_width_cm) AS product_density_g_per_cm_cub
FROM products
LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name) calculated_volume;

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
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
FROM products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;

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
FROM products LEFT JOIN product_category_name_translation 
ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_translation.product_category_name_english
ORDER BY no_prodcuts DESC
LIMIT 10;
