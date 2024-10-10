-- 3. Before & After Analysis
-- This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

-- Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

-- We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

-- Using this analysis approach - answer the following questions:

-- What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
SELECT before_4_weeks,
	after_4_weeks,
	percent_change
FROM clean_weekly_sales,
	LATERAL(SELECT SUM(sales) after_4_weeks
			FROM clean_weekly_sales cws2 
			WHERE week_date >= '2020-06-15'
			AND week_date <= '2020-06-15'::timestamp + INTERVAL'3weeks') a4w,
	LATERAL (SELECT SUM(sales) before_4_weeks 
			FROM clean_weekly_sales cws3 
			WHERE week_date < '2020-06-15' 
			AND week_date >= '2020-06-15'::timestamp - INTERVAL'4weeks') b4w,
	LATERAL (SELECT ROUND((after_4_weeks - before_4_weeks)*100.0 / before_4_weeks, 2) percent_change) pc
GROUP BY after_4_weeks, before_4_weeks, percent_change;

-- What about the entire 12 weeks before and after?
SELECT before_12_weeks,
	after_12_weeks,
	percent_change
FROM clean_weekly_sales,
	LATERAL(SELECT SUM(sales) after_12_weeks
			FROM clean_weekly_sales cws2 
			WHERE week_date >= '2020-06-15'
			AND week_date <= '2020-06-15'::timestamp + INTERVAL'11weeks') a12w,
	LATERAL (SELECT SUM(sales) before_12_weeks 
			FROM clean_weekly_sales cws3 
			WHERE week_date < '2020-06-15'
			AND week_date >= '2020-06-15'::timestamp - INTERVAL'12weeks') b12w,
	LATERAL (SELECT ROUND((after_12_weeks - before_12_weeks)*100.0 / before_12_weeks, 2) percent_change) pc
GROUP BY after_12_weeks, before_12_weeks, percent_change;

-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
--4 week period
SELECT calendar_year,
	before_4_weeks,
	after_4_weeks,
	percent_change
FROM clean_weekly_sales cws,
	LATERAL(SELECT SUM(sales) after_4_weeks
			FROM clean_weekly_sales cws2 
			WHERE week_number >= DATE_PART('w', '2020-06-15'::DATE)
			AND week_number <= DATE_PART('w', '2020-06-15'::DATE)+3
		   	AND cws2.calendar_year = cws.calendar_year) a4w,
	LATERAL (SELECT SUM(sales) before_4_weeks 
			FROM clean_weekly_sales cws3 
			WHERE week_number < DATE_PART('w', '2020-06-15'::DATE)
			AND week_number >= DATE_PART('w', '2020-06-15'::DATE)-4
			AND cws3.calendar_year = cws.calendar_year) b4w,
	LATERAL (SELECT ROUND((after_4_weeks - before_4_weeks)*100.0 / before_4_weeks, 2) percent_change) pc
GROUP BY calendar_year, after_4_weeks, before_4_weeks, percent_change
ORDER BY calendar_year;

--12 week period
SELECT calendar_year,
	before_12_weeks,
	after_12_weeks,
	percent_change
FROM clean_weekly_sales cws,
	LATERAL(SELECT SUM(sales) after_12_weeks
			FROM clean_weekly_sales cws2 
			WHERE week_number >= DATE_PART('w', '2020-06-15'::DATE)
			AND week_number <= DATE_PART('w', '2020-06-15'::DATE)+11
		    AND cws2.calendar_year = cws.calendar_year) a12w,
	LATERAL (SELECT SUM(sales) before_12_weeks 
			FROM clean_weekly_sales cws3 
			WHERE week_number < DATE_PART('w', '2020-06-15'::DATE)
			AND week_number >= DATE_PART('w', '2020-06-15'::DATE)-12
			AND cws3.calendar_year = cws.calendar_year) b12w,
	LATERAL (SELECT ROUND((after_12_weeks - before_12_weeks)*100.0 / before_12_weeks, 2) percent_change) pc
GROUP BY calendar_year, after_12_weeks, before_12_weeks, percent_change
ORDER BY calendar_year;