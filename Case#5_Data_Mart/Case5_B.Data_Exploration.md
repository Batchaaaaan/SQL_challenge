# Data Exploration
### 1.What day of the week is used for each week_date value?
#### Solution:
```sql
SELECT DISTINCT(TO_CHAR(week_date, 'Day')) Day_of_the_week 
FROM clean_weekly_sales;
```
#### Output:
day_of_the_week
-- |
Monday

Monday is the day of the week where each week_date value start.
<hr>

### 2.What range of week numbers are missing from the dataset?
#### Solution:
```sql
SELECT * FROM generate_series(1,53) week_numbers
WHERE week_numbers NOT IN (SELECT DISTINCT(week_number) 
FROM clean_weekly_sales
ORDER BY week_number);
```
#### Output:

###### Note: Not all outputs are shown.
 week_numbers
-- |
1
2
3
--
51
52
53

Week 1 to Week 12 and Week 37 to Week 53 are missing from the dataset.
###### Note: PostgreSQL first week does not start on 01-01. It is rather adjusted that is why the count have 53 weeks.

<hr>


### 3.How many total transactions were there for each year in the dataset?
#### Solution:
```sql
SELECT calendar_year, 
	SUM(transactions) total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year;
```
#### Output:
 calendar_year | total_transactions
-- | --
2018 |          346406460
2019 |          365639285
2020 |          375813651

2020 have the highest count of transactions followed by 2019 and 2018 having the least.
<hr>

### 4.What is the total sales for each region for each month?
#### Solution:
```sql
SELECT region, 
	month_number, 
	SUM(sales) total_sales
FROM clean_weekly_sales
GROUP BY region, month_number
ORDER BY region, month_number;
```
#### Output:
###### Note: Not all data are shown since the result is huge.
region     | month_number | total_sales
-- | -- | --
AFRICA        |            3 |   567767480
AFRICA        |            4 |  1911783504
AFRICA        |            5 |  1647244738
AFRICA        |            6 |  1767559760
AFRICA        |            7 |  1960219710
AFRICA        |            8 |  1809596890
AFRICA        |            9 |   276320987
ASIA          |            3 |   529770793
ASIA          |            4 |  1804628707
ASIA          |            5 |  1526285399
ASIA          |            6 |  1619482889
ASIA          |            7 |  1768844756

<hr>

### 5.What is the total count of transactions for each platform?
#### Solution:
```sql
SELECT platform, 
	SUM(transactions) transaction_count
FROM clean_weekly_sales
GROUP BY platform;
```
#### Output:
 platform | transaction_count
-- | --
Shopify  |           5925169
Retail   |        1081934227

Retail transactions count have way more than Shopify.
<hr>

### 6.What is the percentage of sales for Retail vs Shopify for each month?
#### Solution:
```sql
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
```
#### Output:
 calendar_year | month_number | retail_percentage_vs_shopify
-- | -- | --
2018 |            3 |                        97.92
2018 |            4 |                        97.93
2018 |            5 |                        97.73
2018 |            6 |                        97.76
2018 |            7 |                        97.75
2018 |            8 |                        97.71
2018 |            9 |                        97.68
2019 |            3 |                        97.71
2019 |            4 |                        97.80
2019 |            5 |                        97.52
2019 |            6 |                        97.42
2019 |            7 |                        97.35
2019 |            8 |                        97.21
2019 |            9 |                        97.09
2020 |            3 |                        97.30
2020 |            4 |                        96.96
2020 |            5 |                        96.71
2020 |            6 |                        96.80
2020 |            7 |                        96.67
2020 |            8 |                        96.51

All retail sales are atleast 96%-98% of the total sales every month.
<hr>

### 7.What is the percentage of sales by demographic for each year in the dataset?
#### Solution:
```sql
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
```
#### Output:
 calendar_year | unknown_percent_total | families_percent_total | couples_percent_total
-- | -- | -- | --
2019 |                 40.25 |                  32.47 |                 27.28
2018 |                 41.63 |                  31.99 |                 26.38
2020 |                 38.55 |                  32.73 |                 28.72

The total sales percentage is mostly composed of unknown demographics each year.
<hr>


### 8.Which age_band and demographic values contribute the most to Retail sales?
#### Solution:
```sql
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
```
#### Output:
age_band   | demographics | total_sales | percent_total_on_retail
-- | -- | -- | --
unknown      | unknown      | 16067285533 |                   40.52
Retirees     | Families     |  6634686916 |                   16.73
Retirees     | Couples      |  6370580014 |                   16.07
Middle Aged  | Families     |  4354091554 |                   10.98
Young Adults | Couples      |  2602922797 |                    6.56
Middle Aged  | Couples      |  1854160330 |                    4.68
Young Adults | Families     |  1770889293 |                    4.47

The total sales is mostly composed of Unknown age_band and Unknown demographics with ~40.52% of the total while Young adults and Families have least with ~4.47% of the tottal.
<hr>

### 9.Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
No, we cannot use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify.

Averaging an already average value would either pull it higher or lower from the true average.

Consider the solution below for my point and how would I solve this problem.
#### Solution:
```sql
SELECT calendar_year,
	platform,
	ROUND(AVG(avg_transaction), 2) incorrect_avg,
	ROUND(SUM(sales)*1.0 / SUM(transactions), 2) correct_avg 
FROM clean_weekly_sales
GROUP BY calendar_year, platform
ORDER BY calendar_year, platform;
```
#### Output:
calendar_year | platform | incorrect_avg | correct_avg
-- | -- | -- | --
2018 | Retail   |         42.41 |       36.56
2018 | Shopify  |        187.80 |      192.48
2019 | Retail   |         41.47 |       36.83
2019 | Shopify  |        177.07 |      183.36
2020 | Retail   |         40.14 |       36.56
2020 | Shopify  |        174.40 |      179.03
