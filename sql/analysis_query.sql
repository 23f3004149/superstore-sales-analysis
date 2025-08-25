-- 1 Total sales and profit
SELECT 
    SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	ROUND(SUM(profit)*100/SUM(sales),2) AS profit_marg
FROM order_details

-- 2. Sales and Profit by Product Category
SELECT p.category AS product_category,
    SUM(sales) AS sales,
    SUM(profit) AS profit, 
     ROUND(SUM(profit)*100/SUM(sales),2) AS profit_margin 
FROM order_details od JOIN products p ON od.product_id = p.product_id 
GROUP BY p.category

-- 3. Sales and Profit by Sub-Category
SELECT 
    p.sub_category AS sub_product_category,
    SUM(od.sales) AS total_sales,
    SUM(od.profit) AS total_profit,
    ROUND(SUM(od.profit) * 100.0 / SUM(od.sales), 2) AS profit_margin
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY profit_margin DESC

-- 4. Sales and Profit by Region
SELECT 
    c.region,
    SUM(od.sales) AS total_sales,
    SUM(od.profit) AS total_profit,
    ROUND(SUM(od.profit) * 100.0 / SUM(od.sales), 2) AS profit_margin
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY profit_margin DESC

-- 5. Find the Top 10 customers by total sales.
SELECT c.customer_name,
    SUM(sales) AS sales,SUM(profit) AS profit,
    ROUND(SUM(profit)*100/SUM(sales),2) AS profit_margin
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY sales DESC
LIMIT 10

-- 6. Find the total sales and profit for each month (across all years). Show the month-year format like Jan-2016, Feb-2016
SELECT 
    TO_CHAR(o.order_date, 'Mon-YYYY') AS month_year,
    SUM(od.sales) AS total_sales,
    SUM(od.profit) AS total_profit,
    ROUND(SUM(od.profit)*100.0/SUM(od.sales), 2) AS profit_margin
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY month_year
ORDER BY MIN(o.order_date)

-- 7. Find sales, profit, and profit margin by ship mode.
SELECT o.ship_mode, COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(od.sales) AS total_sales,
    SUM(od.profit) AS total_profit,
    ROUND(SUM(od.profit) * 100.0 / SUM(od.sales), 2) AS profit_margin
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.ship_mode

-- 8. Profitability by State (Top & Bottom 5).
WITH top_states AS (
    SELECT c.state,
           SUM(od.sales) AS sales,
           SUM(od.profit) AS profit,
           ROUND(SUM(od.profit) * 100.0 / SUM(od.sales), 2) AS profit_margin,
           'Top 5' AS category
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.state
    ORDER BY profit_margin DESC
    LIMIT 5
),
bottom_states AS (
    SELECT c.state,
           SUM(od.sales) AS sales,
           SUM(od.profit) AS profit,
           ROUND(SUM(od.profit) * 100.0 / SUM(od.sales), 2) AS profit_margin,
           'Bottom 5' AS category
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.state
    ORDER BY profit_margin ASC
    LIMIT 5
)
SELECT * FROM top_states
UNION ALL
SELECT * FROM bottom_states
ORDER BY category DESC, profit_margin DESC

-- 9. Average Discount and its impact on Profit by Category
SELECT p.category,AVG(od.discount) avg_discount,
    SUM(od.sales) AS sales,
    SUM(od.profit) AS profit,
	ROUND(SUM(od.profit) * 100.0 / SUM(od.sales), 2) AS profit_margin
FROM order_details od 
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category

-- 10. Find customers who placed more than 1 order.
SELECT c.customer_id,c.customer_name
FROM order_details od 
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1,2
HAVING COUNT(DISTINCT o.order_id) > 1

-- 11. Year-over-Year (YoY) Growth in Sales
WITH yearly_sales AS (
    SELECT DATE_TRUNC('year', o.order_date) AS year_start,SUM(od.sales) AS curr_year_sales
    FROM order_details od 
    JOIN orders o ON od.order_id = o.order_id
    GROUP BY 1
)
SELECT TO_CHAR(year_start, 'YYYY') AS years,curr_year_sales,
    LAG(curr_year_sales) OVER (ORDER BY year_start) AS prev_year_sales,
    ROUND((curr_year_sales - LAG(curr_year_sales) OVER (ORDER BY year_start)) * 100
	/ NULLIF(LAG(curr_year_sales) OVER (ORDER BY year_start), 0),2) AS yoy_growth_percent
FROM yearly_sales
ORDER BY year_start

-- 12. Cohort Analysis (First Purchase Month vs Repeat Purchases).
WITH cohort_month AS (
    SELECT c.customer_id,MIN(DATE_TRUNC('month', o.order_date)) AS cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT cm.cohort_month,
       DATE_TRUNC('month', o.order_date) AS order_month,
       COUNT(DISTINCT cm.customer_id) AS customers
FROM cohort_month cm
JOIN orders o ON cm.customer_id = o.customer_id
GROUP BY 1,2
ORDER BY 1,2

-- 13. Basket Analysis Which sub-categories are frequently bought together
WITH cte1 AS(
SELECT p.sub_category,od.order_id
FROM products p 
JOIN order_details od ON od.product_id = p.product_id
)

SELECT c1.sub_category AS sub_category_1,
       c2.sub_category AS sub_category_2,
	   COUNT(*) AS times_bought_together
FROM cte1 c1
JOIN cte1 c2 ON c1.order_id = c2.order_id AND c1.sub_category < c2.sub_category
GROUP BY 1,2
ORDER BY times_bought_together DESC

-- 14. Customer Lifetime Value (CLV).
SELECT c.customer_id,c.customer_name,
    SUM(od.sales) AS total_sales,
	SUM(od.profit) AS total_profit,
	ROUND(SUM(od.profit)*100.0/SUM(od.sales),2) AS profit_margin,
	COUNT(o.order_id) AS total_order
FROM order_details od 
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY total_sales DESC

-- 15. Moving Average of Sales (3-month rolling window).
WITH monthly_sales AS (
SELECT DATE_TRUNC('month',o.order_date) AS months1,SUM(od.sales) AS sales
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
GROUP BY 1
) 
SELECT TO_CHAR(months1,'Mon-YYYY') AS months,
    sales,
    ROUND(AVG(sales) OVER(ORDER BY months1 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg
FROM monthly_sales 
ORDER BY months1

