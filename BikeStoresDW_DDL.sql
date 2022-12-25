USE [master]
GO

/****** Object:  Database [BikeStoresDW]    Script Date: 12/26/2022 12:07:44 AM ******/
CREATE DATABASE [BikeStoresDW]
GO

USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[DimCustomers]    Script Date: 12/26/2022 12:08:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimCustomers](
	[customer_key] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[first_name] [varchar](255) NOT NULL,
	[last_name] [varchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NULL,
	[street] [varchar](255) NULL,
	[city] [varchar](255) NULL,
	[stat] [varchar](10) NULL,
	[zip_code] [varchar](5) NULL,
	[current_flag] [char](1) NOT NULL,
	[valid_date] [datetime] NOT NULL,
	[expire_date] [datetime] NULL,
 CONSTRAINT [pk_DimCustomers] PRIMARY KEY CLUSTERED 
(
	[customer_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[DimDate]    Script Date: 12/26/2022 12:09:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimDate](
	[date_key] [int] IDENTITY(1,1) NOT NULL,
	[date_naturalkey] [datetime] NOT NULL,
	[date_month] [varchar](2) NOT NULL,
	[date_year] [varchar](4) NOT NULL,
 CONSTRAINT [pk_DimDate] PRIMARY KEY CLUSTERED 
(
	[date_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[DimProducts]    Script Date: 12/26/2022 12:09:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimProducts](
	[product_key] [int] IDENTITY(1,1) NOT NULL,
	[product_id] [int] NOT NULL,
	[product_name] [varchar](255) NOT NULL,
	[model_year] [smallint] NOT NULL,
	[list_price] [decimal](10, 2) NOT NULL,
	[brand_id] [int] NOT NULL,
	[brand_name] [varchar](255) NOT NULL,
	[category_id] [int] NOT NULL,
	[category_name] [varchar](255) NOT NULL,
	[current_flag] [char](1) NOT NULL,
	[valid_date] [datetime] NOT NULL,
	[expire_date] [datetime] NULL,
 CONSTRAINT [pk_DimProducts] PRIMARY KEY CLUSTERED 
(
	[product_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[DimStores]    Script Date: 12/26/2022 12:10:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimStores](
	[store_key] [int] IDENTITY(1,1) NOT NULL,
	[store_id] [int] NOT NULL,
	[store_name] [varchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NULL,
	[street] [varchar](255) NULL,
	[city] [varchar](255) NULL,
	[state] [varchar](10) NULL,
	[zip_code] [varchar](5) NULL,
 CONSTRAINT [pk_DimStores] PRIMARY KEY CLUSTERED 
(
	[store_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[FactOrders]    Script Date: 12/26/2022 12:10:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FactOrders](
	[order_key] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[customer_key] [int] NOT NULL,
	[store_key] [int] NOT NULL,
	[product_key] [int] NOT NULL,
	[orderdate_key] [int] NOT NULL,
	[quantity] [decimal](10, 2) NOT NULL,
	[discount] [decimal](4, 2) NOT NULL,
 CONSTRAINT [pk_FactOrders] PRIMARY KEY CLUSTERED 
(
	[order_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FactOrders] ADD  DEFAULT ((0)) FOR [quantity]
GO

ALTER TABLE [dbo].[FactOrders] ADD  DEFAULT ((0)) FOR [discount]
GO

ALTER TABLE [dbo].[FactOrders]  WITH CHECK ADD  CONSTRAINT [FK_OrdersCustomers] FOREIGN KEY([customer_key])
REFERENCES [dbo].[DimCustomers] ([customer_key])
GO

ALTER TABLE [dbo].[FactOrders] CHECK CONSTRAINT [FK_OrdersCustomers]
GO

ALTER TABLE [dbo].[FactOrders]  WITH CHECK ADD  CONSTRAINT [FK_OrdersDate] FOREIGN KEY([orderdate_key])
REFERENCES [dbo].[DimDate] ([date_key])
GO

ALTER TABLE [dbo].[FactOrders] CHECK CONSTRAINT [FK_OrdersDate]
GO

ALTER TABLE [dbo].[FactOrders]  WITH CHECK ADD  CONSTRAINT [FK_OrdersProducts] FOREIGN KEY([product_key])
REFERENCES [dbo].[DimProducts] ([product_key])
GO

ALTER TABLE [dbo].[FactOrders] CHECK CONSTRAINT [FK_OrdersProducts]
GO

ALTER TABLE [dbo].[FactOrders]  WITH CHECK ADD  CONSTRAINT [FK_OrdersStores] FOREIGN KEY([store_key])
REFERENCES [dbo].[DimStores] ([store_key])
GO

ALTER TABLE [dbo].[FactOrders] CHECK CONSTRAINT [FK_OrdersStores]
GO

USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[stg_DimCustomers]    Script Date: 12/26/2022 12:10:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_DimCustomers](
	[customer_id] [int] NOT NULL,
	[first_name] [varchar](255) NOT NULL,
	[last_name] [varchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NULL,
	[street] [varchar](255) NULL,
	[city] [varchar](255) NULL,
	[stat] [varchar](10) NULL,
	[zip_code] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[stg_DimProducts]    Script Date: 12/26/2022 12:11:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_DimProducts](
	[product_id] [int] NOT NULL,
	[product_name] [varchar](255) NOT NULL,
	[model_year] [smallint] NOT NULL,
	[list_price] [decimal](10, 2) NOT NULL,
	[brand_id] [int] NOT NULL,
	[brand_name] [varchar](255) NOT NULL,
	[category_id] [int] NOT NULL,
	[category_name] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[stg_DimStores]    Script Date: 12/26/2022 12:11:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_DimStores](
	[store_id] [int] NOT NULL,
	[store_name] [varchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NULL,
	[street] [varchar](255) NULL,
	[city] [varchar](255) NULL,
	[state] [varchar](10) NULL,
	[zip_code] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[store_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [BikeStoresDW]
GO

/****** Object:  Table [dbo].[stg_FactOrders]    Script Date: 12/26/2022 12:11:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_FactOrders](
	[order_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[customer_key] [int] NOT NULL,
	[store_key] [int] NOT NULL,
	[product_key] [int] NOT NULL,
	[orderdate_key] [int] NOT NULL,
	[quantity] [decimal](10, 2) NOT NULL,
	[discount] [decimal](4, 2) NOT NULL
) ON [PRIMARY]
GO



