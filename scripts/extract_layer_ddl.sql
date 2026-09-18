/*
=========================================================================
    Extract DDL Script for the AdventureWorks Data Warehouse Project

    Purpose:
        This script creates the extract layer tables in the STG_AdventureWorks database. 
        The extract layer is used to stage data from the source systems before it is transformed and loaded INTo the data warehouse.
        It is designed to be run once to create the necessary tables for the dimension and fact tables in the extract layer.

    Source:
        Production.Product
        Production.ProductSubcategory
        Production.ProductCategory
        Production.ProductModel
        Production.UnitMeasure
        Sales.SalesTerritory
        Sales.Customer
        Sales.Store
        Person.Person
        Person.CountryRegion
 ========================================================================
 */

USE [STG_AdventureWorks];
GO

--	=====================================================================
-- This script drops then creates the Product table in the extract layer. 
-- ======================================================================
IF OBJECT_ID('[extract].[Product]', 'U') IS NOT NULL
    DROP TABLE [extract].[Product];
GO

CREATE TABLE [extract].[Product](
	[ProductID]                 INT           NULL,
	[Name]                      NVARCHAR(50)  NULL,
	[ProductNumber]             NVARCHAR(25)  NULL,
	[Color]                     NVARCHAR(15)  NULL,
	[Size]                      NVARCHAR(5)   NULL,
	[SizeUnitMeasureCode]       [nchar](3)      NULL,
	[WeightUnitMeasureCode]     [nchar](3)      NULL,
	[Weight]                    [decimal](8, 2) NULL,
	[Class]                     [nchar](2)      NULL,
	[Style]                     [nchar](2)      NULL,
	[ProductLine]               [nchar](2)      NULL,
	[ProductSubcategoryID]      INT           NULL,
	[ProductModelID]            INT           NULL,
	[SellStartDate]             [datetime]      NULL,
	[SellEndDate]               [datetime]      NULL,
	[DiscontinuedDate]          [datetime]      NULL,
);
GO

-- =====================================================================
-- This script drops then creates the ProductModel table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[ProductModel]', 'U') IS NOT NULL
    DROP TABLE [extract].[ProductModel];
GO

CREATE TABLE [extract].[ProductModel](
	[ProductModelID]            INT           NULL,
	[Name]                      NVARCHAR(50)  NULL,
);
GO

-- =====================================================================
-- This script drops then creates the ProductCategory table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[ProductCategory]', 'U') IS NOT NULL
    DROP TABLE [extract].[ProductCategory];
GO

CREATE TABLE [extract].[ProductCategory](
	[ProductCategoryID] 		INT 			NULL,
    [Name]                      NVARCHAR(50)  NULL
);
GO

-- =====================================================================
-- This script drops then creates the ProductSubcategory table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[ProductSubcategory]', 'U') IS NOT NULL
    DROP TABLE [extract].[ProductSubcategory];
GO

CREATE TABLE [extract].[ProductSubcategory] (
    [ProductSubcategoryID]      INT             NULL,
    [ProductCategoryID]         INT             NULL,
    [Name]                      NVARCHAR(50)  NULL
);
GO

-- =====================================================================
-- This script drops then creates the UnitMeasure table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[UnitMeasure]', 'U') IS NOT NULL
    DROP TABLE [extract].UnitMeasure;
GO

CREATE TABLE [extract].[UnitMeasure](
	[UnitMeasureCode]           [nchar](3)      NULL,
	[Name]                      NVARCHAR(50)  NULL
);
GO

-- =====================================================================
-- This script drops then creates the SalesTerritory table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[SalesTerritory]', 'U') IS NOT NULL
    DROP TABLE [extract].[SalesTerritory];
GO

CREATE TABLE [extract].[SalesTerritory] (
    [TerritoryID]               INT            NULL,
    [Name]                      NVARCHAR (50)  NULL,
    [CountryRegionCode]         NVARCHAR (3)   NULL,
    [Group]                     NVARCHAR (50)  NULL
);
GO

-- =====================================================================
-- This script drops then creates the CountryRegion table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[CountryRegion]', 'U') IS NOT NULL
    DROP TABLE [extract].[CountryRegion];
GO

CREATE TABLE [extract].[CountryRegion](
	[CountryRegionCode]         NVARCHAR (3)  NULL,
	[Name]                      NVARCHAR (50) NULL
);
GO

-- =====================================================================
-- This script drops then creates the Customer table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[Customer]', 'U') IS NOT NULL
    DROP TABLE [extract].[Customer];
GO

CREATE TABLE [extract].[Customer] (
    [CustomerID]                INT             NULL,
    [PersonID]                  INT             NULL,
    [StoreID]                   INT             NULL,
    [TerritoryID]               INT             NULL,
    [AccountNumber]             VARCHAR (10)    NULL
);
Go

-- =====================================================================
-- This script drops then creates the Store table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[Store]', 'U') IS NOT NULL
    DROP TABLE [extract].[Store];
GO

CREATE TABLE [extract].[Store] (
    [BusinessEntityID]          INT            NULL,
    [Name]                      NVARCHAR (50)  NULL
);
GO

-- =====================================================================
-- This script drops then creates the Person table in the extract layer.
-- =====================================================================
IF OBJECT_ID('[extract].[Person]', 'U') IS NOT NULL
    DROP TABLE [extract].[Person];
GO

CREATE TABLE [extract].[Person] (
    [BusinessEntityID]          INT            NULL,
    [PersonType]                NCHAR (2)      NULL,
    [FirstName]                 NVARCHAR (50)  NULL,
    [LastName]                  NVARCHAR (50)  NULL,
    [EmailPromotion]            INT            NULL
);
