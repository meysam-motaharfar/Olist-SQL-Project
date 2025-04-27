-- OLIST EXPLORATORY ANALYSIS - TWO TABLES

---------------------------------------------------------------------------------------------------------
-- 1) CUSTOMER-ORDERS:
-- Questions:
-- What are the top 10 states and cities with the highest number of orders?
-- Which are the top 10 states with the highest delivery rates?
-- What are the top 10 cities with the highest delivery rates, where the total number of orders exceeds 500?
-- What are the top 10 states with the lowest average approval time, carrier delivery time since approval, and total carrier delivery time?
-- What are the top 10 cities (with more than 500 orders) with the lowest average approval time, carrier delivery time since approval, and total carrier delivery time?
-- How accurate are the estimated delivery dates in the top 10 states and cities (with more than 500 orders)?
---------------------------------------------------------------------------------------------------------
	
SELECT 
	* 
FROM
	orders
JOIN 
	customer
ON
	orders.customer_id = customer.customer_id;

---------------------------------------------------------------------------------------------------------

SELECT
	customer_state,
	COUNT(order_id) as no_orders
FROM 
    orders
JOIN 
    customer
ON 
    orders.customer_id = customer.customer_id
GROUP BY 
    customer_state
ORDER BY 
    no_orders DESC
LIMIT 
    10;

---------------------------------------------------------------------------------------------------------
	
SELECT
	customer_city,
	COUNT(order_id) as no_orders
FROM 
    orders
JOIN 
    customer
ON 
    orders.customer_id = customer.customer_id
GROUP BY 
    customer_city
ORDER BY 
    no_orders DESC
LIMIT 
    10;

---------------------------------------------------------------------------------------------------------
	
SELECT
	customer_state,
	ROUND(SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100.00 / COUNT(order_status), 2) AS percentage_of_delivered_orders
FROM 
    orders
JOIN 
    customer
ON 
    orders.customer_id = customer.customer_id
GROUP BY 
    customer_state
ORDER BY 
    percentage_of_delivered_orders DESC
LIMIT 
    10;
	
---------------------------------------------------------------------------------------------------------
	
SELECT
	customer_city,
	ROUND(SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) * 100.00 / COUNT(order_status), 2) AS percentage_of_delivered_orders
FROM 
    orders
JOIN 
    customer
ON 
    orders.customer_id = customer.customer_id
GROUP BY 
    customer_city
HAVING
	COUNT(order_id)>500
ORDER BY 
    percentage_of_delivered_orders DESC
LIMIT 
    10;

---------------------------------------------------------------------------------------------------------

SELECT 
	customer_state,
	AVG(order_approved_at - order_purchase_timestamp) AS avg_approve_time
FROM
	orders
JOIN 
	customer
ON
	orders.customer_id = customer.customer_id
GROUP BY 
	customer_state
ORDER BY 
	avg_approve_time
LIMIT
	10;
	
---------------------------------------------------------------------------------------------------------

SELECT 
	customer_city,
	AVG(order_approved_at - order_purchase_timestamp) AS avg_approve_time
FROM
	orders
JOIN 
	customer
ON
	orders.customer_id = customer.customer_id
GROUP BY 
	customer_city
HAVING
	COUNT(order_id)>500
ORDER BY 
	avg_approve_time
LIMIT
	10;
	
---------------------------------------------------------------------------------------------------------

SELECT 
	customer_state,
	AVG(order_delivered_carrier_date - order_approved_at) AS avg_delivered_carrier_time
FROM
	orders
JOIN 
	customer
ON
	orders.customer_id = customer.customer_id
GROUP BY 
	customer_state
ORDER BY 
	avg_delivered_carrier_time
LIMIT
	10;
	
---------------------------------------------------------------------------------------------------------

SELECT 
	customer_city,
	AVG(order_delivered_carrier_date - order_approved_at) AS avg_delivered_carrier_time
FROM
	orders
JOIN 
	customer
ON
	orders.customer_id = customer.customer_id
GROUP BY 
	customer_city
HAVING
	COUNT(order_id)>500
ORDER BY 
	avg_delivered_carrier_time
LIMIT
	10;

---------------------------------------------------------------------------------------------------------

SELECT 
	customer_state,
	ROUND(SUM(CASE WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 /COUNT(order_delivered_customer_date), 1) AS estimated_accuracy 
FROM
	orders
JOIN 
	customer
ON
	orders.customer_id = customer.customer_id
WHERE 
    order_delivered_customer_date IS NOT NULL
AND 
	order_estimated_delivery_date IS NOT NULL
GROUP BY 
	customer_state
ORDER BY
	estimated_accuracy DESC;

---------------------------------------------------------------------------------------------------------

SELECT 
	customer_city,
	ROUND(SUM(CASE WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 /COUNT(order_delivered_customer_date), 1) AS estimated_accuracy 
FROM
	orders
JOIN 
	customer
ON
	orders.customer_id = customer.customer_id
WHERE 
    order_delivered_customer_date IS NOT NULL
AND 
	order_estimated_delivery_date IS NOT NULL
GROUP BY 
	customer_city
HAVING
	COUNT(order_id)>500
ORDER BY
	estimated_accuracy DESC
LIMIT
	10;
