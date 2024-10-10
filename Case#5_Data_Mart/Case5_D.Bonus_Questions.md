# Bonus Questions
### Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?
- <details><summary><h4>region</h4></summary>
  
  #### Solution:
  ```sql
  SELECT region,
    before_12_weeks,
    after_12_weeks,
    percent_change
  FROM clean_weekly_sales cws,
    LATERAL(SELECT SUM(sales) after_12_weeks
        FROM clean_weekly_sales cws2 
        WHERE week_number >= DATE_PART('w', '2020-06-15'::DATE)
        AND week_number <= DATE_PART('w', '2020-06-15'::DATE)+11
        AND calendar_year = '2020'
          AND cws2.region = cws.region) a12w,
    LATERAL (SELECT SUM(sales) before_12_weeks 
        FROM clean_weekly_sales cws3 
        WHERE week_number < DATE_PART('w', '2020-06-15'::DATE)
        AND week_number >= DATE_PART('w', '2020-06-15'::DATE)-12
        AND calendar_year = '2020'
        AND cws3.region = cws.region) b12w,
    LATERAL (SELECT ROUND((after_12_weeks - before_12_weeks)*100.0 / before_12_weeks, 2) percent_change) pc
  GROUP BY region, after_12_weeks, before_12_weeks, percent_change
  ORDER BY percent_change;
  ```
  #### Output:
  region     | before_12_weeks | after_12_weeks | percent_change
  -- | -- | -- | --
  ASIA          |      1637244466 |     1583807621 |          -3.26
  OCEANIA       |      2354116790 |     2282795690 |          -3.03
  SOUTH AMERICA |       213036207 |      208452033 |          -2.15
  CANADA        |       426438454 |      418264441 |          -1.92
  USA           |       677013558 |      666198715 |          -1.60
  AFRICA        |      1709537105 |     1700390294 |          -0.54
  EUROPE        |       108886567 |      114038959 |           4.73

  Asia have a 3.26% decrease in sales followed by Oceania with 3.03% decrease in sales while Europe have 4.73% increase in sales. Check above details for other regions.
  <hr>
  
  </details>

- <details><summary><h4>platform</h4></summary>
  
  #### Solution:
  ```sql
  SELECT platform,
  	before_12_weeks,
  	after_12_weeks,
  	percent_change
  FROM clean_weekly_sales cws,
  	LATERAL(SELECT SUM(sales) after_12_weeks
  			FROM clean_weekly_sales cws2 
  			WHERE week_number >= DATE_PART('w', '2020-06-15'::DATE)
  			AND week_number <= DATE_PART('w', '2020-06-15'::DATE)+11
  			AND calendar_year = '2020'
  		    AND cws2.platform = cws.platform) a12w,
  	LATERAL (SELECT SUM(sales) before_12_weeks 
  			FROM clean_weekly_sales cws3 
  			WHERE week_number < DATE_PART('w', '2020-06-15'::DATE)
  			AND week_number >= DATE_PART('w', '2020-06-15'::DATE)-12
  			AND calendar_year = '2020'
  			AND cws3.platform = cws.platform) b12w,
  	LATERAL (SELECT ROUND((after_12_weeks - before_12_weeks)*100.0 / before_12_weeks, 2) percent_change) pc
  GROUP BY platform, after_12_weeks, before_12_weeks, percent_change
  ORDER BY percent_change;
  ```
  #### Output:
  platform | before_12_weeks | after_12_weeks | percent_change
  -- | -- | -- | --
  Retail   |      6906861113 |     6738777279 |          -2.43
  Shopify  |       219412034 |      235170474 |           7.18

  Retail total sales have decreased by 2.43% after the changes while Shopify total sales increased by 7.18% after its changes.
  <hr>
  </details>
  
