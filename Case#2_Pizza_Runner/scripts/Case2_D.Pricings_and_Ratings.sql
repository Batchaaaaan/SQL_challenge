/* D. Pricing and Ratings */
-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
		--how much money has Pizza Runner made so far if there are no delivery fees?
SELECT
SUM(CASE
	WHEN pizza_id = 1 THEN 12
	WHEN pizza_id = 2 THEN 10
END) total_sales
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL

-- What if there was an additional $1 charge for any pizza extras?
	-- Add cheese is $1 extra
WITH cte_summary AS (
	SELECT 
		SUM(CASE
			WHEN pizza_id = 1 THEN 12 
			WHEN pizza_id = 2 THEN 10
		END) pizza_sales,
		SUM(CASE
			WHEN co.extras IS NOT NULL THEN ARRAY_LENGTH(STRING_TO_ARRAY(co.extras, ', '), 1)
			ELSE 0
		END) AS num_extras_added
	FROM customer_orders co JOIN runner_orders ro
	ON ro.order_id = co.order_id
	WHERE ro.cancellation IS NULL
	)
SELECT pizza_sales + num_extras_added AS total_sales
FROM cte_summary;

-- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
			--how would you design an additional table for this new dataset - generate a schema for this new table 
			--and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings (
	order_id INT,
	rating INT
);

INSERT INTO ratings
SELECT order_id, FLOOR(RANDOM() * 5 + 1)
		FROM (SELECT DISTINCT(order_id) order_id
	  		  FROM customer_orders) AS order_ids
		ORDER BY order_id;

SELECT * FROM ratings;

-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
	-- customer_id
	-- order_id
	-- runner_id
	-- rating
	-- order_time
	-- pickup_time
	-- Time between order and pickup
	-- Delivery duration
	-- Average speed
	-- Total number of pizzas
	
SELECT co.customer_id, co.order_id, ro.runner_id,
	r.rating, co.order_time, ro.pickup_time, 
	TO_CHAR(AVG(ro.pickup_time-co.order_time), 'MI') timediff_order_and_pickup,
	ro.duration, AVG(distance*60/duration) average_speed,
	COUNT(pizza_id) pizza_count
FROM customer_orders co LEFT JOIN runner_orders ro
ON ro.order_id = co.order_id
LEFT JOIN ratings r
ON r.order_id = co.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.customer_id, co.order_id, r.rating, ro.runner_id, co.order_time, ro.pickup_time, ro.duration
ORDER by co.customer_id;
-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is 
		--paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
WITH cte_sales AS (
	SELECT
		SUM(CASE
			WHEN pizza_id = 1 THEN 12
			WHEN pizza_id = 2 THEN 10
		END) sales
	FROM customer_orders co JOIN runner_orders ro
	ON ro.order_id = co.order_id
	WHERE ro.cancellation IS NULL
	)
SELECT sales - (SELECT SUM(distance*0.3)
			    FROM runner_orders
			   	WHERE cancellation IS NULL) total_revenue
FROM cte_sales;