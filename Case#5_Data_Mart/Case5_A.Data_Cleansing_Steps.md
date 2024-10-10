# Data Cleansing Steps

In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

- Convert the week_date to a DATE format
- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
- Add a month_number with the calendar month for each week_date value as the 3rd column
- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

<div align=center>
  
| segment | age_band     |
-- | --
| 1       | Young Adults |
| 2       | Middle Aged  |
| 3 or 4  | Retirees     |

</div>

- Add a new demographic column using the following mapping for the first letter in the segment values:
<div align=center>
  
| segment | demographic |
|---------|-------------|
| C       | Couples     |
| F       | Families    |

</div>

- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns
- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record

  #### Solution:
```sql
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
```
