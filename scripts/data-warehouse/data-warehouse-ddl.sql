/* ----------------------------------------------------------------------
    Dimension: Customer

    Purpose:
        Represents the product dimension used to analyze sales by
        Person as Customer, Territory, Store.

    Grain:
        One row per customer version.

    Source:
        Query from the transform schema's customer-related tables.
   ---------------------------------------------------------------------- */

-- Switch to the DWH_AdventureWorks database.
USE DWH_AdventureWorks;
GO

-- Check if the table exists and drop it if it does.
IF OBJECT_ID('[dimension].[dim_customer]', 'U') IS NOT NULL
    DROP TABLE [dimension].[dim_customer];
GO

-- Create the sales.[dim_customer] table.
CREATE TABLE [dimension].[dim_customer] (
-- Main Dimension attributes.
    [customer_key]              INT IDENTITY (1, 1) NOT NULL,
    [account_number_bk]         VARCHAR (10)        NOT NULL,
    [person_id]                 INT                 NOT NULL,
    [store_id]                  INT                 NOT NULL,
    [territory_id]              INT                 NOT NULL,
    [person_type]               NVARCHAR (50)       NOT NULL,
    [first_name]                NVARCHAR (50)       NOT NULL,
    [Last_name]                 NVARCHAR (50)       NOT NULL,
    [email_promotion]           NVARCHAR (50)       NOT NULL,
    [store]                     NVARCHAR (100)      NOT NULL,
    [territory]                 NVARCHAR (50)       NOT NULL,
    [country_region_code]       NVARCHAR (3)        NOT NULL,
    [territory_group]           NVARCHAR (50)       NOT NULL,

-- System metadata attributes.
    [sys_insert_date]           DATETIME2           NOT NULL,
    [sys_update_date]           DATETIME2               NULL,
    [sys_delete_date]           DATETIME2               NULL,
    [sys_hash_value]            CHAR (64)           NOT NULL,
    [sys_data_source]           NVARCHAR (255)      NOT NULL,
    [sys_source_record_id]      NVARCHAR (100)      NOT NULL,
    [is_current]                BIT                     NULL

-- Define Constrains.
    CONSTRAINT pk_customer_key PRIMARY KEY ([customer_key])
);

-- Create a non-clustered index on the account_number_bk column 
-- to enforce uniqueness and improve query performance.
CREATE NONCLUSTERED INDEX ix_dim_customer_bk_current
    ON [dimension].[dim_customer] (account_number_bk) WHERE is_current = 1;

