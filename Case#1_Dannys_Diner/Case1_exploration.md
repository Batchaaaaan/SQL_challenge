# Case Study Questions

### 1. What is the total amount each customer spent at the restaurant?

```sql
SELECT sales.customer_id, SUM(menu.price) totalAmount
FROM sales JOIN menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;
```
### Output:
customer_id | totalamount
| -- | --
B|74
C|36
A|76

Customer A spent the most with 76, followed by Customer B with 74 and Customer C having the least with 36.
<hr>

### 2. How many days has each customer visited the restaurant?

```sql
SELECT customer_id,  COUNT(order_date) AS numDays
FROM (
	SELECT customer_id, order_date 
	FROM sales
	GROUP BY customer_id, order_date
	) AS derivedTable
GROUP BY customer_id;
```

### Output:
 customer_id | numdays
| -- | -- |
 B           |       6
 C           |       2
 A           |       4

 Customer B have the most days with 6 total visits followed, Customer A with 4 visits and lastly, Customer C with 2 visits.
<hr>

### 3. What was the first item from the menu purchased by each customer?
```sql
SELECT s.customer_id, m.product_name
FROM sales s JOIN menu m
ON s.product_id = m.product_id
WHERE s.order_date = (
	SELECT MIN(order_date)
	FROM sales
	WHERE customer_id = s.customer_id
	)
GROUP BY s.customer_id, m.product_name;
```
### Output:
 customer_id | product_name
| -- | -- |
 A           | sushi
 A           | curry
 B           | curry
 C           | ramen
 
 Customer A had sushi and curry as its first order. Customer B had curry while customer C had ramen.
<hr>

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
SELECT m.product_name, COUNT(*) AS total_count 
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_count DESC
LIMIT 1;
```
### Output
 product_name | total_count
| -- | -- |
 ramen        |           8

 Ramen is the most sold product with 8 units sold.
<hr>

### 5. Which item was the most popular for each customer?
```sql
SELECT customer_id, product_name, orderedCount
FROM (
	SELECT customer_id, product_name, orderedCount, 
	DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY orderedCount DESC) as ranking
	FROM (
		SELECT s.customer_id, m.product_name, COUNT(*) AS orderedCount
		FROM sales s JOIN menu m 
		ON s.product_id = m.product_id
		GROUP BY s.customer_id, m.product_name
		) AS purchaseTable
	) AS rankingTable
WHERE ranking = 1;
```
### Output:
 customer_id | product_name | orderedCount
| -- | -- | -- |
 A           | ramen        |             3
 B           | sushi        |             2
 B           | curry        |             2
 B           | ramen        |             2
 C           | ramen        |             3

 Customer A ordered ramen the most with 3 unit count. Customer B ordered sushi, curry and ramen with 2 units each while Customer C ordered ramen the most with 3 unit.
<hr>

### 6. Which item was purchased first by the customer after they became a member?
```sql
SELECT customer_id, product_name
FROM (
	SELECT s.customer_id, m.product_name, order_date, 
	DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS ranking
	FROM sales s JOIN menu m
	ON s.product_id = m.product_id
	WHERE s.order_date >= (
		SELECT join_date
		FROM members me
		WHERE customer_id = s.customer_id)
  ) as rankingTable
WHERE ranking = 1;
```
### Output:
 customer_id | product_name
| -- | -- |
 A           | curry
 B           | sushi

 There are only 2 members registered. Customer A ordered curry after becoming member while B ordered sushi.
<hr>
	
### 7. Which item was purchased just before the customer became a member?
```sql
SELECT customer_id, product_name
FROM (
	SELECT s.customer_id, m.product_name, order_date, 
	DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) as ranking
	FROM sales s JOIN menu m
	ON s.product_id = m.product_id
	WHERE s.order_date < (
		SELECT join_date
		FROM members me
		WHERE customer_id = s.customer_id)
  ) as rankingTable
WHERE ranking = 1;
```
### Output:
 customer_id | product_name
-- | --
 A           | sushi
 A           | curry
 B           | sushi

 Customer A last ordered sushi and curry before becoming a member while Customer B ordered sushi.
<hr>

### 8. What is the total items and amount spent for each member before they became a member?
```sql
SELECT s.customer_id, COUNT(*), SUM(m.price) totalSpent
FROM sales s JOIN menu m
ON s.product_id = m.product_id
WHERE s.order_date < (
		SELECT join_date
		FROM members me
		WHERE customer_id = s.customer_id)
GROUP BY s.customer_id;
```
### Output:
 customer_id | count | totalspent
-- | -- | --
 A           |     2 |         25
 B           |     3 |         40

Customer A spent 25 units on 2 items while Customer B spent 40 units on 3 items.
 <hr>
 
### 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```sql
SELECT customer_id, SUM(price)
FROM (
	SELECT s.customer_id, m.product_name, 
	CASE 
		WHEN m.product_name ='sushi' THEN m.price * 20
    	ELSE m.price * 10
    	END AS price
	FROM sales s JOIN menu m
	ON s.product_id = m.product_id 
	) as derivedTable
GROUP BY customer_id;
```
### Output:
 customer_id | sum
-- | --
 B           | 940
 C           | 360
 A           | 860

 Customer B have the highest points with 960, followed by customer A with 860 while Customer C had the lowest with 360.
<hr>

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```sql
SELECT customer_id, SUM(price)
FROM (
  SELECT s.customer_id, m.product_name,
  CASE 
      WHEN s.order_date - me.join_date >= 0 and s.order_date - me.join_date <= 6 
          THEN price * 10 * 2
      WHEN m.product_name = 'sushi'
          THEN price * 10 * 2
      ELSE price * 10
  END AS price
  FROM sales s JOIN menu m
  ON s.product_id = m.product_id
  JOIN members me
  ON s.customer_id = me.customer_id
  WHERE date_part('month', s.order_date ) = 1
	) as derivedTable
