# B. Customer Transactions
### 1.What is the unique count and total amount for each transaction type?
#### Solution:
```sql
SELECT txn_type, COUNT(txn_type) txn_count, SUM(txn_amount) total_amount
FROM customer_transactions
GROUP BY txn_type;
```
#### Output:
  txn_type  | txn_count | total_amount
-- | -- | --
purchase   |      1617 |       806537
withdrawal |      1580 |       793003
deposit    |      2671 |      1359168

 Deposit transaction type have the most count and highest total amount, followed by purchase and withdrawal having the least.
<hr>

### 2.What is the average total historical deposit counts and amounts for all customers?
#### Solution:
```sql
WITH cte_deposit AS (
	SELECT customer_id, txn_type, COUNT(customer_id) customer_Count, SUM(txn_amount) as average_Per_Customers
	FROM customer_transactions
	WHERE txn_type = 'deposit'
	GROUP BY customer_id, txn_type
	ORDER BY customer_id
	)
SELECT txn_type, AVG(customer_Count) total_Average_Count, AVG(average_Per_Customers) total_Average_Amount
FROM cte_deposit
GROUP By txn_type;
```
#### Output:
 txn_type | total_average_count | total_average_amount
-- | -- | --
deposit  |  5.3420000000000000 | 2718.3360000000000000

 On average, customers have atleast deposited 5 times with a total average of 2718.33 units. 
<hr>

### 3.For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
#### Solution:
```sql
WITH cte_monthly AS (
	SELECT TO_CHAR(txn_date, 'Month') month_Name, customer_id,
	COUNT(CASE 
		  WHEN txn_type = 'deposit' THEN 1 
		  END) AS deposit_Count,
	COUNT(CASE 
		  WHEN txn_type = 'purchase' THEN 1 
		  END) AS purchase_Count,
    COUNT(CASE 
		  WHEN txn_type = 'withdrawal' THEN 1 
		  END) AS withdrawal_Count
	FROM customer_transactions
	GROUP BY month_Name, customer_id
	)
SELECT month_Name, COUNT(*) customer_Count
FROM cte_monthly
WHERE deposit_Count > 1
AND (purchase_Count > 0 OR withdrawal_Count > 0)
GROUP BY month_Name;
```
#### Output:
 month_name | customer_count
-- | --
January    |            168
February   |            181
March      |            192
April      |             70

Most distribution of customers are from January to March with counts of 168, 181 and 192, repectively. April have the least count with 70.
<hr>

### 4.What is the closing balance for each customer at the end of the month?
#### Solution:
```sql
WITH cte_balance AS (	
	SELECT DATE_PART('Month', txn_date) month_Num, TO_CHAR(txn_date, 'Month') month_Name, customer_id,
	SUM(CASE 
		WHEN txn_type = 'deposit' THEN txn_amount
		ELSE -txn_amount
	END) AS balance
	FROM customer_transactions
	GROUP BY month_Num, month_name, customer_id
	)														  
SELECT month_Num, month_Name, customer_id,
	SUM(balance) OVER (PARTITION BY customer_id ORDER BY month_Num) closing_balance
FROM cte_balance
ORDER BY customer_id, month_Num;
```
#### Output:
###### Note: Not all data are displayed. 
 month_num | month_name | customer_id |  sum
month_num | month_name | customer_id | closing_balance
-- | -- | -- | --
1 | January    |           1 |             312
3 | March      |           1 |            -640
1 | January    |           2 |             549
3 | March      |           2 |             610
1 | January    |           3 |             144
2 | February   |           3 |            -821
3 | March      |           3 |           -1222
4 | April      |           3 |            -729
1 | January    |           4 |             848
3 | March      |           4 |             655
1 | January    |           5 |             954
3 | March      |           5 |           -1923
4 | April      |           5 |           -2413
1 | January    |           6 |             733
2 | February   |           6 |             -52
3 | March      |           6 |             340
1 | January    |           7 |             964
2 | February   |           7 |            3173
3 | March      |           7 |            2533
4 | April      |           7 |            2623
1 | January    |           8 |             587
2 | February   |           8 |             407
3 | March      |           8 |             -57
4 | April      |           8 |           -1029
1 | January    |           9 |             849
2 | February   |           9 |             654
3 | March      |           9 |            1584
4 | April      |           9 |             862
1 | January    |          10 |           -1622
2 | February   |          10 |           -1342
3 | March      |          10 |           -2753
4 | April      |          10 |           -5090
1 | January    |          11 |           -1744
2 | February   |          11 |           -2469
3 | March      |          11 |           -2088
4 | April      |          11 |           -2416
1 | January    |          12 |              92
3 | March      |          12 |             295
1 | January    |          13 |             780
2 | February   |          13 |            1279
3 | March      |          13 |            1405
1 | January    |          14 |             205
2 | February   |          14 |             821
4 | April      |          14 |             989
1 | January    |          15 |             379
4 | April      |          15 |            1102
1 | January    |          16 |           -1341
2 | February   |          16 |           -2893
3 | March      |          16 |           -4284

<hr>

### 5.What is the percentage of customers who increase their closing balance by more than 5%?
#### Solution:
```sql
WITH cte_transactions AS (	
	SELECT DATE_PART('Month', txn_date) month_Num, TO_CHAR(txn_date, 'Month') month_Name, customer_id,
	SUM(CASE 
		WHEN txn_type = 'deposit' THEN txn_amount
		ELSE -txn_amount
	END) AS balance
	FROM customer_transactions
	GROUP BY month_Num, month_name, customer_id
	),														  
cte_balance AS (
	SELECT month_Num, month_Name, customer_id,
		SUM(balance) OVER (PARTITION BY customer_id ORDER by month_Num) closing_balance
	FROM cte_transactions
	),
cte_pct AS (
	SELECT *,
		LAG(closing_balance) OVER (PARTITION BY customer_id ORDER BY month_Num) last_balance,
		(closing_balance - LAG(closing_balance) OVER (PARTITION BY customer_id ORDER BY month_Num))* 100 / NULLIF(LAG(closing_balance) OVER (PARTITION BY customer_id ORDER BY month_Num), 0) AS percent_increase
	FROM cte_balance
	)
SELECT COUNT(DISTINCT(customer_id))*100.0 / (SELECT COUNT(DISTINCT(customer_id)) FROM customer_transactions) percent_customers_above_5
FROM cte_pct
WHERE percent_increase > 5;

```
#### Output:
 percent_customers_above_5
-- |
75.8000000000000000

The 75.8% of the total customers have atleast 5% percent increase on their closing balance.

