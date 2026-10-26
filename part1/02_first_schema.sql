CREATE SCHEMA IF NOT EXISTS basics;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- query

SELECT schema_name
FROM information_schema_schemata
ORDER BY schema_name;