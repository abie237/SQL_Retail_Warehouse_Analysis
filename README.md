# PostgreSQL Stakeholder Business Questions

This project is a hands-on PostgreSQL learning exercise focused on answering real business questions with SQL.  
I worked through a retail-style database schema and used SQL to analyze revenue, customer behavior, promotions, returns, and shipping performance.

## Project Goal

The main goal of this project was to practice writing PostgreSQL queries that turn raw transactional data into useful business insights.  
Instead of only querying tables, I focused on solving stakeholder-style questions that a business team would actually ask.

## What I Learned

Through this project, I learned how to:

- Use `JOIN`s to combine related tables like `orders`, `order_items`, `products`, `customers`, `stores`, `suppliers`, and `returns`.
- Write aggregate queries using `SUM()`, `COUNT()`, `AVG()`, `MIN()`, and `MAX()`.
- Group data by product, category, supplier, store, city, and promotion.
- Calculate important KPIs such as revenue, average order value, return rate, customer retention, and lifetime value.
- Use `CTE`s (`WITH` clauses) to make complex queries easier to read and reuse.
- Build views to simplify repeated analysis.
- Use window functions like `DENSE_RANK()` and `COUNT() OVER()` for ranking and percentage calculations.
- Handle return analysis correctly by joining `returns` to `order_items`, since refunds are linked to order lines, not directly to products.
- Write cleaner PostgreSQL syntax with `ROUND()`, `COALESCE()`, and `NULLIF()` to avoid errors and divide-by-zero issues.

## Business Questions Explored

### 1. Revenue and Product Performance
I analyzed which products contribute the most to revenue and calculated the highest and lowest average selling prices.  
This helped me understand how product-level performance can be measured in different ways.

### 2. Category Performance
I explored the top-selling categories by quantity and revenue, and compared them across stores and cities.  
This showed how category demand can vary depending on location.

### 3. Supplier Performance
I identified suppliers associated with the most profitable products and those linked to the highest number of returns.  
This was useful for comparing supplier quality and business value.

### 4. Customer Retention
I measured how many customers placed repeat orders after their first purchase.  
This helped me practice retention analysis and understand customer loyalty patterns.

### 5. Customer Lifetime Value
I calculated lifetime value per customer by summing their order totals and comparing ordering behavior.  
This gave me a better view of which customers generate the most long-term value.

### 6. Average Order Value
I calculated average order value by store, by city, and by promotion usage.  
This made it easier to compare how geography and promotions affect basket size.

### 7. Promotion Impact
I studied how promotions affect order volume, revenue, and discount performance over time.  
This helped me understand whether promotions drive more sales or just reduce margins.

### 8. Return Rate Analysis
I calculated return rate by product, category, and supplier, and identified the most frequently refunded items.  
This was one of the most important parts of the project because it required careful reasoning about the schema.

### 9. Shipment Efficiency
I analyzed shipment status distribution and looked at how efficient deliveries are.  
This introduced me to operational analysis beyond sales and refunds.

## Key SQL Techniques Used

This project helped me practice the following PostgreSQL concepts:

- `INNER JOIN`, `LEFT JOIN`
- `GROUP BY` and `HAVING`
- Aggregation with `SUM()`, `COUNT()`, `AVG()`
- `CTE`s for modular query design
- `CREATE VIEW`
- Window functions like `DENSE_RANK()`
- Percentage calculations
- Safe division using `NULLIF()`
- Null handling with `COALESCE()`

## Important Schema Insight

One of the biggest lessons from this project was understanding the difference between an **order item** and a **refund record**.  
A refund is linked to an `order_item_id`, which means the refund belongs to a specific order line, not directly to a product.  
Because of that, return analysis must first join `returns` to `order_items`, and only then connect to `products`, `categories`, and `suppliers`.

## My Takeaway

This project helped me move from simple SQL practice to business-focused analysis.  
I learned how to translate stakeholder questions into structured PostgreSQL queries and how to think carefully about data relationships before writing logic.  
It was a strong exercise in both SQL syntax and analytical thinking.

## Example Questions Answered

- Which products generate the most revenue?
- Which categories sell the most by quantity and revenue?
- Which suppliers are linked to profitable or frequently returned products?
- How many customers are repeat buyers?
- Which customers have the highest lifetime value?
- How do promotions affect sales?
- Which products have the highest return rate?
- Which shipments are completed successfully most often?

## Final Note

This repository is part of my ongoing PostgreSQL learning journey.  
It reflects practical query building, problem solving, and business analysis using relational data.
