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