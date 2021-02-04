CREATE DATABASE AMAZON_ORDERS
GO
USE AMAZON_ORDERS
GO
CREATE TABLE Departments_dim
(department_id INT NOT NULL IDENTITY,
department_name VARCHAR(10),
PRIMARY KEY (department_id));
GO
CREATE TABLE Category_dim
(category_id INT NOT NULL IDENTITY,
category_name VARCHAR(10),
PRIMARY KEY (category_id));
GO
CREATE TABLE Products_dim
(product_id INT NOT NULL IDENTITY,
product_name VARCHAR(15),
product_description VARCHAR(25),
product_image VARCHAR(25),
product_price INT,
PRIMARY KEY (product_id));
GO
CREATE TABLE Customers_dim
(customer_id INT NOT NULL IDENTITY,
customer_fname VARCHAR(10),
customer_lname VARCHAR(10),
customer_email VARCHAR(16),
customer_password VARCHAR(16),
customer_street VARCHAR(15),
customer_city VARCHAR(10),
customer_state VARCHAR(10),
customer_zipcode VARCHAR(15)
PRIMARY KEY (customer_id));
GO
CREATE TABLE Orders_dim
(order_id INT NOT NULL IDENTITY,
order_date VARCHAR(10),
order_status VARCHAR(10),
PRIMARY KEY (order_id));
GO
CREATE TABLE Orders_items_dim
(order_item_id INT NOT NULL IDENTITY,
order_item_quantity INT,
order_item_subtotal INT,
PRIMARY KEY (order_item_id));
GO
USE AMAZON_ORDERS
GO
CREATE TABLE Amazon_retail_fact
(
customer_id INT,
category_id INT,
department_id INT,
product_id INT,
order_id INT,
order_item_id INT,
order_status_count INT,
sum_total_purchase INT,
PRIMARY KEY (product_id, customer_id),
FOREIGN KEY (customer_id) REFERENCES Customers_dim (customer_id),
FOREIGN KEY (category_id) REFERENCES Category_dim (category_id),
FOREIGN KEY (department_id) REFERENCES Departments_dim (department_id),
FOREIGN KEY (order_id) REFERENCES Orders_dim (order_id),
FOREIGN KEY (order_item_id) REFERENCES Orders_items_dim (order_item_id),
FOREIGN KEY (product_id) REFERENCES  Products_dim (product_id));
GO
USE AMAZON_ORDERS
GO
ALTER TABLE Products_dim
ADD product_category_id INT;

DROP DATABASE AMAZON_ORDERS;