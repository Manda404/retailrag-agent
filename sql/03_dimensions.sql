/* DIMENSIONS */
CREATE TABLE dim_date (
  date_key INT PRIMARY KEY,
  full_date DATE UNIQUE,
  year INT,
  month INT,
  day INT
);

INSERT INTO dim_date
SELECT DISTINCT
  EXTRACT(YEAR FROM order_date)::int * 10000 +
  EXTRACT(MONTH FROM order_date)::int * 100 +
  EXTRACT(DAY FROM order_date)::int,
  order_date,
  EXTRACT(YEAR FROM order_date)::int,
  EXTRACT(MONTH FROM order_date)::int,
  EXTRACT(DAY FROM order_date)::int
FROM stg_sales_orders;

CREATE TABLE dim_customer (
  customer_id INT PRIMARY KEY,
  customer_name TEXT
);

INSERT INTO dim_customer
SELECT DISTINCT customer_index, customer_name
FROM stg_customers;

CREATE TABLE dim_product (
  product_id INT PRIMARY KEY,
  product_name TEXT
);

INSERT INTO dim_product
SELECT DISTINCT product_index, product_name
FROM stg_products;

CREATE TABLE dim_region (
  region_id INT PRIMARY KEY,
  city_name TEXT,
  state_code TEXT,
  state TEXT,
  macro_region TEXT,
  latitude NUMERIC,
  longitude NUMERIC,
  population BIGINT,
  median_income BIGINT
);

INSERT INTO dim_region
SELECT
  r.id,
  r.name,
  r.state_code,
  r.state,
  sr.region,
  r.latitude,
  r.longitude,
  r.population,
  r.median_income
FROM stg_regions r
LEFT JOIN stg_state_regions sr
  ON r.state_code = sr.state_code;