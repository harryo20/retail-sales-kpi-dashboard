CREATE OR REPLACE VIEW vw_sales_clean AS
SELECT
  invoiceno,
  stockcode,
  description,
  quantity,
  unitprice,
  customerid,
  country,
  invoicedate_ts AS invoicedate,
  (quantity < 0) AS is_return,
  (quantity * unitprice) AS line_revenue
FROM vw_sales_typed
WHERE invoicedate_ts IS NOT NULL
  AND quantity IS NOT NULL
  AND unitprice IS NOT NULL
  AND unitprice > 0;
