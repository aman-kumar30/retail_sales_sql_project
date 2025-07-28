create database project_1;

-- create table
drop table if exists retails_sales;
create table retails_sales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(15),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

select count(*) from retails_sales;

-- Data cleaning
select * from retails_sales
where transactions_id is null;

select * from retails_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

-- Data exploration

-- How many sales we have?
select count(*)  as total_sales from retails_sales;
-- How many uniuque customers we have ?
select count(distinct customer_id) as unique_customers from retails_sales;
-- How many category wh have ?
select distinct category from retails_sales;

-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retails_sales where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select * from retails_sales
where category = 'clothing'
and
quantiy >= 4
and
year(sale_date) = '2022'
and
month(sale_date) = "11";


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,
sum(total_sale) as total_sale,
COUNT(transactions_id) as total_orders from retails_sales 
group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as average_age from retails_sales where category = "Beauty";


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retails_sales where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender,
count(transactions_id) from retails_sales
group by category, gender
order by category asc;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select year,
       month,
       Avg_total_sale
       from
(select year(sale_date) as year ,month(sale_date) as month,
avg(total_sale) as Avg_total_sale,
RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
from retails_sales
group by year(sale_date), month(sale_date)
order by Avg_total_sale desc)
as ranked
where rnk = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select * from retails_sales order by total_sale desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,
count(distinct customer_id) as unique_customers
from retails_sales
group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retails_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;