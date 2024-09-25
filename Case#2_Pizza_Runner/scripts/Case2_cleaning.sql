-- Cleaning customer_orders table
UPDATE customer_orders
SET 
exclusions = 
	CASE
		WHEN exclusions = 'null' THEN NULL 
		ELSE exclusions
	END,
extras =
	CASE
		WHEN extras = 'null' THEN NULL
		ELSE extras
	END;

--Cleaning runner_orders table
UPDATE runner_orders
SET
pickup_time =
	CASE
		WHEN pickup_time = 'null' THEN NULL
		ELSE pickup_time
	END,
distance = 
	CASE 
		WHEN distance like '%km' THEN TRIM('km' FROM distance)
		WHEN distance = 'null' THEN NULL
		ELSE distance
	END,
duration = 
	CASE
		WHEN duration like '%mins' THEN TRIM('mins' FROM duration) -- remove 'mins' from values
		WHEN duration like '%minute' THEN TRIM('minute' FROM duration) --remove 'minute' from values
		WHEN duration like '%minutes' THEN TRIM('minutes' FROM duration) --remove 'minutes' from values
		WHEN duration = 'null' THEN NULL
		ELSE duration
	END,
cancellation =
	CASE
		WHEN cancellation = 'null' THEN NULL 
		ELSE cancellation
	END
;


-- Alter runner_orders specific columns data types
ALTER TABLE runner_orders
ALTER COLUMN pickup_time TYPE timestamp USING pickup_time::timestamp without time zone,
ALTER COLUMN distance SET DATA TYPE DECIMAL(5,2) USING distance::numeric(5,2),
ALTER COLUMN duration TYPE INT USING duration::integer;
