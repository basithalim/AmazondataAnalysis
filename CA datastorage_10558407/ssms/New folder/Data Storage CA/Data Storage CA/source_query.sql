CREATE DATABASE AMAZON_ORDER_SOURCE
GO
USE AMAZON_ORDER_SOURCE
GO
DROP TABLE Category;
CREATE TABLE Departments
(department_id DECIMAL NOT NULL,
department_name VARCHAR(10),
PRIMARY KEY (department_id));
GO
select * from Departments;

DELETE from Orders_items;
USE AMAZON_ORDER_SOURCE;
DROP TABLE Orders;

CREATE TABLE Category
(category_id DECIMAL NOT NULL,
category_department_id DECIMAL,
category_name VARCHAR(50),
PRIMARY KEY (category_id),
FOREIGN KEY (category_department_id) REFERENCES Departments (department_id));
GO
CREATE TABLE Products
(product_id DECIMAL NOT NULL,
product_category_id DECIMAL,
product_name VARCHAR(100),
product_price DECIMAL,
product_image VARCHAR(200),
PRIMARY KEY (product_id),
FOREIGN KEY (product_category_id) REFERENCES Category (category_id));

SELECT * FROM Products;
GO
USE AMAZON_ORDER_SOURCE;
DROP TABLE Products;
GO
CREATE TABLE Customers
(customer_id DECIMAL NOT NULL,
customer_fname VARCHAR(25),
customer_lname VARCHAR(25),
customer_email VARCHAR(50),
customer_password VARCHAR(50),
customer_street VARCHAR(50),
customer_city VARCHAR(50),
customer_state VARCHAR(50),
customer_zipcode DECIMAL,
PRIMARY KEY (customer_id));
GO
DELETE FROM Customers;
SELECT * FROM Customers;
USE AMAZON_ORDER_SOURCE
GO
CREATE TABLE Orders
(order_id DECIMAL NOT NULL,
order_customer_id DECIMAL NOT NULL,
order_date DATE,
order_status VARCHAR(40),
date_id INT NOT NULL,
PRIMARY KEY (order_id),
FOREIGN KEY (order_customer_id) REFERENCES Customers(customer_id));
DROP TABLE Date_temp;
GO
SELECT * FROM Orders_items;
GO
CREATE TABLE Orders_items
(order_item_id DECIMAL NOT NULL,
order_item_order_id DECIMAL,
order_item_product_id DECIMAL,
order_item_quantity DECIMAL,
order_item_subtotal DECIMAL,
order_item_product_price DECIMAL,
PRIMARY KEY (order_item_id),
FOREIGN KEY (order_item_order_id) REFERENCES Orders (order_id),
FOREIGN KEY (order_item_product_id) REFERENCES Products (product_id));
GO
SELECT * from Orders_items;
GO
DROP TABLE Date_temp;
USE AMAZON_ORDER_SOURCE;
DELETE FROM Order_date;
GO
USE AMAZON_ORDER_SOURCE;
CREATE TABLE Date_temp
(calendar_key INT NOT NULL IDENTITY,
order_date DATE,
cal_order_id DECIMAL,
PRIMARY KEY (calendar_key),
FOREIGN KEY (cal_order_id) REFERENCES Orders(order_id));
GO
CREATE TABLE Orders_date
(calendar_key INT NOT NULL,
order_date DATE,
PRIMARY KEY (calendar_key));
GO
DROP TABLE Orders_date;
INSERT INTO Orders_date(calendar_key,order_date, cal_order_id)
SELECT RANK() OVER (ORDER BY order_date) calendar_key, order_date,order_id from Orders;
GO
SELECT 
    DENSE_RANK() OVER (ORDER BY First_Name, Last_Name) ID,

select * FROM Customers 
order by calendar_key;
GO
INSERT INTO dbo.Departments_test
SELECT CAST (department_id AS INT), department_name FROM dbo.departments_demo;
GO
DELETE FROM Customers;
GO
select DISTINCT(order_date) from Orders
order by order_date
GO
CREATE TABLE Departments_test
(department_id INT NOT NULL,
department_name VARCHAR(10),
PRIMARY KEY (department_id));
GO
USE AMAZON_ORDER_SOURCE
GO
DROP TABLE departments_test;
GO
DROP TABLE Category;
GO
DROP TABLE Customers;
GO
DROP TABLE Departments;
GO
DROP TABLE Orders;
GO
DROP TABLE Date_temp
GO
DROP TABLE Orders_date;
GO
DROP TABLE Orders_items;
GO
DROP TABLE Products;

SELECT Customers.customer_id, Products.product_id, Orders.order_id, Orders.order_date, Orders.order_status, MAX(Orders_items.order_item_quantity * Orders_items.order_item_product_price) AS order_price_subtotal, 
                         SUM(Orders_items.order_item_quantity) AS order_quantity_total
FROM Orders INNER JOIN
 Customers ON Orders.order_customer_id = Customers.customer_id INNER JOIN
 Orders_items ON Orders.order_id = Orders_items.order_item_order_id INNER JOIN
 Products ON Orders_items.order_item_product_id = Products.product_id INNER JOIN
 Category INNER JOIN
 Departments ON Category.category_department_id = Departments.department_id ON Products.product_category_id = Category.category_id
