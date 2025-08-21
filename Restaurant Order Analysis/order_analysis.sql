CREATE DATABASE IF NOT EXISTS restaurant;
USE restaurant;
#DATA EXPLORATION
#table_name --> menu_items
#1View the menu_items table and write a query to find the number of items on the menu
SELECT COUNT(*) FROM menu_items; # 32 items presented

#2What are the least and most expensive items on the menu? ANS: Endamame & Shrimp Scampi
SELECT *
FROM menu_items
WHERE price IN ((SELECT MIN(price) FROM menu_items),(SELECT MAX(price) FROM menu_items));

#3How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
#ANS: there are 9 italian dishes out of which spaghetti and alfredo are cheap and shrimp scampi is expensive
SELECT *
FROM menu_items
WHERE category = "Italian"
	 AND price IN ((SELECT MIN(price) FROM menu_items WHERE category = "Italian"),
     (SELECT MAX(price) FROM menu_items WHERE category = "Italian"));

#4How many dishes are in each category? What is the average dish price within each category?
SELECT category, COUNT(item_name), ROUND(AVG(price),2)
FROM menu_items
GROUP BY category;

#table_name --> order_details
#1View the order_details table. What is the date range of the table?
SELECT MIN(order_date), MAX(order_date) FROM order_details; 

#2How many orders were made within this date range? How many items were ordered within this date range?
SELECT COUNT(order_id), COUNT(DISTINCT(item_id)) FROM order_details; # 12234 & 32

#3Which orders had the most number of items?
SELECT order_id, COUNT(item_id)   #SELECT order_id, COUNT(item_id)
FROM order_details                #FROM order_details
GROUP BY order_id                 #GROUP BY order_id
HAVING COUNT(item_id) = 14;      #ORDER BY COUNT(item_id) DESC

#4How many orders had more than 12 items?
SELECT COUNT(*)
FROM(SELECT COUNT(order_id)
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12) AS sub;

# current column name ï»¿menu_item_id. chaning to menu_item_id
ALTER TABLE menu_items
CHANGE COLUMN `ï»¿menu_item_id` menu_item_id INT;
ALTER TABLE order_details
CHANGE COLUMN `ï»¿order_details_id` order_details_id INT;

#Final task
CREATE TABLE menu_orders AS
SELECT *
FROM menu_items AS m
LEFT JOIN order_details AS o
  ON m.menu_item_id = o.item_id
UNION
SELECT *
FROM menu_items AS m
RIGHT JOIN order_details AS o
  ON m.menu_item_id = o.item_id;

#1a What were the least and most ordered items? 
#Chicken Tacos are the leas and Hamburgers are the most
SELECT item_name,COUNT(item_name)
FROM menu_orders
GROUP BY item_name
ORDER BY COUNT(item_name) DESC;
#1b What categories were they in? American and Mexican
SELECT DISTINCT item_name,category
FROM menu_orders
WHERE item_name = 'Hamburger' OR item_name = 'Chicken Tacos';

#2 What were the top 5 orders that spent the most money? 440,2075,1957,330,2675
SELECT order_id, ROUND(SUM(price),2) AS spent
FROM menu_orders
GROUP BY order_id
ORDER BY spent DESC
LIMIT 5;

#3 View the details of the highest spend order. Which specific items were purchased?
SELECT DISTINCT item_name	
FROM menu_orders
WHERE order_id = 440;

#FINAL PROJECT QUESTION
# How much was the most expensive order in the dataset?
SELECT ROUND(SUM(price),2)	
FROM menu_orders
WHERE order_id = 440;