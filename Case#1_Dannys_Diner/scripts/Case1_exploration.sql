/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id, SUM(menu.price) totalAmount
FROM sales JOIN menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT customer_id,  COUNT(order_date) AS numDays
FROM (
	SELECT customer_id, order_date 
	FROM sales
	GROUP BY customer_id, order_date
	) AS derivedTable
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
SELECT s.customer_id, m.product_name
FROM sales s JOIN menu m
ON s.product_id = m.product_id
WHERE s.order_date = (
	SELECT MIN(order_date)
	FROM sales
	WHERE customer_id = s.customer_id
	)
GROUP BY s.customer_id, m.product_name;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name, COUNT(*) AS total_count 
FROM sales s JOIN menu m
ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_count DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
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

-- 6. Which item was purchased first by the customer after they became a member?
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
	
-- 7. Which item was purchased just before the customer became a member?
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

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(*), SUM(m.price) totalSpent
FROM sales s JOIN menu m
ON s.product_id = m.product_id
WHERE s.order_date < (
		SELECT join_date
		FROM members me
		WHERE customer_id = s.customer_id)
GROUP BY s.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
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

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
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

-- BONUS QUESTIONS 
-- JOIN ALL 
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


-- RANK ALL
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
