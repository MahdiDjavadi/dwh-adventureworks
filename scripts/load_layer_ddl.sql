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


/* ----------------------------------------------------------------------
    Dimension: Date

   dimension.dim_date -- DDL only (fill/populate logic is a separate script)

   Design decisions locked in for this version:
     - gregorian_date is the real join key (date_key = yyyymmdd INT, PK).
     - Jalali is attribute-only: jalali_date_key (yyyymmdd jalali) as a unique alt key,
       not the PK, so relationships to fact tables stay on the Gregorian side.
     - Every calendar period has TWO columns: a display label (..._year_month,
       ..._year_quarter, ..._year_week -- text, for slicers) and a sequential number
       (..._year_month_number etc. -- INT, step = 1 across year boundaries, safe for
       DAX offset arithmetic instead of DATEADD on a non-Gregorian calendar).
     - day_of_week_number is locale-independent: Saturday = 1 .. Friday = 7.
     - is_working_day = Friday is the only weekly day off (per confirmed decision).
       This is a WEEKEND flag only -- official holidays vary yearly and are NOT
       computable from the calendar; if holiday-accurate reporting is needed later,
       join a separate holiday reference table and override this column there.
     - is_date_with_data is a placeholder (default 0) -- it depends on fact-table
       coverage and must be populated by an ETL step, not by calendar generation.
   ---------------------------------------------------------------------- */

IF OBJECT_ID('dimension.dim_date') IS NOT NULL
    DROP TABLE dimension.dim_date;
GO

