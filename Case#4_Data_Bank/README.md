<h1><p align="center"> Case Study #4 - Data Bank </p></h1>

<div align='center'><img src="https://8weeksqlchallenge.com/images/case-study-designs/4.png" alt="case1_image" width="500"/></div>
<hr>
<p align='center'>This is the Fourth Case Study of 8 Weeks SQL Challenge by DannyMa.
<a href="https://8weeksqlchallenge.com/case-study-4/" rel="nofollow">Click here to view.</a>
</p>
<hr>


# Introduction
There is a new innovation in the financial industry called Neo-Banks: new aged digital only banks without physical branches.

Danny thought that there should be some sort of intersection between these new age banks, cryptocurrency and the data world…so he decides to launch a new initiative - Data Bank!

Data Bank runs just like any other digital bank - but it isn’t only for banking activities, they also have the world’s most secure distributed data storage platform!

Customers are allocated cloud data storage limits which are directly linked to how much money they have in their accounts. There are a few interesting caveats that go with this business model, and this is where the Data Bank team need your help!

The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.

This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments!

# Entity Relationship Diagram
<div align='center'><img src="https://github.com/user-attachments/assets/c090890c-aa6d-4865-9f65-1453a609c4b4" alt='case1_entity' width='500'></div>

# Tables 
<details><summary>All tables are available here</summary>
  
 - ### Table 1: Regions
| region_id | region_name |
|-----------|-------------|
| 1         | Africa      |
| 2         | America     |
| 3         | Asia        |
| 4         | Europe      |
| 5         | Oceania     |

<hr>

- ### Table 2: menu
| customer_id | region_id | node_id | start_date | end_date   |
|-------------|-----------|---------|------------|------------|
| 1           | 3         | 4       | 2020-01-02 | 2020-01-03 |
| 2           | 3         | 5       | 2020-01-03 | 2020-01-17 |
| 3           | 5         | 4       | 2020-01-27 | 2020-02-18 |
| 4           | 5         | 4       | 2020-01-07 | 2020-01-19 |
| 5           | 3         | 3       | 2020-01-15 | 2020-01-23 |
| 6           | 1         | 1       | 2020-01-11 | 2020-02-06 |
| 7           | 2         | 5       | 2020-01-20 | 2020-02-04 |
| 8           | 1         | 2       | 2020-01-15 | 2020-01-28 |
| 9           | 4         | 5       | 2020-01-21 | 2020-01-25 |
| 10          | 3         | 4       | 2020-01-13 | 2020-01-14 |

<hr>

 - ### Table 3: members
| customer_id | txn_date   | txn_type | txn_amount |
|-------------|------------|----------|------------|
| 429         | 2020-01-21 | deposit  | 82         |
| 155         | 2020-01-10 | deposit  | 712        |
| 398         | 2020-01-01 | deposit  | 196        |
| 255         | 2020-01-14 | deposit  | 563        |
| 185         | 2020-01-29 | deposit  | 626        |
| 309         | 2020-01-13 | deposit  | 995        |
| 312         | 2020-01-20 | deposit  | 485        |
| 376         | 2020-01-03 | deposit  | 706        |
| 188         | 2020-01-13 | deposit  | 601        |
| 138         | 2020-01-11 | deposit  | 520        |

</details>

# Case Study Questions
The following case study questions include some general data exploration analysis for the nodes and transactions before diving right into the core business questions and finishes with a challenging final request!
