USE [BikeStores]
GO

/****** Object:  View [dbo].[vOrderDetails]    Script Date: 12/26/2022 12:17:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE or ALTER VIEW [dbo].[vOrderDetails]
AS
SELECT        sales.order_items.item_id, sales.order_items.quantity, sales.order_items.discount, sales.order_items.product_id, sales.orders.store_id, sales.orders.order_id, sales.orders.customer_id, CONVERT(datetime, 
                         sales.orders.order_date) AS order_date_date, sales.orders.order_date
FROM            sales.order_items INNER JOIN
                         sales.orders ON sales.order_items.order_id = sales.orders.order_id
GO

USE [BikeStores]
GO

/****** Object:  View [dbo].[vProduct]    Script Date: 12/26/2022 12:18:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [dbo].[vProduct]
AS
SELECT        production.products.brand_id, production.products.product_name, production.products.product_id, production.products.model_year, production.brands.brand_name, production.categories.category_name, 
                         production.products.list_price, production.products.category_id
FROM            production.products INNER JOIN
                         production.brands ON production.products.brand_id = production.brands.brand_id INNER JOIN
                         production.categories ON production.products.category_id = production.categories.category_id
GO

