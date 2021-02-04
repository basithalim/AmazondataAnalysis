CREATE DATABASE AMAZON_ORDERS_DW
GO 
USE AMAZON_ORDERS_DW
GO
CREATE TABLE Products_dim
(product_key DECIMAL NOT NULL,
product_name VARCHAR(100),
product_image VARCHAR(200),
product_price DECIMAL,
category_name VARCHAR(50),
department_name VARCHAR(50),
PRIMARY KEY (product_key));
GO
CREATE TABLE Customers_dim
(customer_key DECIMAL NOT NULL,
customer_fname VARCHAR(25),
customer_lname VARCHAR(25),
customer_email VARCHAR(50),
customer_password VARCHAR(50),
customer_street VARCHAR(50),
customer_city VARCHAR(50),
customer_state VARCHAR(50),
customer_zipcode INT,
PRIMARY KEY (customer_key));
GO
CREATE TABLE Orders_status_dim
(order_key INT NOT NULL ,
order_status VARCHAR(25),
PRIMARY KEY (order_key));
GO
CREATE TABLE Calendar_dim
(calendar_key INT NOT NULL,
order_date DATE,
day_of_week VARCHAR(30),
day_number INT,
month_number INT,
year_number INT,
PRIMARY KEY (calendar_key));
GO
CREATE TABLE Orders_dim
(order_key DECIMAL NOT NULL,
order_status VARCHAR(40),
PRIMARY KEY(order_key));
DROP TABLE Orders_dim
GO
CREATE TABLE Orders_items_dim
(order_items_key INT NOT NULL,
order_item_quantity INT,
order_item_price DECIMAL ,
PRIMARY KEY (order_items_key));
GO
CREATE TABLE Amazon_retail_fact
(
customer_key DECIMAL,
product_key DECIMAL,
order_key DECIMAL,
calendar_key INT,
order_date DATE,
order_status VARCHAR(40),
order_price_subtotal DECIMAL,
order_quantity_total INT,
PRIMARY KEY (customer_key,product_key, order_key, calendar_key),
FOREIGN KEY (customer_key) REFERENCES Customers_dim (customer_key),
FOREIGN KEY (product_key) REFERENCES Products_dim (product_key),
FOREIGN KEY (order_key) REFERENCES Orders_dim (order_key),
FOREIGN KEY (calendar_key) REFERENCES  Calendar_dim (calendar_key));
USE AMAZON_ORDERS_DW;
GO
SELECT * FROM Products_dim
DELETE FROM Products_dim
CREATE TABLE Fact_temp
(
customer_key INT,
product_key INT,
order_key INT,
order_date DATE,
order_status VARCHAR(40),
order_price_subtotal DECIMAL,
order_quantity_total INT,
PRIMARY KEY (customer_key, product_key, order_key),
FOREIGN KEY (customer_key) REFERENCES Customers_dim (customer_key),
FOREIGN KEY (product_key) REFERENCES Products_dim (product_key),
FOREIGN KEY (order_key) REFERENCES Orders_dim(order_key));
USE AMAZON_ORDERS_DW;
GO
select * from Customers_dim;
USE 
DROP TABLE Fact_temp;
GO
DROP TABLE Amazon_retail_fact; 
GO
INSERT INTO Customers_dim(customer_key, customer_fname, customer_lname,customer_email, customer_password,
customer_street, customer_city, customer_state, customer_zipcode)
SELECT c.customer_id, c.customer_fname, c.customer_lname, c.customer_email, c.customer_password,
c.customer_street, c.customer_city, c.customer_state, c.customer_zipcode
FROM AMAZON_ORDER_SOURCE.dbo.Customers c;
GO
INSERT INTO Order_date_dim(order_date, day_of_week,day_number,month_number,year_number)
SELECT DISTINCT order_date, DATENAME(dw, order_date), 
DATEPART(day, order_date), DATEPART(month, order_date),
DATEPART(year, order_date)
FROM AMAZON_ORDER_SOURCE.dbo.Orders;
GO
INSERT INTO Orders_dim(order_key, order_status)
SELECT o.order_id, o.order_status
FROM AMAZON_ORDER_SOURCE.dbo.Orders o;
SELECT * from Orders_dim
DELETE FROM Orders_dim
GO
INSERT INTO Products_dim(product_key, product_name, product_image, product_price, 
category_name, department_name)
SELECT p.product_id, p.product_name, p.product_image, p.product_price, c.category_name, d.department_name
FROM AMAZON_ORDER_SOURCE.dbo.Products p
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Category c ON p.product_category_id = c.category_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Departments d ON c.category_department_id = d.department_id;
GO
INSERT INTO Customers_dim(product_key, product_name, product_image, product_price, 
category_name, department_name)
SELECT p.product_id, p.product_name, p.product_image, p.product_price, c.category_name, d.department_name
FROM AMAZON_ORDER_SOURCE.dbo.Products p
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Category c ON p.product_category_id = c.category_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Departments d ON c.category_department_id = d.department_id;
GO
CREATE TABLE Fact_keys
(customer_key INT,
product_key INT,
order_key INT,
order_items_key INT,
order_status VARCHAR(25),
PRIMARY KEY (customer_key),
FOREIGN KEY (customer_key) REFERENCES Customers_dim (customer_key),
FOREIGN KEY (product_key) REFERENCES Products_dim (product_key),
FOREIGN KEY (order_key) REFERENCES Orders_status_dim (order_key),
FOREIGN KEY (order_items_key) REFERENCES Orders_items_dim (order_items_key));

