CREATE   VIEW  auditoria.vw_auditoria_login  
AS
SELECT 
    s.userid  AS id_user,
    r.rolname AS user_name,
    s.dbid    AS id_bd,
    d.datname AS database_name,
    m.schema_array[1] AS schema_name,  -- acessando o primeiro elemento do array
    s.query,
    s.calls   AS qtde_execucoes,
    s.rows    AS qtde_linhas_retornada
FROM  pg_stat_statements s
INNER JOIN pg_database d ON s.dbid = d.oid
INNER JOIN  pg_roles r ON s.userid = r.oid
CROSS JOIN LATERAL regexp_matches(s.query, 'FROM\s+([a-zA-Z0-9_]+)\.') AS m(schema_array)
WHERE r.rolname IN ('jaime_souza')
AND m.schema_array[1] <> 'pg_catalog';