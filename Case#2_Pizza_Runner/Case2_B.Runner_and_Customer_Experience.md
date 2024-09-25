# B. Runner and Customer Experience

**Note**: Table Cleaning was executed first before data exploration. [Click here to view.](https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%232_Pizza_Runner/scripts/Case2_cleaning.sql)


### 1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```sql
SELECT TO_CHAR(registration_date, 'w') weekNum, COUNT(runner_id) runners
FROM runners
GROUP BY weekNum;
```
### Output:
 weeknum | runners
-- | --
 2       |       1
 3       |       1
 1       |       2


<hr>

### 2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
SELECT ro.runner_id, AVG(DATE_PART('minute', pickup_time - order_time)) AS average 
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL
GROUP BY ro.runner_id;
```
### Output:
 runner_id |      average
-- | --
3 |                 10
2 |               23.4
1 | 15.333333333333334

On average, Runner 2 took the most time before arriving at the Pizza Runner HQ.
<hr>

### 3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
SELECT pizza_count, AVG(averageTime) as averageTime
FROM(
	SELECT COUNT(co.order_id) pizza_count, AVG(pickup_time-order_time) AS averageTime
	FROM customer_orders co LEFT JOIN runner_orders ro
	ON ro.order_id = co.order_id
	WHERE ro.distance IS NOT NULL
	GROUP BY co.order_id
	) as derivedTable
GROUP BY pizza_count;
```
### Output:
 pizza_count | averagetime
-- | --  
3 | 00:29:17
2 | 00:18:22.5
1 | 00:12:21.4

There is a relationship between the number of pizzas ordered and how long to prepare them since time increases as the pizza count increases.
<hr>

### 4.What was the average distance travelled for each customer?
```
SELECT co.customer_id, AVG(ro.distance) as averageDistance
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL
GROUP BY co.customer_id;
```
### Output:
 customer_id |  average_distance
-- | --
101 | 20.0000000000000000
103 | 23.4000000000000000
104 | 10.0000000000000000
105 | 25.0000000000000000
102 | 16.7333333333333333

On average, runners have to travel the farthest for Customer 105 with 25KM distance while only 10KM distance for Customer 104.  
<hr>

### 5.What was the difference between the longest and shortest delivery times for all orders?
```sql
SELECT MAX(duration) - MIN(duration) AS min_max_diff
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL;
```
### Output:
 min_max_diff
-- |
30 |

A 30 minute difference between the longest and shortest delivery. 
<hr>

### 6.What was the average speed for each runner for each delivery and do you notice any trend for these values?
```sql
SELECT co.order_id, ro.runner_id, AVG((distance/duration)*60) AS average_Speed
FROM customer_orders co JOIN runner_orders ro
ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL
GROUP BY co.order_id, ro.runner_id
ORDER BY co.order_id, ro.runner_id;
```
### Output:
 order_id | runner_id |      average_speed
-- | -- | --
1 |         1 | 37.50000000000000000000
2 |         1 | 44.44444444444444444440
3 |         1 | 40.20000000000000000000
4 |         2 | 35.10000000000000000000
5 |         3 | 40.00000000000000000020
7 |         2 | 60.00000000000000000000
8 |         2 |     93.6000000000000000
10 |         1 | 60.00000000000000000000

On average, runners became faster after successful deliveries.
<hr>

### 7.What is the successful delivery percentage for each runner?
```sql
SELECT runner_id, (successful::float/total_orders) * 100 AS successfulPercentage
FROM (
	SELECT runner_id, COUNT(*) as total_orders, 
	SUM(CASE
			WHEN distance IS NOT NULL THEN 1
			ELSE 0
			END) AS successful
	FROM runner_orders
	GROUP BY runner_id
	) as derivedTable;
```
### Output:
 runner_id | successful_percentage
-- | --
3 |                    50
2 |                    75
1 |                   100

Runner 1 have a perfect successful deliveries while Runner 3 have the lowest percentage. 
