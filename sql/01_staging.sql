/* STAGING TABLES */
CREATE TABLE stg_sales_orders (
  order_number TEXT,
  order_date DATE,
  customer_name_index INT,
  channel TEXT,
  currency_code TEXT,
  warehouse_code TEXT,
  delivery_region_index INT,
  product_description_index INT,
  order_quantity INT,
  unit_price NUMERIC,
  line_total NUMERIC,
  total_unit_cost NUMERIC
);

CREATE TABLE stg_customers (
  customer_index INT,
  customer_name TEXT
);

CREATE TABLE stg_products (
  product_index INT,
  product_name TEXT
);

CREATE TABLE stg_budgets (
  product_name TEXT,
  budgets NUMERIC
);

CREATE TABLE stg_regions (
  id INT,
  name TEXT,
  county TEXT,
  state_code TEXT,
  state TEXT,
  type TEXT,
  latitude NUMERIC,
  longitude NUMERIC,
  area_code TEXT,
  population BIGINT,
  households BIGINT,
  median_income BIGINT,
  land_area BIGINT,
  water_area BIGINT,
  time_zone TEXT
);

CREATE TABLE stg_state_regions (
  state_code TEXT,
  state TEXT,
  region TEXT
);