GROUP BY customer_id;
```
### Output:
 customer_id | sum
-- | --
 B           |  820
 A           | 1370

 Customer A have the the highest points with 1370 while Customer B have 820 points.
 <hr>
 
### BONUS QUESTIONS 

- ### JOIN ALL
	<details><summary>Recreate the following table output using the available data:</summary>
		<table>
	    <thead>
	      <tr>
		<th>customer_id</th>
		<th>order_date</th>
		<th>product_name</th>
		<th>price</th>
		<th>member</th>
	      </tr>
	    </thead>
	    <tbody>
	      <tr>
		<td>A</td>
		<td>2021-01-01</td>
		<td>curry</td>
		<td>15</td>
		<td>N</td>
	      </tr>
	      <tr>
		<td>A</td>
		<td>2021-01-01</td>
		<td>sushi</td>
		<td>10</td>
		<td>N</td>
	      </tr>
	      <tr>
		<td>A</td>
		<td>2021-01-07</td>
		<td>curry</td>
		<td>15</td>
		<td>Y</td>
	      </tr>
	      <tr>
		<td>A</td>
		<td>2021-01-10</td>
		<td>ramen</td>
		<td>12</td>
		<td>Y</td>
	      </tr>
	      <tr>
		<td>A</td>
		<td>2021-01-11</td>
		<td>ramen</td>
		<td>12</td>
		<td>Y</td>
	      </tr>
	      <tr>
		<td>A</td>
		<td>2021-01-11</td>
		<td>ramen</td>
		<td>12</td>
		<td>Y</td>
	      </tr>
	      <tr>
		<td>B</td>
		<td>2021-01-01</td>
		<td>curry</td>
		<td>15</td>
		<td>N</td>
	      </tr>
	      <tr>
		<td>B</td>
		<td>2021-01-02</td>
		<td>curry</td>
		<td>15</td>
		<td>N</td>
	      </tr>
	      <tr>
		<td>B</td>
		<td>2021-01-04</td>
		<td>sushi</td>
		<td>10</td>
		<td>N</td>
	      </tr>
	      <tr>
		<td>B</td>
		<td>2021-01-11</td>
		<td>sushi</td>
		<td>10</td>
		<td>Y</td>
	      </tr>
	      <tr>
		<td>B</td>
		<td>2021-01-16</td>
		<td>ramen</td>
		<td>12</td>
		<td>Y</td>
	      </tr>
	      <tr>
		<td>B</td>
		<td>2021-02-01</td>
		<td>ramen</td>
		<td>12</td>
		<td>Y</td>
	      </tr>
	      <tr>
		<td>C</td>
		<td>2021-01-01</td>
		<td>ramen</td>
		<td>12</td>
		<td>N</td>
	      </tr>
	      <tr>
		<td>C</td>
		<td>2021-01-01</td>
		<td>ramen</td>
		<td>12</td>
		<td>N</td>
	      </tr>
	      <tr>
		<td>C</td>
		<td>2021-01-07</td>
		<td>ramen</td>
		<td>12</td>
		<td>N</td>
	      </tr>
	    </tbody>
	  </table>
	</details>

  Solution:
	```sql
	SELECT s.customer_id, s.order_date, m.product_name, m.price,
	CASE 
		WHEN s.order_date < me.join_date THEN 'N'
	    WHEN s.order_date >= me.join_date THEN 'Y'
	    ELSE 'N'
	    END as member
	FROM sales s LEFT JOIN members me
	ON me.customer_id = s.customer_id
	JOIN menu m 
	ON m.product_id = s.product_id
	ORDER BY s.customer_id, s.order_date;
	```

<hr>

- ### RANK ALL
	<details><summary>Recreate the following table output using the available data:</summary>
		<table>
    <thead>
      <tr>
        <th>customer_id</th>
        <th>order_date</th>
        <th>product_name</th>
        <th>price</th>
        <th>member</th>
        <th>ranking</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>sushi</td>
        <td>10</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-07</td>
        <td>curry</td>
        <td>15</td>
        <td>Y</td>
        <td>1</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-10</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>2</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>3</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>3</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-01</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-02</td>
        <td>curry</td>
        <td>15</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-04</td>
        <td>sushi</td>
        <td>10</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-11</td>
        <td>sushi</td>
        <td>10</td>
        <td>Y</td>
        <td>1</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-16</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>2</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-02-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>Y</td>
        <td>3</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
        <td>null</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-07</td>
        <td>ramen</td>
        <td>12</td>
        <td>N</td>
        <td>null</td>
      </tr>
    </tbody>
  </table>
	</details>
	
	Solution:
	```sql
	SELECT customer_id, order_date, product_name, price, member, 
	CASE
		WHEN member = 'N'THEN null
	    WHEN member = 'Y' THEN RANK() OVER ( PARTITION BY customer_id, member ORDER BY order_date ASC)
	  	END AS rank
	FROM (
		SELECT s.customer_id, s.order_date, m.product_name, m.price,
	  	CASE 
	    	WHEN s.order_date < me.join_date THEN 'N'
	    	WHEN s.order_date >= me.join_date THEN 'Y'
	      	ELSE 'N'
		END AS member
	  	FROM sales s LEFT JOIN members me
	  	ON me.customer_id = s.customer_id
	  	JOIN menu m 
	  	ON m.product_id = s.product_id
	  	ORDER BY s.customer_id, s.order_date
	   ) as derivedTable;
	```
