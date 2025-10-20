CREATE OR REPLACE PROCEDURE interno.verifica_e_desativa_login()
LANGUAGE plpgsql
AS $$
DECLARE
    conexoes_ativas INTEGER;
BEGIN
    -- Conta quantas sessões estão ativas para o usuário
    SELECT COUNT(*) INTO conexoes_ativas
    FROM pg_stat_activity
    WHERE usename = 'jaime_souza';

    -- Se houver conexões ativas, desativa o login
    IF conexoes_ativas > 0 THEN
        RAISE NOTICE 'Usuário jaime_souza está com % conexões ativas. Desativando login...', conexoes_ativas;
        EXECUTE 'ALTER ROLE jaime_souza NOLOGIN';
    ELSE
        RAISE NOTICE 'Nenhuma conexão ativa para jaime_souza. Nenhuma ação necessária.';
    END IF;
END $$;

--Executa a proc 
CALL interno.verifica_e_desativa_login()

-- Job 

SELECT cron.schedule(
    'job_login_21_ate_23_utc',
    '*/5 22-23 * * *',
    $$CALL interno.verifica_e_desativa_login();$$
);


SELECT cron.schedule(
    'job_login_00_ate_10_utc',
    '*/5 0-10 * * *',
    $$CALL interno.verifica_e_desativa_login();$$
);






	

