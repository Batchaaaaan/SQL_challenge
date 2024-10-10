<h1><p align="center"> Case Study #5 - Data Mart </p></h1>

<div align='center'><img src="https://8weeksqlchallenge.com/images/case-study-designs/5.png" alt="case5_image" width="500"/></div>
<hr>
<p align='center'>This is the fifth Case Study of 8 Weeks SQL Challenge by DannyMa.
<a href="https://8weeksqlchallenge.com/case-study-5/" rel="nofollow">Click here to view.</a>
</p>
<hr>


# Introduction
Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specialises in fresh produce - Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.

Danny needs your help to quantify the impact of this change on the sales performance for Data Mart and it’s separate business areas.

The key business question he wants you to help him answer are the following:

- What was the quantifiable impact of the changes introduced in June 2020?
- Which platform, region, segment and customer types were the most impacted by this change?
- What can we do about future introduction of similar sustainability updates to the business to minimise impact on sales?
<hr>

# Available Data
For this case study there is only a single table: weekly_sales

The Entity Relationship Diagram is shown below with the data types made clear, please note that there is only this one table - hence why it looks a little bit lonely!

<div align='center'><img src="https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%235_Data_Mart/images/case-study-5-erd.png?raw=true" alt="case5_image" width="400">
</div>

<hr>

# Table
 - ### Table: weekly_sales
 ###### Note: This is only an example rows. Not all data are shown.
| week_date | region        | platform | segment | customer_type | transactions | sales      |
|-----------|---------------|----------|---------|---------------|--------------|------------|
| 9/9/20    | OCEANIA       | Shopify  | C3      | New           | 610          | 110033.89  |
| 29/7/20   | AFRICA        | Retail   | C1      | New           | 110692       | 3053771.19 |
| 22/7/20   | EUROPE        | Shopify  | C4      | Existing      | 24           | 8101.54    |
| 13/5/20   | AFRICA        | Shopify  | null    | Guest         | 5287         | 1003301.37 |
| 24/7/19   | ASIA          | Retail   | C1      | New           | 127342       | 3151780.41 |
| 10/7/19   | CANADA        | Shopify  | F3      | New           | 51           | 8844.93    |
| 26/6/19   | OCEANIA       | Retail   | C3      | New           | 152921       | 5551385.36 |
| 29/5/19   | SOUTH AMERICA | Shopify  | null    | New           | 53           | 10056.2    |
| 22/8/18   | AFRICA        | Retail   | null    | Existing      | 31721        | 1718863.58 |
| 25/7/18   | SOUTH AMERICA | Retail   | null    | New           | 2136         | 81757.91   |

