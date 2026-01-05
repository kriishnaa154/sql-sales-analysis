-- BASIC QUERIES

--listing all the customers from a specific country 'Germany'

select customerid, companyname, contactname, country
from customers
where country = 'Germany'

SELECT customerid, companyname, contactname, country
FROM customers 
WHERE country = 'Mexico'


--counting the total customers
SELECT count(customer_id) as total_no_of_customers
FROM customers




--counting the total number of orders 
SELECT customer_id,ship_name,ship_address,ship_country
FROM orders
where ship_country = 'Venezuela'

select count(*) total_no_of_orders
from orders



--counting the total number of orders where the shipped country is venezuela

select count(*) total_no_of_orders
from orders
where ship_country = 'Venezuela'



--Total revenue (sum of all order items)

select unit_price,quantity,discount
from order_details

select round(sum(unit_price* quantity)::decimal,3) as total_revenue
from order_details



--counting the total orders

select count(*) as total_no_of_orders
from orders


--Average order value

select round(avg(unit_price* quantity)::decimal,3) as avg_order_value
from order_details od
join orders o 
on od.order_id = o.order_id


--maximum single order amount

select max(unit_price*quantity) as max_order_amount
from order_details


--minimum single order amount
select min(unit_price*quantity) as min_order_amount
from order_details


--total number of products

select count(*) as total_no_of_products
from products

--product names in alphabetical order
select product_name
from products
order by product_name asc




--INTERMEDIATE QUERIES


--top 5 customers by total spend

select c.customer_id,company_name,sum(od.unit_price*od.quantity) as total_spend
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id= od.order_id
group by c.customer_id,company_name
order by total_spend desc
limit 5


-- total revenue per country

select country,round(sum(od.unit_price*od.quantity)::decimal,2) as total_revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
group by country
order by total_revenue desc


--most sold products by quantity

select p.product_id,product_name,sum(od.quantity) as total_sold
from products p 
join order_details od
on p.product_id = od.product_id
group by p.product_id,product_name
order by total_sold desc
limit 10


--revenue per month

select extract(month from order_date) as month,sum(od.unit_price*od.quantity) as total_revenue
from orders o
join order_details od
on o.order_id = od.order_id
group by extract(month from order_date)
order by month


--number of orders per customer

select c.customer_id,c.company_name,count(o.order_id) as total_no_of_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id


--average revenue per customer

select c.customer_id,c.company_name,avg(od.unit_price*od.quantity) as average_revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
group by c.customer_id,c.company_name
order by average_revenue desc



--customers who spent more than 5000

select c.customer_id,c.company_name,sum(od.unit_price*od.quantity) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
group by c.customer_id,c.company_name
having sum(od.unit_price*od.quantity)>5000
order by total_spent desc

--total quantity sold per product

select p.product_id,p.product_name,sum(od.quantity) as total_quantity
from products p 
join order_details od
on p.product_id = od.product_id
group by p.product_id,p.product_name
order by total_quantity desc


--total revenue per product category

select c.category_name,sum(od.unit_price*od.quantity) as total_revenue
from products p 
join categories c on p.category_id = c.category_id
join order_details od on p.product_id = od.product_id
group by c.category_name


--top 3 products by revenue

SELECT p.product_name, SUM(od.unit_price * od.quantity) AS revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 3


select *
from products

--customers with more than 5 orders

select c.customer_id,company_name,count(o.order_id) as total_no_of_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id,company_name
having count(o.order_id)>5


--ranking customers by total spending

with total_spend as (
		select c.customer_id,company_name,sum(od.unit_price*od.quantity) as total_spend
		from customers c
		join orders o 
		on c.customer_id = o.customer_id
		join order_details od on o.order_id = od.order_id
		group by c.customer_id, company_name),

		ranked_customers as(
				select * ,rank() over(order by total_spend desc) as rank
				from total_spend
		)

select * from ranked_customers
where rank<=10  		--for top 10 customers 



--products never ordered

SELECT p.product_id,product_name
FROM products p 
LEFT JOIN order_details od
ON p.product_id = od.product_id
WHERE od.product_id is null


--top products by revenue

SELECT * 
	FROM (SELECT p.product_id,product_name,rank() over(order by sum(od.unit_price*od.quantity) desc )as revenue_rank
	FROM products p 
	JOIN order_details od
	ON p.product_id = od.product_id
	group by p.product_id,product_name)
WHERE revenue_rank<=10


--product-wise sales

SELECT p.product_id,product_name,sum(od.quantity) quantity_sold
FROM products p 
JOIN order_details od
ON p.product_id = od.product_id
group by p.product_id,product_name
order by quantity_sold desc


--products contributing most to sales


with product_revenue as ( 
				select p.product_id,p.product_name,round(sum(od.unit_price*od.quantity)::numeric,2) as revenue_per_product
				from products p 
				join order_details od
				on p.product_id = od.product_id
				group by p.product_id,p.product_name
				order by revenue_per_product desc),

		product_contribution as (

				select sum(revenue_per_product) as total_revenue
				from product_revenue	
		)

select pr.product_id,pr.product_name,
round((revenue_per_product/total_revenue)*100,2) contribution_percentage
from product_revenue pr
cross join product_contribution pc
order by contribution_percentage desc



--top 5 customers per country by spend

WITH customer_spend AS (
		SELECT c.customer_id,company_name,country,round(sum(od.unit_price*od.quantity)::numeric,2) as total_spend
		FROM customers c
		JOIN orders o ON c.customer_id= o.customer_id
		JOIN order_details od on o.order_id = od.order_id
		GROUP BY c.customer_id,company_name,country
			),
	ranked_customers AS (
   	 SELECT *,
           RANK() OVER (
               PARTITION BY country 
               ORDER BY total_spend DESC
           ) AS rank_in_country
    FROM customer_spend
)
SELECT *
FROM ranked_customers
WHERE rank_in_country <= 5
ORDER BY country, rank_in_country;



--Orders with total amount above average order value

with total_amount as (
	SELECT o.order_id,customer_id,round(sum(od.unit_price*od.quantity)::numeric,2) as order_value
	FROM orders o
	JOIN order_details od
	ON o.order_id = od.order_id
	GROUP BY o.order_id,customer_id
	),
	average_order_value as (
	SELECT AVG(order_value) as avg_order_value
	FROM total_amount
	)
select t.order_id,customer_id,round(t.order_value,2)as order_value
from total_amount t
cross join average_order_value a
where t.order_value>a.avg_order_value
order by order_value desc


--top 3 months with highest sales

with sales_month as (
		SELECT date_trunc('month',order_date) as month,round(sum(od.unit_price*od.quantity)::numeric,2) as total_sales
		FROM orders o 
		join order_details od
		on o.order_id = od.order_id
		group by date_trunc('month',o.order_date)),

		month_ranks as (
		select *,rank () over(order by total_sales desc) as ranks
		from sales_month
		)

select * from month_ranks
where ranks<=3
order by month asc,total_sales desc;


--customers who made orders more than 2 countries

select c.customer_id,count(distinct ship_country) as total_count
from customers c
join orders o 
on c.customer_id =  o.customer_id 
group by c.customer_id
having count(distinct ship_country)>2

 
--Customers who made repeat purchases in consecutive months

with customer_months as (
		select distinct c.customer_id,extract('month' from order_date) as month_number
		from customers c
		join orders o
		on c.customer_id = o.customer_id
		order by month_number asc
		),

		month_comparison as (
		select *,lag(month_number) over(partition by customer_id order by month_number) as previous_month
		from customer_months
		)

select distinct customer_id
from month_comparison
where month_number = previous_month + 1;