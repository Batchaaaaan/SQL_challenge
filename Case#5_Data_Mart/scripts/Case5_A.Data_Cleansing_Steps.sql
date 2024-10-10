
-- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

-- segment	age_band
-- 1	Young Adults
-- 2	Middle Aged
-- 3 or 4	Retirees
-- Add a new demographic column using the following mapping for the first letter in the segment values:
-- segment	demographic
-- C	Couples
-- F	Families
-- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns

-- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record
SELECT week_date::DATE, --CAST week_date into DATE data type
	DATE_PART('Week', week_date::DATE) week_number, 
	DATE_PART('Month', week_date::DATE) month_number,
	DATE_PART('Year', week_date::DATE) calendar_year,
	region,
	platform,
	s.segment,
	customer_type,
	age_band,
	demographics,
	transactions,
	sales,
	avg_transaction
INTO TABLE clean_weekly_sales
FROM weekly_sales ws,
	LATERAL (SELECT CASE 
						WHEN ws.segment = 'null' THEN 'unknown'
						ELSE ws.segment
					END as segment) s,
	LATERAL (SELECT CASE 
						WHEN ws.segment LIKE '%1' THEN 'Young Adults'
						WHEN ws.segment LIKE '%2' THEN 'Middle Aged'
						WHEN ws.segment LIKE '%3' OR ws.segment LIKE '%4' THEN 'Retirees'
						ELSE 'unknown'
					END AS age_band) ab,
	LATERAL (SELECT CASE
						WHEN ws.segment LIKE 'C%' THEN 'Couples'
						WHEN ws.segment LIKE 'F%' THEN 'Families'
						ELSE 'unknown'
					END AS demographics) d,
	LATERAL (SELECT ROUND(sales/transactions, 2) avg_transaction ) t
;
