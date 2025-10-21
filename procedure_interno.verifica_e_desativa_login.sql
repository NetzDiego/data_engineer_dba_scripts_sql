CREATE OR REPLACE PROCEDURE interno.verifica_e_desativa_login(
	)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    conexoes_ativas INTEGER;
BEGIN
    -- Verifica se há algum ip diferente que ('179.191.72.251','200.206.39.42'), se existir bloqueia o login
    SELECT COUNT(*) INTO conexoes_ativas
    FROM pg_stat_activity
    WHERE usename = 'jaime_souza'
	AND   client_addr NOT IN ('179.191.72.251','200.206.39.42');

    -- Se houver conexões ativas, desativa o login
    IF conexoes_ativas > 0 THEN
        RAISE NOTICE 'Usuário jaime_souza está com % conexões ativas. Desativando login...', conexoes_ativas;
        EXECUTE 'ALTER ROLE jaime_souza NOLOGIN';
    ELSE
        RAISE NOTICE 'Nenhuma conexão ativa para jaime_souza. Nenhuma ação necessária.';
    END IF;
END 
$BODY$;
ALTER PROCEDURE interno.verifica_e_desativa_login()
    OWNER TO netz_admin;

