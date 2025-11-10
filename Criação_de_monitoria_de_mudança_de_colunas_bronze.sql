================================================================================================================================================
--Base de Dados - Bronze
--Schema - validacao_estrutural
================================================================================================================================================
CALL  validacao_estrutural.sp_fixedIncome_xp()

CREATE PROCEDURE validacao_estrutural.sp_fixedIncome_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    fixedincome_api  INTEGER;
    fixedincome_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key) AS lower
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'fixedIncome') AS fixedIncome,
         jsonb_object_keys(fixedIncome) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base
    UPDATE validacao_estrutural.fixedIncome_xp AS f
    SET    nm_columns = p.lower
    FROM   positions_temp AS p
    WHERE  p.id = f.id
    AND    p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
    INTO fixedincome_api
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'fixedIncome') AS fund,
         jsonb_object_keys(fund) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 5️ Contagem da base
    SELECT COUNT(*) INTO fixedincome_base
    FROM validacao_estrutural.fixedIncome_xp;

    -- 6️ Comparação e exibição do resultado
    IF fixedincome_api <> fixedincome_base THEN
        INSERT INTO validacao_estrutural.fixedIncome_xp (nm_columns)
        SELECT p.lower
        FROM positions_temp AS p
        LEFT JOIN validacao_estrutural.fixedIncome_xp AS f ON p.id = f.id
        WHERE f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            fixedincome_api, fixedincome_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            fixedincome_api, fixedincome_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;

==================================================================================================================================================================================
CALL validacao_estrutural.sp_checkingAccount_xp()

CREATE PROCEDURE validacao_estrutural.sp_checkingAccount_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    checkingAccount_api  INTEGER;
    checkingAccount_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key) AS lower
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'checkingAccount') AS checkingAccount,
         jsonb_object_keys(checkingAccount) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.checkingAccount_xp AS f
    SET nm_columns = p.lower
    FROM positions_temp AS p
    WHERE p.id = f.id
    AND p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
    INTO checkingAccount_api
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'checkingAccount') AS fund,
         jsonb_object_keys(fund) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 5️ Contagem da base
    SELECT COUNT(*) INTO checkingAccount_base
    FROM validacao_estrutural.checkingAccount_xp;

    -- 6️ Comparação e exibição do resultado
    IF checkingAccount_api <> checkingAccount_base THEN
        INSERT INTO validacao_estrutural.checkingAccount_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.checkingAccount_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            checkingAccount_api, checkingAccount_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            checkingAccount_api, checkingAccount_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;


==================================================================================================================================================================================
==================================================================================================================================================================================
CALL validacao_estrutural.sp_coe_xp()

CREATE PROCEDURE validacao_estrutural.sp_coe_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    coe_api  INTEGER;
    coe_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key) AS lower
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'coe') AS coe,
         jsonb_object_keys(coe) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.coe_xp AS f
    SET nm_columns = p.lower
    FROM positions_temp AS p
    WHERE p.id = f.id
    AND p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
    INTO coe_api
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'coe') AS coe,
         jsonb_object_keys(coe) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 5️ Contagem da base
    SELECT COUNT(*) INTO coe_base
    FROM validacao_estrutural.coe_xp;

    -- 6️ Comparação e exibição do resultado
    IF coe_api <> coe_base THEN
        INSERT INTO validacao_estrutural.coe_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.coe_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            coe_api, coe_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            coe_api, coe_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;

==================================================================================================================================================================================
CALL validacao_estrutural.sp_funds_xp()

CREATE PROCEDURE validacao_estrutural.sp_funds_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    funds_api  INTEGER;
    funds_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key) AS lower
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'funds') AS funds,
         jsonb_object_keys(funds) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.funds_xp AS f
    SET nm_columns = p.lower
    FROM positions_temp AS p
    WHERE p.id = f.id
    AND p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
    INTO funds_api
    FROM xp.positions,
         jsonb_array_elements(payload::jsonb) AS root,
         jsonb_array_elements(root->'funds') AS funds,
         jsonb_object_keys(funds) AS key
    WHERE data_referencia_inicio = (
        SELECT MAX(data_referencia_inicio) FROM xp.positions
    );

    -- 5️ Contagem da base
    SELECT COUNT(*) INTO funds_base
    FROM validacao_estrutural.funds_xp;

    -- 6️ Comparação e exibição do resultado
    IF funds_api <> funds_base THEN
        INSERT INTO validacao_estrutural.funds_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.funds_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            funds_api, funds_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            funds_api, funds_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;

==================================================================================================================================================================================
CALL validacao_estrutural.sp_pensionfunds_xp();


CREATE PROCEDURE validacao_estrutural.sp_pensionfunds_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    pensionfunds_api  INTEGER;
    pensionfunds_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key)
    FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'pensionFunds') AS pensionFunds,
       jsonb_object_keys(pensionFunds) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
    
    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.pensionfunds_xp AS f
    SET    nm_columns = p.lower
    FROM   positions_temp AS p
    WHERE  p.id = f.id
    AND    p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
    INTO pensionfunds_api
     FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'pensionFunds') AS pensionFunds,
       jsonb_object_keys(pensionFunds) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
	

    -- 5️ Contagem da base
    SELECT COUNT(*) INTO pensionfunds_base
    FROM validacao_estrutural.pensionfunds_xp;

    -- 6️ Comparação e exibição do resultado
    IF pensionfunds_api <> pensionfunds_base THEN
        INSERT INTO validacao_estrutural.pensionfunds_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.pensionfunds_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            pensionfunds_api, pensionfunds_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            pensionfunds_api, pensionfunds_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;

