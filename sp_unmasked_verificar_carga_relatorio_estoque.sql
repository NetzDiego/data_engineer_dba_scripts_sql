/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     autor                          data criação                            data alteração                                               objetivo 
  Diego Silva                        2025-09-01                                                          verificar a carga do dia referente unmasked_relatorio_estoque
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE vortx.sp_unmasked_verificar_carga_relatorio_estoque(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    total_registros INTEGER;
    dados_coletados BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO total_registros
    FROM     vortx.unmasked_relatorio_estoque
    WHERE    data_extracao = CURRENT_DATE;

    dados_coletados := total_registros > 0;

    INSERT INTO logs_azure.unmasked_log_monitoramento_azure_function (tabela, existe_dado, mensagem, linhas_inseridas,schema)
    VALUES (
	    'unmasked_relatorio_estoque',
        dados_coletados,
        CASE 
            WHEN dados_coletados 
            THEN 'Dados inseridos com sucesso no dia ' || CURRENT_DATE
            ELSE 'Dados NÃO inseridos no dia ' || CURRENT_DATE
        END,
		total_registros,
		'vortx'
    );
END;
$BODY$;
ALTER PROCEDURE vortx.sp_unmasked_verificar_carga_relatorio_estoque()
    OWNER TO netz_admin;
