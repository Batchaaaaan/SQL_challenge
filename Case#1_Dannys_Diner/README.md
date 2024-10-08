<h1><p align="center"> Case Study #1 - Danny's Diner </p></h1>

<div align='center'><img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="case1_image" width="500"/></div>
<hr>
<p align='center'>This is the first Case Study of 8 Weeks SQL Challenge by DannyMa.
<a href="https://8weeksqlchallenge.com/case-study-1/" rel="nofollow">Click here to view.</a>
</p>
<hr>


# Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

# Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

- sales
- menu
- members

# Entity Relationship Diagram
<div align='center'><img src="https://github.com/user-attachments/assets/c090890c-aa6d-4865-9f65-1453a609c4b4" alt='case1_entity' width='500'></div>

# Tables 
 - ## Table 1: sales
 <table>
    <thead>
      <tr>
        <th>customer_id</th>
        <th>order_date</th>
        <th>product_id</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>1</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-01</td>
        <td>2</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-07</td>
        <td>2</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-10</td>
        <td>3</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>3</td>
      </tr>
      <tr>
        <td>A</td>
        <td>2021-01-11</td>
        <td>3</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-01</td>
        <td>2</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-02</td>
        <td>2</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-04</td>
        <td>1</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-11</td>
        <td>1</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-16</td>
        <td>3</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-02-01</td>
        <td>3</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>3</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-01</td>
        <td>3</td>
      </tr>
      <tr>
        <td>C</td>
        <td>2021-01-07</td>
        <td>3</td>
      </tr>
    </tbody>
  </table>

- ## Table 2: menu
<table>
    <thead>
      <tr>
        <th>product_id</th>
        <th>product_name</th>
        <th>price</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>sushi</td>
        <td>10</td>
      </tr>
      <tr>
        <td>2</td>
        <td>curry</td>
        <td>15</td>
      </tr>
      <tr>
        <td>3</td>
        <td>ramen</td>
        <td>12</td>
      </tr>
    </tbody>
  </table>

 - ## Table 3: members
<table>
    <thead>
      <tr>
        <th>customer_id</th>
        <th>join_date</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>A</td>
        <td>2021-01-07</td>
      </tr>
      <tr>
        <td>B</td>
        <td>2021-01-09</td>
      </tr>
    </tbody>
  </table>
