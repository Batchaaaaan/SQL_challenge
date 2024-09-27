
<h1><p align="center">Case Study #3 - Foodie-Fi</p></h1>

<div align='center'><img src='https://8weeksqlchallenge.com/images/case-study-designs/3.png' alt="case3_image" width="500"/></div>
<hr>
<p align='center'>This is the Third Case Study of 8 Weeks SQL Challenge by DannyMa.
<a href="https://8weeksqlchallenge.com/case-study-3/" rel="nofollow">Click here to view.</a>
</p>
<hr>

### Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.
<hr>

### Entity Relationship Diagram
<div align='center'><img src="https://github.com/Batchaaaaan/SQL_challenge/blob/main/Case%233_Foodie_Fi/images/case-study-3-erd.png?raw=true" alt='case2_entity' width='700'></div>

<hr>

### Tables
<details><summary> All the tables used in the challenge</summary>
   
   ### Table 1: plans
  Customers can choose which plans to join Foodie-Fi when they first sign up.
  
  Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90
  
  Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.
  
  Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.
  
  When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.
   
 <table>
    <thead>
      <tr>
        <th>plan_id</th>
        <th>plan_name</th>
        <th>price</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>0</td>
        <td>trial</td>
        <td>0</td>
      </tr>
      <tr>
        <td>1</td>
        <td>basic monthly</td>
        <td>9.90</td>
      </tr>
      <tr>
        <td>2</td>
        <td>pro monthly</td>
        <td>19.90</td>
      </tr>
      <tr>
        <td>3</td>
        <td>pro annual</td>
        <td>199</td>
      </tr>
      <tr>
        <td>4</td>
        <td>churn</td>
        <td>null</td>
      </tr>
    </tbody>
  </table>
  <hr>
  
   ### Table 2: subscriptions
   Customer subscriptions show the exact date where their specific plan_id starts.

  If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.
  
  When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.
  
  When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.

<table>
    <thead>
      <tr>
        <th>customer_id</th>
        <th>plan_id</th>
        <th>start_date</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>0</td>
        <td>2020-08-01</td>
      </tr>
      <tr>
        <td>1</td>
        <td>1</td>
        <td>2020-08-08</td>
      </tr>
      <tr>
        <td>2</td>
        <td>0</td>
        <td>2020-09-20</td>
      </tr>
      <tr>
        <td>2</td>
        <td>3</td>
        <td>2020-09-27</td>
      </tr>
      <tr>
        <td>11</td>
        <td>0</td>
        <td>2020-11-19</td>
      </tr>
      <tr>
        <td>11</td>
        <td>4</td>
        <td>2020-11-26</td>
      </tr>
      <tr>
        <td>13</td>
        <td>0</td>
        <td>2020-12-15</td>
      </tr>
      <tr>
        <td>13</td>
        <td>1</td>
        <td>2020-12-22</td>
      </tr>
      <tr>
        <td>13</td>
        <td>2</td>
        <td>2021-03-29</td>
      </tr>
      <tr>
        <td>15</td>
        <td>0</td>
        <td>2020-03-17</td>
      </tr>
      <tr>
        <td>15</td>
        <td>2</td>
        <td>2020-03-24</td>
      </tr>
      <tr>
        <td>15</td>
        <td>4</td>
        <td>2020-04-29</td>
      </tr>
      <tr>
        <td>16</td>
        <td>0</td>
        <td>2020-05-31</td>
      </tr>
      <tr>
        <td>16</td>
        <td>1</td>
        <td>2020-06-07</td>
      </tr>
      <tr>
        <td>16</td>
        <td>3</td>
        <td>2020-10-21</td>
      </tr>
      <tr>
        <td>18</td>
        <td>0</td>
        <td>2020-07-06</td>
      </tr>
      <tr>
        <td>18</td>
        <td>2</td>
        <td>2020-07-13</td>
      </tr>
      <tr>
        <td>19</td>
        <td>0</td>
        <td>2020-06-22</td>
      </tr>
      <tr>
        <td>19</td>
        <td>2</td>
        <td>2020-06-29</td>
      </tr>
      <tr>
        <td>19</td>
        <td>3</td>
        <td>2020-08-29</td>
      </tr>
    </tbody>
  </table>

  </details>
<hr>

### Case Study Questions

This case study is split into an initial data understanding question before diving straight into data analysis questions before finishing with 1 single extension challenge.
