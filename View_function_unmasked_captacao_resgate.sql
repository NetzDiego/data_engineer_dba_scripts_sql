CREATE MATERIALIZED VIEW IF NOT EXISTS interno.unmasked_consolidado_captacao_resgate
TABLESPACE pg_default
AS
 SELECT us.cod_carteira AS clientid,
    COALESCE(
        CASE
            WHEN uca.tipo_dia::text = 'Dia Util'::text THEN us.data_captacao
            ELSE ( SELECT min(c.data) AS min
               FROM unmasked_calendario_anbima c
              WHERE c.data > us.data_captacao AND c.tipo_dia::text = 'Dia Util'::text)
        END, us.data_captacao) AS data_ajustada,
        CASE
            WHEN us.captacao >= 0::numeric THEN 'Captacao'::text
            WHEN us.captacao < 0::numeric THEN 'Resgate'::text
            ELSE 'A validar'::text
        END AS "movementType",
    us.tipo_lancamento AS "subType",
    us.ativo AS assetid,
    us.captacao AS value,
    us.data_extracao,
    us.mercado AS ativo,
    'BTG'::text AS custodiante,
    (us.cod_carteira::text || '-'::text) || 'BTG'::text AS chave
   FROM unmasked_stvm us
     LEFT JOIN unmasked_calendario_anbima uca ON us.data_captacao = uca.data
UNION ALL
 SELECT unmasked_captacao_resgate."clientId"::text AS clientid,
    unmasked_captacao_resgate."effectiveDate" AS data_ajustada,
    unmasked_captacao_resgate."movementType",
    unmasked_captacao_resgate."subType",
    unmasked_captacao_resgate."assetId" AS assetid,
    unmasked_captacao_resgate.value,
    unmasked_captacao_resgate.data_extracao,
    unmasked_captacao_resgate."Ativo" AS ativo,
    'XP'::text AS custodiante,
    (unmasked_captacao_resgate."clientId" || '-'::text) || 'XP'::text AS chave
   FROM unmasked_captacao_resgate;


------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION interno.atualiza_view_unmasked_captacao_resgate(
	)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
BEGIN
  PERFORM dblink_exec(
    'host=netz-database-server.postgres.database.azure.com dbname=spec user=netz_admin password=producao@3204!# sslmode=require',
    'REFRESH MATERIALIZED VIEW interno.unmasked_consolidado_captacao_resgate;'
  );
  RETURN 'View atualizada com sucesso!';
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'Erro ao atualizar a view: ' || SQLERRM;
END;
$BODY$;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT  *  FROM  interno.atualiza_view_unmasked_captacao_resgate()






