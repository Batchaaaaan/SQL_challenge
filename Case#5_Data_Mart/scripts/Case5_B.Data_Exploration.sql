-- 2. Data Exploration
-- What day of the week is used for each week_date value?
SELECT DISTINCT(TO_CHAR(week_date, 'Day')) Day_of_the_week 
FROM clean_weekly_sales;

-- What range of week numbers are missing from the dataset?
SELECT * FROM generate_series(1,53) week_numbers
WHERE week_numbers NOT IN (SELECT DISTINCT(week_number) 
FROM clean_weekly_sales
ORDER BY week_number);

-- How many total transactions were there for each year in the dataset?
SELECT calendar_year, 
	SUM(transactions) total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year;


-- What is the total sales for each region for each month?
SELECT region, 
	month_number, 
	SUM(sales) total_sales
FROM clean_weekly_sales
GROUP BY region, month_number
ORDER BY region, month_number;

-- What is the total count of transactions for each platform
SELECT platform, 
	SUM(transactions) transaction_count
FROM clean_weekly_sales
GROUP BY platform;

-- What is the percentage of sales for Retail vs Shopify for each month?
SELECT calendar_year,
	month_number,
	ROUND(SUM(sales)*100.0 / total_sales,2) retail_percentage_vs_shopify
FROM clean_weekly_sales cws1,
	LATERAL (SELECT SUM(sales) total_sales 
			 FROM clean_weekly_sales cws2 
			 WHERE cws2.month_number = cws1.month_number 
			 AND cws2.calendar_year = cws1.calendar_year
			 GROUP BY calendar_year, month_number) ts
WHERE platform = 'Retail'
GROUP BY calendar_year, month_number, total_sales
ORDER by calendar_year, month_number;
	
-- What is the percentage of sales by demographic for each year in the dataset?
SELECT calendar_year,
	ROUND(total_sales_unknown*100.0/ SUM(sales),2) unknown_percent_total,
	ROUND(total_sales_families*100.0/ SUM(sales),2) families_percent_total,
	ROUND(total_sales_couples*100.0/ SUM(sales),2) couples_percent_total
FROM clean_weekly_sales cws,
	LATERAL (SELECT SUM(sales) total_sales_unknown
			 FROM clean_weekly_sales cws_unknown
			 WHERE demographics = 'unknown'
			 AND cws_unknown.calendar_year = cws.calendar_year
			 GROUP BY calendar_year) ts_u,
	LATERAL (SELECT SUM(sales) total_sales_families
			 FROM clean_weekly_sales cws_unknown
			 WHERE demographics = 'Families'
			 AND cws_unknown.calendar_year = cws.calendar_year
			 GROUP BY calendar_year) ts_f,
	LATERAL (SELECT SUM(sales) total_sales_couples
			 FROM clean_weekly_sales cws_unknown
			 WHERE demographics = 'Couples'
			 AND cws_unknown.calendar_year = cws.calendar_year
			 GROUP BY calendar_year) ts_c
GROUP By calendar_year, total_sales_unknown, total_sales_families, total_sales_couples;


-- Which age_band and demographic values contribute the most to Retail sales?
SELECT age_band,
	demographics,
	SUM(sales) total_sales,
	ROUND(SUM(sales)*100.0 / retail_sales, 2) percent_total_on_retail
FROM clean_weekly_sales,
	LATERAL (SELECT SUM(sales) retail_sales
			 FROM clean_weekly_sales
			 WHERE platform='Retail') rs
WHERE platform = 'Retail'
GROUP BY age_band, demographics, retail_sales
ORDER BY total_sales DESC;

-- Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 
--If not - how would you calculate it instead?
SELECT calendar_year,
	platform,
	ROUND(AVG(avg_transaction), 2) incorrect_avg,
	ROUND(SUM(sales)*1.0 / SUM(transactions), 2) correct_avg 
FROM clean_weekly_sales
GROUP BY calendar_year, platform
ORDER BY calendar_year, platform;
