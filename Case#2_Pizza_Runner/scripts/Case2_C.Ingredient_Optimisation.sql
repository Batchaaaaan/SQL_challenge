-- C. Ingredient Optimisation
-- What are the standard ingredients for each pizza?
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

-- What was the most commonly added extra?
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

-- What was the most common exclusion?
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

-- Generate an order item for each record in the customers_orders table in the format of one of the following:
	-- Meat Lovers
	-- Meat Lovers - Exclude Beef
	-- Meat Lovers - Extra Bacon
	-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
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

-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table 
																		--and add a 2x in front of any relevant ingredients
	-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
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


-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
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