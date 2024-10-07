# C. Ingredient Optimisation

###### **Note**: Table Cleaning was executed first before data exploration. [Click here to view.](https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%232_Pizza_Runner/scripts/Case2_cleaning.sql)
### 1.What are the standard ingredients for each pizza?
#### Solution:
```sql
WITH cte_ingredients AS (
	SELECT pn.pizza_name, 
		STRING_TO_TABLE(pr.toppings, ',')::INT AS toppings --seperate each string into rows then cast them to integers
	FROM pizza_names pn JOIN pizza_recipes pr
	ON pn.pizza_id = pr.pizza_id
	)
SELECT pizza_name, 
	STRING_AGG(topping_name, ', ') ingredients -- combine them into single row seperated by ', '
FROM cte_ingredients
JOIN pizza_toppings pt
ON pt.topping_id = cte_ingredients.toppings
GROUP BY pizza_name;
```
#### Output:
 pizza_name |                              ingredients
-- | --
Meatlovers | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami
Vegetarian | Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce

<hr>

### 2.What was the most commonly added extra?
#### Solution:
```sql
WITH cte_extras AS (
	SELECT STRING_TO_TABLE(co.extras, ',')::INT AS extras -- seperate strings to rows
	FROM customer_orders co
	WHERE co.extras IS NOT NULL AND co.extras != ''
	)
SELECT pt.topping_name, 
	COUNT(*) AS extra_Count
FROM cte_extras
JOIN pizza_toppings pt
ON pt.topping_id = cte_extras.extras
GROUP BY pt.topping_name
ORDER BY extra_Count DESC;
```
#### Output:
 topping_name | extra_count
-- | --
Bacon        |           4
Chicken      |           1
Cheese       |           1

 Bacon is the most added extra with a count of 4 followed by Chicken and Cheese with a count of 1 each.
<hr>

### 3.What was the most common exclusion?
#### Solution:
```sql
WITH cte_exclusions AS (
	SELECT STRING_TO_TABLE(co.extras, ',')::INT AS exclusions --seperate strings to rows
	FROM customer_orders co
	WHERE co.exclusions IS NOT NULL AND co.exclusions != ''
	)
SELECT pt.topping_name, 
	COUNT(*) AS exclusion_Count
FROM cte_exclusions
JOIN pizza_toppings pt
ON pt.topping_id = cte_exclusions.exclusions
GROUP BY pt.topping_name
ORDER BY exclusion_Count DESC;
```
#### Output:
 topping_name | exclusion_count
-- | --
 Bacon        |               2
 Chicken      |               1
 Cheese       |               1

 Bacon is the most excluded toppings with a count of 2, followed by Chicken and Cheese with a count of 1 each. 
<hr>

### 4.Generate an order item for each record in the customers_orders table in the format of one of the following:
  - Meat Lovers
  - Meat Lovers - Exclude Beef
  - Meat Lovers - Extra Bacon
  - Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
#### Solution:
```sql
WITH cte_changes AS (
	SELECT co.order_id, 
		co.customer_id, 
		pn.pizza_name, 
		co.exclusions, 
		co.extras, 
		co.order_time,
		STRING_TO_ARRAY(co.exclusions, ', ')::INT[] excluded,
		STRING_TO_ARRAY(co.extras, ', ')::INT[] added_Extra
	FROM customer_orders co JOIN pizza_names pn
	ON pn.pizza_id = co.pizza_id
	),
cte_string_changes AS (
	SELECT *,
		CASE
			WHEN pizza_name = 'Meatlovers' THEN 'Meat Lovers'
			WHEN pizza_name = 'Vegetarian' THEN 'Veg Lovers'
		END p_name,
		CASE 
			WHEN excluded IS NOT NULL THEN ' - Exclude '|| (SELECT STRING_AGG(topping_name, ', ')
											FROM pizza_toppings
											WHERE topping_id = ANY(excluded))
		END exclusion_string,
		CASE 
			WHEN added_Extra IS NOT NULL THEN ' - Extra '|| (SELECT STRING_AGG(topping_name, ', ')
												FROM pizza_toppings
												WHERE topping_id = ANY(added_Extra))
		END extras_string
	FROM cte_changes
	)
SELECT order_id, 
	customer_id, 
	pizza_name, 
	exclusions, 
	extras, 
	order_time, 
	CONCAT(p_name, exclusion_string, extras_string) order_item
FROM cte_string_changes;
```
#### Output:
order_id | customer_id | pizza_name | exclusions | extras |     order_time      |                            order_item
-- | -- | -- | -- | -- |-- | --
10 |         104 | Meatlovers | 2, 6       | 1, 4   | 2020-01-11 18:34:49 | Meat Lovers - Exclude BBQ Sauce, Mushrooms - Extra Bacon, Cheese
2 |         101 | Meatlovers |            |        | 2020-01-01 19:00:52 | Meat Lovers
3 |         102 | Meatlovers |            |        | 2020-01-02 23:51:23 | Meat Lovers
8 |         102 | Meatlovers |            |        | 2020-01-09 23:54:33 | Meat Lovers
9 |         103 | Meatlovers | 4          | 1, 5   | 2020-01-10 11:22:59 | Meat Lovers - Exclude Cheese - Extra Bacon, Chicken
10 |         104 | Meatlovers |            |        | 2020-01-11 18:34:49 | Meat Lovers
1 |         101 | Meatlovers |            |        | 2020-01-01 18:05:02 | Meat Lovers
4 |         103 | Meatlovers | 4          |        | 2020-01-04 13:23:46 | Meat Lovers - Exclude Cheese
4 |         103 | Meatlovers | 4          |        | 2020-01-04 13:23:46 | Meat Lovers - Exclude Cheese
5 |         104 | Meatlovers |            | 1      | 2020-01-08 21:00:29 | Meat Lovers - Extra Bacon
3 |         102 | Vegetarian |            |        | 2020-01-02 23:51:23 | Veg Lovers
7 |         105 | Vegetarian |            | 1      | 2020-01-08 21:20:29 | Veg Lovers - Extra Bacon
6 |         101 | Vegetarian |            |        | 2020-01-08 21:03:13 | Veg Lovers
4 |         103 | Vegetarian | 4          |        | 2020-01-04 13:23:46 | Veg Lovers - Exclude Cheese

<hr>

### 5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
  - For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
#### Solution:
```sql
WITH cte_unnest AS ( --to query each pizza recipes with their ingredients
	SELECT pizza_id, 
		top.toppings,
		topping_name
	FROM pizza_recipes pr,
		LATERAL (SELECT UNNEST(STRING_TO_ARRAY(pr.toppings, ', ')::INT[]) toppings) top, --seperate strings into rows
		LATERAL (SELECT topping_name FROM pizza_toppings WHERE topping_id = top.toppings) t --query the topping name
	),
cte_array AS ( --to make exclusions and extras value into arrays
	SELECT co.order_id, 
		co.customer_id, 
		co.pizza_id, 
		co.exclusions,
		co.extras, 
		order_name,
		co.order_time,
		STRING_TO_ARRAY(co.exclusions, ', ')::INT[] excluded,
		STRING_TO_ARRAY(co.extras, ', ')::INT[] added_Extra
	FROM customer_orders co JOIN runner_orders ro
	ON ro.order_id = co.order_id,
		LATERAL (SELECT CASE 
							WHEN pizza_id = 1 THEN 'Meat Lovers: ' 
							ELSE 'Veg Lovers: ' 
				 		END AS order_name) ord_name
	WHERE ro.cancellation IS NULL
	),
cte_array2 AS ( --to remove exclusions and insert extras from the ingredients array
	SELECT *,
		CASE 
			WHEN excluded IS NOT NULL THEN (SELECT ARRAY_AGG(toppings)
										   FROM cte_unnest
										   WHERE NOT (toppings = ANY(excluded))
										   AND pizza_id = cte_array.pizza_id) || added_Extra 
			ELSE (SELECT ARRAY_AGG(toppings)
				  FROM cte_unnest
				  WHERE pizza_id = cte_array.pizza_id) || added_Extra
		END toppings_array
	FROM cte_array 
	),
cte_last AS ( --to count all instances of each elements in ingredients array
	SELECT order_id, 
		customer_id, 
		pizza_id,
		exclusions, 
		extras, 
		order_time,
		topping_name,
		order_name, 
		COUNT(topping_name) ingredient_count
	FROM cte_array2,
		LATERAL (SELECT UNNEST(toppings_array) topping_id) top_unnest,
		LATERAL (SELECT topping_name FROM pizza_toppings WHERE pizza_toppings.topping_id=top_unnest.topping_id) top
	GROUP BY order_id, customer_id, pizza_id, exclusions, extras, order_time, order_name, topping_name
	)
SELECT order_id,
	customer_id,
	pizza_id,
	exclusions, 
	extras,
	order_time,
	order_name || STRING_AGG(order_list, ', ') ingredient_list --combine all ingredients with their counts
FROM cte_last,
	LATERAL (SELECT CASE 
						WHEN ingredient_count = 1 THEN topping_name
						ELSE ingredient_count ||'x'||topping_name 
			 		END AS order_list) list
GROUP BY cte_last.order_id, cte_last.customer_id, 
		cte_last.pizza_id, cte_last.exclusions, cte_last.extras,
		cte_last.order_time, cte_last.order_name;
```
#### Output:
order_id | customer_id | pizza_id | exclusions | extras |     order_time      |                                     ingredient_list
-- | -- | -- | -- | -- | -- | --
1 |         101 |        1 |            |        | 2020-01-01 18:05:02 | Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami
2 |         101 |        1 |            |        | 2020-01-01 19:00:52 | Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami
3 |         102 |        1 |            |        | 2020-01-02 23:51:23 | Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami
3 |         102 |        2 |            |        | 2020-01-02 23:51:23 | Veg Lovers: Cheese, Mushrooms, Onions, Peppers, Tomato Sauce, Tomatoes
4 |         103 |        1 | 4          |        | 2020-01-04 13:23:46 | Meat Lovers: 2xBacon, 2xBBQ Sauce, 2xBeef, 2xChicken, 2xMushrooms, 2xPepperoni, 2xSalami
4 |         103 |        2 | 4          |        | 2020-01-04 13:23:46 | Veg Lovers: Mushrooms, Onions, Peppers, Tomato Sauce, Tomatoes
5 |         104 |        1 |            | 1      | 2020-01-08 21:00:29 | Meat Lovers: 2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami
7 |         105 |        2 |            | 1      | 2020-01-08 21:20:29 | Veg Lovers: Bacon, Cheese, Mushrooms, Onions, Peppers, Tomato Sauce, Tomatoes
8 |         102 |        1 |            |        | 2020-01-09 23:54:33 | Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami
10 |         104 |        1 | 2, 6       | 1, 4   | 2020-01-11 18:34:49 | Meat Lovers: 2xBacon, Beef, 2xCheese, Chicken, Pepperoni, Salami
10 |         104 |        1 |            |        | 2020-01-11 18:34:49 | Meat Lovers: Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami

<hr>

### 6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
#### Solution:
```sql
WITH cte_unnest AS (
	SELECT pizza_id, 
		top.toppings,
		topping_name
	FROM pizza_recipes pr,
		LATERAL (SELECT UNNEST(STRING_TO_ARRAY(pr.toppings, ', ')::INT[]) toppings) top,
		LATERAL (SELECT topping_name FROM pizza_toppings WHERE topping_id = top.toppings) t
	),
cte_array AS (
	SELECT *,
	STRING_TO_ARRAY(co.exclusions, ', ')::INT[] excluded,
	STRING_TO_ARRAY(co.extras, ', ')::INT[] added_Extra
	FROM customer_orders co JOIN runner_orders ro
	ON ro.order_id = co.order_id
	WHERE ro.cancellation IS NULL
	),
cte_array2 AS (
	SELECT *,
		CASE 
			WHEN excluded IS NOT NULL THEN (SELECT ARRAY_AGG(toppings)
										   FROM cte_unnest
										   WHERE NOT (toppings = ANY(excluded))
										   AND pizza_id = cte_array.pizza_id) || added_Extra 
			ELSE (SELECT ARRAY_AGG(toppings)
				  FROM cte_unnest
				  WHERE pizza_id = cte_array.pizza_id) || added_Extra
		END toppings_array
	FROM cte_array
	)
SELECT top.topping_name,
	COUNT(*) ingredient_count
FROM cte_array2,
	LATERAL (SELECT UNNEST(toppings_array) topping_id) top_unnest, --seperate arrays into rows
	LATERAL (SELECT topping_name FROM pizza_toppings WHERE pizza_toppings.topping_id=top_unnest.topping_id) top 
GROUP BY topping_name
ORDER BY ingredient_count DESC;
```
#### Output:
topping_name | ingredient_count
-- | --
Bacon        |               12
Mushrooms    |               11
Cheese       |               10
Pepperoni    |                9
Salami       |                9
Chicken      |                9
Beef         |                9
BBQ Sauce    |                8
Tomatoes     |                3
Onions       |                3
Peppers      |                3
Tomato Sauce |                3
