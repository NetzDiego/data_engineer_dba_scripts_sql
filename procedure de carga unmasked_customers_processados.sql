-- View: xp.vw_unmasked_customers_processados_consolidado

-- DROP VIEW xp.vw_unmasked_customers_processados_consolidado;

CREATE OR REPLACE VIEW xp.vw_unmasked_customers_processados_consolidado
 AS
 WITH bronze AS (
         SELECT unmasked_customers_processados_bronze.customers_id
           FROM xp.unmasked_customers_processados_bronze
        ), bronze_count AS (
         SELECT bronze.customers_id,
            count(*) AS total_bronze
           FROM bronze
          GROUP BY bronze.customers_id
        ), silver AS (
         SELECT unmasked_customers_processados.customers_id
           FROM xp.unmasked_customers_processados
        ), silver_count AS (
         SELECT silver.customers_id,
            count(*) AS total_silver
           FROM silver
          GROUP BY silver.customers_id
        )
 SELECT COALESCE(b.customers_id, s.customers_id) AS customers_id,
    b.total_bronze,
    s.total_silver,
    COALESCE(s.total_silver, 0::bigint) - COALESCE(b.total_bronze, 0::bigint) AS diferenca,
        CASE
            WHEN COALESCE(b.total_bronze, 0::bigint) <> COALESCE(s.total_silver, 0::bigint) THEN 'diferente'::text
            ELSE 'consolidado'::text
        END AS conciliacao_entre_bronze_silver
   FROM bronze_count b
     FULL JOIN silver_count s ON s.customers_id = b.customers_id
  ORDER BY (COALESCE(s.total_silver, 0::bigint) - COALESCE(b.total_bronze, 0::bigint)) DESC, (COALESCE(b.customers_id, s.customers_id));

ALTER TABLE xp.vw_unmasked_customers_processados_consolidado
    OWNER TO dba;

