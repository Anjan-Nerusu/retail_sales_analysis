-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10;

select count(*) from retail_sales;

-- Data cleaning

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

	DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- Data Exploration
-- how many sales we have 
select count(*) as total_sale from retail_sales;
-- how many customers we have 
select count(transaction_id) as total_customers from retail_sales;
-- how many categories
select distinct(category) as category_count from retail_sales;

-- Data Analysis 

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
select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select * from retail_sales where category = 'Clothing' and quantity >= 4 and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as total_sales from retail_sales group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) from retail_sales where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count(*) as total_transactions,gender,category from retail_sales group by 2,3 order by 2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

--CTE
with ranked_sales as 
(
SELECT 
    DATE_PART('year', sale_date) AS best_selling_year, 
    DATE_PART('month', sale_date) AS best_selling_month, 
    avg(total_sale) AS total_sales,rank() over(partition by DATE_PART('year', sale_date) order by avg(total_sale) desc) as rnk
FROM retail_sales 
GROUP BY DATE_PART('year', sale_date), DATE_PART('month', sale_date)
)
select best_selling_year,best_selling_month,total_sales from ranked_sales where rnk =1
ORDER BY best_selling_year DESC, best_selling_month DESC;
;
-- select extract(year from sale_date) as year from retail_sales group by 1;
-- select extract(month from sale_date) as year from retail_sales group by 1 ;

--subquery
select best_selling_year,best_selling_month,avg_sales from 
(
select extract(year from sale_date) as best_selling_year,extract(month from sale_date) as best_selling_month
,AVG(total_sale) AS avg_sales,rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk from retail_sales group by 1,2
) as t1
where rnk =1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,max(total_sale) as highest_sales from retail_sales
group by customer_id order by max(total_sale) desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id) as unique_customers from retail_sales group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select * from retail_sales;

with hourly_sales as 
(
select *,case when extract(hour from sale_time) < 12 then 'Morning'
              when extract(hour from sale_time) BETWEEN 12 AND 17 then 'Afternoon'
			  else 'Evening'
			  end as shift
				from retail_sales 
				)
select count(*) as total_orders,shift from hourly_sales group by 2;
















