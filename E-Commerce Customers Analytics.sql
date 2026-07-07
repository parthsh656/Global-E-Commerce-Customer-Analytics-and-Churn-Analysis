/* 1. DATA UNDERSTANDING*/
/* Total Customers */
select count(*) as total_customers
from ecom;

/* Unique Countries*/
select count(Distinct country) as total_countries
from ecom;

/* Customer Distribution by Region*/
select region, count(*) as total_customers
from ecom
group by region
order by total_customers desc;

/* Gender Distribution*/
select gender, count(*) as total_customers
from ecom
group by gender
order by total_customers desc;

/* 2. DATA QUALITY CHECK */
/* DUPLICATE CUSTOMERS */
SELECT customer_id
from ecom
group by customer_id
having count(*)>1;

/* Null Checks*/
 Select count(*) as nulls
 from ecom
 where age is null or total_spent_usd is null or satisfaction_score is null;
 
 /* 3.CUSTOMER ANALYTICS */
 /* Age Group Segmentation */
 select
 case
     WHEN age BETWEEN 18 AND 25 THEN '18-25'
     WHEN age BETWEEN 26 AND 35 THEN '26-35'
     WHEN age BETWEEN 36 AND 45 THEN '36-45'
     WHEN age BETWEEN 46 AND 55 THEN '46-55'
     ELSE '55+'
     end as age_group,
count(*) as total_customers
from ecom
group by age_group
order by total_customers desc;

/* Loyalty Tier Distribution */
SELECT
loyalty_tier,
COUNT(*) AS customers
FROM ecom
GROUP BY loyalty_tier;

/* Newsletter Impact */
SELECT
newsletter_subscribed,
COUNT(*) AS customers,
AVG(total_spent_usd) AS avg_spend,
AVG(total_orders) AS avg_orders
FROM ecom
GROUP BY newsletter_subscribed;

/*Device Usage*/
SELECT
device_type,
COUNT(*) AS customers
FROM ecom
GROUP BY device_type;

/* Preferred Payment Method */
SELECT
preferred_payment_method,
COUNT(*) AS customers
FROM ecom
GROUP BY preferred_payment_method
ORDER BY customers DESC;

/* 4. REVENUE ANALYTICS */
/* Total Revenue */
SELECT
SUM(total_spent_usd) AS revenue
FROM ecom;

/* Revenue by region */
SELECT
region,
SUM(total_spent_usd) revenue
FROM ecom
GROUP BY region
ORDER BY revenue DESC;

/* Revenue by Loyalty tier */
SELECT
loyalty_tier,
SUM(total_spent_usd) revenue
FROM ecom
GROUP BY loyalty_tier
ORDER BY revenue DESC;

/* Revenue by Category */
SELECT
preferred_category,
SUM(total_spent_usd) revenue
FROM ecom
GROUP BY preferred_category
ORDER BY revenue DESC;

/* Average Order Value by Device */
SELECT
device_type,
AVG(avg_order_value_usd) avg_order_value
FROM ecom
GROUP BY device_type;

/* 5: Churn Analytics */
/* Overall Churn Rate */
select round(100*sum(churn)/count(*),2) as churn_rate
from ecom;

/* Churn by Region*/
SELECT
region,
ROUND(100.0 * AVG(churn),2) AS churn_rate
FROM ecom
GROUP BY region
ORDER BY churn_rate DESC;

/* Churn by Satisfaction Score */
SELECT
satisfaction_score,
ROUND(100.0 * AVG(churn),2) AS churn_rate
FROM ecom
GROUP BY satisfaction_score
ORDER BY satisfaction_score;

/* Churn by newsletter subscription */
SELECT
newsletter_subscribed,
ROUND(100.0 * AVG(churn),2) AS churn_rate
FROM ecom
GROUP BY newsletter_subscribed;

/* TOP 5 CUSTOMERS BY SPENDING */
select customer_id,total_spent_usd,
dense_rank() over(order by total_spent_usd desc) as cust_rank 
from ecom;

/* HIGHEST REVENUE CUSTOMER IN EACH REGION */
with cte as (
select *,
row_number() over(partition by region order by total_spent_usd desc) as rn
from ecom
)
select * from cte where rn=1;
