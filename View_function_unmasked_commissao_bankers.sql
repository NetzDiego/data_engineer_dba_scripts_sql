CREATE  MATERIALIZED VIEW  interno.unmasked_consolidado_comissao_bankers
AS
SELECT 
    "Codigo Cliente",                         -- Código identificador do cliente
    "Nome Cliente",                           -- Nome do cliente
    "Taxa Adm",                               -- Taxa de administração
    "Datainiciotaxaadm"::date,                -- Data de início da taxa de administração (convertida para date)
    "Datafimtaxaadm"::date,                   -- Data de fim da taxa de administração (convertida para date)
    "Tipo de Taxa Adm",                       -- Tipo da taxa de administração
    "Escritório",                             -- Escritório responsável
    "Assessor Comercial",                     -- Nome do assessor comercial
    "Gerente Comercial",                      -- Nome do gerente comercial
    "Diretor Comercial",                      -- Nome do diretor comercial
    "Repasse Assessor Comercial",             -- Percentual/valor de repasse para o assessor comercial
    "Repasse Gerente Comercial",              -- Percentual/valor de repasse para o gerente comercial
    "Repasse Diretor Comercial",              -- Percentual/valor de repasse para o diretor comercial
    "Email Assessor",                         -- E-mail do assessor
    "Custodiante",                            -- Instituição custodiante
    "DataContrato",                           -- Data do contrato
    "Produtos Ponderação",                    -- Produtos considerados na ponderação
    "Repasse Netz Assessor",                  -- Repasse da Netz para o assessor
    data_extracao,                            -- Data de extração do dado
    "Canal",                                  -- Canal de distribuição
    "CPF/CNPJ"::varchar(20),                  -- Documento do cliente (convertido para varchar de 20 caracteres)
    "Executivo Comercial",                    -- Nome do executivo comercial
    "Repasse Executivo Comercial",            -- Percentual/valor de repasse para o executivo comercial
    data_referencia,                          -- Data de referência
    patrimonio_liquido,                       -- Patrimônio líquido do cliente
    valor_cobrado,                            -- Valor efetivamente cobrado
    repasse_netz,                             -- Repasse da Netz
    repasse_assessor,                         -- Repasse para o assessor
    repasse_diretor,                          -- Repasse para o diretor
    repasse_gerente,                          -- Repasse para o gerente
    taxa_netz,                                -- Taxa da Netz
    taxa_assessor,                            -- Taxa do assessor
    taxa_diretor,                             -- Taxa do diretor
    taxa_gerente                              -- Taxa do gerente
FROM unmasked_btg_comissao_bankers

UNION ALL  -- Une os dados da tabela BTG com os dados da tabela XP, mantendo duplicados caso existam

-- Seleciona os dados da tabela xp.unmasked_comissao_bankers
SELECT 
    "Codigo Cliente", 
    "Nome Cliente", 
    "Taxa Adm", 
    "Datainiciotaxaadm"::date, 
    "Datafimtaxaadm"::date, 
    "Tipo de Taxa Adm", 
    "Escritório", 
    "Assessor Comercial", 
    "Gerente Comercial", 
    "Diretor Comercial", 
    "Repasse Assessor Comercial", 
    "Repasse Gerente Comercial", 
    "Repasse Diretor Comercial", 
    "Email Assessor", 
    "Custodiante", 
    "DataContrato", 
    "Produtos Ponderação", 
    "Repasse Netz Assessor", 
    data_extracao, 
    "Canal", 
    "CPF/CNPJ"::varchar(20), 
    "Executivo Comercial", 
    "Repasse Executivo Comercial", 
    data_referencia, 
    patrimonio_liquido, 
    valor_cobrado, 
    repasse_netz, 
    repasse_assessor, 
    repasse_diretor, 
    repasse_gerente, 
    taxa_netz, 
    taxa_assessor, 
    taxa_diretor, 
    taxa_gerente
FROM unmasked_xp_comissao_bankers ucb;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION interno.atualiza_view_unmasked_comissao_bankers()  
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
BEGIN
  PERFORM dblink_exec(
    'host=netz-database-server.postgres.database.azure.com dbname=spec user=netz_admin password=producao@3204!# sslmode=require',
    'REFRESH MATERIALIZED VIEW interno.unmasked_consolidado_comissao_bankers;'
  );
  RETURN 'View atualizada com sucesso!';
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'Erro ao atualizar a view: ' || SQLERRM;
END;
$BODY$;  


SELECT  * FROM interno.atualiza_view_unmasked_comissao_bankers() 

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Cria Job às 13:00 de segunda a sábado
SELECT cron.schedule(
    'job_atualiza_materialized_views_spec',
    '0 13 * * 1-6',
    $$
    SELECT interno.atualiza_view_unmasked_captacao_resgate();
    SELECT pg_sleep(15);
    SELECT interno.atualiza_view_unmasked_posicao();
    SELECT pg_sleep(15);
    SELECT interno.atualiza_view_unmasked_comissao_bankers();
    $$
);






