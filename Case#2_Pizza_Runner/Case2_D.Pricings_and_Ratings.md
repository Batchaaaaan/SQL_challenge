# D. Pricing and Ratings
###### **Note**: Table Cleaning was executed first before data exploration. [Click here to view.](https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%232_Pizza_Runner/scripts/Case2_cleaning.sql)


### 1.If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
SELECT
SUM(CASE
	WHEN pizza_id = 1 THEN 12
	WHEN pizza_id = 2 THEN 10
END) total_sales
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.cancellation IS NULL
```
### Output:
 total_sales
-- |
138 |

A total of 138 units is the accumulated sales of Pizza Runner without charges on extras.
<hr>

### 2.What if there was an additional $1 charge for any pizza extras?
  - Add cheese is $1 extra
```sql 
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
```
### Output:
 total_sales
-- |
142

A total 142 units is the accumulated sales of Pizza Runner.
<hr>

### 3.The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
```sql
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
```
### Output:
 order_id | rating
-- | --
1 |      5
2 |      5
3 |      1
4 |      2
5 |      1
6 |      2
7 |      1
8 |      3
9 |      2
10 |      5

rating data are randomized.
<hr>

### 4.Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
  - customer_id
  - order_id
  - runner_id
  - rating
  - order_time
  - pickup_time
  - Time between order and pickup
  - Delivery duration
  - Average speed
  - Total number of pizzas
```sql  	
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
```
### Output:
 customer_id | order_id | runner_id | rating |     order_time      |     pickup_time     | timediff_order_and_pickup | duration |         average_speed         | pizza_count
-- | -- | -- | -- | -- | -- | -- | -- | -- | --
101 |        1 |         1 |      5 | 2020-01-01 18:05:02 | 2020-01-01 18:15:34 | 10      |       32 | 37.5000000000000000 |     1
101 |        2 |         1 |      5 | 2020-01-01 19:00:52 | 2020-01-01 19:10:54 | 10      |       27 | 44.4444444444444444 |     1
102 |        3 |         1 |      1 | 2020-01-02 23:51:23 | 2020-01-03 00:12:37 | 21      |       20 | 40.2000000000000000 |     2
102 |        8 |         2 |      3 | 2020-01-09 23:54:33 | 2020-01-10 00:15:02 | 20      |       15 | 93.6000000000000000 |     1
103 |        4 |         2 |      2 | 2020-01-04 13:23:46 | 2020-01-04 13:53:03 | 29      |       40 | 35.1000000000000000 |     3
104 |        5 |         3 |      1 | 2020-01-08 21:00:29 | 2020-01-08 21:10:57 | 10      |       15 | 40.0000000000000000 |     1
104 |       10 |         1 |      5 | 2020-01-11 18:34:49 | 2020-01-11 18:50:20 | 15      |       10 | 60.0000000000000000 |     2
105 |        7 |         2 |      1 | 2020-01-08 21:20:29 | 2020-01-08 21:30:45 | 10      |       25 | 60.0000000000000000 |     1

<hr>

### 5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
```sql
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
```
### Output:
 total_revenue
-- |
94.440

Total revenue after deducting runners salary is 94.440 units.
