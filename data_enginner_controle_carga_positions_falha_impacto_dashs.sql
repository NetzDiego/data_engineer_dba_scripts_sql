-- PROCEDURE: interno.sp_controle_falhas_carga_xp_api_positions()

-- DROP PROCEDURE IF EXISTS interno.sp_controle_falhas_carga_xp_api_positions();

CREATE OR REPLACE PROCEDURE interno.sp_controle_falhas_carga_xp_api_positions(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    total_registros INTEGER;
	data_comparacao DATE;
	dias_uteis        VARCHAR(50);
BEGIN
    SELECT COUNT(*) INTO total_registros
    FROM  xp.unmasked_positions
    WHERE data_extracao = CURRENT_DATE;

	SELECT  dados_do_dia  INTO  data_comparacao FROM interno.unmasked_relatorio_azure_functions_etl  WHERE  carregado_dia = CURRENT_DATE  AND nm_tabela = 'unmasked_positions' AND linhas_inseridas = 0;

    SELECT  tipo_dia  INTO  dias_uteis FROM interno.unmasked_calendario_anbima  WHERE  data = data_comparacao;
    
	IF  total_registros = 0  AND dias_uteis IN ('Dia Util') THEN

	INSERT  INTO xp.unmasked_xp_controle_processos (id_tab,tab_segundaria,id_dash)
	SELECT 3 AS id_tab,tablename,1  AS id_dash1
    FROM   pg_catalog.pg_tables
    WHERE  schemaname = 'xp'
    AND    tablename LIKE '%dp%' 
	OR     tablename LIKE '%hp%'
	UNION
	SELECT 3 AS id_tab,tablename,2  AS id_dash2
    FROM   pg_catalog.pg_tables
    WHERE  schemaname = 'xp'
    AND    tablename LIKE '%dp%' 
	OR     tablename LIKE '%hp%' 
	UNION
	SELECT 3 AS id_tab,tablename,3  AS  id_dash3
    FROM   pg_catalog.pg_tables
    WHERE  schemaname = 'xp'
    AND    tablename LIKE '%dp%' 
	OR     tablename LIKE '%hp%'
	ORDER BY 3; 

	END IF;

END;
$BODY$;
ALTER PROCEDURE interno.sp_controle_falhas_carga_xp_api_positions()
    OWNER TO netz_admin;
