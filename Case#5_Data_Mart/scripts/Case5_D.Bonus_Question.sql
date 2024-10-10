-- Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?

-- region

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

-- platform
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

-- age_band
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

-- demographic
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

-- customer_type
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

-- Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis?