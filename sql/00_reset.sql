/* RESET PIPELINE */ 
DROP TABLE IF EXISTS
  fact_sales,
  fact_budget,
  dim_date,
  dim_customer,
  dim_product,
  dim_region,
  stg_sales_orders,
  stg_customers,
  stg_products,
  stg_budgets,
  stg_regions,
  stg_state_regions
CASCADE;