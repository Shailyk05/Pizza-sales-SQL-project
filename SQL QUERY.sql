CREATE DATABASE pizzahut;

use pizzahut;

 -- EASY 
/* 1. Retrieve the total number of orders placed. */
SELECT count(order_id) AS total_orders
FROM orders;

/* 2. Calculate the total revenue generated from pizza sales. */
SELECT 
ROUND(SUM(order_details.quantity * pizzas.price)) AS Total_revenue
FROM order_details 
JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id;

/* 3. Identify the highest-priced pizza. */

SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas	
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1 ;

/*4.Identify the most common pizza size ordered.*/
SELECT pizzas.size AS size, COUNT(order_details.order_details_id) AS order_count
FROM pizzas
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP By size
ORDER BY order_count DESC;

/*5.List the top 5 most ordered pizza types along with their quantities..*/
SELECT pizza_types.name,SUM(order_details.quantity) as quantity
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;


 -- Intermediate: 
/* 1.Join the necessary tables to find the total quantity of each pizza category ordered.  */
SELECT pizza_types.category AS category,SUM(order_details.quantity) as quantity
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id 
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category
order by quantity DESC;

/* 2. Determine the distribution of orders by hour of the day.*/
SELECT HOUR(time) AS Hour,COUNT(order_id) AS order_count
FROM orders
GROUP BY Hour;

/* 3. Join relevant tables to find the category-wise distribution of pizzas.  */
SELECT category,count(name) 
FROM pizza_types
group by category;

/* 4. Group the orders by date and calculate the average number of pizzas ordered per day.*/

SELECT round(AVG(quantity),0) AS Avg_Pizza_orders
FROM
(SELECT orders.date , SUM(order_details.quantity) as quantity
FROM orders
JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.date)As order_quantity;

/* 5. Determine the top 3 most ordered pizza types based on revenue.   */
SELECT pizza_types.name AS name,
SUM(order_details.quantity * pizzas.price) AS Total_revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY name
ORDER BY Total_revenue DESC
LIMIT 3;

--  ADVANCE
/*  1. Calculate the percentage contribution of each pizza type to total revenue. */
SELECT pizza_types.category AS category,
ROUND((SUM(order_details.quantity * pizzas.price)) /( SELECT  ROUND(SUM(order_details.quantity * pizzas.price),2)
								FROM order_details JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id) *100,2) AS Total_revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY Total_revenue DESC;

/* 2. Analyze the cumulative revenue generated over time */
SELECT o_date,
SUM(revenue) OVER(order by o_date) AS cum_revenue
FROM
(SELECT orders.date AS o_date,SUM(order_details.quantity * pizzas.price) as revenue
FROM order_details
JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id 
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY o_date) AS SALES;

/* 3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.*/
SELECT name,category,revenue,rankk
FROM
(SELECT name,category,revenue,
rank() OVER(partition by category order by  revenue DESC) AS rankk
FROM
(SELECT pizza_types.name AS name,pizza_types.category AS category,
SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY name, category) AS a) AS b
where rankk <=3;



SELECT * FROM pizza_types;
SELECT * FROM pizzas;
SELECT * FROM orders;
SELECT * FROM order_details;












