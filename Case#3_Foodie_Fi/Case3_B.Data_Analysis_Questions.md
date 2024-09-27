# Data Analysis Questions
### 1.How many customers has Foodie-Fi ever had?
#### Solution:
```sql
SELECT COUNT(DISTINCT(customer_id)) total_customers
FROM subscriptions;
```
#### Output:
 total_customers
-- |
1000

Foodie-Fi has 1000 unique customer.
<hr>

### 2.What is the monthly distribution of trial plan start_date values for our dataset? 
  - use the start of the month as the group by value
#### Solution:
```sql
SELECT EXTRACT('Month' FROM start_date) month_Num, TO_CHAR(start_date, 'Month') month_Name , COUNT(*) distribution
FROM subscriptions
WHERE plan_id = 0
GROUP BY month_Num, month_Name
ORDER BY month_Num;
```
#### Output:
 month_num | month_name | distribution
-- | -- | --
 1 | January    |           88
 2 | February   |           68
 3 | March      |           94
 4 | April      |           81
 5 | May        |           88
 6 | June       |           79
 7 | July       |           89
 8 | August     |           88
 9 | September  |           87
10 | October    |           79
11 | November   |           75
12 | December   |           84

March have the highest count of customers with 94, followed by July with 89 and February have the least with 68.
<hr>

### 3.What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.
#### Solution:
```sql
SELECT p.plan_name, COUNT(*)
FROM subscriptions s JOIN plans p
ON p.plan_id = s.plan_id
WHERE EXTRACT('Year' FROM start_date) > 2020
GROUP BY p.plan_name;
```
#### Output:
plan_name   | count
-- | --
pro annual    |    63
churn         |    71
pro monthly   |    60
basic monthly |     8

Most of the customers have either churned or upgraded to pro plan.
<hr>

### 4.What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
#### Solution:
```sql
SELECT COUNT(customer_id) AS Customers_Churned, 
ROUND(COUNT(customer_id)*100.0/(SELECT COUNT(DISTINCT(customer_id)) FROM subscriptions), 1) AS Percent_Customers_Churned
FROM subscriptions 
WHERE plan_id = 4;
```
#### Output:
 customers_churned | percent_customers_churned
-- | --
307 |                      30.7

A total of 307 have churned. That is 30.7% of the total customers.
<hr>

### 5.How many customers have churned straight after their initial free trial? What percentage is this rounded to the nearest whole number?
#### Solution:
```sql
WITH cte_next AS (
	SELECT customer_id, plan_id, 
	LEAD(plan_id) OVER (PARTITION BY customer_id) AS next_plan
	FROM subscriptions
	)
SELECT COUNT(DISTINCT(customer_id)) AS total_Customers, 
ROUND(COUNT(customer_id)*100.0/(SELECT COUNT(DISTINCT(customer_id)) FROM subscriptions), 0) AS Percent_Customers
FROM cte_next
WHERE plan_id = 0 AND next_plan = 4;
```
#### Output:
 total_customers | percent_customers
-- | --
92 |                 9

A total of 92 customers have churned after their free trial. That is 9% of the total customers.
<hr>

### 6.What is the number and percentage of customer plans after their initial free trial?
#### Solution:  
```sql
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
```
#### Output:
 plan_id |   plan_name   | total_customers | percentcustomers
-- | -- | -- | --
1 | basic monthly |             546 |             54.6
2 | pro monthly   |             325 |             32.5
3 | pro annual    |              37 |              3.7
4 | churn         |              92 |              9.2

Most customers have downgraded from basic monthly after their initial free trial with 54.6% of the total customers.
<hr>

### 7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
#### Solution:
```sql
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
```
#### Output:
 plan_id |   plan_name   | customer_count | percent_customers
-- | -- | -- | --
0 | trial         |             19 |               1.9
1 | basic monthly |            224 |              22.4
2 | pro monthly   |            326 |              32.6
3 | pro annual    |            195 |              19.5
4 | churn         |            236 |              23.6

Customers have mostly upgraded from pro monthly plan with 32.6% of the total or downgraded from basic monthly with 22.4% of the total at 2020-12-31.
<hr>

### 8.How many customers have upgraded to an annual plan in 2020?
#### Solution:
```sql
SELECT COUNT(DISTINCT(customer_id)) AS customerCount
FROM subscriptions
WHERE plan_id = 3 AND EXTRACT('Year' FROM start_date) = '2020';
```
#### Output:
 customer_count
-- |
195

A total of 195 have upgraded to an annual plan in 2020.
<hr>

### 9.How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
#### Solution:
```sql
WITH cte_trial AS (
	SELECT customer_id, start_date
	FROM subscriptions
	WHERE plan_id = 0),
cte_annual AS (
	SELECT customer_id, start_date
	FROM subscriptions
	WHERE plan_id = 3)
SELECT ROUND(AVG(cte_annual.start_date-cte_trial.start_date),0) AS averageDays
FROM cte_trial INNER JOIN cte_annual
ON cte_annual.customer_id = cte_trial.customer_id;
```
#### Output:
 average_days
-- |
105

On average, it takes 105 days for a customer to upgrade to pro annual plan after their initial trial plan.
<hr>

### 10.Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
#### Solution:
```sql
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
END AS dayIntervals,
ROUND(AVG(cte_annual.start_date-cte_trial.start_date),0) AS averageDays,
COUNT(DISTINCT(cte_trial.customer_id)) AS customerCount
FROM cte_trial INNER JOIN cte_annual
ON cte_annual.customer_id = cte_trial.customer_id
GROUP BY dayIntervals
ORDER BY averageDays;
```
#### Output:
 day_intervals | average_days | customer_count
-- | -- | --
0-30 days     |           10 |             49
30-60 days    |           42 |             24
60-90 days    |           71 |             34
90-120 days   |          101 |             35
120-150 days  |          133 |             42
150-180 days  |          162 |             36
180-210 days  |          191 |             26
210-240 days  |          224 |              4
240-270 days  |          257 |              5
270-300 days  |          285 |              1
300-330 days  |          327 |              1
330-360 days  |          346 |              1

On average, a good portion of the total customers takes atleast <=150 days before upgrading into pro annual. Small count on later days.
<hr>

### 11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
#### Solution:
```sql
WITH cte_next AS (
	SELECT customer_id, plan_id, start_date,
	LEAD(plan_id) OVER (PARTITION BY customer_id) AS next_plan
	FROM subscriptions
	WHERE EXTRACT('Year' FROM start_date) = '2020'
	)
SELECT COUNT(customer_id) customerCount
FROM cte_next
WHERE plan_id = 2 
AND next_plan = 1;
```
#### Output:
 customer_count
-- |
0

Amazingly, no customers downgraded from pro monthly to basic monthly in 2020.
