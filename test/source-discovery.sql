/* ----------------------------------------------------------------------------
   01 — STRUCTURE & VOLUME
   ---------------------------------------------------------------------------- */
SELECT *
FROM   INFORMATION_SCHEMA.SCHEMATA;

-- Check Sales Order Detail PK's
SELECT -- Check PK/Uniqueness to check grain
    COUNT(*) AS row_count,
    COUNT(DISTINCT SalesOrderID) AS distinct_sales_order_header_id,
    COUNT(DISTINCT SalesOrderDetailID) AS distinct_sales_order_detial_id
FROM Sales.SalesOrderDetail;

   -- Check the structure of the Sales.Store table
EXEC sp_help 'Sales.Store';

SELECT -- Check PK/Uniqueness to check grain
    COUNT(*) AS row_count,
    COUNT(DISTINCT BusinessEntityID) AS distinct_business_entity_id,
    COUNT(DISTINCT Name) AS distinct_name
FROM Sales.Store;

   -- Check the structure of the Sales.SalesPerson table
SELECT TOP (1000) * FROM Sales.SalesPerson;

EXEC sp_help 'Sales.SalesPerson';

SELECT -- Check PK/Uniqueness to check grain
    COUNT(*) AS row_count,
    COUNT(DISTINCT BusinessEntityID) AS distinct_business_entity_id
FROM Sales.SalesPerson;

   -- Check the structure of the HumanResources.Employee table
EXEC sp_help 'HumanResources.Employee';

SELECT -- Check PK/Uniqueness to check grain
    COUNT(*) AS row_count,
    COUNT(DISTINCT BusinessEntityID) AS distinct_id,
    COUNT(DISTINCT NationalIDNumber) AS distinct_business_key
FROM HumanResources.Employee;

SELECT TOP (1000) * FROM HumanResources.Employee;

/* ----------------------------------------------------------------------------
   02 — NULL PROFILING
   ---------------------------------------------------------------------------- */
   -- Check for Nullls in the Sales.Store table for key columns
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN BusinessEntityID IS NULL THEN 1 ELSE 0 END) AS null_business_entity_id,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS null_name,
    SUM(CASE WHEN SalesPersonID IS NULL THEN 1 ELSE 0 END) AS null_sales_person_id,
    SUM((case when Demographics IS NULL THEN 1 ELSE 0 END)) AS null_demographics
FROM Sales.Store;

   -- Check for Nullls in the Sales.SalesTerritory table for key columns
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TerritoryID IS NULL THEN 1 ELSE 0 END) AS null_territory_id,
    SUM(CASE WHEN [Name] IS NULL THEN 1 ELSE 0 END) AS null_name,
    SUM(CASE WHEN CountryRegionCode IS NULL THEN 1 ELSE 0 END) AS null_country_region_code,
    SUM(CASE WHEN [Group] IS NULL THEN 1 ELSE 0 END) AS null_group
FROM Sales.SalesTerritory;

   -- Check for Nullls in the HumanResources.Employee table for key columns
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN JobTitle IS NULL THEN 1 ELSE 0 END) AS null_job_title,
    SUM(CASE WHEN HireDate IS NULL THEN 1 ELSE 0 END) AS null_hire_date,
    SUM(CASE WHEN CurrentFlag IS NULL THEN 1 ELSE 0 END) AS null_current_flag
FROM HumanResources.Employee;

   -- Check for Nullls in the Sales.SalesOrderHeader table for key columns
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN SalesOrderID IS NULL THEN 1 ELSE 0 END) AS null_sales_order_id,
    SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN OnlineOrderFlag IS NULL THEN 1 ELSE 0 END) AS null_online_order_flag,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN SalesPersonID IS NULL THEN 1 ELSE 0 END) AS null_sales_person_id, -- Have a Null Value for Online Sales
    SUM(CASE WHEN TerritoryID IS NULL THEN 1 ELSE 0 END) AS null_territory_id
FROM Sales.SalesOrderHeader;

   -- Check for Nullls in the Sales.SalesOrderDetail table for key columns
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN SalesOrderDetailID IS NULL THEN 1 ELSE 0 END) AS null_sales_order_detail_id,
    SUM(CASE WHEN SalesOrderID IS NULL THEN 1 ELSE 0 END) AS null_sales_order_id,
    SUM(CASE WHEN OrderQty IS NULL THEN 1 ELSE 0 END) AS null_order_qty,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS null_unit_price,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN UnitPriceDiscount IS NULL THEN 1 ELSE 0 END) AS null_unit_price_discount
FROM Sales.SalesOrderDetail;


/* ----------------------------------------------------------------------------
   03 — UNIQUENESS
   ---------------------------------------------------------------------------- */
   -- Check for uniqueness of the BusinessEntityID and Name columns in the Sales.Store table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT BusinessEntityID) AS distinct_business_entity_id
FROM Sales.Store;

SELECT COUNT(*) AS TotalStores,
       COUNT(Demographics) AS StoresWithDemographics
FROM Sales.Store;

SELECT
    Name,
    COUNT(*) AS row_count
FROM Sales.Store
GROUP BY Name
HAVING COUNT(*) > 1; -- Name is not unique => not a valid Business Key candidate

select *
from Sales.Store
where Name in (
    select Name
    from Sales.Store
    group by Name
    having count(*) > 1
)

   -- Check for uniqueness of the TerritoryID and Name columns in the Sales.SalesTerritory table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT TerritoryID) AS distinct_territory_id
FROM Sales.SalesTerritory;

SELECT
    Name,
    COUNT(*) AS row_count
FROM Sales.SalesTerritory
GROUP BY Name
HAVING COUNT(*) > 1; -- Name is unique => Business Key candidate

   -- Check for uniqueness of the BusinessEntityID and NationalIDNumber columns in the HumanResources.Employee table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT BusinessEntityID) AS distinct_primary_key,
    COUNT(DISTINCT NationalIDNumber) AS distinct_business_key
FROM HumanResources.Employee;

SELECT
    NationalIDNumber,
    COUNT(*) AS row_count
FROM HumanResources.Employee
GROUP BY NationalIDNumber
HAVING COUNT(*) > 1; -- Name is unique => Business Key candidate

SELECT name FROM sys.indexes
WHERE object_id = OBJECT_ID('Sales.Product') OR object_id = OBJECT_ID('Production.Product')
  AND is_unique = 1;


-- Check for uniqueness of the primary key in the Sales.SalesOrderDetail table
SELECT name, is_unique, is_primary_key
FROM sys.indexes
WHERE object_id = OBJECT_ID('Sales.SalesOrderDetail') AND is_primary_key = 1;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT SalesOrderID) AS distinct_sales_order_id
FROM Sales.SalesOrderHeader;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT SalesOrderDetailID) AS distinct_sales_order_detail_id
FROM Sales.SalesOrderDetail;


SELECT COLUMN_NAME, DATA_TYPE, NUMERIC_PRECISION, NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales' AND TABLE_NAME = 'SalesOrderDetail'
  AND DATA_TYPE IN ('numeric', 'money');