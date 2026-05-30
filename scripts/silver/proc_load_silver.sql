/*
===============================================================================
Stored Procedure: silver.load_silver

Purpose:
    This stored procedure transforms, cleanses, and loads data from the
    Bronze layer into the Silver layer tables of the data warehouse.

Process:
    1. Truncates existing Silver tables
    2. Cleans and standardizes source data
    3. Removes duplicate customer records
    4. Validates and transforms date fields
    5. Handles missing and invalid values
    6. Standardizes business attributes such as gender, marital status,
       product categories, and countries
    7. Calculates product validity periods using window functions
    8. Tracks execution time for each transformation process
    9. Implements error handling using TRY...CATCH

Source Tables:                                                   
    - bronze.crm_cust_info
    - bronze.crm_prd_info
    - bronze.crm_sales_details
    - bronze.erp_CUST_AZ12
    - bronze.erp_LOC_A101
    - bronze.erp_PX_CAT_G1V2

Target Tables:
    - silver.crm_cust_info
    - silver.crm_prd_info
    - silver.crm_sales_details
    - silver.erp_CUST_AZ12
    - silver.erp_LOC_A101
    - silver.erp_PX_CAT_G1V2


Layer:
    Silver Layer (Data Cleansing & Transformation)

Author:
    Adarsh Jha
===============================================================================
*/

create or alter procedure silver.load_silver as 
begin 
begin try 
declare @start_time datetime , @end_time datetime , @start_ftime datetime , @end_ftime datetime
set @start_ftime = getdate()
print '=============================================='
print '----------------------------------------------'
print 'Transfromation processes on CRM files'
print '----------------------------------------------'
print 'first truncating the [silver].[crm_cust_info] table'
set @start_time = getdate()
if object_id ('[silver].[crm_cust_info]' , 'U') is not null
truncate table [silver].[crm_cust_info]
print 'then transforming and inserting data from bronze layer to [silver].[crm_cust_info]'
insert into  [silver].[crm_cust_info] ( cst_id ,cst_key , cst_firstname , cst_lastname , cst_material_status ,
cst_gndr , cst_create_date)

select 
cst_id ,
cst_key,
trim(cst_firstname) cst_firstname,
trim(cst_lastname) cst_lastname,

case 
when upper(trim(cst_material_status)) = 'S' then 'Single'
when upper(trim(cst_material_status)) = 'M' then 'Married'
else 'NA' 
end cst_material_status,

case 
when upper(trim(cst_gndr)) = 'F' then 'Female'
when upper(trim(cst_gndr)) = 'M' then 'Male'
else 'NA' 
end cst_gndr ,
cst_create_date
from 
(
select *,
rank() over(partition by cst_id order by cst_create_date desc ) rnk
from bronze.crm_cust_info ) temp 
where rnk = 1 and cst_id is not null
set @end_time = getdate()
print 'time duration for transformation of this table is:' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'
print '----------------------------------------------'
print 'first truncating the silver.crm_prd_info table'
set @start_time = getdate()
if object_id ('silver.crm_prd_info' , 'U') is not null
truncate table silver.crm_prd_info
print 'then transforming and inserting data from bronze layer to silver.crm_prd_info'
insert into silver.crm_prd_info(
prd_id , cat_id , prd_key , prd_nm , prd_cost , prd_line , prd_start_dt , prd_end_dt)
select 
[prd_id] ,

	replace(substring([prd_key], 1, 5 ),'-','_') cat_id ,
	substring([prd_key], 7, len(prd_key) ) prd_key ,
	[prd_nm] ,
	coalesce([prd_cost],0) as prd_cost,
	case 
	when upper(prd_line) = 'M' then 'Mountain'
	when upper(prd_line) = 'R' then 'Road'
	when upper(prd_line) = 'S' then 'Sports'
	when upper(prd_line) = 'T' then 'Tourisms'
	else 'NA'
	end [prd_line] ,
	cast([prd_start_dt] as date) as prd_start_dt,
	cast(dateadd(day,-1,lead(prd_start_dt ) over (partition by prd_key order by prd_start_dt))as date ) as prd_end_dt
