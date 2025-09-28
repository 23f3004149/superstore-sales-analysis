### Superstore Sales Analysis with SQL

## 📊 Project Overview

This project performs a deep-dive exploratory data analysis (EDA) of the Superstore dataset. The primary goal is to use SQL to uncover key insights into sales performance, customer behavior, and product profitability to inform business strategy.

The entire workflow, from database creation and data loading to complex analytical querying, is documented in the SQL scripts within the `/sql` directory.

## 🗂️ Database Schema

The project utilizes a relational database schema to ensure data integrity and reduce redundancy. The data is organized into four main tables:

* **`customers`**: Stores unique information about each customer.
* **`products`**: Contains details for each product, including category and sub-category.
* **`orders`**: Holds order-level information, such as order date, ship date, and customer ID.
* **`order_details`**: A transactional table linking orders and products, containing metrics like sales, quantity, discount, and profit.


## ⚙️ ETL Process (Extract, Transform, Load)

A two-step ETL process was used to populate the database:

1.  **Extract**: Data is first loaded from the `Superstore.csv` file into a temporary `staging_superstore` table.
2.  **Transform & Load**: SQL scripts then clean and transform the data from the staging table into the final normalized tables. The `ROW_NUMBER()` window function is used to handle and eliminate duplicate entries for customers, products, and orders, ensuring data quality.

## 📈 Key Business Questions & Analysis

The `analysis_query.sql` script answers 15 key business questions, including:

## Performance & Profitability Analysis
* What are the total sales, profit, and overall profit margin?
* How do sales and profit compare across different product categories and sub-categories?
* What is the sales and profit distribution by region and state?
* Which are the top 5 most and least profitable states?
* How does the shipping mode affect sales and profit?
* What is the impact of discounts on profitability by category?

## Customer-Centric Analysis
* Who are the top 10 most valuable customers by sales?
* Which customers are repeat purchasers (more than one order)?
* What is the Customer Lifetime Value (CLV) based on their total spending?
* **Cohort Analysis**: Groups customers by their first purchase month to track retention and repeat purchase behavior over time.

## Advanced & Time-Series Analysis
* **Year-over-Year (YoY) Growth**: Calculates the percentage growth in sales compared to the previous year using the `LAG()` window function.
* **Moving Average**: Computes the 3-month rolling average of sales to identify trends.
* **Basket Analysis**: Identifies which product sub-categories are most frequently purchased together in the same order.

## 🚀 How to Use

To replicate this analysis, follow these steps:

1.  **Create the Database**: Set up a PostgreSQL database.
2.  **Run the Scripts**:
    * Execute the `create_tables.sql` script to create the database schema.
    * Update the file path in `load_data.sql` and run it to load the data from the CSV into the tables.
    * Execute the `analysis_query.sql` script to perform the full analysis.
3.  **Explore the Results**: Analyze the output of each query to draw business conclusions.

## 🛠️ Technologies Used

* **Database**: PostgreSQL
* **Language**: SQL
