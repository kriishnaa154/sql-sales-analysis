# Sales & Customer Analysis using PostgreSQL

## Project Overview
This project conducts a detailed analysis of a retail sales database using **PostgreSQL**.  
The aim is to get useful business insights about **sales performance, customer behavior, product contribution, and retention patterns** through SQL.

This project showcases **real-world data analyst skills**, such as complex joins, aggregations, window functions, and time-based analysis.

---

## Dataset Description
**Dataset Used:** Northwind Database

The Northwind database represents a fictional trading company and includes information about:
- Customers
- Orders
- Order details
- Products
- Categories
- Suppliers
- Employees

### Key Tables Used
- `customers` – information about customers
- `orders` – details at the order level
- `order_details` – sales data at the line-item level
- `products` – information about products
- `categories` – categories for products

---

## Tools & Technologies
- **Database:** PostgreSQL
- **Language:** SQL
- **Concepts Used:**
  - JOINs (INNER, LEFT)
  - GROUP BY & HAVING
  - Common Table Expressions (CTEs)
  - Window Functions (`RANK`, `LAG`)
  - Date functions (`DATE_TRUNC`)
  - Aggregations & subqueries

---

## Business Questions Solved
This project addresses **30+ real-world business questions**, including:

### Sales Analysis
- Total revenue and average order value
- Orders with a total amount above average order value
- Top 3 months with the highest sales
- Monthly sales trends

### Customer Analysis
- Top customers by spending
- Customers with more than 5 orders
- Customers who purchased in more than 2 countries
- Customers with repeat purchases in consecutive months

### Product Analysis
- Top products by revenue
- Quantity sold for each product
- Products that were never ordered
- Percentage contribution of each product to total revenue
- Products priced above the category average

