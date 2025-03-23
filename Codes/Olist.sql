-- OLIST EXPLORATORY ANALYSIS

---------------------------------------------------------------------------------------------------------
-- 1) PRODUCT_CATEGORY_NAME_TRANSLATION:
-- Questions:
-- How many distinct category is there?
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
COUNT(customer_unique_id) AS no_customers
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
    HAVING COUNT(customer_unique_id) > 500
) AS cities_with_more_than_500;

---------------------------------------------------------------------------------------------------------

SELECT
customer_state,
COUNT(customer_unique_id) AS no_customers
FROM customer
GROUP BY customer_state
ORDER BY no_customers DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------

SELECT
customer_state, COUNT(DISTINCT(customer_city)) AS no_city_per_state
FROM customer
GROUP BY customer_state
ORDER BY COUNT(DISTINCT(customer_city)) DESC;

---------------------------------------------------------------------------------------------------------

SELECT SUM(no_customers) * 100 / (SELECT COUNT(DISTINCT(customer_unique_id)) FROM customer) AS percent_top_10_cities FROM (
SELECT
customer_city,
COUNT(customer_unique_id) AS no_customers
FROM customer
GROUP BY customer_city
ORDER BY no_customers DESC
LIMIT 10) AS to_ten_cities;

---------------------------------------------------------------------------------------------------------

SELECT SUM(no_customers) * 100 / (SELECT COUNT(DISTINCT(customer_unique_id)) FROM customer) AS percent_top_10_states FROM (
SELECT
customer_state,
COUNT(customer_unique_id) AS no_customers
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
           COUNT(customer_unique_id) AS no_customers,
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
        COUNT(customer_unique_id) AS no_customers,
        RANK() OVER (PARTITION BY customer_state ORDER BY COUNT(customer_unique_id) DESC) AS city_rank
    FROM customer
    GROUP BY customer_state, customer_city
) ranked_cities
JOIN (
    SELECT 
        customer_state,
        COUNT(customer_unique_id) AS total_customers
    FROM customer
    GROUP BY customer_state
) total_customers_per_state
ON ranked_cities.customer_state = total_customers_per_state.customer_state
WHERE city_rank <= 3
GROUP BY ranked_cities.customer_state, total_customers
ORDER BY percent_top_3_cities ASC;

---------------------------------------------------------------------------------------------------------
