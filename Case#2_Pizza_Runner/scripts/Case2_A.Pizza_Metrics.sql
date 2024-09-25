/* A. Pizza Metrics */

-- How many pizzas were ordered?
SELECT COUNT(*) pizzas_Ordered
FROM customer_orders;

-- How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) pizza_ordered
FROM customer_orders;

-- How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(*) delivered_Order_Count
FROM runner_orders
WHERE distance IS NOT NULL
GROUP BY runner_id;

-- How many of each type of pizza was delivered?
SELECT co.pizza_id, COUNT(*) pizza_Delivered
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE distance IS NOT NULL
GROUP BY co.pizza_id;

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id, pn.pizza_name, COUNT(*) pizza_Count
FROM customer_orders co JOIN pizza_names pn
ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id, pn.pizza_name;

-- What was the maximum number of pizzas delivered in a single order?
SELECT COUNT(*) pizza_Ordered
FROM customer_orders
GROUP BY order_id
ORDER BY pizza_Ordered DESC
LIMIT 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT co.customer_id, 
SUM(CASE
   		WHEN (exclusions IS NOT NULL AND exclusions != '0') OR (extras IS NOT NULL AND extras != '0')
			THEN 1
		ELSE 0
	END) AS Atleast_1_Change,
SUM(CASE	
		WHEN (exclusions IS NULL OR exclusions = '0') OR (extras IS NULL OR extras = '0')
			THEN 1
		ELSE 0
	END) AS No_Change
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE distance IS NOT NULL
GROUP BY co.customer_id;

-- How many pizzas were delivered that had both exclusions and extras?
SELECT co.customer_id, COUNT(*) with_both_changes
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL
AND co.exclusions != ''
AND co.extras IS NOT NULL
AND co.extras !=''
GROUP BY co.customer_id;

-- What was the total volume of pizzas ordered for each hour of the day?
SELECT DATE_PART('HOUR', co.order_time) AS by_Hour, COUNT(*) pizza_Ordered
FROM customer_orders co
GROUP BY by_Hour
ORDER BY by_Hour;

-- What was the volume of orders for each day of the week?
SELECT TO_CHAR(co.order_time, 'Day') AS day_of_the_week, COUNT(*) pizza_Ordered
FROM customer_orders co
GROUP BY day_of_the_week
ORDER BY pizza_Ordered DESC;