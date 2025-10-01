-- PROCEDURE: bacen.sp_verificar_etl_unmasked_cdi()

-- DROP PROCEDURE IF EXISTS bacen.sp_verificar_etl_unmasked_cdi();

CREATE OR REPLACE PROCEDURE bacen.sp_verificar_etl_unmasked_ipca(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    total_registros INTEGER;
    dados_coletados BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO total_registros
    FROM  bacen.unmasked_ipca 
    WHERE data_extracao = CURRENT_DATE;

    dados_coletados := total_registros > 0;

    INSERT INTO logs_azure.unmasked_log_monitoramento_Azure_Function (tabela, existe_dado, mensagem, linhas_inseridas)
    VALUES (
        'unmasked_ipca',
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
