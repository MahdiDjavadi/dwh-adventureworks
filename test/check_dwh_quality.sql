-- =========================================================
-- Test: Check DWH Quality, StoreID in SalesOrderHeader and Customer
-- =========================================================

SELECT h.OnlineOrderFlag,
       SUM(CASE WHEN c.StoreID IS NULL     THEN 1 ELSE 0 END) AS no_store,
       SUM(CASE WHEN c.StoreID IS NOT NULL THEN 1 ELSE 0 END) AS has_store
FROM Sales.SalesOrderDetail d
JOIN Sales.SalesOrderHeader h ON h.SalesOrderID = d.SalesOrderID
JOIN Sales.Customer c ON c.CustomerID = h.CustomerID
GROUP BY h.OnlineOrderFlag;
/*
Result Set Batch 1 - Query 1
========================================

OnlineOrderFlag  no_store    has_store 
---------------  ----------  ----------
0                0           60919     
1                60391       7         
(2 rows affected)
*/



-- =========================================================
-- Test: Check DWH Quality, Orphan Records in Fact Table
-- =========================================================

SELECT
  SUM(CASE WHEN c.customer_key     IS NULL THEN 1 ELSE 0 END) AS orphan_customer,
  SUM(CASE WHEN p.product_key      IS NULL THEN 1 ELSE 0 END) AS orphan_product,
  SUM(CASE WHEN t.territory_key    IS NULL THEN 1 ELSE 0 END) AS orphan_territory,
  SUM(CASE WHEN s.store_key        IS NULL THEN 1 ELSE 0 END) AS orphan_store,
  SUM(CASE WHEN sp.salesperson_key IS NULL THEN 1 ELSE 0 END) AS orphan_salesperson,
  SUM(CASE WHEN d.date_key         IS NULL THEN 1 ELSE 0 END) AS orphan_date
FROM fact.fact_sales f
LEFT JOIN dimension.dim_customer    c  ON c.customer_key     = f.customer_key
LEFT JOIN dimension.dim_product     p  ON p.product_key      = f.product_key
LEFT JOIN dimension.dim_territory   t  ON t.territory_key    = f.territory_key
LEFT JOIN dimension.dim_store       s  ON s.store_key        = f.store_key
LEFT JOIN dimension.dim_salesperson sp ON sp.salesperson_key = f.salesperson_key
LEFT JOIN dimension.dim_date        d  ON d.date_key         = f.date_key;
/*
Result Set Batch 1 - Query 1
========================================

orphan_customer  orphan_product  orphan_territory  orphan_store  orphan_salesperson  orphan_date
---------------  --------------  ----------------  ------------  ------------------  -----------
0                0               0                 0             0                   0          
(1 row affected)
*/


-- =========================================================
-- Test: Check DWH Quality, Negative Order Quantity in Fact Table
-- =========================================================

SELECT
  f.sales_order_key AS primary_key,
  f.sales_order_id AS sales_order_nk,
  f.order_quantity AS order_quantity
FROM fact.fact_sales f
WHERE f.order_quantity < 0;
/*
Result Set Batch 1 - Query 1
========================================

primary_key  sales_order_nk  order_quantity
-----------  --------------  --------------
(0 rows affected)
*/

-- ========================================================
-- Test: Check DWH Quality, Negative Unit Price in Fact Table
-- ========================================================

SELECT
  f.sales_order_key AS primary_key,
  f.sales_order_id AS sales_order_nk,
  f.unit_price AS unit_price
FROM fact.fact_sales f
WHERE f.unit_price < 0;
/*
Result Set Batch 1 - Query 1
========================================

primary_key  sales_order_nk  unit_price
-----------  --------------  ----------
(0 rows affected)
*/


-- ========================================================
-- Test: Unit Price Discount is greater than Unit Price in Fact Table
-- ========================================================

SELECT
  f.sales_order_key AS primary_key,
  f.sales_order_id AS sales_order_nk,
  f.unit_price AS unit_price,
  f.unit_price_discount AS unit_price_discount
FROM fact.fact_sales f
WHERE f.unit_price_discount > f.unit_price;
/*
Result Set Batch 1 - Query 1
========================================

primary_key  sales_order_nk  unit_price  unit_price_discount
-----------  --------------  ----------  -------------------
(0 rows affected)
*/

-- ========================================================
-- Test: Check DWH Quality, Foreign Key Relationships
-- This test checks whether the foreign key relationships between the fact and dimension tables are valid.
-- ========================================================

