/* LOAD CSV */
COPY stg_budgets FROM '/csv/Budgets.csv' WITH (FORMAT csv, HEADER true);
COPY stg_customers FROM '/csv/Customers.csv' WITH (FORMAT csv, HEADER true);
COPY stg_products FROM '/csv/Products.csv' WITH (FORMAT csv, HEADER true);
COPY stg_regions FROM '/csv/Regions.csv' WITH (FORMAT csv, HEADER true);
COPY stg_state_regions FROM '/csv/State_Regions.csv' WITH (FORMAT csv, HEADER true);
COPY stg_sales_orders FROM '/csv/Sales_Orders.csv' WITH (FORMAT csv, HEADER true);