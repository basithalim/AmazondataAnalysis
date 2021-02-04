CREATE DATABASE AMAZON_ORDER_SOURCE
GO
USE AMAZON_ORDER_SOURCE;
GO
DROP TABLE Departments;
GO
DROP TABLE Departments;
GO
DROP TABLE Category;
GO
DROP TABLE Customers;
GO
DROP TABLE Orders;
GO
DROP TABLE Orders_items;
GO
DROP TABLE Products;

CREATE TABLE Departments
(department_id DECIMAL NOT NULL PRIMARY KEY,
department_name VARCHAR(10));
GO
DROP TABLE Departments;

DROP TABLE Category;
select * from Departments
CREATE TABLE Category
(category_id DECIMAL NOT NULL PRIMARY KEY,
category_department_id DECIMAL not null,
category_name VARCHAR(100),
FOREIGN KEY(category_department_id) REFERENCES Departments (department_id));
SELECT * FROM Category;
GO
USE AMAZON_ORDER_SOURCE;

DROP TABLE Customers;
USE AMAZON_ORDER_SOURCE
GO

CREATE TABLE PRODUCTS
(product_id decimal not null primary key,
product_category_id decimal not null,
product_name varchar(100),
product_price decimal,
product_image varchar(200)
foreign key (product_category_id) references Category(category_id));
DROP TABLE PRODUCTS;
go




USE AMAZON_ORDER_SOURCE;
DROP TABLE Customers;
CREATE TABLE Customers
(customer_id DECIMAL NOT NULL,
customer_fname VARCHAR(20),
customer_lname VARCHAR(20),
customer_email VARCHAR(40),
customer_password VARCHAR(25),
customer_street VARCHAR(40),
customer_city VARCHAR(40),
customer_state VARCHAR(40),
customer_zipcode DECIMAL,
PRIMARY KEY (customer_id));
USE AMAZON_ORDER_SOURCE
SELECT * FROM Customers
GO
CREATE TABLE Orders
(order_id INT NOT NULL IDENTITY,
order_customer_id INT,
order_date VARCHAR(10),
order_status VARCHAR(10),
PRIMARY KEY (order_id),
FOREIGN KEY (order_customer_id) REFERENCES  Customers (customer_id));
GO
CREATE TABLE Orders_items
(order_item_id INT NOT NULL IDENTITY,
order_item_order_id INT,
order_item_product_id INT,
order_item_quantity INT,
order_item_subtotal INT,
order_item_product_price INT,
PRIMARY KEY (order_item_id),
FOREIGN KEY (order_item_order_id) REFERENCES Orders (order_id),
FOREIGN KEY (order_item_product_id) REFERENCES Products (product_id));

select * from AMAZON_ORDER_SOURCE.dbo.Customers;
DELETE from AMAZON_ORDER_SOURCE.dbo.Customers;