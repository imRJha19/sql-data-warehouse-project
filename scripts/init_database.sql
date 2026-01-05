/* =========================================================
   Database Initialization Script
   Creates DataWarehouse database and Medallion schemas

this scripts will generate a database named datawarehouse if its already exits it will drop it so take care pf past database 
   ========================================================= */

USE master;
GO

-- Drop database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'datawarehouse')
BEGIN
    ALTER DATABASE datawarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE datawarehouse;
END;
GO

-- Create the DataWarehouse database
CREATE DATABASE datawarehouse;
GO

-- Switch to the new database
USE datawarehouse;
GO

-- Create Medallion Architecture schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
