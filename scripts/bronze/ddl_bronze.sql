/*
-- =============================================
-- Database: datawarehouse
-- Layer: Bronze
-- Purpose: Source ingestion tables
-- Author: Adarsh Jha
-- =============================================
*/

USE [datawarehouse]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
go
if object_id ('[bronze].[crm_cust_info]','U') is not null 
	drop table [bronze].[crm_cust_info]
go

CREATE TABLE [bronze].[crm_cust_info](
	[cst_id] [int] NULL,
	[cst_key] [nvarchar](50) NULL,
	[cst_firstname] [nvarchar](50) NULL,
	[cst_lastname] [nvarchar](50) NULL,
	[cst_material_status] [nvarchar](50) NULL,
	[cst_gndr] [nvarchar](50) NULL,
	[cst_create_date] [nvarchar](50) NULL
) ON [PRIMARY]
GO


GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
go
if object_id ('[bronze].[crm_prd_info]','U') is not null 
	drop table [bronze].[crm_prd_info]
go

CREATE TABLE [bronze].[crm_prd_info](
	[prd_id] [int] NULL,
	[prd_key] [varchar](40) NULL,
	[prd_nm] [varchar](50) NULL,
	[prd_cost] [int] NULL,
	[prd_line] [varchar](10) NULL,
	[prd_start_dt] [date] NULL,
	[prd_end_dt] [date] NULL
) ON [PRIMARY]
GO



GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
go
if object_id ('[bronze].[crm_sales_details]','U') is not null 
	drop table [bronze].[crm_sales_details]
go
CREATE TABLE [bronze].[crm_sales_details](
	[sls_ord_num] [varchar](20) NULL,
	[sls_prd_key] [varchar](40) NULL,
	[sls_cust_id] [int] NULL,
	[sls_order_dt] [int] NULL,
	[sls_ship_dt] [int] NULL,
	[sls_due_dt] [int] NULL,
	[sls_sales] [int] NULL,
	[sls_quantity] [int] NULL,
	[sls_price] [int] NULL
) ON [PRIMARY]
GO



GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
go
if object_id ('[bronze].[erp_CUST_AZ12]','U') is not null 
	drop table [bronze].[erp_CUST_AZ12]
go
CREATE TABLE [bronze].[erp_CUST_AZ12](
	[CID] [varchar](50) NULL,
	[BDATE] [date] NULL,
	[GEN] [varchar](10) NULL
) ON [PRIMARY]
GO



GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
go
if object_id ('[bronze].[erp_LOC_A101]','U') is not null 
	drop table [bronze].[erp_LOC_A101]
go
CREATE TABLE [bronze].[erp_LOC_A101](
	[cid] [int] NULL,
	[cntry] [nvarchar](50) NULL
) ON [PRIMARY]
GO



GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
go
if object_id ('[bronze].[erp_PX_CAT_G1V2]','U') is not null 
	drop table [bronze].[erp_PX_CAT_G1V2]
go
CREATE TABLE [bronze].[erp_PX_CAT_G1V2](
	[id] [varchar](50) NULL,
	[cat] [nvarchar](50) NULL,
	[subcat] [nvarchar](50) NULL,
	[maintenance] [nvarchar](50) NULL
) ON [PRIMARY]
GO