==================================================================================================================================================================================
CALL validacao_estrutural.sp_repo_xp();


CREATE PROCEDURE validacao_estrutural.sp_repo_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    repo_api  INTEGER;
    repo_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key)
    FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'repo') AS repo,
       jsonb_object_keys(repo) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
    
    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.repo_xp AS f
    SET    nm_columns = p.lower
    FROM   positions_temp AS p
    WHERE  p.id = f.id
    AND    p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
     INTO   repo_api
     FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'repo') AS repo,
       jsonb_object_keys(repo) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
	

    -- 5️ Contagem da base
    SELECT COUNT(*) INTO repo_base
    FROM validacao_estrutural.repo_xp;

    -- 6️ Comparação e exibição do resultado
    IF repo_api <> repo_base THEN
        INSERT INTO validacao_estrutural.repo_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.repo_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            repo_api, repo_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            repo_api, repo_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;

=================================================================================================================================================================

==================================================================================================================================================================================
CALL validacao_estrutural.sp_stock_xp();


CREATE PROCEDURE validacao_estrutural.sp_stock_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    stock_api  INTEGER;
    stock_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key)
    FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'stock') AS stock,
       jsonb_object_keys(stock) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
    
    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.stock_xp AS f
    SET    nm_columns = p.lower
    FROM   positions_temp AS p
    WHERE  p.id = f.id
    AND    p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
    INTO   stock_api
     FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'stock') AS stock,
       jsonb_object_keys(stock) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
	

    -- 5️ Contagem da base
    SELECT COUNT(*) INTO stock_base
    FROM validacao_estrutural.stock_xp;

    -- 6️ Comparação e exibição do resultado
    IF stock_api <> stock_base THEN
        INSERT INTO validacao_estrutural.stock_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.stock_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            stock_api, stock_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            stock_api, stock_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;

=================================================================================================================================================================
==================================================================================================================================================================================
CALL validacao_estrutural.sp_tradedfunds_xp();


CREATE PROCEDURE validacao_estrutural.sp_tradedfunds_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    tradedfunds_api  INTEGER;
    tradedfunds_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key)
    FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'tradedFunds') AS tradedfunds,
       jsonb_object_keys(tradedfunds) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
    
    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.tradedfunds_xp AS f
    SET    nm_columns = p.lower
    FROM   positions_temp AS p
    WHERE  p.id = f.id
    AND    p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
	INTO   tradedfunds_api
    FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'tradedFunds') AS tradedfunds,
       jsonb_object_keys(tradedfunds) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
	
    -- 5️ Contagem da base
    SELECT COUNT(*) INTO tradedfunds_base
    FROM validacao_estrutural.tradedfunds_xp;

    -- 6️ Comparação e exibição do resultado
    IF tradedfunds_api <> tradedfunds_base THEN
        INSERT INTO validacao_estrutural.tradedfunds_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.stock_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            tradedfunds_api, tradedfunds_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            tradedfunds_api, tradedfunds_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;

==================================================================================================================================================================================
CALL validacao_estrutural.sp_treasury_xp();


CREATE PROCEDURE validacao_estrutural.sp_treasury_xp()
LANGUAGE plpgsql
AS $$
DECLARE
    treasury_api  INTEGER;
    treasury_base INTEGER;
BEGIN
    -- 1️ Cria tabela temporária
    CREATE TEMP TABLE positions_temp AS
    SELECT DISTINCT LOWER(key)
    FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'treasury') AS treasury,
       jsonb_object_keys(treasury) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
    
    -- 2️ Adiciona coluna ID
    ALTER TABLE positions_temp ADD COLUMN id SERIAL;

    -- 3️ Atualiza tabela base 
    UPDATE validacao_estrutural.treasury_xp AS f
    SET    nm_columns = p.lower
    FROM   positions_temp AS p
    WHERE  p.id = f.id
    AND    p.lower <> f.nm_columns;

    -- 4️ Contagem do JSON
    SELECT COUNT(DISTINCT key)
	INTO   treasury_api
    FROM   xp.positions,
       jsonb_array_elements(payload::jsonb) AS root,
       jsonb_array_elements(root->'treasury') AS treasury,
       jsonb_object_keys(treasury) AS key
    WHERE data_referencia_inicio = (
    SELECT MAX(data_referencia_inicio) FROM xp.positions
    );
	
    -- 5️ Contagem da base
    SELECT COUNT(*) INTO treasury_base
    FROM validacao_estrutural.treasury_xp;

    -- 6️ Comparação e exibição do resultado
    IF treasury_api <> treasury_base THEN
        INSERT INTO validacao_estrutural.treasury_xp (nm_columns)
        SELECT      p.lower
        FROM        positions_temp AS p
        LEFT JOIN   validacao_estrutural.treasury_xp AS f ON p.id = f.id
        WHERE       f.id IS NULL;

        RAISE NOTICE 'Base corrigida! API: %, BASE: %',
            treasury_api, treasury_base;
    ELSE
        RAISE NOTICE 'Não há divergência entre colunas! API: %, BASE: %',
            treasury_api, treasury_base;
    END IF;

    -- 7️ Exclui tabela temporária
    DROP TABLE positions_temp;
END $$;


