use project;

select * from customers;
select * from order_items;
select * from orders;
select * from products;

# Q1 Total number of orders per customer

select c.customer_id, c.customer_name ,count(o.order_id)  from
 orders as o join customers as c  on ( c.customer_id = o.customer_id)
group by 1  ;

# Q2 Total revenue per order
select o.order_id , round(sum(p.price * o.quantity),2) as revenue from order_items as o join products as p on(p.product_id = o.product_id)
group by 1
order by 2 desc ;

 # Q3 customers who never placed an order

 select customer_id from customers
 where customer_id not in (select customer_id from orders )  ;

SELECT c.customer_name
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

# Q4 Most sold product by quantity

select p.product_name , sum(o.quantity)  from products as p join order_items as o on p.product_id = o.product_id
group by 1 
order by 2 desc ;


# Q5 Total revenue per customer (Completed orders only)


select c.customer_id , c.customer_name , sum(oi.quantity * p.price  ) from 
customers as c join orders as o on c.customer_id = o.customer_id 
join order_items as oi on  o.order_id = oi.order_id
join products as p on oi.product_id = p.product_id 
where o.status = 'completed'
group by 1 
order by 3 desc ;

# Q6 Top 5 customers by spending

select c.customer_name , sum(p.price * oi.quantity) as spending from 
customers as c join orders as o on c.customer_id = o.customer_id
join order_items as oi on (o.order_id = oi.order_id)
join products as p on oi.product_id = p.product_id
where o.status = 'completed'
group by 1
order by 2 desc
limit 5
;

# Q7 Revenue by city
select c.city , sum(p.price * oi.quantity) as city_Revenue  from 
customers as c join orders as o on c.customer_id = o.customer_id
join order_items as oi on (o.order_id = oi.order_id)
join products as p on oi.product_id = p.product_id
where o.status = 'Completed'
group by 1 
;

# Q8 Monthly revenue trend
select month(o.order_date) as months , sum(p.price * oi.quantity) as Monthly_Revenue  from 
customers as c join orders as o on c.customer_id = o.customer_id
join order_items as oi on (o.order_id = oi.order_id)
join products as p on oi.product_id = p.product_id
where o.status = 'Completed'
group by 1 
;

# Q9 Customers who purchased from more than 1 categories
select c.customer_name , count(p.category) from 
customers as c join orders as o on c.customer_id = o.customer_id
join order_items as oi on (o.order_id = oi.order_id)
join products as p on oi.product_id = p.product_id
group by 1
having count(distinct p.category) >= 2   ;

# Q10 Rank customers by total spending (Window Function)
select customer_name ,spending ,  rank() over (order by spending desc) from (
select c.customer_name , sum(p.price * oi.quantity) as spending from 
customers as c join orders as o on c.customer_id = o.customer_id
join order_items as oi on (o.order_id = oi.order_id)
join products as p on oi.product_id = p.product_id
where o.status = 'Completed'
group by 1)t;

# Q11 Average Order Value (AOV)
select round(avg(order_value),2)  as average_order from (
select oi.order_id , sum(p.price * oi.quantity) as order_value from 
order_items as oi join orders as o on oi.order_id = o.order_id
join products as p on p.product_id = oi.product_id 
where o.status = 'completed'
group by 1 ) t   ;

# Q12 Customers whose spending is above average
select customer_name , spending  from (
select c.customer_name , sum(p.price * oi.quantity) as spending from 
customers as c join orders as o on c.customer_id = o.customer_id
join order_items as oi on (o.order_id = oi.order_id)
join products as p on oi.product_id = p.product_id
where o.status = 'completed'
group by 1) t
where spending >  (select round(avg(order_value),2)  as average_order from (
select oi.order_id , sum(p.price * oi.quantity) as order_value from 
order_items as oi join orders as o on oi.order_id = o.order_id
join products as p on p.product_id = oi.product_id 
where o.status = 'completed'
group by 1 ) x )
order by 2 desc  ;


# Q13 Percentage of cancelled orders
select round(sum(case when status = 'cancelled' then 1 else 0 end) *100 / count(*) ,2) 
as cancelled_order_perc from orders ;

# Q14 Best-selling category by revenue	
select p.category , sum(p.price * oi.quantity) as order_value from 
order_items as oi join products as p on p.product_id = oi.product_id 
group by 1 
order by 2 desc 
limit 1;

# Q15 Orders whose value is above average order value
select order_id , order_value from (
select oi.order_id , sum(oi.quantity * p.price) as order_value from 
order_items as oi join orders as o on oi.order_id = o.order_id
join products as p on p.product_id = oi.product_id 
where o.status = 'completed'
group by 1 ) x 
where order_value > ( select avg(order_value) from (select sum(oi.quantity * p.price) as order_value from 
order_items as oi join orders as o on oi.order_id = o.order_id
join products as p on p.product_id = oi.product_id 
where o.status = 'completed'
group by oi.order_id)t) 
;


select * from customers;
select * from order_items;
select * from orders;
select * from products;
