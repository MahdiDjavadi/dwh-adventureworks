/* ----------------------------------------------------------------------------
   01 — STRUCTURE & VOLUME
   ---------------------------------------------------------------------------- */
SELECT *
FROM   INFORMATION_SCHEMA.SCHEMATA;

   -- Check the structure of the Sales.Store table
EXEC sp_help 'Sales.Store';

SELECT -- Check PK/Uniqueness to check grain
    COUNT(*) AS row_count,
    COUNT(DISTINCT BusinessEntityID) AS distinct_business_entity_id,
    COUNT(DISTINCT Name) AS distinct_name
FROM Sales.Store;


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


/* ----------------------------------------------------------------------------
   03 — UNIQUENESS
   ---------------------------------------------------------------------------- */
   -- Check for uniqueness of the BusinessEntityID and Name columns in the Sales.Store table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT BusinessEntityID) AS distinct_business_entity_id
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
HAVING COUNT(*) > 1; -- Name is unique => valid for Business Key candidate