/*
=========================================================================
    Extract DDL Script for the AdventureWorks Data Warehouse Project

    Purpose:
        This script creates the transform layer tables in the STG_AdventureWorks database. 
        The transform layer is used to stage data from the source systems before it is transformed and loaded INTo the data warehouse.
        The tables are used to stage product data transformed from the AdventureWorks database.

    Source:
        extract.Product
        extract.ProductSubcategory
        extract.ProductCategory
        extract.ProductModel
        extract.UnitMeasure
        extract.SalesTerritory
        extract.Customer
        Saextractles.Store
        extract.Person
        extract.CountryRegion
 ========================================================================
 */

USE [STG_AdventureWorks];
GO

--	=====================================================================
-- This script drops then creates the Product table in the transform layer. 
-- ======================================================================
IF OBJECT_ID('[transform].[Product]', 'U') IS NOT NULL
    DROP TABLE [transform].[Product];
GO

CREATE TABLE [transform].[Product](
	[ProductID]                 INT           NULL,
	[Name]                      NVARCHAR(50)  NULL,
	[ProductNumber]             NVARCHAR(25)  NULL,
	[Color]                     NVARCHAR(15)  NULL,
	[Size]                      NVARCHAR(5)   NULL,
	[SizeUnitMeasureCode]       NCHAR(3)      NULL,
	[WeightUnitMeasureCode]     NCHAR(3)      NULL,
	[Weight]                    [decimal](8, 2) NULL,
	[Class]                     NCHAR(2)      NULL,
	[Style]                     NCHAR(2)      NULL,
	[ProductLine]               NCHAR(2)      NULL,
	[ProductSubcategoryID]      INT           NULL,
	[ProductModelID]            INT           NULL,
	[SellStartDate]             [datetime]      NULL,
	[SellEndDate]               [datetime]      NULL,
	[DiscontinuedDate]          [datetime]      NULL,
);
GO

-- =====================================================================
-- This script drops then creates the ProductModel table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[ProductModel]', 'U') IS NOT NULL
    DROP TABLE [transform].[ProductModel];
GO

CREATE TABLE [transform].[ProductModel](
	[ProductModelID]            INT           NULL,
	[Name]                      NVARCHAR(50)  NULL,
);
GO

-- =====================================================================
-- This script drops then creates the ProductCategory table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[ProductCategory]', 'U') IS NOT NULL
    DROP TABLE [transform].[ProductCategory];
GO

CREATE TABLE [transform].[ProductCategory](
	[ProductCategoryID] 		INT 		  NULL,
    [Name]                      NVARCHAR(50)  NULL
);
GO

-- =====================================================================
-- This script drops then creates the ProductSubcategory table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[ProductSubcategory]', 'U') IS NOT NULL
    DROP TABLE [transform].[ProductSubcategory];
GO

CREATE TABLE [transform].[ProductSubcategory] (
    [ProductSubcategoryID]      INT             NULL,
    [ProductCategoryID]         INT             NULL,
    [Name]                      NVARCHAR (50)   NULL
);
GO

-- =====================================================================
-- This script drops then creates the UnitMeasure table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[UnitMeasure]', 'U') IS NOT NULL
    DROP TABLE [transform].UnitMeasure;
GO

CREATE TABLE [transform].[UnitMeasure](
	[UnitMeasureCode]           NCHAR (3)     NULL,
	[Name]                      NVARCHAR (50) NULL
);
GO

-- =====================================================================
-- This script drops then creates the SalesTerritory table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[SalesTerritory]', 'U') IS NOT NULL
    DROP TABLE [transform].[SalesTerritory];
GO

CREATE TABLE [transform].[SalesTerritory] (
    [TerritoryID]               INT              NULL,
    [Name]                      NVARCHAR (50)    NULL,
    [CountryRegionCode]         NVARCHAR (3)     NULL,
    [Group]                     NVARCHAR (50)    NULL
);
GO

-- =====================================================================
-- This script drops then creates the CountryRegion table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[CountryRegion]', 'U') IS NOT NULL
    DROP TABLE [transform].[CountryRegion];
GO

CREATE TABLE [transform].[CountryRegion](
	[CountryRegionCode]         NVARCHAR (3)    NULL,
	[Name]                      NVARCHAR (50)   NULL
);
GO

-- =====================================================================
-- This script drops then creates the Customer table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[Customer]', 'U') IS NOT NULL
    DROP TABLE [transform].[Customer];
GO

CREATE TABLE [transform].[Customer] (
    [CustomerID]                INT             NULL,
    [PersonID]                  INT             NULL,
    [StoreID]                   INT             NULL,
    [TerritoryID]               INT             NULL,
    [AccountNumber]             VARCHAR (10)    NULL
);
Go

-- =====================================================================
-- This script drops then creates the Store table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[Store]', 'U') IS NOT NULL
    DROP TABLE [transform].[Store];
GO

CREATE TABLE [transform].[Store] (
    [BusinessEntityID]          INT            NULL,
    [Name]                      NVARCHAR (50)  NULL,
    [SalesPersonID]             INT            NULL,
    [SquareFeet]                INT            NULL,
    [YearOpend]                 INT            NULL,
    [NumberEmployees]           INT            NULL,
    [Speciality]                NVARCHAR (50)  NULL,
    [Brands]                    INT            NULL
);
GO

-- =====================================================================
-- This script drops then creates the Person table in the transform layer.
-- =====================================================================
IF OBJECT_ID('[transform].[Person]', 'U') IS NOT NULL
    DROP TABLE [transform].[Person];
GO

CREATE TABLE [transform].[Person] (
    [BusinessEntityID]          INT            NULL,
    [PersonType]                NVARCHAR (50)  NULL,
    [FirstName]                 NVARCHAR (50)  NULL,
    [LastName]                  NVARCHAR (50)  NULL,
    [EmailPromotion]            NVARCHAR (50)  NULL
);
GO
