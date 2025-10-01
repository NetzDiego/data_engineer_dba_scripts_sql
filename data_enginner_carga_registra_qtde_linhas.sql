-- PROCEDURE: interno.sp_relatorio_azure_functions_etl()

-- DROP PROCEDURE IF EXISTS interno.sp_relatorio_azure_functions_etl();

CREATE OR REPLACE PROCEDURE interno.sp_relatorio_azure_functions_etl()
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN

   BEGIN
        DROP TABLE resultado_temp;
        EXCEPTION
        WHEN undefined_table THEN NULL;
    END;

    CREATE TEMP TABLE resultado_temp AS
    SELECT 
        CASE  
            WHEN tabela IN ('unmasked_clients','unmasked_de_para_cliente_assessor')  THEN (data_execucao - interval '0 days')::date
			WHEN tabela IN ('unmasked_statements')  THEN (data_execucao - interval '4 days')::date
            WHEN tabela IN ('unmasked_debentures','unmasked_debentures_mercado_secundario') THEN (data_execucao - interval '1 days')::date
            ELSE (data_execucao - interval '8 days')::date 
            END AS data_carga,
        tabela,
        data_execucao,
        linhas_inseridas
    FROM logs_azure.unmasked_log_monitoramento_Azure_Function
    WHERE DATE(data_execucao) = DATE(CURRENT_DATE - INTERVAL '3 hours');

    INSERT INTO interno.unmasked_relatorio_azure_functions_etl (dados_do_dia,nm_tabela,linhas_inseridas,carregado_dia,dia_semana,status_carga,observacao,tipo_extracao)
    SELECT      data_carga,
	            tabela,
				r.linhas_inseridas,
				r.data_execucao,
				f.dia_semana,
            CASE  
            WHEN (f.tipo_dia = 'Dia Util' AND r.linhas_inseridas = 0) 
            THEN 'Warning'
            ELSE 'OK'
        END AS status_carga,
		CASE   WHEN  r.linhas_inseridas = 0 AND f.tipo_dia = 'Dia Util'
		THEN   'ATENÇÃO, dia util,não houve a inserção de dados!'
		END    AS Observacao,
		'D - '|| r.data_execucao::date - data_carga::date  as tipo_dia
    FROM resultado_temp                                       AS r 
    INNER JOIN interno.unmasked_calendario_anbima             AS f  ON f.data = r.data_carga
    LEFT JOIN  interno.unmasked_relatorio_azure_functions_etl AS rf ON rf.carregado_dia = r.data_execucao  AND rf.nm_tabela = r.tabela
    WHERE rf.dados_do_dia IS NULL
    ORDER BY status_carga DESC;
END;
$BODY$;
ALTER PROCEDURE interno.sp_relatorio_azure_functions_etl()
    OWNER TO netz_admin;



