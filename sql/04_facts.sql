/*
===============================================================================
04_facts.sql
===============================================================================
OBJECTIF
--------
Construire les TABLES DE FAITS du Data Warehouse.

PRINCIPE FONDAMENTAL
-------------------
- Une table de faits DOIT avoir un grain clair, stable et documenté.
- Ici, le grain de fact_sales est :

    1 ligne = 1 PRODUIT dans 1 COMMANDE

CONSTAT SUR LA DONNÉE SOURCE
---------------------------
- Le fichier Sales_Orders.csv contient des doublons métier :
    (order_number, product_id) apparaît plusieurs fois
- Ces doublons peuvent varier sur d'autres attributs (channel, région, etc.)

DÉCISION DE MODÉLISATION
-----------------------
- Le grain cible est (order_number, product_id)
- Toute information non déterminante à ce grain est stabilisée (MIN)
- Les mesures sont AGRÉGÉES (SUM)

La contrainte UNIQUE sert de filet de sécurité métier.
===============================================================================
*/

-- ============================================================================
-- FACT SALES
-- ============================================================================
CREATE TABLE fact_sales (
  sales_id SERIAL PRIMARY KEY,          -- Clé technique (surrogate key)
  order_number TEXT NOT NULL,           -- Clé métier (non unique seule)
  date_key INT REFERENCES dim_date(date_key),
  customer_id INT REFERENCES dim_customer(customer_id),
  product_id INT REFERENCES dim_product(product_id),
  region_id INT REFERENCES dim_region(region_id),
  channel TEXT,
  currency_code TEXT,

  -- Mesures transactionnelles
  order_quantity INT,
  line_total NUMERIC,
  total_unit_cost NUMERIC,

  -- Mesure dérivée (calculée à l’ETL)
  margin_amount NUMERIC
);

-- ---------------------------------------------------------------------------
-- Contrainte métier
-- 1 produit ne doit apparaître qu'une seule fois par commande
-- ---------------------------------------------------------------------------
ALTER TABLE fact_sales
ADD CONSTRAINT uq_order_product UNIQUE (order_number, product_id);

-- ---------------------------------------------------------------------------
-- Chargement de fact_sales
-- IMPORTANT :
-- - Le GROUP BY DOIT correspondre EXACTEMENT au grain cible
-- - Les autres attributs sont stabilisés (MIN)
-- ---------------------------------------------------------------------------
INSERT INTO fact_sales (
  order_number,
  date_key,
  customer_id,
  product_id,
  region_id,
  channel,
  currency_code,
  order_quantity,
  line_total,
  total_unit_cost,
  margin_amount
)
SELECT
  s.order_number,

  -- Date stabilisée (une commande a une seule date logique)
  EXTRACT(YEAR FROM MIN(s.order_date))::int * 10000 +
  EXTRACT(MONTH FROM MIN(s.order_date))::int * 100 +
  EXTRACT(DAY FROM MIN(s.order_date))::int        AS date_key,

  -- Dimensions stabilisées
  MIN(s.customer_name_index)       AS customer_id,
  s.product_description_index      AS product_id,
  MIN(s.delivery_region_index)     AS region_id,
  MIN(s.channel)                   AS channel,
  MIN(s.currency_code)             AS currency_code,

  -- Mesures agrégées
  SUM(s.order_quantity)            AS order_quantity,
  SUM(s.line_total)                AS line_total,
  SUM(s.total_unit_cost)           AS total_unit_cost,

  -- Mesure dérivée
  SUM(s.line_total - s.total_unit_cost) AS margin_amount
FROM stg_sales_orders s
GROUP BY
  s.order_number,
  s.product_description_index;

-- ============================================================================
-- FACT BUDGET
-- ============================================================================
/*
OBJECTIF
--------
Stocker les objectifs budgétaires par produit.

REMARQUE
--------
- Les budgets ne sont pas transactionnels
- Pas de dimension temps disponible dans la source
- Il s’agit donc d’une FACT DE RÉFÉRENCE (snapshot global)
*/
CREATE TABLE fact_budget (
  product_id INT REFERENCES dim_product(product_id),
  budget NUMERIC
);

INSERT INTO fact_budget
SELECT
  dp.product_id,
  b.budgets AS budget
FROM stg_budgets b
JOIN dim_product dp
  ON dp.product_name = b.product_name;