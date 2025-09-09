CREATE   MATERIALIZED VIEW   interno.unmasked_posicao_consolidado 
AS

-- Seleção de posições da XP
SELECT 
    -- ID do cliente convertido para texto
    CAST(xap."clientId" AS TEXT) AS client_id,
    
    -- Data da posição convertida para date
    xap."effectiveDate"::date AS effective_date,
    
    -- Nome do ativo
    asset,
    
    -- Classe do ativo, baseada no tipo de mercado ou tipo de produto
    CASE
        WHEN xap."marketType" IN ('CDB','CDCA','CRA','CRI','DEB','FIDC','LCA','LCD','LCI','LF','NTN-B','LFT','NTN-F') THEN 'Renda fixa'
        WHEN xap."marketType" IN ('LTN', 'NTNB PRINC', 'NTN-B1') THEN 'Tesouro direto'
        WHEN xap."marketType" IN ('MACROMULTIMARKET', 'OTHERSMULTIMARKET', 'POSTFIXEDINCOME', 'PREFIXEDINCOME') THEN 'Previdência'
        WHEN xap."marketType" IN (
            'Fundo de Investimento Renda Fixa', 'Alternativo', 'Fundo de Investimento Referenciado',
            'Fundo de Investimento Multimercado', 'Fundo de Investimento Renda Variável',
            'Fundo de Investimento Internacional', 'FND', 'FII') THEN 'Fundos'
        WHEN xap."marketType" = 'AÇÃO' THEN 'Ações'
        WHEN xap."marketType" IS NULL THEN
            CASE
                -- Se marketType for NULL, verifica product_type para definir a classe
                WHEN xap.product_type = 'coe' THEN 'COE'
                WHEN xap.product_type = 'fixedIncome' THEN 'Renda fixa'
                WHEN xap.product_type = 'funds' THEN 'Fundos de investimento'
                WHEN xap.product_type = 'pensionFunds' THEN 'Fundos de pensão'
                WHEN xap.product_type = 'repo' THEN 'A classificar'
                WHEN xap.product_type = 'stock' THEN 'Ações'
                WHEN xap.product_type = 'tradedFunds' THEN 'ETF'
                WHEN xap.product_type = 'treasury' THEN 'treasury'
                ELSE NULL
            END
        ELSE NULL
    END AS classe,
 
    -- Subclasse ajustada, detalhando melhor o tipo do ativo
    CASE
        WHEN xap."marketType" IN ('CDB','CDCA','CRA','CRI','DEB','FIDC','LCA','LCD','LCI','LF','NTN-B','LFT','NTN-F','LTN') THEN xap."marketType"
        WHEN xap."marketType" = 'NTNB PRINC' THEN 'NTN-B'
        WHEN xap."marketType" = 'NTN-B1' THEN 'NTN-B'
        WHEN xap."marketType" IN ('MACROMULTIMARKET', 'OTHERSMULTIMARKET', 'POSTFIXEDINCOME', 'PREFIXEDINCOME') THEN 'Previdência'
        WHEN xap."marketType" IN (
            'Fundo de Investimento Renda Fixa', 'Alternativo', 'Fundo de Investimento Referenciado',
            'Fundo de Investimento Multimercado', 'Fundo de Investimento Renda Variável',
            'Fundo de Investimento Internacional', 'FND') THEN
            CASE
                -- Subclasse baseada no nome do ativo
                WHEN xap.asset ILIKE '%FIC FIDC%' THEN 'FIC FIDC'
                WHEN xap.asset ILIKE '%FIC FIP%'  THEN 'FIC FIP'
                WHEN xap.asset ILIKE '%FIC FIRF%' THEN 'FIC FIRF'
                WHEN xap.asset ILIKE '%FIC FIM%'  THEN 'FIC FIM'
                WHEN xap.asset ILIKE '%FIC FIA%'  THEN 'FIC FIA'
                WHEN xap.asset ILIKE '%FIC FIF%'  THEN 'FIC FIF'
                WHEN xap.asset ILIKE '%FIC RF%'   THEN 'FIC RF'
 
                WHEN xap.asset ILIKE '%FIDC%' THEN 'FIDC'
                WHEN xap.asset ILIKE '%FIP%'  THEN 'FIP'
                WHEN xap.asset ILIKE '%FIRF%' THEN 'FIRF'
                WHEN xap.asset ILIKE '%FII%'  THEN 'FII'
                WHEN xap.asset ILIKE '%FIM%'  THEN 'FIM'
                WHEN xap.asset ILIKE '%FIA%'  THEN 'FIA'
                WHEN xap.asset ILIKE '%CIC%'  THEN 'CIC'
                WHEN xap.asset ILIKE '%FIF%'  THEN 'FIF'
                WHEN xap.asset ILIKE '%RF%'   THEN 'RF'
                WHEN xap.asset ILIKE '%FIC%'  THEN 'FIC'
 
                -- Subclasse especial para seniores, mezaninos ou subordinados
                WHEN xap.asset ILIKE '%SEN%' OR xap.asset ILIKE '%SR%' OR xap.asset ILIKE '%MEZ%'
                     OR xap.asset ILIKE '%MZ%' OR xap.asset ILIKE '%SUB%' THEN 'FIDC'
                WHEN xap.asset ILIKE '%11%' THEN 'FII'
                WHEN xap.asset ILIKE '%FND%' THEN 'FIDC'
 
                ELSE 'Outros'
            END
        WHEN xap."marketType" = 'FII' THEN 'FII'
        WHEN xap."marketType" = 'AÇÃO' THEN 'Ações'
        WHEN xap."marketType" IS NULL THEN
            CASE
                -- Caso marketType seja NULL, usa product_type para definir a subclasse
                WHEN xap.product_type = 'coe' THEN 'COE'
                WHEN xap.product_type = 'fixedIncome' THEN 'Renda fixa'
                WHEN xap.product_type = 'funds' THEN 'Fundos de investimento'
                WHEN xap.product_type = 'pensionFunds' THEN 'Fundos de pensão'
                WHEN xap.product_type = 'repo' THEN 'A classificar'
                WHEN xap.product_type = 'stock' THEN 'Ações'
                WHEN xap.product_type = 'tradedFunds' THEN 'ETF'
                WHEN xap.product_type = 'treasury' THEN 'treasury'
                ELSE NULL
            END
        ELSE NULL
    END AS subclasse,
    
    -- Valor de fechamento da posição
    xap."closingValue",
    
    -- Lucro/prejuízo da posição
    xap."profitAndLoss",
    
    -- Custodiante fixo para XP
    'XP' AS custodiante
FROM unmasked_xp_positions xap

-- União com posições do BTG
UNION ALL

SELECT 
    "AccountNumber" AS clientId,         -- ID do cliente
    "PositionDate"::date AS effectiveDate,  -- Data da posição
    NULL AS "Asset",                     -- Asset não informado no BTG
    "MarketName" AS classe,              -- Classe pelo nome do mercado
    "MarketName" AS subclasse,           -- Subclasse igual à classe
    "EndPositionValue" AS closingValue,  -- Valor de fechamento
    profitandloss AS profitAndLoss,      -- Lucro/prejuízo
    'BTG' AS custodiante                 -- Custodiante fixo para BTG
FROM unmasked_btg_positions;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION interno.atualiza_view_unmasked_posicao()  
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
BEGIN
  PERFORM dblink_exec(
    'host=netz-database-server.postgres.database.azure.com dbname=spec user=netz_admin password=producao@3204!# sslmode=require',
    'REFRESH MATERIALIZED VIEW interno.unmasked_consolidado_posicao;'
  );
  RETURN 'View atualizada com sucesso!';
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'Erro ao atualizar a view: ' || SQLERRM;
END;
$BODY$;  


SELECT  * FROM interno.atualiza_view_unmasked_posicao() 