from bronze.crm_prd_info
set @end_time = getdate()
print 'time duration for transformation of this table is:' +cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'
print '----------------------------------------------'
set @start_time = getdate() 
print 'first truncating the silver.crm_sales_details table'
if object_id ('silver.crm_sales_details' , 'U') is not null
truncate table silver.crm_sales_details
print 'then transforming and inserting data from bronze layer to silver.crm_sales_details'
insert into silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price)
select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
case 
when sls_order_dt = 0 or len(sls_order_dt) <> 8 then NULL
else cast(cast(sls_order_dt as varchar) as date)
end sls_order_dt ,
case 
when sls_ship_dt = 0 or len(sls_ship_dt) <> 8 then NULL
else cast(cast(sls_ship_dt as varchar) as date)
end sls_ship_dt ,
case 
when sls_due_dt = 0 or len(sls_due_dt) <> 8 then NULL
else cast(cast(sls_due_dt as varchar) as date)
end sls_due_dt ,
case 
when sls_sales <> sls_quantity * abs(sls_price) or sls_sales <= 0 or sls_sales is null 
then sls_quantity * abs(sls_price)
else sls_sales
end sls_sales,

sls_quantity,

case 
when sls_price is null or sls_price <=0 
then sls_sales / nullif(sls_quantity,0)
else sls_price
end sls_price
from bronze.[crm_sales_details]
set @end_time = getdate()
print 'time duration for transforming this table is:' + cast(datediff(second,@start_time,@end_time) as varchar) +'seconds'
print '----------------------------------------------'
print 'Transfromation processes on ERP files'
print '----------------------------------------------'
print '----------------------------------------------'
print 'first truncating the silver.erp_CUST_AZ12 table'
set @start_time = getdate()
if object_id ('silver.erp_CUST_AZ12' , 'U') is not null
truncate table silver.erp_CUST_AZ12
print 'then transforming and inserting data from bronze layer to silver.erp_CUST_AZ12'
insert into silver.erp_CUST_AZ12 (CID , BDATE , GEN ) 
select 
case 
when cid like 'NAS%' then substring(cid,4,len(cid))
else cid
end CID,
case 
when BDATE > getdate() then NULL
else BDATE
end BDATE,
case 
when upper(trim(GEN)) in ('F' , 'FEMALE') then 'Female'
when upper(trim(GEN)) in ('M' , 'MALE' ) then 'Male'
else 'NA'
end GEN
from bronze.erp_CUST_AZ12
set @end_time = getdate()
print 'time duration for transformation of this table is:' + cast(datediff(second,@start_time,@end_time) as varchar) +'seconds'

print '----------------------------------------------'
print 'first truncating the silver.erp_LOC_A101 table'
set @start_time = getdate()
if object_id ('silver.erp_LOC_A101' , 'U') is not null
truncate table silver.erp_LOC_A101
print 'then transforming and inserting data from bronze layer to silver.erp_LOC_A101'
insert into silver.erp_LOC_A101(cid , cntry)

select 
replace(cid,'-', '') as cid ,
case 
when upper(trim(cntry)) in ('DE' ,'GERMANY') then 'Germany'
when upper(trim(cntry)) in ('US' , 'USA' ,'United States' ) then 'United States'
when trim(cntry) = '' or trim(cntry) is null then 'NA'
else trim(cntry)
end cntry
from bronze.erp_LOC_A101
set @end_time = getdate()
print'time duration for transformation of this table is:' + cast(datediff(second,@start_time,@end_time) as varchar) +'seconds'
print '----------------------------------------------'
print 'first truncating the silver.erp_PX_CAT_G1V2 table'
set @start_time = getdate()
if object_id ('silver.erp_PX_CAT_G1V2' , 'U') is not null
truncate table silver.erp_PX_CAT_G1V2
print 'then transforming and inserting data from bronze layer to silver.erp_PX_CAT_G1V2'
insert into silver.erp_PX_CAT_G1V2 (id , cat, subcat, maintenance)
select * from bronze.erp_PX_CAT_G1V2
set @end_time = getdate()
print 'time duration for transfromation of this table is;' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'
set @end_ftime = getdate()
print 'time duration for full silver tables is:' + cast(datediff(second,@start_ftime,@end_ftime) as varchar) + 'seconds'
end try 

begin catch 
print '=================================================='
print 'error occured during the loading '
print 'error message:' + error_message();
print 'error number:' +cast(error_number() as varchar);
print 'error state:' + cast(error_state() as varchar);
print '=================================================='
end catch 
end 
