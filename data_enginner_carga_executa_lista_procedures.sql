-- PROCEDURE: interno.sp_executar_rotinas_etl()

-- DROP PROCEDURE IF EXISTS interno.sp_executar_rotinas_etl();

CREATE OR REPLACE PROCEDURE interno.sp_executar_rotinas_etl(
	)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    BEGIN
        SET LOCAL statement_timeout = 40000;
        CALL btg.sp_verificar_etl_btg_api_debentures();
    EXCEPTION WHEN OTHERS THEN
        INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
        VALUES ('btg.sp_verificar_etl_btg_api_debentures', SQLERRM);
    END;

    BEGIN 
    SET LOCAL statement_timeout = 40000;
    CALL interno.sp_verificar_etl_depara_clientes_assessor();
	    EXCEPTION WHEN OTHERS THEN
        INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
        VALUES ('interno.sp_verificar_etl_depara_clientes_assessor', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL interno.sp_verificar_etl_int_comissao_bankers();
		EXCEPTION WHEN OTHERS THEN
        INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
        VALUES ('interno.sp_verificar_etl_int_comissao_bankers', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL xp.sp_verificar_etl_xp_api_clients();
		EXCEPTION WHEN OTHERS THEN
        INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
        VALUES ('xp.sp_verificar_etl_xp_api_clients', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL xp.sp_verificar_etl_xp_api_evolution();
		EXCEPTION WHEN OTHERS THEN
        INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
        VALUES ('xp.sp_verificar_etl_xp_api_evolution', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL xp.sp_verificar_etl_xp_api_movements();
		EXCEPTION WHEN OTHERS THEN
        INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
        VALUES ('xp.sp_verificar_etl_xp_api_movements', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL xp.sp_verificar_etl_xp_api_positions();
		EXCEPTION WHEN OTHERS THEN
        INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
        VALUES ('xp.sp_verificar_etl_xp_api_positions', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL xp.sp_verificar_etl_xp_api_statements();
	     EXCEPTION WHEN OTHERS THEN
         INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
         VALUES ('xp.sp_verificar_etl_xp_api_statements', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL interno.sp_verificar_etl_debentures_mercado_secundario();
	     EXCEPTION WHEN OTHERS THEN
         INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
         VALUES ('interno.sp_verificar_etl_debentures_mercado_secundario', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL xp.sp_verificar_etl_xp_captacao_e_resgate();
	     EXCEPTION WHEN OTHERS THEN
         INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
         VALUES ('xp.sp_verificar_etl_xp_captacao_e_resgate', SQLERRM);
    END;

	BEGIN
    SET LOCAL statement_timeout = 40000;
    CALL interno.sp_relatorio_azure_functions_etl();
	     EXCEPTION WHEN OTHERS THEN
         INSERT INTO logs_azure.unmasked_log_erros_etl (nome_procedure, erro)
         VALUES ('interno.sp_relatorio_azure_functions_etl', SQLERRM);
	END;
END;
$BODY$;
ALTER PROCEDURE interno.sp_executar_rotinas_etl()
    OWNER TO netz_admin;
