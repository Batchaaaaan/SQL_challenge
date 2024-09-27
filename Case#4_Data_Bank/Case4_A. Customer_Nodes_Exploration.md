# Customer Nodes Exploration
### 1.How many unique nodes are there on the Data Bank system?
#### Solution:
```sql
SELECT COUNT(DISTINCT(node_id)) nodes
FROM customer_nodes;
```
#### Output:
 nodes
-- |
5 

There are 5 unique nodes.
<hr>

### 2.What is the number of nodes per region?
#### Solution:
```sql
SELECT r.region_name, COUNT(cn.node_id) numNodes
FROM customer_nodes cn JOIN regions r
ON r.region_id = cn.region_id
GROUP BY r.region_name;
```
#### Output:
 region_name | num_nodes
-- | --
America     |       735
Australia   |       770
Africa      |       714
Asia        |       665
Europe      |       616

<hr>

### 3.How many customers are allocated to each region?
#### Solution:
```sql
SELECT r.region_name, COUNT(DISTINCT(customer_id)) numCustomers
FROM customer_nodes cn JOIN regions r
ON r.region_id = cn.region_id
GROUP BY r.region_name;
```
#### Output:
 region_name | num_customers
-- | --
Africa      |           102
America     |           105
Asia        |            95
Australia   |           110
Europe      |            88

<hr>

### 4.How many days on average are customers reallocated to a different node?
#### Solution:
```sql
SELECT 
	ROUND(AVG(end_date - start_date),0) AS averageDays
FROM customer_nodes
WHERE end_date != '9999-12-31';
```
#### Output:
 average_days
-- |
15

On average, it takes 15 days to reallocate a customer to a different node.
<hr>

### 5.What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
#### Solution:
```sql
WITH cte_derived AS (
	SELECT r.region_name,
	end_date - start_date AS days
	FROM customer_nodes cn JOIN regions r
	ON r.region_id = cn.region_id
	WHERE end_date != '9999-12-31'
	)
SELECT DISTINCT(region_name),
(SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY days) FROM cte_derived AS d WHERE d.region_name = cte_derived.region_name) AS median,
(SELECT PERCENTILE_CONT(0.80) WITHIN GROUP(ORDER BY days) FROM cte_derived AS d WHERE d.region_name = cte_derived.region_name) AS percentile_80,
(SELECT PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY days) FROM cte_derived AS d WHERE d.region_name = cte_derived.region_name) AS percentile_95
FROM cte_derived;
```
#### Output:
 region_name | median | percentile_80 | percentile_95
-- | -- | -- | --
 Africa      |     15 |            24 |            28
 America     |     15 |            23 |            28
 Asia        |     15 |            23 |            28
 Australia   |     15 |            23 |            28
 Europe      |     15 |            24 |            28

Almost every region have the same reallocation days.