-- 1. Which physical foreign keys actually exist?
SELECT
    fk.name AS foreign_key_name,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS referencing_schema,
    OBJECT_NAME(fk.parent_object_id) AS referencing_table,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id)
        AS referencing_column,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) AS referenced_schema,
    OBJECT_NAME(fk.referenced_object_id) AS referenced_table,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id)
        AS referenced_column
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY referencing_table, foreign_key_name;
GO
/*
Result Set Batch 2 - Query 1
========================================

foreign_key_name  referencing_schema  referencing_table  referencing_column  referenced_schema  referenced_table  referenced_column
----------------  ------------------  -----------------  ------------------  -----------------  ----------------  -----------------
(0 rows affected)
*/


-- ========================================================
-- Test: Check DWH Quality, Fact to Dimension Relationships
-- This test checks whether the foreign key relationships between the fact and dimension tables are valid.
-- ========================================================

-- 2. Check whether fact keys match their dimensions.
SELECT
    'customer_key' AS relationship,
    COUNT_BIG(*) AS unmatched_rows
FROM fact.fact_sales AS f
LEFT JOIN dimension.dim_customer AS d
    ON f.customer_key = d.customer_key
WHERE d.customer_key IS NULL

UNION ALL

SELECT
    'product_key',
    COUNT_BIG(*)
FROM fact.fact_sales AS f
LEFT JOIN dimension.dim_product AS d
    ON f.product_key = d.product_key
WHERE d.product_key IS NULL

UNION ALL

SELECT
    'store_key',
    COUNT_BIG(*)
FROM fact.fact_sales AS f
LEFT JOIN dimension.dim_store AS d
    ON f.store_key = d.store_key
WHERE d.store_key IS NULL

UNION ALL

SELECT
    'salesperson_key',
    COUNT_BIG(*)
FROM fact.fact_sales AS f
LEFT JOIN dimension.dim_salesperson AS d
    ON f.salesperson_key = d.salesperson_key
WHERE d.salesperson_key IS NULL

UNION ALL

SELECT
    'territory_key',
    COUNT_BIG(*)
FROM fact.fact_sales AS f
LEFT JOIN dimension.dim_territory AS d
    ON f.territory_key = d.territory_key
WHERE d.territory_key IS NULL

UNION ALL

SELECT
    'date_key',
    COUNT_BIG(*)
FROM fact.fact_sales AS f
LEFT JOIN dimension.dim_date AS d
    ON f.date_key = d.date_key
WHERE d.date_key IS NULL;
GO
/*
-----------------------------------
relationship	    | unmatched_rows
------------------|----------------
customer_key	    |     0
product_key	      |     0
store_key	        |     0
salesperson_key	  |     0
territory_key	    |     0
date_key	        |     0
*/


-- ========================================================
-- Test: Check DWH Quality, Duplicate Keys in Dimension Tables
-- This test checks whether there are any duplicate keys in the dimension tables.
-- ========================================================
SELECT
    'dim_customer' AS dimension_table,
    COUNT_BIG(*) AS duplicate_keys
FROM (
    SELECT customer_key
    FROM dimension.dim_customer
    GROUP BY customer_key
    HAVING COUNT_BIG(*) > 1
) AS d

UNION ALL

SELECT
    'dim_product',
    COUNT_BIG(*)
FROM (
    SELECT product_key
    FROM dimension.dim_product
    GROUP BY product_key
    HAVING COUNT_BIG(*) > 1
) AS d

UNION ALL

SELECT
    'dim_store',
    COUNT_BIG(*)
FROM (
    SELECT store_key
    FROM dimension.dim_store
    GROUP BY store_key
    HAVING COUNT_BIG(*) > 1
) AS d

UNION ALL

SELECT
    'dim_salesperson',
    COUNT_BIG(*)
FROM (
    SELECT salesperson_key
    FROM dimension.dim_salesperson
    GROUP BY salesperson_key
    HAVING COUNT_BIG(*) > 1
) AS d

UNION ALL

SELECT
    'dim_territory',
    COUNT_BIG(*)
FROM (
    SELECT territory_key
    FROM dimension.dim_territory
    GROUP BY territory_key
    HAVING COUNT_BIG(*) > 1
) AS d

UNION ALL

SELECT
    'dim_date',
    COUNT_BIG(*)
FROM (
    SELECT date_key
    FROM dimension.dim_date
    GROUP BY date_key
    HAVING COUNT_BIG(*) > 1
) AS d;
GO

/*
----------------------------------
dimension_table	  | duplicate_keys
----------------------------------
dim_customer	    |     0
dim_product	      |     0
dim_store	        |     0
dim_salesperson	  |     0
dim_territory	    |     0
dim_date	        |     0
(6 rows affected)
*/