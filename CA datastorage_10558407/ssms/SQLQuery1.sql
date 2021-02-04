USE AMAZON_ORDERS_DW
GO
INSERT INTO Products_dim(product_key, product_name, product_description, 
product_image, product_price, department_name, category_name)
SELECT p.product_id, p.product_category_id, p.product_name, 
p.product_description, p.product_image, p.product_price, d.department_name, c.category_name
FROM AMAZON_ORDERS_SOURCE.dbo.Products p
INNER JOIN AMAZON_ORDERS_SOURCE.dbo.Category c 
ON p.product_category_id = c.category_id
INNER JOIN AMAZON_ORDERS_SOURCE.dbo.Departments d
ON c.category_department_id = d.department_id

GO

INSERT INTO Orders_status_dim(order_key, order_status)
SELECT o.order_id, o.order_status
FROM AMAZON_ORDERS_SOURCE.dbo.Orders o

GO

INSERT INTO Customers_dim(customer_key, customer_fname, customer_lname, customer_email, 
customer_password, customer_street, customer_city, customer_state, customer_zipcode)
SELECT c..customer_id, c.customer_fname, c.customer_lname, c.customer_email, c.customer_password,
c.customer_street, c.customer_city, c.customer_state, c. customer_zipcode
FROM AMAZON_ORDERS_SOURCE.dbo.Customers c

Go
INSERT INTO Orders_items_dim(order_items_key, order_item_quantity, order_item_price)
SELECT o.order_item_id, o.order_item_quantity, o.order_item_product_price
FROM AMAZON_ORDERS_SOURCE.dbo.Orders_items

GO

INSERT INTO Order_date_dim(calendar_key, order_date, day_of_week, week_nmber,month_number, year_number)
SELECT 

