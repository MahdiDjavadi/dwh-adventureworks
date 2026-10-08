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