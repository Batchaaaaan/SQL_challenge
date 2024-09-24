<h1><p align="center">Case Study #2 - Pizza Runner</p></h1>

<div align='center'><img src='https://8weeksqlchallenge.com/images/case-study-designs/2.png' alt="case1_image" width="500"/></div>
<hr>
<p align='center'>This is the Second Case Study of 8 Weeks SQL Challenge by DannyMa.
<a href="https://8weeksqlchallenge.com/case-study-2/" rel="nofollow">Click here to view.</a>
</p>
<hr>

### Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.
<hr>

### Entity Relationship Diagram
<div align='center'><img src="https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%232_Pizza_Runner/images/case2_entity.png?raw=true" alt='case2_entity' width='700'></div>

<hr>

### Tables
<details><summary> All the tables used in the challenge</summary>
   
   ### Table 1: runners
   
 <table>
  <thead>
    <tr>
      <th>runner_id</th>
      <th>registration_date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>2021-01-01</td>
    </tr>
    <tr>
      <td>2</td>
      <td>2021-01-03</td>
    </tr>
    <tr>
      <td>3</td>
      <td>2021-01-08</td>
    </tr>
    <tr>
      <td>4</td>
      <td>2021-01-15</td>
    </tr>
  </tbody>
</table>
<hr>

   ### Table 2: customer_orders

<table>
    <thead>
      <tr>
        <th>order_id</th>
        <th>customer_id</th>
        <th>pizza_id</th>
        <th>exclusions</th>
        <th>extras</th>
        <th>order_time</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>101</td>
        <td>1</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2021-01-01 18:05:02</td>
      </tr>
      <tr>
        <td>2</td>
        <td>101</td>
        <td>1</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2021-01-01 19:00:52</td>
      </tr>
      <tr>
        <td>3</td>
        <td>102</td>
        <td>1</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>2021-01-02 23:51:23</td>
      </tr>
      <tr>
        <td>3</td>
        <td>102</td>
        <td>2</td>
        <td>&nbsp;</td>
        <td>NaN</td>
        <td>2021-01-02 23:51:23</td>
      </tr>
      <tr>
        <td>4</td>
        <td>103</td>
        <td>1</td>
        <td>4</td>
        <td>&nbsp;</td>
        <td>2021-01-04 13:23:46</td>
      </tr>
      <tr>
        <td>4</td>
        <td>103</td>
        <td>1</td>
        <td>4</td>
        <td>&nbsp;</td>
        <td>2021-01-04 13:23:46</td>
      </tr>
      <tr>
        <td>4</td>
        <td>103</td>
        <td>2</td>
        <td>4</td>
        <td>&nbsp;</td>
        <td>2021-01-04 13:23:46</td>
      </tr>
      <tr>
        <td>5</td>
        <td>104</td>
        <td>1</td>
        <td>null</td>
        <td>1</td>
        <td>2021-01-08 21:00:29</td>
      </tr>
      <tr>
        <td>6</td>
        <td>101</td>
        <td>2</td>
        <td>null</td>
        <td>null</td>
        <td>2021-01-08 21:03:13</td>
      </tr>
      <tr>
        <td>7</td>
        <td>105</td>
        <td>2</td>
        <td>null</td>
        <td>1</td>
        <td>2021-01-08 21:20:29</td>
      </tr>
      <tr>
        <td>8</td>
        <td>102</td>
        <td>1</td>
        <td>null</td>
        <td>null</td>
        <td>2021-01-09 23:54:33</td>
      </tr>
      <tr>
        <td>9</td>
        <td>103</td>
        <td>1</td>
        <td>4</td>
        <td>1, 5</td>
        <td>2021-01-10 11:22:59</td>
      </tr>
      <tr>
        <td>10</td>
        <td>104</td>
        <td>1</td>
        <td>null</td>
        <td>null</td>
        <td>2021-01-11 18:34:49</td>
      </tr>
      <tr>
        <td>10</td>
        <td>104</td>
        <td>1</td>
        <td>2, 6</td>
        <td>1, 4</td>
        <td>2021-01-11 18:34:49</td>
      </tr>
    </tbody>
  </table>
<hr>

   ### Table 3: runner_orders

