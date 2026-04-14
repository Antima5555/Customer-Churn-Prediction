CREATE TABLE churn_train (
    customer_id INT,
    age INT,
    gender VARCHAR(10),
    tenure INT,
    usage_frequency INT,
    support_calls INT,
    payment_delay INT,
    subscription_type VARCHAR(20),
    contract_length VARCHAR(20),
    total_spend FLOAT,
    last_interaction INT,
    churn INT
);

CREATE TABLE  churn_test (
    customer_id INT,
    age INT,
    gender VARCHAR(10),
    tenure INT,
    usage_frequency INT,
    support_calls INT,
    payment_delay INT,
    subscription_type VARCHAR(20),
    contract_length VARCHAR(20),
    total_spend FlOAT,
    last_interaction INT,
    churn INT
);

SELECT * FROM churn_test;
SELECT * FROM churn_train;


-- churan_rate
SELECT ROUND(AVG(churn) * 100 ,2) AS churn_rate
from churn_train; 


-- Revenue Loss due to Churn
select sum(total_spend) as revenue_lost from churn_train where churn=1;


-- Customer Segmentation
SELECT 
CASE 
    WHEN tenure < 12 THEN 'New'
    WHEN tenure BETWEEN 12 AND 36 THEN 'Mid'
    ELSE 'Loyal'
END AS segment,
COUNT(*) AS customers,
ROUND(AVG(churn)*100,2) AS churn_rate
FROM churn_train
GROUP BY segment;


-- Avg usage vs churn
select avg(usage_frequency) as use_frequency, avg(support_calls) as support_calls, avg(Payment_delay) as delays
from churn_train
where churn=1;


-- Churn rate by segment
select subscription_type , round(avg(churn) * 100,2) as churn_rate
from churn_train
group by subscription_type;


-- CTE (Common Table Expression)
WITH churn_summary AS (
    SELECT subscription_type, COUNT(*) AS total, SUM(churn) AS churned
    FROM churn_train
    GROUP BY subscription_type
)
SELECT *,
ROUND(churned*100.0/total,2) AS churn_rate
FROM churn_summary;


-- Risk Customer Identification
select customer_id ,
CASE
  WHEN support_calls >5 and payment_delay >20 THEN 'high risk'
  WHEN support_calls >3 and payment_delay >10 THEN 'medium risk'
  ELSE 'low risk'
END AS risk_level
from churn_train;




