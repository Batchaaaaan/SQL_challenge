DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
	customer_id INT,
	plan_id INT, 
	plan_name VARCHAR(13),
	payment_date date,
	amount numeric(5,2),
	payment_order INT);

DROP VIEW IF EXISTS cte_full_structure;
CREATE OR REPLACE VIEW cte_full_structure AS --create a view for the next step which is using recursive cte
WITH cte_initial AS (
	SELECT s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price amount,
		LEAD(s.start_date, 1) OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) next_date,
		LEAD(s.plan_id, -1) OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) last_plan,
		LEAD(p.price, -1) OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) last_amount
	FROM subscriptions s JOIN plans p
	ON p.plan_id = s.plan_id
	WHERE DATE_PART('Year', s.start_date) = '2020'
	ORDER BY s.customer_id, s.plan_id
	),
cte_secondary AS (
	SELECT customer_id, plan_id, plan_name, 
	start_date , start_date AS payment_date,
		CASE
			WHEN (next_date IS NULL OR next_date> '2020-12-31') THEN MAKE_DATE(2020, 12,31)::timestamp
			ELSE next_date::timestamp
		END next_date,
		CASE
			WHEN (plan_id=2 AND last_plan=1) THEN  amount-last_amount
			WHEN (plan_id=3 AND last_plan=1) THEN  amount-last_amount
			ELSE amount
		END amount
	FROM cte_initial
	WHERE plan_id NOT IN (0,4) --not 'trial' or 'churn'
	)
SELECT * 
FROM cte_secondary;


WITH RECURSIVE cte_recursive AS ( --use recursive cte for adding more rows into the payments table
	SELECT customer_id, plan_id, plan_name, 
		d.payment_date::timestamp, next_date, amount
	FROM cte_full_structure,
		LATERAL (SELECT CASE WHEN payment_date<next_date THEN payment_date 
				 ELSE next_date END payment_date) d
	UNION ALL
	SELECT customer_id, plan_id, plan_name,
		payment_date + INTERVAL'1 month', next_date, amount
	FROM cte_recursive
	WHERE payment_date < '2020-12-31' AND plan_id !=3
	)
INSERT INTO payments (customer_id, plan_id, plan_name, 
					  payment_date, amount, payment_order) --insert the data into the payments table
SELECT customer_id, plan_id, plan_name, 
	payment_date, amount, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) payment_order
FROM cte_recursive
WHERE DATE_PART('Year', payment_date) = '2020'
ORDER BY customer_id, payment_date;

SELECT * FROM payments;
