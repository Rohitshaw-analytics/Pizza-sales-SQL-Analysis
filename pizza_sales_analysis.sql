CREATE DATABASE Dominos;

create table orders (
order_id int not null primary key,
order_date date not null,
order_time time not null
);
create table ordrs_details (
order_details_id int not null primary key,
order_id int not null,
pizza_id text not null,
quantity int not null
);
alter table ordrs_details
rename Orders_details;
-- Basics Question 5 / Intermediate level 6 / Advance Level 3
-- 1 Retrieve the total number of orders placed?
SELECT 
    COUNT(order_id) AS Totsl_Orders
FROM
    orders;
-- 2 Calculate the total revenue generated from pizza sales.
SELECT ALL
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS Total_Revenue
FROM
    orders_details
        INNER JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id;
    -- 3 Identify the highest-priced pizza.
SELECT 
    pizza_types.name, MAX(price) AS Highest_Price
FROM
    pizza_types 
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name
ORDER BY Highest_Price DESC
LIMIT 1;

select count(quantity) from orders_details;
-- 4 Identify the most common pizza size ordered.
SELECT DISTINCT
    pizzas.size,
    ROUND(COUNT(orders_details.quantity), 0) AS Total_size_BY_Orders
FROM
    orders_details
        INNER JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size;
-- List the top 5 most ordered pizza types along with their quantities.?
SELECT 
    pizza_types.name, SUM(orders_details.quantity) AS Top_5_Order_Pizza
FROM
    orders_details
        JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.name
ORDER BY SUM(orders_details.quantity) DESC 
LIMIT 5;                         
#####Intermediate: LEVELS 
-- 6) Join the necessary tables to find the total quantity of each pizza category ordered.?
SELECT 
    pizza_types.category, SUM(orders_details.quantity)
FROM
    orders_details
        INNER JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id
        INNER JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category
ORDER BY SUM(orders_details.quantity) DESC;
-- 7.Determine the distribution of orders by hour of the day.?
SELECT 
    HOUR(order_time) AS Hours,
    COUNT(orders.order_id) AS orders_count
FROM
    orders
        INNER JOIN
    orders_details ON orders.order_id = orders_details.order_id
GROUP BY HOUR(order_time)
ORDER BY COUNT(orders.order_id) DESC;
-- 8.Join relevant tables to find the category-wise distribution of pizzas.?
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;
SELECT category,name FROM pizza_types;
-- 9.Group the orders by date and calculate the average number of pizzas ordered per day.?
SELECT 
    orders.order_date, SUM(orders_details.quantity)
FROM
    orders
        JOIN
    orders_details ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date;
SELECT 
    AVG(quantity)
FROM
    (SELECT 
        orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM
        orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    -- Advance Level
-- 10) Determine the top 3 most ordered pizza types based on revenue.?
	SELECT 
    pizza_types.name,
    SUM(orders_details.quantity * pizzas.price) AS Top_3_Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY SUM(orders_details.quantity * pizzas.price) DESC
LIMIT 3;
-- 11) Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND(SUM(orders_details.quantity * pizzas.price), 2) AS Total_Revenue,
    ROUND(SUM(orders_details.quantity * pizzas.price) *100/sum(SUM(orders_details.quantity * pizzas.price)) over (),2) AS Total_Percantage
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Total_Revenue DESC;
-- 12 Analyze the cumulative revenue generated over time.?
SELECT 
    orders.order_date,
    ROUND(SUM(orders_details.quantity * pizzas.price), 2) AS revenue,
    ROUND(sum(SUM(orders_details.quantity * pizzas.price)) 
    OVER (ORDER BY orders.order_date), 2) AS Cumulative_Total
FROM
    orders_details
        JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id
        JOIN
    orders ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date
ORDER BY Cumulative_Total asc ;



-- 13  Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT 
    pizza_types.category,
    pizza_types.name,
    SUM(orders_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category , pizza_types.name
order by revenue desc limit 3;


























