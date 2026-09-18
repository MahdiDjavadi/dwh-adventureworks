/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new databases named 'STG_AdventureWorks' after checking if they already exist. 
    If the databases exist, they are dropped and recreated. Additionally, the script sets up two schemas 
    within each database: 'extract' and 'transform'.
	
WARNING:
    Running this script will drop the entire 'STG_AdventureWorks' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- Drop and recreate the 'STG_AdventureWorks' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'STG_AdventureWorks')
BEGIN
    ALTER DATABASE STG_AdventureWorks SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE STG_AdventureWorks;
END;
GO

-- Create the 'STG_AdventureWorks' database
CREATE DATABASE STG_AdventureWorks;
GO

use STG_AdventureWorks;
GO

-- Create Schemas
CREATE SCHEMA extract;
GO

create SCHEMA transform;
GO
