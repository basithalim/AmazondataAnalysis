
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

