# A. Pizza Metrics

**Note**: Table Cleaning was executed first before data exploration. [Click here to view.](https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%232_Pizza_Runner/scripts/Case2_cleaning.sql)
### 1.How many pizzas were ordered?
```sql
SELECT COUNT(*) pizzas_Ordered
FROM customer_orders;
```
### Output:
 pizzas_ordered |
-- |
14 |

In total, there are 14 pizzas ordered.
<hr>

### 2.How many unique customer orders were made?
```sql
SELECT COUNT(DISTINCT(order_id)) pizza_ordered
FROM customer_orders;
```
### Output:
 pizza_ordered |
-- |
10 |

There are 10 unique customer orders.
<hr>

### 3.How many successful orders were delivered by each runner?
```sql
SELECT runner_id, COUNT(*) delivered_Order_Count
FROM runner_orders
WHERE distance IS NOT NULL
GROUP BY runner_id;
```
### Output:

 runner_id | delivered_order_count |
 | -- | -- |
3 |                     1
2 |                     3
1 |                     4

Runner 1 delivered the most with 4, followed by Runner 2 with 3 orders delivered while Runner 3 delivered 1.  
<hr>

### 4.How many of each type of pizza was delivered?
```sql
SELECT co.pizza_id, COUNT(*) pizza_Delivered
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE distance IS NOT NULL
GROUP BY co.pizza_id;
```
### Output:
 pizza_id | pizza_delivered
| -- | -- | 
2 | 3 |
1 | 9 |

Pizza 1 have the most delivered orders with 9 while Pizza 2 have only 3 orders delivered.
<hr>

### 5.How many Vegetarian and Meatlovers were ordered by each customer?
```sql
SELECT co.customer_id, pn.pizza_name, COUNT(*) pizza_Count
FROM customer_orders co JOIN pizza_names pn
ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id, pn.pizza_name;
```
### Output:
 customer_id | pizza_name | pizza_count
-- | -- | --
101 | Meatlovers |           2
101 | Vegetarian |           1
102 | Meatlovers |           2
102 | Vegetarian |           1
103 | Meatlovers |           3
103 | Vegetarian |           1
104 | Meatlovers |           3
105 | Vegetarian |           1

Meatlovers pizza is the most ordered for each customer.
<hr>

### 6.What was the maximum number of pizzas delivered in a single order?
```sql
SELECT COUNT(*) pizza_Ordered
FROM customer_orders
GROUP BY order_id
ORDER BY pizza_Ordered DESC
LIMIT 1;
```
### Output:
 pizza_ordered
-- |
3 

There are 3 pizzas delivered in a single order.
<hr>

### 7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
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
```
### Output:
 customer_id | atleast_1_change | no_change
-- | -- | --
101 |                2 |         0
103 |                3 |         0
104 |                2 |         2
105 |                1 |         1
102 |                2 |         2

For Customer 101 and 103, all of their orders had atleast 1 changes(excluded or extras toppings) while the remaining customers have the same count of change/no change pizzas ordered.
<hr>

### 8.How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT co.customer_id, COUNT(*) with_both_changes
FROM customer_orders co JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.distance IS NOT NULL
AND co.exclusions != ''
AND co.extras IS NOT NULL
AND co.extras !=''
GROUP BY co.customer_id;
```
### Output:
 customer_id | with_both_changes
-- |
104 |                 1

Only Customer 104 ordered a pizza with excluded and added extra toppings that was successfully delivered.
<hr>

### 9.What was the total volume of pizzas ordered for each hour of the day?
```sql
SELECT DATE_PART('HOUR', co.order_time) AS by_hour, COUNT(*) pizza_ordered
FROM customer_orders co
GROUP BY by_hour
ORDER BY by_hour;
```
### Output:
 by_hour | pizza_ordered
-- | --
11 |             1
13 |             3
18 |             3
19 |             1
21 |             3
23 |             3

All throughout the day, order volume is equal at 3 pizza orders except for 11:00 AM and 7:00 PM which have the least amount of orders with 1.
<hr>

### 10.What was the volume of orders for each day of the week?
```sql
SELECT TO_CHAR(co.order_time, 'Day') AS day_of_the_week, COUNT(*) pizza_Ordered
FROM customer_orders co
GROUP BY day_of_the_week
ORDER BY pizza_Ordered DESC;
```
### Output:
 day_of_the_week | pizza_ordered
-- | --
Saturday        |             5
Wednesday       |             5
Thursday        |             3
Friday          |             1

Saturday and Wednesday have the highest pizza orders with 5 while Friday having the least with 1.
<hr>
