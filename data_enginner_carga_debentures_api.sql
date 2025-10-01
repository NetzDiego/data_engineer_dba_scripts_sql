-- PROCEDURE: btg.sp_verificar_etl_btg_api_debentures()

-- DROP PROCEDURE IF EXISTS btg.sp_verificar_etl_btg_api_debentures();

CREATE OR REPLACE PROCEDURE btg.sp_verificar_etl_btg_api_debentures(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    total_registros INTEGER;
    dados_coletados BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO total_registros
    FROM  btg.unmasked_debentures
    WHERE extraction_date = CURRENT_DATE;

    dados_coletados := total_registros > 0;

    INSERT INTO logs_azure.unmasked_log_monitoramento_azure_function (tabela, existe_dado, mensagem, linhas_inseridas)
    VALUES (
	    'unmasked_debentures',
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
ALTER PROCEDURE btg.sp_verificar_etl_btg_api_debentures()
    OWNER TO netz_admin;