CREATE TABLE dimension.dim_date
(
    -- Base
    date_key                       INT             NOT NULL,   -- gregorian yyyymmdd
    gregorian_date                 DATE            NOT NULL,
    jalali_date_key                INT             NOT NULL,   -- jalali yyyymmdd, e.g. 14040101
    sequential_day_number          INT             NOT NULL,   -- DATEDIFF(DAY,'1900-01-01',gregorian_date)+1, gapless across the whole table

    -- Gregorian breakdown (kept for reconciliation with Gregorian-native systems: Hesabfa/Codal, bank feeds, etc.)
    gregorian_year                 SMALLINT        NOT NULL,
    gregorian_month_number         TINYINT         NOT NULL,
    gregorian_month_name           NVARCHAR(20)    NOT NULL,
    gregorian_quarter_number       TINYINT         NOT NULL,
    gregorian_quarter_name         NVARCHAR(20)    NOT NULL,
    gregorian_year_month           NVARCHAR(10)    NOT NULL,   -- label 'yyyy-MM'
    gregorian_year_month_number    INT             NOT NULL,   -- sequential = year*12+month
    gregorian_year_quarter         NVARCHAR(10)    NOT NULL,   -- label 'yyyy-Q#'
    gregorian_year_quarter_number  INT             NOT NULL,   -- sequential = year*4+quarter

    -- Jalali calendar
    jalali_date                    NVARCHAR(10)    NOT NULL,   -- 'yyyy/mm/dd'
    jalali_year                    SMALLINT        NOT NULL,
    jalali_year_name               NVARCHAR(10)    NOT NULL,
    jalali_month_number            TINYINT         NOT NULL,
    jalali_month_name              NVARCHAR(20)    NOT NULL,
    jalali_year_month              NVARCHAR(10)    NOT NULL,   -- label '1404-01'
    jalali_year_month_number       INT             NOT NULL,   -- sequential = year*12+month
    jalali_quarter_number          TINYINT         NOT NULL,
    jalali_quarter_name            NVARCHAR(20)    NOT NULL,
    jalali_year_quarter            NVARCHAR(10)    NOT NULL,   -- label '1404-Q1'
    jalali_year_quarter_number     INT             NOT NULL,   -- sequential = year*4+quarter
    jalali_half_year_number        TINYINT         NOT NULL,
    jalali_half_year_name          NVARCHAR(20)    NOT NULL,

    -- Day / week position (needed for custom YTD/QTD/MTD/PYTD-style Time Intelligence)
    month_of_quarter_number        TINYINT         NOT NULL,   -- 1..3
    day_of_week_number             TINYINT         NOT NULL,   -- Saturday=1 .. Friday=7, locale-independent
    day_of_week_name               NVARCHAR(20)    NOT NULL,
    day_of_month_number            TINYINT         NOT NULL,
    day_of_quarter_number          SMALLINT        NOT NULL,
    day_of_year_number             SMALLINT        NOT NULL,
    week_of_year_number            TINYINT         NOT NULL,
    week_of_month_number           TINYINT         NOT NULL,   -- week belongs to the month containing its Saturday
    week_of_quarter_number         TINYINT         NOT NULL,
    jalali_year_week               NVARCHAR(10)    NOT NULL,   -- label '1404-W01'
    jalali_year_week_number        INT             NOT NULL,   -- sequential

    -- Period boundaries (Gregorian DATE values, boundaries defined by the Jalali calendar)
    week_start_date                DATE            NOT NULL,
    week_end_date                  DATE            NOT NULL,
    month_start_date               DATE            NOT NULL,
    month_end_date                 DATE            NOT NULL,
    quarter_start_date             DATE            NOT NULL,
    quarter_end_date               DATE            NOT NULL,
    year_start_date                DATE            NOT NULL,
    year_end_date                  DATE            NOT NULL,

    -- Flags
    is_working_day                 BIT             NOT NULL CONSTRAINT df_dim_date_is_working_day DEFAULT (1), -- Friday = 0, populated by fill logic
    is_date_with_data              BIT             NOT NULL CONSTRAINT df_dim_date_is_date_with_data DEFAULT (0), -- ETL-populated, not derivable from calendar

    CONSTRAINT pk_dim_date PRIMARY KEY CLUSTERED (date_key)
        WITH (FILLFACTOR = 100, PAD_INDEX = ON, DATA_COMPRESSION = PAGE)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX unqix_dim_date_jalali_date_key
    ON dimension.dim_date (jalali_date_key) WITH (FILLFACTOR = 100, PAD_INDEX = ON, DATA_COMPRESSION = PAGE);
GO

CREATE UNIQUE NONCLUSTERED INDEX unqix_dim_date_gregorian_date
    ON dimension.dim_date (gregorian_date) INCLUDE (jalali_date) WITH (FILLFACTOR = 100, PAD_INDEX = ON, DATA_COMPRESSION = PAGE);
GO

CREATE UNIQUE NONCLUSTERED INDEX unqix_dim_date_jalali_date
    ON dimension.dim_date (jalali_date) INCLUDE (gregorian_date) WITH (FILLFACTOR = 100, PAD_INDEX = ON, DATA_COMPRESSION = PAGE);
GO

CREATE UNIQUE NONCLUSTERED INDEX unqix_dim_date_sequential_day_number
    ON dimension.dim_date (sequential_day_number) WITH (FILLFACTOR = 100, PAD_INDEX = ON, DATA_COMPRESSION = PAGE);
GO


/*  ----------------------------------------------------------------------
    Dimension: Product

    Purpose:
        Represents the product dimension used to analyze sales by
        product, category, subcategory, and product model.

    Grain:
        One row per product.

    Source:
        Query from the transform schema's product-related tables.
    ------------------------------------------------------------------------
*/

-- Check if the table exists and drop it if it does
IF OBJECT_ID('dimension.dim_product', 'U') IS NOT NULL
    DROP TABLE dimension.dim_product;
GO

-- Create the sales.dim_product table
CREATE TABLE dimension.dim_product
(
-- Main dimension attributes.
    [product_key]             INT IDENTITY (1, 1) NOT NULL,   -- Surrogate key generated by the data warehouse.
    [product_code_bk]         NVARCHAR (50)       NOT NULL,   -- Product business identifier from the source system.
    [product]                 NVARCHAR (50)       NOT NULL,   -- Product name used for reporting.
    [category_key]            INT                     NULL,   -- Category business key from the source system.
    [category]                NVARCHAR (50)       NOT NULL,   -- Product category name.
    [subcategory_key]         INT                     NULL,   -- Subcategory business key from the source system.
    [subcategory]             NVARCHAR (50)       NOT NULL,   -- Product subcategory name.
    [model_key]               INT                     NULL,   -- Product model business key from the source system.
    [model]                   NVARCHAR (50)       NOT NULL,   -- Product model name.
    [class]                   NVARCHAR (50)       NOT NULL,   -- Product class e.g., high, medium, low.
    [color]                   NVARCHAR (20)       NOT NULL,   -- Product color.
    [style]                   NVARCHAR (10)       NOT NULL,   -- Product style e.g., men's, women's, universal.
    [size]                    NVARCHAR (10)       NOT NULL,   -- Product size.
    [size_measure_unit]       NVARCHAR (50)           NULL,   -- Unit of measurement for product size.
    [weight]                  NVARCHAR (10)       NOT NULL,   -- Product weight.
    [weight_measure_unit]     NVARCHAR (50)           NULL,   -- Unit of measurement for product weight.
    [product_line]            NVARCHAR (10)       NOT NULL,   -- Product line e.g., Road, Mountain, Touring, Standard.
    [sell_start_date]         DATE                NOT NULL,   -- Date when the product became available for sale.
    [sell_end_date]           DATE                    NULL,   -- Date when the product was no longer available for sale.
    [discontinued_date]       DATE                    NULL,   -- Date when the product was officially discontinued.

-- System metadata attributes.
    [sys_insert_date]         DATETIME2 (3)       NOT NULL,   -- System metadata: date and time when the record was inserted.
    [sys_update_date]         DATETIME2 (3)           NULL,   -- System metadata: date and time when the record was last updated.
    [sys_delete_date]         DATETIME2 (3)           NULL,   -- System metadata: date and time when the record was deleted or marked for deletion.
    [sys_hash_value]          CHAR (64)           NOT NULL,   -- System metadata: hash value used to detect changes in source attributes.
    [sys_data_source]         NVARCHAR (25)       NOT NULL,   -- System metadata: name of the source system.
    [sys_source_record_id]    NVARCHAR (255)      NOT NULL,   -- System metadata: identifier of the source system or source record.

-- Define constraints.
    CONSTRAINT PK_dim_product
        PRIMARY KEY CLUSTERED (product_key ASC)
);

-- Create a unique non-clustered index on the product_code_bk column 
-- to enforce uniqueness and improve query performance
CREATE UNIQUE NONCLUSTERED INDEX UX_dim_product_product_code_bk
        ON dimension.dim_product (product_code_bk);


/*
    ------------------------------------------------------------------
    Dimension: Terrotry

    Purpose:
        Represents the territory dimension used to analyze sales by
        Country name and alias, territory group.

    Grain:
        One row per exact territory.

    Source:
        Query from the transform schema's terrytory-related tables.
    -----------------------------------------------------------------
*/

-- Check if the table exists and drop it if it does
IF OBJECT_ID('dimension.dim_territory', 'U') IS NOT NULL
    DROP TABLE dimension.dim_territory;
GO

-- Create the sales.dim_territory table
CREATE TABLE dimension.dim_territory
(
-- Main dimension attributes.
    [territory_key]             INT IDENTITY (1, 1) NOT NULL,   -- Surrogate key generated by the data warehouse.
    [territory_name_bk]         NVARCHAR (50)       NOT NULL,   -- Sales territory description.
    [territory_group]           NVARCHAR (50)       NOT NULL,   -- Geographic area to which the sales territory belong.
    [country_region_code]       NVARCHAR (3)        NOT NULL,   -- ISO standard country or region code. Foreign key to CountryRegion.CountryRegionCode.
    [country_name]              NVARCHAR (30)       NOT NULL,   -- Country or region name.

-- System metadata attributes.
    [sys_insert_date]           DATETIME2 (3)       NOT NULL,   -- System metadata: date and time when the record was inserted.
    [sys_update_date]           DATETIME2 (3)           NULL,   -- System metadata: date and time when the record was last updated.
    [sys_delete_date]           DATETIME2 (3)           NULL,   -- System metadata: date and time when the record was deleted or marked for deletion.
    [sys_hash_value]            CHAR (64)           NOT NULL,   -- System metadata: hash value used to detect changes in source attributes.
    [sys_data_source]           NVARCHAR (25)       NOT NULL,   -- System metadata: name of the source system.
    [sys_source_record_id]      NVARCHAR (255)      NOT NULL,   -- System metadata: identifier of the source system or source record.

-- Define constraints.
    CONSTRAINT PK_dim_territory
        PRIMARY KEY CLUSTERED (territory_key ASC)
);

-- Create a unique non-clustered index on the territory_name_bk column 
-- to enforce uniqueness and improve query performance
CREATE UNIQUE NONCLUSTERED INDEX UX_dim_territory_territory_name_bk
        ON dimension.dim_territory (territory_name_bk);


/*
    ------------------------------------------------------------------
    Dimension: Store

    Purpose:
        Represents the store dimension used to analyze sales by store, square feet, 
        year opened, number of employees, speciality, and brands.

    Grain:
        One row per store.

    Source:
        Query from the transform schema's store-related tables.
    -----------------------------------------------------------------
*/

-- Check if the table exists and drop it if it does
IF OBJECT_ID('dimension.dim_store', 'U') IS NOT NULL
    DROP TABLE dimension.dim_store;
GO

-- Create the sales.dim_territory table
CREATE TABLE dimension.dim_store
(
-- Main dimension attributes.
    [store_key]                 INT IDENTITY (1, 1)  NOT NULL,   --  
    [store_name]                NVARCHAR (50)        NOT NULL,   --
    [square_feet]               INT                  NOT NULL,   --
    [year_opend]                INT                  NOT NULL,   -- 
    [number_employee]           INT                  NOT NULL,   --
    [specialty]                 NVARCHAR (50)        NOT NULL,   --
    [brands]                    NVARCHAR (50)        NOT NULL,   --

-- System metadata attributes.
    [sys_insert_date]           DATETIME2 (3)        NOT NULL,   -- System metadata: date and time when the record was inserted.
    [sys_update_date]           DATETIME2 (3)            NULL,   -- System metadata: date and time when the record was last updated.
    [sys_delete_date]           DATETIME2 (3)            NULL,   -- System metadata: date and time when the record was deleted or marked for deletion.
    [sys_hash_value]            CHAR (64)            NOT NULL,   -- System metadata: hash value used to detect changes in source attributes.
    [sys_data_source]           NVARCHAR (25)        NOT NULL,   -- System metadata: name of the source system.
    [sys_source_record_id]      NVARCHAR (255)       NOT NULL,   -- System metadata: identifier of the source system or source record.

-- Define constraints.
    CONSTRAINT PK_dim_store
        PRIMARY KEY CLUSTERED (store_key ASC)
);


/*
    ------------------------------------------------------------------
    Dimension: Sales Person

    Purpose:
        Represents the Sales Person dimension used to analyze sales by full name, job title,
        hire date and current employee flag.

    Grain:
        One row per store.

    Source:
        Query from the transform schema's salesperson-related tables.
    -----------------------------------------------------------------
*/

-- Check if the table exists and drop it if it does
IF OBJECT_ID('dimension.dim_salesperson', 'U') IS NOT NULL
    DROP TABLE dimension.dim_salesperson;
GO

-- Create the sales.dim_territory table
CREATE TABLE dimension.dim_salesperson
(
-- Main dimension attributes.
    [salesperson_key]           INT IDENTITY (1, 1)  NOT NULL,   --  
    [national_number_bk]        NVARCHAR (20)        NOT NULL,   --
    [full_name]                 NVARCHAR (50)        NOT NULL,   -- 
    [job_tiltle]                NVARCHAR (50)        NOT NULL,   --
    [hire_date]                 DATE                 NOT NULL,   --
    [is_current_employee]       NVARCHAR (20)        NOT NULL,   -- 'Active' / 'Terminated'

-- System metadata attributes.
    [sys_insert_date]           DATETIME2 (3)        NOT NULL,   -- System metadata: date and time when the record was inserted.
    [sys_update_date]           DATETIME2 (3)            NULL,   -- System metadata: date and time when the record was last updated.
    [sys_delete_date]           DATETIME2 (3)            NULL,   -- System metadata: date and time when the record was deleted or marked for deletion.
    [sys_hash_value]            CHAR (64)            NOT NULL,   -- System metadata: hash value used to detect changes in source attributes.
    [sys_data_source]           NVARCHAR (25)        NOT NULL,   -- System metadata: name of the source system.
    [sys_source_record_id]      NVARCHAR (255)       NOT NULL,   -- System metadata: identifier of the source system or source record.

-- Define constraints.
    CONSTRAINT PK_dim_salesperson
        PRIMARY KEY CLUSTERED (salesperson_key ASC)
);

-- Create a unique non-clustered index on the national_number_bk column 
-- to enforce uniqueness and improve query performance
CREATE UNIQUE NONCLUSTERED INDEX UX_dim_salesperson_national_number_bk
        ON dimension.dim_salesperson (national_number_bk);
