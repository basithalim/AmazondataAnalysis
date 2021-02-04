USE AMAZON_ORDERS_DW;
GO
INSERT INTO Fact_temp(customer_key, product_key, order_price_subtotal,order_quantity_total)
SELECT c.customer_id, p.product_id,
MAX(oi.order_item_quantity * oi.order_item_product_price) AS [order_price_subtotal],
sum(oi.order_item_quantity) AS [order_quantity_total]
FROM AMAZON_ORDER_SOURCE.dbo.Customers c 
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Orders o ON c.customer_id = o.order_customer_id
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Orders_items oi ON o.order_id = oi.order_item_order_id 
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Products p ON oi.order_item_product_id = p.product_id
GROUP BY c.customer_id, p.product_id;

Delete FROM Amazon_retail_fact

insert into Amazon_retail_fact(customer_key,product_key,order_key,calendar_key,order_date,order_price_subtotal,
order_quantity_total)
select o.date_id,c.customer_id,p.product_id,o.order_id,o.order_date,
MAX(oi.order_item_quantity * oi.order_item_product_price) AS order_price_subtotal, 
SUM(oi.order_item_quantity) AS order_quantity_total
from AMAZON_ORDER_SOURCE.dbo.customers c 
inner join AMAZON_ORDER_SOURCE.dbo.Orders_source o on c.customer_id = o.order_customer_id
inner join AMAZON_ORDER_SOURCE.dbo.Orders_items_source oi on o.order_id = oi.order_item_order_id 
inner join AMAZON_ORDER_SOURCE.dbo.Products_source p on oi.order_item_product_id=p.product_id 
INNER JOIN AMAZON_ORDER_SOURCE.dbo.Category_source t5 ON p.product_category_id = t5.category_id
inner join AMAZON_ORDER_SOURCE.dbo.Departments_source t6 ON t5.category_department_id = t6.department_id
group by c.customer_id,p.product_id,o.order_id,o.date_id,o.order_date,
(oi.order_item_product_price*oi.order_item_quantity),(oi.order_item_quantity)
order by o.date_id,c.customer_id
USE AMAZON_ORDERS_DW
DELETE FROM Amazon_retail_fact
INSERT TOP(500) INTO Amazon_retail_fact(customer_key, product_key, order_key, calendar_key,
order_Date, order_status, order_price_subtotal, order_quantity_total)
SELECT Customers.customer_id, Products.product_id, Orders.order_id,Orders.date_id,
Orders.order_date, Orders.order_status, 
MAX(Orders_items.order_item_quantity * Orders_items.order_item_product_price) AS order_price_subtotal, 
                         SUM(Orders_items.order_item_quantity) AS order_quantity_total
FROM AMAZON_ORDER_SOURCE.dbo.Orders INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Customers ON Orders.order_customer_id = Customers.customer_id INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Orders_items ON Orders.order_id = Orders_items.order_item_order_id INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Products ON Orders_items.order_item_product_id = Products.product_id INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Category INNER JOIN
 AMAZON_ORDER_SOURCE.dbo.Departments ON Category.category_department_id = Departments.department_id ON Products.product_category_id = Category.category_id
GROUP BY Customers.customer_id, Products.product_id, Orders.order_id, Orders.date_id,
Orders.order_status, Orders.order_date
Order By Customers.customer_id