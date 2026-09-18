/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new databases named 'DWH_AdventureWorks' after checking if they already exist. 
    If the databases exist, they are dropped and recreated. Additionally, the script sets up three schemas 
    within each database: 'fact', 'demension' and 'audit'.
	
WARNING:
    Running this script will drop the entire 'DWH_AdventureWorks' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


USE master;
GO

-- Drop and recreate the 'DWH_AdventureWorks' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DWH_AdventureWorks')
BEGIN
    ALTER DATABASE DWH_AdventureWorks SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DWH_AdventureWorks;
END;
GO

-- Create the 'DWH_AdventureWorks' database
CREATE DATABASE DWH_AdventureWorks;
GO

USE DWH_AdventureWorks;
GO

-- Create Schemas
CREATE SCHEMA fact;
GO

create SCHEMA audit;
GO

create SCHEMA dimension;
GO