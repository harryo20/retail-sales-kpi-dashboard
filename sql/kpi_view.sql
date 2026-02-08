CREATE OR REPLACE VIEW vw_kpi_monthly AS
WITH base AS (
  SELECT
    DATE_TRUNC('month', invoicedate)::date AS month,
    invoiceno,
    customerid,
    is_return,
    line_revenue
  FROM vw_sales_clean
),
agg AS (
  SELECT
    month,
    SUM(CASE WHEN is_return THEN 0 ELSE line_revenue END) AS total_revenue,
    SUM(CASE WHEN is_return THEN line_revenue ELSE 0 END) AS returns_revenue,
    COUNT(DISTINCT invoiceno) AS orders,
    COUNT(DISTINCT customerid) FILTER (WHERE customerid IS NOT NULL) AS active_customers
  FROM base
  GROUP BY month
),
final AS (
  SELECT
    month,
    total_revenue,
    returns_revenue,
    (total_revenue + returns_revenue) AS net_revenue,
    orders,
    CASE WHEN orders = 0 THEN NULL ELSE total_revenue / orders END AS aov,
    active_customers,
    LAG(total_revenue + returns_revenue) OVER (ORDER BY month) AS prev_month_net_revenue
  FROM agg
)
SELECT
  month,
  total_revenue,
  returns_revenue,
  net_revenue,
  orders,
  aov,
  active_customers,
  CASE
    WHEN prev_month_net_revenue IS NULL OR prev_month_net_revenue = 0 THEN NULL
    ELSE (net_revenue - prev_month_net_revenue) / prev_month_net_revenue
  END AS mom_growth_pct
FROM final
ORDER BY month;
