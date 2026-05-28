/*
===============================================================================
Stored Procedure: bronze.load_bronze

Purpose:
    This stored procedure loads raw data from CRM and ERP source CSV files
    into the bronze layer tables of the data warehouse.

Process:
    1. Truncates existing bronze tables
    2. Loads fresh data using BULK INSERT
    3. Tracks execution time for each load
    4. Implements basic error handling using TRY...CATCH

Source Systems:
    - CRM Source Files
    - ERP Source Files

Layer:
    Bronze Layer (Raw Data Ingestion)

Author:
    Adarsh Jha
===============================================================================
*/

create or alter procedure bronze.load_bronze as 
begin
begin try 
declare @start_time datetime , @end_time datetime , @start_ftime datetime , @end_ftime datetime
print '==========================================================='
print 'Loading the Bronze Layer ';
print '==========================================================='

print '-----------------------------------------------------------'
print 'loading the CRM files '
print '-----------------------------------------------------------'

set @start_ftime = getdate();
set @start_time = getdate();
print '>> first truncating the file: [bronze].[crm_cust_info]'
	truncate table [bronze].[crm_cust_info]
print '>> inserting the data from source to file: [bronze].[crm_cust_info]'

	bulk insert [bronze].[crm_cust_info]
	from 'C:\Users\abhay\Downloads\DWH\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
	);
set @end_time = getdate();
print 'total time consumed:' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'
print '------------'

set @start_time = getdate();
print '>> first truncating the file: [bronze].[crm_prd_info]'
	truncate table [bronze].[crm_prd_info]
print '>> inserting the data from source to file: [bronze].[crm_prd_info]'
	bulk insert [bronze].[crm_prd_info]
	from 'C:\Users\abhay\Downloads\DWH\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
	);
set @end_time = getdate();
print 'total time consumed:' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'

print '------------'



set @start_time = getdate();
print '>> first truncating the file: [bronze].[crm_sales_details]'
	truncate table [bronze].[crm_sales_details]
print '>> inserting the data from source to file: [bronze].[crm_sales_details]'
	bulk insert [bronze].[crm_sales_details]
	from 'C:\Users\abhay\Downloads\DWH\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
	);
set @end_time = getdate();
print 'total time consumed:' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'

print '------------'



print '-----------------------------------------------------------'
print 'loading the ERP files '
print '-----------------------------------------------------------'


set @start_time = getdate();
print '>> first truncating the file: [bronze].[erp_CUST_AZ12]'
	truncate table [bronze].[erp_CUST_AZ12]
print '>> inserting the data from source to file: [bronze].[erp_CUST_AZ12]'
	bulk insert [bronze].[erp_CUST_AZ12]
	from 'C:\Users\abhay\Downloads\DWH\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
	);
set @end_time = getdate();
print 'total time consumed:' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'

print '------------'



set @start_time = getdate();
print '>> first truncating the file: [bronze].[erp_LOC_A101]'
	truncate table [bronze].[erp_LOC_A101]
print '>> inserting the data from source to file: [bronze].[erp_LOC_A101]'
	bulk insert [bronze].[erp_LOC_A101]
	from 'C:\Users\abhay\Downloads\DWH\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
	);
set @end_time = getdate();
print 'total time consumed:' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'

print '------------'



set @start_time = getdate();
print '>> first truncating the file: [bronze].[erp_PX_CAT_G1V2]'
	truncate table [bronze].[erp_PX_CAT_G1V2]
print '>> inserting the data from source to file: [bronze].[erp_PX_CAT_G1V2]'
	bulk insert [bronze].[erp_PX_CAT_G1V2]
	from 'C:\Users\abhay\Downloads\DWH\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with (
	firstrow = 2 ,
	fieldterminator = ',',
	tablock
	);
set @end_time = getdate();
set @end_ftime = getdate();

print 'total time consumed:' + cast(datediff(second,@start_time,@end_time) as varchar) + 'seconds'

print '-------------------------------'

print 'total time consumed for full bronze layer :' + cast(datediff(second,@start_ftime,@end_ftime) as varchar) + 'seconds'

print '------------'


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

exec bronze.load_bronze