CREATE TABLE Fact_cal
(customer_key INT,
PRIMARY KEY (customer_key),
FOREIGN KEY (customer_key) REFERENCES Customers_dim (customer_key),
FOREIGN KEY (product_key) REFERENCES Products_dim (product_key),
FOREIGN KEY (order_key) REFERENCES Orders_status_dim (order_key),
FOREIGN KEY (order_items_key) REFERENCES Orders_items_dim (order_items_key));
GO
DROP TABLE Fact_temp;
USE AMAZON_ORDERS_DW;


INSERT INTO Fact_temp(customer_key, product_key, order_price_subtotal,order_quantity_total)
SELECT c.customer_id, p.product_id,MAX(oi.order_item_quantity * oi.order_item_product_price) AS [order_price_subtotal],
sum(oi.order_item_quantity) AS [order_quantity_total]
FROM AMAZON_ORDER_SOURCE.dbo.Customers c 
LEFT JOIN AMAZON_ORDER_SOURCE.dbo.Orders o ON c.customer_id = o.order_customer_id
LEFT JOIN AMAZON_ORDER_SOURCE.dbo.Orders_items oi ON o.order_id = oi.order_item_order_id 
LEFT JOIN AMAZON_ORDER_SOURCE.dbo.Products p ON oi.order_item_product_id = p.product_id
GROUP BY c.customer_id, p.product_id, o.order_status, order_price_subtotal, order_quantity_total;

DROP TABLE Fact_temp;


SELECT * FROM Fact_temp;
AMAZON_ORDER_SOURCE.dbo.Orders_items oi 
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Orders o ON oi.order_item_order_id = o.order_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Products p ON oi.order_item_product_id = p.product_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Customers c ON o.order_customer_id = c.customer_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Category ca ON p.product_category_id = ca.category_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Departments d ON ca.category_department_id = d.department_id
GROUP BY c.customer_id, p.product_id, o.order_id, oi.order_item_id, o.order_status, 
oi.order_item_quantity;

FROM AMAZON_ORDER_SOURCE.dbo.Products p
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Category c ON p.product_category_id = c.category_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Departments d ON c.category_department_id = d.department_id;
GO
SELECT * FROM Customers_dim;
GO
DROP TABLE Fact_temp;
DROP TABLE Orders_status;
GO[customer_key]
SELECT * FROM Customers_dim;
GO
DROP TABLE Order_date_dim;
DELETE Customers_dim;
GO
SELECT * FROM Order_date_dim;
GO
USE AMAZON_ORDERS_DW;
GO
DROP TABLE Order_date_dim;
GO
DROP TABLE Orders_items_dim;
GO
GO
USE AMAZON_ORDERS_DW;
GO
USE AMAZON_ORDERS_DW;
GO
DROP TABLE Amazon_retail_fact
DROP TABLE Orders_status_dim;
GO
DROP TABLE Products_dim;
GO
DROP TABLE Orders_items_dim;
GO
DROP TABLE Customers_dim;
GO
DROP TABLE Products_dim;
GO
select * from Products_dim;
GO
select * FROM Customers_dim;
GO
DROP TABLE Products_dim;
GO
select * from Products_dim;
GO
select * FROM Products_dim;
USE AMAZON_ORDERS_DW;
DELETE FROM Customers_dim;
DELETE FROM Orders_items_dim;
DELETE FROM Orders_dim
DELETE FROM Products_dim
DELETE FROM Calendar_dim
DELETE FROM Amazon_retail_fact
DELETE FROM Fact_temp
DROP TABLE Customers_dim


select * from Fact_temp;
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
 AMAZON_ORDER_SOURCE.dbo. ON Orders_items.order_item_product_id = Products.product_id INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Category INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Departments ON Category.category_department_id = Departments.department_id ON Products.product_category_id = Category.category_id
GROUP BY Customers.customer_id, Products.product_id, Orders.order_id, Orders.order_status, Orders.order_date
Order By Customers.customer_id
GO
CREATE TABLE Amazon_Fact
(
customer_key INT,
product_key INT,
order_key INT,
calendar_key INT,
order_date DATE,
order_status VARCHAR(40),
order_price_subtotal DECIMAL,
order_quantity_total INT,
PRIMARY KEY (customer_key, product_key, order_key,calendar_key),
FOREIGN KEY (customer_key) REFERENCES Customers_dim (customer_key),
FOREIGN KEY (product_key) REFERENCES Products_dim (product_key),
FOREIGN KEY (order_key) REFERENCES Orders_dim(order_key),
FOREIGN KEY (calendar_key) REFERENCES Calendar_dim(calendar_key));
USE AMAZON_ORDERS_DW;
SELECT * FROM Customers_dim
DELETE FROM Customers_dim
DELETE FROM Amazon_retail_fact

INSERT INTO Customers_dim(customer_key, customer_fname, customer_lname, customer_email,
customer_password, customer_street, customer_city, customer_state, customer_zipcode)
SELECT DISTINCT(c.customer_id), c.customer_fname, c.customer_lname, c.customer_email,
c.customer_password, c.customer_street, c.customer_city, c.customer_state, c.customer_zipcode
FROM AMAZON_ORDER_SOURCE.dbo.Customers_source c INNER JOIN 
AMAZON_ORDER_SOURCE.dbo.Orders_source o ON c.customer_id = o.order_customer_id
