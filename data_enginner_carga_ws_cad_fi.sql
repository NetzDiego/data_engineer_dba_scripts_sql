-- PROCEDURE: interno.sp_verificar_etl_ws_cad_fi()

-- DROP PROCEDURE IF EXISTS interno.sp_verificar_etl_ws_cad_fi();

CREATE OR REPLACE PROCEDURE interno.sp_verificar_etl_ws_cad_fi(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    total_registros INTEGER;
    dados_coletados BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO total_registros
    FROM  interno.unmasked_ws_cad_fi
    WHERE data_extracao = CURRENT_DATE;

    dados_coletados := total_registros > 0;

    INSERT INTO logs_azure.unmasked_log_monitoramento_azure_function (tabela, existe_dado, mensagem, linhas_inseridas)
    VALUES (
	    'unmasked_ws_cad_fi',
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
ALTER PROCEDURE interno.sp_verificar_etl_ws_cad_fi()
    OWNER TO netz_admin;
