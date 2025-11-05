-- 1. Listar todas as bases de dados com seus tamanhos
SELECT
  d.datname AS database_name,
  pg_size_pretty(pg_database_size(d.datname)) AS database_size
FROM pg_database d
WHERE d.datistemplate = false
ORDER BY pg_database_size(d.datname) DESC;

-- 2. Dentro de cada base, listar tamanho das tabelas e uso
-- Este bloco deve ser executado dentro de cada base individualmente
CREATE SCHEMA auditoria

CREATE    TABLE  auditoria.saude_bd ( 
id            		   int  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
data_base              VARCHAR(50),
schema_name            VARCHAR(50),
table_name             VARCHAR(50),
total_size             VARCHAR(30),
total_reads            BIGINT,
total_writes,           BIGINT,
last_vacuum            TIMESTAMP,
last_analyse           TIMESTAMP,
status                 INT  DEFAULT 1)


SELECT  * FROM  auditoria.saude_bd_postgres


--INSERT   INTO  auditoria.saude_bd_postgres (data_base,schema_name,table_name,total_size,total_reads,total_writes,last_vacuum,last_analyse,status)
SELECT
  'bronze' AS data_base,
  schemaname,relname AS table_name,
  pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
  seq_scan + idx_scan AS total_reads,
  n_tup_ins + n_tup_upd + n_tup_del AS total_writes,
  last_vacuum, last_analyze,1
FROM pg_stat_user_tables
ORDER BY schemaname,total_reads DESC;




