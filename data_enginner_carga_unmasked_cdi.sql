
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       autor                            data criação                    data alteração                                   objetivo 
   Diego Silva                           2025-09-01                                                   procedure que verifica a carga da unmasked_cdi

*/--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE bacen.sp_unmasked_verificar_carga_cdi(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    total_registros INTEGER;
    dados_coletados BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO total_registros
    FROM  bacen.unmasked_cdi 
    WHERE data_extracao = CURRENT_DATE;

    dados_coletados := total_registros > 0;

    INSERT INTO logs_azure.unmasked_log_monitoramento_Azure_Function (tabela, existe_dado, mensagem, linhas_inseridas,schema)
    VALUES (
        'unmasked_cdi',
        dados_coletados,
        CASE 
            WHEN dados_coletados 
            THEN 'Dados inseridos com sucesso no dia ' || CURRENT_DATE
            ELSE 'Dados NÃO inseridos no dia ' || CURRENT_DATE
        END,
        total_registros,
		'bacen'
    );
END;
$BODY$;
ALTER PROCEDURE bacen.sp_unmasked_verificar_carga_cdi()
    OWNER TO netz_admin;
