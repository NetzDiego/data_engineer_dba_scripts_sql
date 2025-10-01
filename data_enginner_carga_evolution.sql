-- PROCEDURE: xp.sp_verificar_etl_xp_api_evolution()

-- DROP PROCEDURE IF EXISTS xp.sp_verificar_etl_xp_api_evolution();

CREATE OR REPLACE PROCEDURE xp.sp_verificar_etl_xp_api_evolution(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    total_registros INTEGER;
    dados_coletados BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO total_registros
    FROM  xp.unmasked_evolution
    WHERE data_extracao = CURRENT_DATE;

    dados_coletados := total_registros > 0;

    INSERT INTO logs_azure.unmasked_log_monitoramento_azure_function  (tabela, existe_dado, mensagem, linhas_inseridas)
    VALUES (
	    'unmasked_evolution',
        dados_coletados,
        CASE 
            WHEN dados_coletados   
            THEN 'Dados inseridos com sucesso no dia ' || CURRENT_DATE
            ELSE 'Dados NÃO inseridos no dia ' || CURRENT_DATE
        END,
		total_registros
    );
END;
$BODY$;
ALTER PROCEDURE xp.sp_verificar_etl_xp_api_evolution()
    OWNER TO netz_admin;