- <details><summary><h4>age_band</h4></summary>
  
  #### Solution:
  ```sql
  SELECT age_band,
  	before_12_weeks,
  	after_12_weeks,
  	percent_change
  FROM clean_weekly_sales cws,
    LATERAL(SELECT SUM(sales) after_12_weeks
            FROM clean_weekly_sales cws2 
            WHERE week_number >= DATE_PART('w', '2020-06-15'::DATE)
            AND week_number <= DATE_PART('w', '2020-06-15'::DATE)+11
            AND calendar_year = '2020'
            AND cws2.age_band = cws.age_band) a12w,
    LATERAL (SELECT SUM(sales) before_12_weeks 
            FROM clean_weekly_sales cws3 
            WHERE week_number < DATE_PART('w', '2020-06-15'::DATE)
            AND week_number >= DATE_PART('w', '2020-06-15'::DATE)-12
            AND calendar_year = '2020'
            AND cws3.age_band = cws.age_band) b12w,
    LATERAL (SELECT ROUND((after_12_weeks - before_12_weeks)*100.0 / before_12_weeks, 2) percent_change) pc
  GROUP BY age_band, after_12_weeks, before_12_weeks, percent_change
  ORDER BY percent_change;
  ```
  #### Output:
  age_band   | before_12_weeks | after_12_weeks | percent_change
  -- | -- | -- | -- 
  unknown      |      2764354464 |     2671961443 |          -3.34
  Middle Aged  |      1164847640 |     1141853348 |          -1.97
  Retirees     |      2395264515 |     2365714994 |          -1.23
  Young Adults |       801806528 |      794417968 |          -0.92

  Unknown age band have the 3.34% decrease in total sales after the changes, followed by Middle age with 1.97% decrease in sales while Young adults have 0.92% decrease in sales after the changes.
  <hr>
  </details>
  
- <details><summary><h4>demographic</h4></summary>

  #### Solution:
  ```sql
  SELECT demographics,
  	before_12_weeks,
  	after_12_weeks,
  	percent_change
  FROM clean_weekly_sales cws,
	  LATERAL(SELECT SUM(sales) after_12_weeks
      			FROM clean_weekly_sales cws2 
      			WHERE week_number >= DATE_PART('w', '2020-06-15'::DATE)
      			AND week_number <= DATE_PART('w', '2020-06-15'::DATE)+11
      			AND calendar_year = '2020'
            AND cws2.demographics = cws.demographics) a12w,
	  LATERAL (SELECT SUM(sales) before_12_weeks 
      			FROM clean_weekly_sales cws3 
      			WHERE week_number < DATE_PART('w', '2020-06-15'::DATE)
      			AND week_number >= DATE_PART('w', '2020-06-15'::DATE)-12
      			AND calendar_year = '2020'
      			AND cws3.demographics = cws.demographics) b12w,
	  LATERAL (SELECT ROUND((after_12_weeks-before_12_weeks)*100.0/before_12_weeks, 2) percent_change) pc
  GROUP BY demographics, after_12_weeks, before_12_weeks, percent_change
  ORDER BY percent_change;
  ```
  #### Output:
  demographics | before_12_weeks | after_12_weeks | percent_change
  -- | -- | -- | --
  unknown      |      2764354464 |     2671961443 |          -3.34
  Families     |      2328329040 |     2286009025 |          -1.82
  Couples      |      2033589643 |     2015977285 |          -0.87

  Unknown demographics is the most affected with 3.34% decrease in total sales, followed by Families demographics with 1.82% decrease in while Couple have 0.87% decrease in total sales after the changes.
  <hr>
  </details>
  
- <details><summary><h4>customer_type</h4></summary>

  #### Solution:
  ```sql
  SELECT customer_type,
  	before_12_weeks,
	  after_12_weeks,
	  percent_change
  FROM clean_weekly_sales cws,
	  LATERAL(SELECT SUM(sales) after_12_weeks
              			FROM clean_weekly_sales cws2 
              			WHERE week_number >= DATE_PART('w', '2020-06-15'::DATE)
              			AND week_number <= DATE_PART('w', '2020-06-15'::DATE)+11
              			AND calendar_year = '2020'
              		  AND cws2.customer_type = cws.customer_type) a12w,
	  LATERAL (SELECT SUM(sales) before_12_weeks 
              			FROM clean_weekly_sales cws3 
              			WHERE week_number < DATE_PART('w', '2020-06-15'::DATE)
              			AND week_number >= DATE_PART('w', '2020-06-15'::DATE)-12
              			AND calendar_year = '2020'
              			AND cws3.customer_type = cws.customer_type) b12w,
	  LATERAL (SELECT ROUND((after_12_weeks-before_12_weeks)*100.0/before_12_weeks, 2) percent_change) pc
  GROUP BY customer_type, after_12_weeks, before_12_weeks, percent_change
  ORDER BY percent_change;
  ```
  #### Output:
  customer_type | before_12_weeks | after_12_weeks | percent_change
  -- | -- | -- | --
  Guest         |      2573436301 |     2496233635 |          -3.00
  Existing      |      3690116427 |     3606243454 |          -2.27
  New           |       862720419 |      871470664 |           1.01

  Guest is the most affted with 3% decrease in total sales, followed by Existing customers with 2.27% decrease and New customers have a 1.01% increase in total sales after the changes. 
  <hr>
  </details>

