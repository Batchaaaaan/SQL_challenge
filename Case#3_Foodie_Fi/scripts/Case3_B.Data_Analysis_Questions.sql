-- Data Analysis Questions
-- How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT(customer_id)) total_customers
FROM subscriptions;

-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month 
				--as the group by value
SELECT EXTRACT('Month' FROM start_date) month_Num, TO_CHAR(start_date, 'Month') month_Name , COUNT(*) distribution
FROM subscriptions
WHERE plan_id = 0
GROUP BY month_Num, month_Name
ORDER BY month_Num;

-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events 
				--for each plan_name
SELECT p.plan_name, COUNT(*)
FROM subscriptions s JOIN plans p
ON p.plan_id = s.plan_id
WHERE EXTRACT('Year' FROM start_date) > 2020
GROUP BY p.plan_name;

-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT COUNT(customer_id) AS Customers_Churned, 
ROUND(COUNT(customer_id)*100.0/(SELECT COUNT(DISTINCT(customer_id)) FROM subscriptions), 1) AS Percent_Customers_Churned
FROM subscriptions 
WHERE plan_id = 4;

-- How many customers have churned straight after their initial free trial - what percentage is this rounded 
			--to the nearest whole number?
WITH cte_next AS (
	SELECT customer_id, plan_id, 
	LEAD(plan_id) OVER (PARTITION BY customer_id) AS next_plan
	FROM subscriptions
	)
SELECT COUNT(DISTINCT(customer_id)) AS total_Customers, 
ROUND(COUNT(customer_id)*100.0/(SELECT COUNT(DISTINCT(customer_id)) FROM subscriptions), 0) AS Percent_Customers
FROM cte_next
WHERE plan_id = 0 AND next_plan = 4;

-- What is the number and percentage of customer plans after their initial free trial?
WITH cte_next AS (
	SELECT customer_id, plan_id, 
	ROW_NUMBER() OVER (PARTITION BY customer_id) AS ranking
	FROM subscriptions
	)
SELECT p.plan_id, p.plan_name, COUNT(customer_id) AS total_Customers, 
COUNT(customer_id)::FLOAT*100/(SELECT COUNT(DISTINCT(customer_id)) FROM subscriptions) AS PercentCustomers
FROM cte_next JOIN plans p
ON p.plan_id = cte_next.plan_id
WHERE ranking = 2
GROUP BY p.plan_id, p.plan_name;

-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH cte_derived AS (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY start_date DESC) AS ranking
	FROM subscriptions
	WHERE start_date <= '2020-12-31'
	)
SELECT p.plan_id, p.plan_name, COUNT(customer_id) AS customer_Count, 
COUNT(customer_id)::FLOAT*100/(SELECT COUNT(DISTINCT(customer_id)) FROM subscriptions) AS Percent_Customers
FROM cte_derived JOIN plans p
ON p.plan_id = cte_derived.plan_id
WHERE ranking = 1
GROUP BY p.plan_id, p.plan_name;

-- How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(DISTINCT(customer_id)) AS customer_Count
FROM subscriptions
WHERE plan_id = 3 AND EXTRACT('Year' FROM start_date) = '2020';

-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
WITH cte_trial AS (
	SELECT customer_id, start_date
	FROM subscriptions
	WHERE plan_id = 0),
cte_annual AS (
	SELECT customer_id, start_date
	FROM subscriptions
	WHERE plan_id = 3)
SELECT ROUND(AVG(cte_annual.start_date-cte_trial.start_date),0) AS average_Days
FROM cte_trial INNER JOIN cte_annual
ON cte_annual.customer_id = cte_trial.customer_id;

-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
WITH cte_trial AS (
	SELECT customer_id, start_date
	FROM subscriptions
	WHERE plan_id = 0),
cte_annual AS (
	SELECT customer_id, start_date
	FROM subscriptions
	WHERE plan_id = 3)
SELECT 
CASE
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=30 THEN '0-30 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=60 THEN '30-60 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=90 THEN '60-90 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=120 THEN '90-120 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=150 THEN '120-150 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=180 THEN '150-180 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=210 THEN '180-210 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=240 THEN '210-240 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=270 THEN '240-270 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=300 THEN '270-300 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=330 THEN '300-330 days'
	WHEN ROUND(cte_annual.start_date - cte_trial.start_date,0) <=360 THEN '330-360 days'
END AS day_Intervals,
ROUND(AVG(cte_annual.start_date-cte_trial.start_date),0) AS average_Days,
COUNT(DISTINCT(cte_trial.customer_id)) AS customer_Count
FROM cte_trial INNER JOIN cte_annual
ON cte_annual.customer_id = cte_trial.customer_id
GROUP BY day_Intervals
ORDER BY average_Days;

-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
WITH cte_next AS (
	SELECT customer_id, plan_id, start_date,
	LEAD(plan_id) OVER (PARTITION BY customer_id) AS next_plan
	FROM subscriptions
	WHERE EXTRACT('Year' FROM start_date) = '2020'
	)
SELECT COUNT(customer_id) customer_Count
FROM cte_next
WHERE plan_id = 2 
AND next_plan = 1;