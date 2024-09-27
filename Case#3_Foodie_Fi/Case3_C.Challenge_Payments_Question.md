# C. Challenge Payment Question
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

- Monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
- Upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
- Upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
- Once a customer churns they will no longer make payments

#### Solution:
- Create the payments table with its necessary columns and data types.
  
```sql
DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
	customer_id INT,
	plan_id INT, 
	plan_name VARCHAR(13),
	payment_date date,
	amount numeric(5,2),
	payment_order INT);
```
- On *cte_initial*, I used 3 LEAD function.
  - The first LEAD is used to look for the start_date of the next plan.
  - Second LEAD is used to look for the last plan_id.
  - Third LEAD is used to look for the last price of the succeeding plan.
  - Joined the subscribtions and plans table.
  - Dropped the rows that is not from year 2020.
- On *cte_secondary*, I used 2 Case function:
  - First CASE function is used to classify next_date, column created from last cte.
  - Second CASE function is used to compute the value of amount column.
  - Dropped the rows that are trial plans or churned.
- Created a View to prepare for the recursive function since it would be inefficient to combine all.
```sql
DROP VIEW IF EXISTS cte_full_structure;

CREATE OR REPLACE VIEW cte_full_structure AS --create a view for the next step which is using recursive cte
WITH cte_initial AS (
	SELECT s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price amount,
		LEAD(s.start_date, 1) OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) next_date, --find the date of the next plan
		LEAD(s.plan_id, -1) OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) last_plan, --find the last plan 
		LEAD(p.price, -1) OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) last_amount --find the last price
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
```

- On the Anchor Member(upper part of UNION) of recursive cte, I used LATERAL function to classify whether the payment date is greater than the next date.
- On the Recursive Member(lower part of UNION) of the recursive cte, I added 1 month interval to the payment date which will loop until it reached 2020-12-31.
- After all that, insert all the values into the payments table using INSERT function.
```sql
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
```
Query the values of payments table using the code below.
```sql
SELECT * FROM payments;
```
##### Output:
###### *Note: Not all data are displayed since the dataset is large.*
 customer_id | plan_id |   plan_name   | payment_date | amount | payment_order
-- | -- | -- | -- | -- | --
1 |       1 | basic monthly | 2020-08-08   |   9.90 |             1
1 |       1 | basic monthly | 2020-09-08   |   9.90 |             2
1 |       1 | basic monthly | 2020-10-08   |   9.90 |             3
1 |       1 | basic monthly | 2020-11-08   |   9.90 |             4
1 |       1 | basic monthly | 2020-12-08   |   9.90 |             5
2 |       3 | pro annual    | 2020-09-27   | 199.00 |             1
3 |       1 | basic monthly | 2020-01-20   |   9.90 |             1
3 |       1 | basic monthly | 2020-02-20   |   9.90 |             2
3 |       1 | basic monthly | 2020-03-20   |   9.90 |             3
3 |       1 | basic monthly | 2020-04-20   |   9.90 |             4
3 |       1 | basic monthly | 2020-05-20   |   9.90 |             5
3 |       1 | basic monthly | 2020-06-20   |   9.90 |             6
3 |       1 | basic monthly | 2020-07-20   |   9.90 |             7
3 |       1 | basic monthly | 2020-08-20   |   9.90 |             8
3 |       1 | basic monthly | 2020-09-20   |   9.90 |             9
3 |       1 | basic monthly | 2020-10-20   |   9.90 |            10
3 |       1 | basic monthly | 2020-11-20   |   9.90 |            11
3 |       1 | basic monthly | 2020-12-20   |   9.90 |            12
4 |       1 | basic monthly | 2020-01-24   |   9.90 |             1
4 |       1 | basic monthly | 2020-02-24   |   9.90 |             2
4 |       1 | basic monthly | 2020-03-24   |   9.90 |             3
4 |       1 | basic monthly | 2020-04-24   |   9.90 |             4
4 |       1 | basic monthly | 2020-05-24   |   9.90 |             5
4 |       1 | basic monthly | 2020-06-24   |   9.90 |             6
4 |       1 | basic monthly | 2020-07-24   |   9.90 |             7
4 |       1 | basic monthly | 2020-08-24   |   9.90 |             8
4 |       1 | basic monthly | 2020-09-24   |   9.90 |             9
