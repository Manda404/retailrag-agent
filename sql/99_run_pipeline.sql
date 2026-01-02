/* ============================================================================
99_run_pipeline.sql
OBJECTIF
- Orchestrateur du pipeline Data Warehouse
- Afficher clairement chaque étape dans le terminal (logs lisibles)
============================================================================ */

\echo '============================================================'
\echo 'DEBUT DU PIPELINE DATA WAREHOUSE'
\echo '============================================================'

\echo ''
\echo '[1/5] RESET DES TABLES'
\echo '------------------------------------------------------------'
\i sql/00_reset.sql

\echo ''
\echo '[2/5] CREATION DES TABLES DE STAGING'
\echo '------------------------------------------------------------'
\i sql/01_staging.sql

\echo ''
\echo '[3/5] CHARGEMENT DES FICHIERS CSV'
\echo '------------------------------------------------------------'
\i sql/02_load_csv.sql

\echo ''
\echo '[4/5] CONSTRUCTION DES DIMENSIONS'
\echo '------------------------------------------------------------'
\i sql/03_dimensions.sql

\echo ''
\echo '[5/5] CONSTRUCTION DES TABLES DE FAITS'
\echo '------------------------------------------------------------'
\i sql/04_facts.sql

\echo ''
\echo '============================================================'
\echo 'FIN DU PIPELINE DATA WAREHOUSE'
\echo '============================================================'