GROUP BY Customers.customer_id, Products.product_id, Orders.order_id, Orders.order_status, Orders.order_date
Order By Customers.customer_id
GO
USE AMAZON_ORDERS_DW;
GO
INSERT INTO Fact_temp(customer_key, product_key, order_key,order_date,order_status,
order_price_subtotal,order_quantity_total)
SELECT Customers.customer_id, Products.product_id, Orders.order_id, Orders.order_date, Orders.order_status, 
MAX(Orders_items.order_item_quantity * Orders_items.order_item_product_price) AS order_price_subtotal, 
                         SUM(Orders_items.order_item_quantity) AS order_quantity_total
FROM AMAZON_ORDER_SOURCE.dbo.Orders INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Customers ON Orders.order_customer_id = Customers.customer_id INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Orders_items ON Orders.order_id = Orders_items.order_item_order_id INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Products ON Orders_items.order_item_product_id = Products.product_id INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Category INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Departments ON Category.category_department_id = Departments.department_id ON Products.product_category_id = Category.category_id
GROUP BY Customers.customer_id, Products.product_id, Orders.order_id, Orders.order_status, Orders.order_date
Order By Customers.customer_id

CREATE TABLE Orders_date
(calendar_key INT NOT NULL,
order_date DATE,
PRIMARY KEY (calendar_key),
FOREIGN KEY (order_date) references Orders(order_date));
GO
USE AMAZON_ORDER_SOURCE;
DROP TABLE Order_date;
INSERT INTO Order_date(order_date, day_of_week,day_number,month_number,year_number)
SELECT DISTINCT order_date, DATENAME(dw, order_date), 
DATEPART(day, order_date), DATEPART(month, order_date),
DATEPART(year, order_date)
FROM AMAZON_ORDER_SOURCE.dbo.Orders;
SELECT * FROM Date_temp
SELECT * FROM Orders_date
DELETE FROM Orders_date

INSERT INTO Date_temp(order_date, cal_order_id)
SELECT DISTINCT(order_date), order_id FROM Orders;

CREATE TABLE Departments_source
(department_id INT NOT NULL,
department_name VARCHAR(10),
PRIMARY KEY (department_id));
GO
select * from Departments;

DELETE from Orders_items;
USE AMAZON_ORDER_SOURCE;
DROP TABLE Orders;

CREATE TABLE Category_source
(category_id INT NOT NULL,
category_department_id INT,
category_name VARCHAR(50),
PRIMARY KEY (category_id),
FOREIGN KEY (category_department_id) REFERENCES Departments_source (department_id));
GO
CREATE TABLE Products_source
(product_id INT NOT NULL,
product_category_id INT,
product_name VARCHAR(100),
product_price DECIMAL,
product_image VARCHAR(200),
PRIMARY KEY (product_id),
FOREIGN KEY (product_category_id) REFERENCES Category_source(category_id));

SELECT * FROM Products;
GO
USE AMAZON_ORDER_SOURCE;
DROP TABLE Products;
GO
CREATE TABLE Customers_source
(customer_id INT NOT NULL,
customer_fname VARCHAR(25),
customer_lname VARCHAR(25),
customer_email VARCHAR(50),
customer_password VARCHAR(50),
customer_street VARCHAR(50),
customer_city VARCHAR(50),
customer_state VARCHAR(50),
customer_zipcode INT,
PRIMARY KEY (customer_id));
GO
DELETE FROM Customers;
SELECT * FROM Customers;
USE AMAZON_ORDER_SOURCE
GO
CREATE TABLE Orders_source
(order_id INT NOT NULL,
order_customer_id INT NOT NULL,
order_date DATE,
order_status VARCHAR(40),
date_id INT NOT NULL,
PRIMARY KEY (order_id),
FOREIGN KEY (order_customer_id) REFERENCES Customers_source(customer_id));
DROP TABLE Date_temp;
GO
SELECT * FROM Orders_items;
GO
CREATE TABLE Orders_items_source
(order_item_id INT NOT NULL,
order_item_order_id INT,
order_item_product_id INT,
order_item_quantity INT,
order_item_subtotal DECIMAL,
order_item_product_price DECIMAL,
PRIMARY KEY (order_item_id),
FOREIGN KEY (order_item_order_id) REFERENCES Orders_source(order_id),
FOREIGN KEY (order_item_product_id) REFERENCES Products_source (product_id));

INSERT INTO Departments_source(department_id,department_name)
SELECT department_id, department_name FROM Departments;
GO
INSERT INTO Category_source(category_id, category_department_id, category_name)
SELECT category_id, category_department_id, category_name
FROM Category;
GO
INSERT INTO Customers_source(customer_id, customer_fname, customer_lname, customer_email,
customer_password, customer_street, customer_city, customer_state, customer_zipcode)
SELECT customer_id, customer_fname, customer_lname, customer_email,
customer_password, customer_street, customer_city, customer_state, customer_zipcode
FROM Customers;
GO
GO
INSERT INTO Orders_source(order_id, order_customer_id, order_date, order_status, date_id)
SELECT order_id, order_customer_id, order_date, order_status, date_id
FROM Orders;
GO
INSERT INTO Orders_items_source(order_item_id, order_item_order_id,order_item_product_id,order_item_quantity,
order_item_subtotal)
SELECT order_item_id, order_item_order_id,order_item_product_id,order_item_quantity,
order_item_subtotal
FROM Orders_items;
USe AMAZON_ORDER_SOURCE
SELECT * fROM Customers_source
USE AMAZON_ORDERS_DW
DROP TABLE Orders_dim
