USE [BikeStoresDW]
GO

/****** Object:  StoredProcedure [dbo].[FillDateDim]    Script Date: 12/26/2022 12:13:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create   or Alter PROCEDURE [dbo].[FillDateDim]
AS
BEGIN
DECLARE @StartDate DATETIME --Starting value of Date Range
DECLARE @EndDate DATETIME --End Value of Date Range

DECLARE
@CurrentDate DATETIME,
@CurrentYear INT,
@CurrentMonth INT
--
set @StartDate = (select min (BikeStores.sales.orders.order_date) from BikeStores.sales.orders)
set @EndDate= (select max (BikeStores.sales.orders.order_date) from BikeStores.sales.orders)
set @EndDate = DATEADD(YY, 1, @EndDate )
set @CurrentDate=@StartDate
WHILE @CurrentDate <= @EndDate
BEGIN
insert into BikeStoresDW.dbo.DimDate(date_naturalkey, date_month, date_year)
values (@CurrentDate, DATEPART (MM, @CurrentDate),DATEPART (YYYY, @CurrentDate))
SET @CurrentDate = DATEADD(DD,1,@CurrentDate)
END
END
GO

USE [BikeStoresDW]
GO

/****** Object:  StoredProcedure [dbo].[Merge_DimCustomers]    Script Date: 12/26/2022 12:13:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE OR ALTER   PROCEDURE [dbo].[Merge_DimCustomers]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;





		--Type 1 and 3 changes
		MERGE INTO dbo.DimCustomers tgt
		USING [dbo].[stg_DimCustomers] src ON tgt.[customer_id] = src.[customer_id]
		WHEN MATCHED AND EXISTS 
		(	
			select src.[first_name],src.[last_name]
			except 
			select tgt.[first_name],tgt.[last_name]
		)
		THEN UPDATE
		SET 
			tgt.[first_name]=src.[first_name],
			tgt.[last_name]=src.[last_name]
		WHEN NOT MATCHED BY TARGET THEN INSERT
		(
			[customer_id],
			[first_name],
			[last_name],
			[phone],
			[email],
			[street],
			[city],
			[stat],
			[zip_code],
			[current_flag],
			[valid_date],
			[expire_date]

		)
		VALUES
		(	src.[customer_id],
			src.[first_name],
			src.[last_name],
			src.[phone],
			src.[email],
			src.[street],
			src.[city],
			src.[stat],
			src.[zip_code],
			'Y',
			getdate(),
			NULL
		);




		
	IF OBJECT_ID('tempdb..#DimCustomers') IS NOT NULL
    DROP TABLE #DimCustomers;


	CREATE TABLE #DimCustomers
	(
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
	);


	INSERT INTO #DimCustomers
		   ([customer_id],[first_name],[last_name],[phone],[email],[street],[city],[stat],[zip_code],[current_flag],[valid_date],[expire_date])
	SELECT	[customer_id],[first_name],[last_name],[phone],[email],[street],[city],[stat],[zip_code],[current_flag],[valid_date],[expire_date]	
    From (
		MERGE INTO dbo.DimCustomers tgt
		USING [dbo].[stg_DimCustomers] src ON tgt.[customer_id] = src.[customer_id]
		WHEN MATCHED AND tgt.[expire_date] IS NULL AND EXISTS 
		(	
			select src.[phone],src.[email],src.[street],src.[city],src.[stat],src.[zip_code]
			except 
			select tgt.[phone],tgt.[email],tgt.[street],tgt.[city],tgt.[stat],tgt.[zip_code]
		)
		THEN UPDATE
		SET 
			tgt.[expire_date] = getdate(),
			tgt.[current_flag] = 'N'
		WHEN NOT MATCHED BY TARGET THEN INSERT
		(
			[customer_id],
			[first_name],
			[last_name],
			[phone],
			[email],
			[street],
			[city],
			[stat],
			[zip_code],
			[current_flag],
			[valid_date],
			[expire_date]

		)
		VALUES
		(	src.[customer_id],
			src.[first_name],
			src.[last_name],
			src.[phone],
			src.[email],
			src.[street],
			src.[city],
			src.[stat],
			src.[zip_code],
			'Y',
			getdate(),
			NULL
		)
		Output $ACTION ActionOut, src.[customer_id],
			src.[first_name],
			src.[last_name],
			src.[phone],
			src.[email],
			src.[street],
			src.[city],
			src.[stat],
			src.[zip_code],
			'Y' as [current_flag],
			getdate() as [valid_date],
			NULL as [expire_date]) AS MergeOut
	WHERE  MergeOut.ActionOut = 'UPDATE';

	insert into [dbo].[DimCustomers]
		   ([customer_id],[first_name],[last_name],[phone],[email],[street],[city],[stat],[zip_code],[current_flag],[valid_date],[expire_date])
	SELECT	[customer_id],[first_name],[last_name],[phone],[email],[street],[city],[stat],[zip_code],[current_flag],[valid_date],[expire_date]	
	from #DimCustomers;


	
END
GO


USE [BikeStoresDW]
GO

/****** Object:  StoredProcedure [dbo].[Merge_DimProducts]    Script Date: 12/26/2022 12:14:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE OR ALTER   PROCEDURE [dbo].[Merge_DimProducts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;





		--Type 1 and 3 changes
		MERGE INTO dbo.DimProducts tgt
		USING [dbo].stg_DimProducts src ON tgt.[product_id] = src.[product_id]
		WHEN MATCHED AND EXISTS 
		(	
			select src.[product_name],src.[model_year],src.[brand_id],src.[brand_name],src.[category_id],src.[category_name]
			except 
			select tgt.[product_name],tgt.[model_year],tgt.[brand_id],tgt.[brand_name],tgt.[category_id],tgt.[category_name]
			--[product_name],[model_year],[brand_id],[brand_name],[category_id],[category_name]
		)
		THEN UPDATE
		SET 
			tgt.[product_name]=src.[product_name],
			tgt.[model_year]=src.[model_year],
			tgt.[brand_id]=src.[brand_id],
			tgt.[brand_name]=src.[brand_name],
			tgt.[category_id]=src.[category_id],
			tgt.[category_name]=src.[category_name]
			
		WHEN NOT MATCHED BY TARGET THEN INSERT
		(
			[product_id],
			[product_name],
			[model_year],
			[list_price],
			[brand_id],
			[brand_name],
			[category_id],
			[category_name],
			[current_flag],
			[valid_date],
			[expire_date]

		)
		VALUES
		(	src.[product_id],
			src.[product_name],
			src.[model_year],
			src.[list_price],
			src.[brand_id],
			src.[brand_name],
			src.[category_id],
			src.[category_name],
			'Y',
			getdate(),
			NULL
		);




		
	IF OBJECT_ID('tempdb..#DimProducts') IS NOT NULL
    DROP TABLE #DimProducts;


	CREATE TABLE #DimProducts
	(
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
	);


	INSERT INTO #DimProducts
		   ([product_id],[product_name],[model_year],[list_price],[brand_id],[brand_name],[category_id],[category_name],[current_flag],[valid_date],[expire_date])
	SELECT	[product_id],[product_name],[model_year],[list_price],[brand_id],[brand_name],[category_id],[category_name],[current_flag],[valid_date],[expire_date]
    From (
		MERGE INTO dbo.DimProducts tgt
		USING dbo.stg_DimProducts src ON tgt.[product_id] = src.[product_id]
		WHEN MATCHED AND tgt.[expire_date] IS NULL AND EXISTS 
		(	
			select src.[list_price]
			except 
			select tgt.[list_price]
		)
		THEN UPDATE
		SET 
			tgt.[expire_date] = getdate(),
			tgt.[current_flag] = 'N'
				WHEN NOT MATCHED BY TARGET THEN INSERT
		(
			[product_id],
			[product_name],
			[model_year],
			[list_price],
			[brand_id],
			[brand_name],
			[category_id],
			[category_name],
			[current_flag],
			[valid_date],
			[expire_date]

		)
		VALUES
		(	src.[product_id],
			src.[product_name],
			src.[model_year],
			src.[list_price],
			src.[brand_id],
			src.[brand_name],
			src.[category_id],
			src.[category_name],
			'Y',
			getdate(),
			NULL
		)
		Output $ACTION ActionOut, src.[product_id],
			src.[product_name],
			src.[model_year],
			src.[list_price],
			src.[brand_id],
			src.[brand_name],
			src.[category_id],
			src.[category_name],
			'Y' as [current_flag],
			getdate() as [valid_date],
			NULL as [expire_date]) AS MergeOut
	WHERE  MergeOut.ActionOut = 'UPDATE';

	insert into [dbo].DimProducts
		   ([product_id],[product_name],[model_year],[list_price],[brand_id],[brand_name],[category_id],[category_name],[current_flag],[valid_date],[expire_date])
	SELECT	[product_id],[product_name],[model_year],[list_price],[brand_id],[brand_name],[category_id],[category_name],[current_flag],[valid_date],[expire_date]
	from #DimProducts;


	
END
GO

USE [BikeStoresDW]
GO

/****** Object:  StoredProcedure [dbo].[Merge_DimStores]    Script Date: 12/26/2022 12:14:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER   PROCEDURE [dbo].[Merge_DimStores]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @RecordCount INT = 0;

		MERGE INTO dbo.DimStores tgt
		USING [dbo].stg_DimStores src ON tgt.[store_id] = src.[store_id]
		WHEN MATCHED AND EXISTS 
		(	
			select src.[store_name],src.[phone],src.[email],src.[street],src.[city],src.[state],src.[zip_code]
			except 
			select tgt.[store_name],tgt.[phone],tgt.[email],tgt.[street],tgt.[city],tgt.[state],tgt.[zip_code]
		--[store_name],[phone],[email],[street],[city],[state],[zip_code]
		)
		THEN UPDATE
		SET		
			tgt.[store_name]=src.[store_name],
			tgt.[phone]=src.[phone],
			tgt.[email]=src.[email],
			tgt.[street]=src.[street],
			tgt.[state]=src.[state],
			tgt.[zip_code]=src.[zip_code]
		WHEN NOT MATCHED BY TARGET THEN INSERT
		(
			[store_id],
			[store_name],
			[phone],
			[email],
			[street],
			[city],
			[state],
			[zip_code]
		)
		VALUES
		(	src.[store_id],
			src.[store_name],
			src.[phone],
			src.[email],
			src.[street],
			src.[city],
			src.[state],
			src.[zip_code]
		);


	
END
GO

USE [BikeStoresDW]
GO

/****** Object:  StoredProcedure [dbo].[Merge_FactOrders]    Script Date: 12/26/2022 12:14:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER   PROCEDURE [dbo].[Merge_FactOrders]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @RecordCount INT = 0;

		MERGE INTO dbo.FactOrders tgt
		USING [dbo].stg_FactOrders src ON tgt.[order_id] = src.[order_id] and tgt.[item_id]=src.[item_id]
		WHEN MATCHED AND EXISTS 
		(	
			select src.[customer_key],src.[store_key],src.[product_key],src.[orderdate_key],src.[quantity],src.[discount]
			except 
			select tgt.[customer_key],tgt.[store_key],tgt.[product_key],tgt.[orderdate_key],tgt.[quantity],tgt.[discount]
		)
		THEN UPDATE
		SET		
			tgt.[customer_key]=src.[customer_key],
			tgt.[store_key]=src.[store_key],
			tgt.[product_key]=src.[product_key],
			tgt.[orderdate_key]=src.[orderdate_key],
			tgt.[quantity]=src.[quantity],
			tgt.[discount]=src.[discount]
		WHEN NOT MATCHED BY TARGET THEN INSERT
		(
			[order_id],
			[item_id],
			[customer_key],
			[store_key],
			[product_key],
			[orderdate_key],
			[quantity],
			[discount]
		)
		VALUES
		(	src.[order_id],
			src.[item_id],
			src.[customer_key],
			src.[store_key],
			src.[product_key],
			src.[orderdate_key],
			src.[quantity],
			src.[discount]
		);


	
END
GO

exec FillDateDim