/*B. Runner and Customer Experience */
-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT TO_CHAR(registration_date, 'w') weekNum, COUNT(runner_id) runners
FROM runners
GROUP BY week;

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT ro.runner_id, AVG(DATE_PART('minute', pickup_time - order_time)) AS average 
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL
GROUP BY ro.runner_id;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT pizza_count, AVG(averageTime) AS averageTime
FROM(
	SELECT COUNT(co.order_id) pizza_count, AVG(pickup_time-order_time) AS averageTime
	FROM customer_orders co LEFT JOIN runner_orders ro
	ON ro.order_id = co.order_id
	WHERE ro.distance IS NOT NULL
	GROUP BY co.order_id
	) AS derivedTable
GROUP BY pizza_count;

-- What was the average distance travelled for each customer?
SELECT co.customer_id, AVG(ro.distance) AS average_Distance
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL
GROUP BY co.customer_id;

-- What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration) - MIN(duration) AS min_max_diff
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL;

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT co.order_id, ro.runner_id, AVG((distance/duration)*60) AS average_Speed
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL
GROUP BY co.order_id, ro.runner_id
ORDER BY co.order_id, ro.runner_id;

-- What is the successful delivery percentage for each runner?
SELECT runner_id, (successful::float/total_orders) * 100 AS successful_Percentage
FROM (
	SELECT runner_id, COUNT(*) as total_orders, 
	SUM(CASE
			WHEN distance IS NOT NULL THEN 1
			ELSE 0
			END) AS successful
	FROM runner_orders
	GROUP BY runner_id
	) as derivedTable;