<table>
    <thead>
      <tr>
        <th>order_id</th>
        <th>runner_id</th>
        <th>pickup_time</th>
        <th>distance</th>
        <th>duration</th>
        <th>cancellation</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>1</td>
        <td>2021-01-01 18:15:34</td>
        <td>20km</td>
        <td>32 minutes</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>2</td>
        <td>1</td>
        <td>2021-01-01 19:10:54</td>
        <td>20km</td>
        <td>27 minutes</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>3</td>
        <td>1</td>
        <td>2021-01-03 00:12:37</td>
        <td>13.4km</td>
        <td>20 mins</td>
        <td>NaN</td>
      </tr>
      <tr>
        <td>4</td>
        <td>2</td>
        <td>2021-01-04 13:53:03</td>
        <td>23.4</td>
        <td>40</td>
        <td>NaN</td>
      </tr>
      <tr>
        <td>5</td>
        <td>3</td>
        <td>2021-01-08 21:10:57</td>
        <td>10</td>
        <td>15</td>
        <td>NaN</td>
      </tr>
      <tr>
        <td>6</td>
        <td>3</td>
        <td>null</td>
        <td>null</td>
        <td>null</td>
        <td>Restaurant Cancellation</td>
      </tr>
      <tr>
        <td>7</td>
        <td>2</td>
        <td>2020-01-08 21:30:45</td>
        <td>25km</td>
        <td>25mins</td>
        <td>null</td>
      </tr>
      <tr>
        <td>8</td>
        <td>2</td>
        <td>2020-01-10 00:15:02</td>
        <td>23.4 km</td>
        <td>15 minute</td>
        <td>null</td>
      </tr>
      <tr>
        <td>9</td>
        <td>2</td>
        <td>null</td>
        <td>null</td>
        <td>null</td>
        <td>Customer Cancellation</td>
      </tr>
      <tr>
        <td>10</td>
        <td>1</td>
        <td>2020-01-11 18:50:20</td>
        <td>10km</td>
        <td>10minutes</td>
        <td>null</td>
      </tr>
    </tbody>
  </table>
  <hr>
  
   ### Table 4: pizza_names
    
  <table>
    <thead>
      <tr>
        <th>pizza_id</th>
        <th>pizza_name</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>Meat Lovers</td>
      </tr>
      <tr>
        <td>2</td>
        <td>Vegetarian</td>
      </tr>
    </tbody>
  </table>
  <hr>
  
  ### Table 5: pizza_recipes

  <table>
    <thead>
      <tr>
        <th>pizza_id</th>
        <th>toppings</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>1, 2, 3, 4, 5, 6, 8, 10</td>
      </tr>
      <tr>
        <td>2</td>
        <td>4, 6, 7, 9, 11, 12</td>
      </tr>
    </tbody>
  </table>
  <hr>

  ### Table 6: pizza_toppings

  <table>
    <thead>
      <tr>
        <th>topping_id</th>
        <th>topping_name</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>Bacon</td>
      </tr>
      <tr>
        <td>2</td>
        <td>BBQ Sauce</td>
      </tr>
      <tr>
        <td>3</td>
        <td>Beef</td>
      </tr>
      <tr>
        <td>4</td>
        <td>Cheese</td>
      </tr>
      <tr>
        <td>5</td>
        <td>Chicken</td>
      </tr>
      <tr>
        <td>6</td>
        <td>Mushrooms</td>
      </tr>
      <tr>
        <td>7</td>
        <td>Onions</td>
      </tr>
      <tr>
        <td>8</td>
        <td>Pepperoni</td>
      </tr>
      <tr>
        <td>9</td>
        <td>Peppers</td>
      </tr>
      <tr>
        <td>10</td>
        <td>Salami</td>
      </tr>
      <tr>
        <td>11</td>
        <td>Tomatoes</td>
      </tr>
      <tr>
        <td>12</td>
        <td>Tomato Sauce</td>
      </tr>
    </tbody>
  </table>

  </details>
<hr>

### Case Study Questions

This case study has LOTS of questions - they are broken up by area of focus including:

- Pizza Metrics
- Runner and Customer Experience
- Ingredient Optimisation
- Pricing and Ratings
- Bonus DML Challenges (DML = Data Manipulation Language)
