use project;

CREATE TABLE `coffee_shop_sales1` (
  `transaction_id` int DEFAULT NULL,
  `transaction_date` text,
  `transaction_time` text,
  `transaction_qty` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `store_location` text,
  `product_id` int DEFAULT NULL,
  `unit_price` double DEFAULT NULL,
  `product_category` text,
  `product_type` text,
  `product_detail` text,
  `month` text,
  `day` text,
  `hour` text
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO coffee_shop_sales1
select *,

date_format(transaction_date, '%M') AS month_name,
dayname(transaction_date)  as day_name,
hour(transaction_time) as hour_time 
from coffee_shop_sales;

ALTER TABLE coffee_shop_sales1
modify COLUMN transaction_date DATE ;

alter table coffee_shop_sales1
add column revenue int;

update coffee_shop_sales1
set revenue= unit_price * transaction_qty;

-- revenue by store 
use project;
select
store_location,
round(sum(unit_price*transaction_qty), 0) as revenue
from coffee_shop_sales1
group by store_location
order by 2  desc;

-- revenue by product
select
product_category,
round(sum(unit_price*transaction_qty), 0) as revenue
from coffee_shop_sales1
group by 1
order by 2  desc;

-- revenue by day part
SELECT 

    CASE
        WHEN HOUR(STR_TO_DATE(transaction_time, '%H:%i:%s')) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(STR_TO_DATE(transaction_time, '%H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(STR_TO_DATE(transaction_time, '%H:%i:%s')) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS day_part,
    round(SUM(transaction_qty * unit_price),0) AS sales_revenue
FROM coffee_shop_sales
GROUP BY  day_part
ORDER BY 2 desc;

-- top 5 most profitable products
with cte as (select
product_type,
sum(revenue) as total_revenue,
rank()over (order by sum(revenue) desc) as rn
from coffee_shop_sales1
group by 1)

select 
product_type,
total_revenue
from cte
where rn <=5;




