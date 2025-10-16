-- PROCEDURE: btg.sp_carga_unmasked_positions_products_sor_para_sot()

-- DROP PROCEDURE IF EXISTS btg.sp_carga_unmasked_positions_products_sor_para_sot();

CREATE OR REPLACE PROCEDURE btg.sp_carga_unmasked_positions_products_sor_para_sot(
	)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN

-- Conta Corrente
WITH   unmasked_positions_products_tratado
AS 
(SELECT
    
    COALESCE(pos_cci."PositionDate", pos_cca."PositionDate")::date AS data_referencia,
    COALESCE(pos_cci."AccountNumber", pos_cca."AccountNumber")::bigint AS client_id,
    'conta_corrente' AS product_type,
    'conta_corrente' AS product,
    SUM(
        COALESCE(pos_cca."CurrentAccountValue", 0) + COALESCE(pos_cci."GrossValue", 0)
    )::numeric(20,8) AS position_value,
    NULL::varchar(15) AS cnpj_fundo,
    NULL::varchar(50) AS produtos_netz,
    NULL::varchar(50) AS produtos_netz_solutions,
	CASE WHEN pos_cci.id IS NULL  THEN  pos_cca.id  ELSE pos_cci.id  END AS  id
FROM btg.unmasked_positions_conta_corrente_investida_sor pos_cci
FULL OUTER JOIN btg.unmasked_positions_conta_corrente_atual_sor pos_cca
    ON pos_cci."AccountNumber" = pos_cca."AccountNumber"
    AND pos_cci."PositionDate" = pos_cca."PositionDate"
WHERE COALESCE(pos_cci."PositionDate", pos_cca."PositionDate") 
      BETWEEN '2025-03-25' AND (CURRENT_DATE - INTERVAL '8 days')
GROUP BY
    pos_cci.id,
	pos_cca.id,
    COALESCE(pos_cci."PositionDate", pos_cca."PositionDate"),
    COALESCE(pos_cci."AccountNumber", pos_cca."AccountNumber")
 
UNION ALL
 
-- Previdência
SELECT
    
    pos_prev."PositionDate"::date AS data_referencia,
    pos_prev."parent_AccountNumber"::bigint AS client_id,
    'previdencia' AS product_type,
    pos_prev."FundName"::varchar(255) AS product,
    pos_prev."GrossAssetValue"::numeric(20, 8) AS position_value,
    pos_prev."PensionCnpjCode"::varchar(15) AS cnpj_fundo,
    pos_prev."produtos_netz" AS produtos_netz,
    pos_prev."produtos_netz_solutions" AS produtos_netz_solutions,
	pos_prev.id
FROM btg.unmasked_positions_previdencia_sor pos_prev
WHERE
    pos_prev."PositionDate" BETWEEN '2025-03-25' AND (
        CURRENT_DATE - INTERVAL '8 days'
    )
UNION ALL
 
-- Ações
SELECT
   
    pos_acoes."PositionDate"::date AS data_referencia,
    pos_acoes."AccountNumber"::bigint AS client_id,
    'renda_variavel' AS product_type,
    pos_acoes."Ticker" AS product,
    pos_acoes."GrossValue"::numeric(20, 8) AS position_value,
    NULL::varchar(15) AS cnpj_fundo,
    NULL::varchar(50) AS produtos_netz,
    NULL::varchar(50) AS produtos_netz_solutions,
	pos_acoes.id
FROM btg.unmasked_positions_acoes_sor pos_acoes
WHERE
    pos_acoes."PositionDate" BETWEEN '2025-03-25' AND (
        CURRENT_DATE - INTERVAL '8 days'
    )
UNION ALL
 
-- Renda Fixa
SELECT
    
    pos_rf."PositionDate"::date AS data_referencia,
    pos_rf."AccountNumber"::bigint AS client_id,
    'renda_fixa' AS product_type,
    pos_rf."Ticker" AS product,
    pos_rf."GrossValue"::numeric(20, 8) AS position_value,
    NULL::varchar(15) AS cnpj_fundo,
    NULL::varchar(50) AS produtos_netz,
    NULL::varchar(50) AS produtos_netz_solutions,
	pos_rf.id
FROM btg.unmasked_positions_renda_fixa_sor pos_rf
WHERE
    pos_rf."PositionDate" BETWEEN '2025-03-25' AND (
        CURRENT_DATE - INTERVAL '8 days'
    )
UNION ALL
 
-- COE / Produtos Estruturados
SELECT
    
    pos_pe."PositionDate"::date AS data_referencia,
    pos_pe."AccountNumber"::bigint AS client_id,
    'coe' AS product_type,
    pos_pe."Ticker" AS product,
    pos_pe."GrossValue"::numeric(20, 8) AS position_value,
    NULL::varchar(15) AS cnpj_fundo,
    NULL::varchar(50) AS produtos_netz,
    NULL::varchar(50) AS produtos_netz_solutions,
	pos_pe.id
FROM btg.unmasked_positions_produtos_estruturados_sor pos_pe
WHERE
    pos_pe."PositionDate" BETWEEN '2025-03-25' AND (
        CURRENT_DATE - INTERVAL '8 days'
    )
    AND pos_pe."AccountingGroupCode" = 'COE'
UNION ALL
 
-- Fundos de Investimento
SELECT
    
    pos_fundos."PositionDate" AS data_referencia,
    pos_fundos."AccountNumber"::bigint AS client_id,
    'fundos' AS product_type,
    pos_fundos."parent_Fund.FundName" AS product,
    pos_fundos."GrossAssetValue"::float AS position_value,
    pos_fundos."parent_Fund.FundCNPJCode"::varchar(15) AS cnpj_fundo,
    pos_fundos."produtos_netz" AS produtos_netz,
    pos_fundos."produtos_netz_solutions" AS produtos_netz_solutions,
	pos_fundos.id
FROM btg.unmasked_positions_fundos_investimento_sor pos_fundos
WHERE
    pos_fundos."PositionDate" BETWEEN '2025-03-25' AND (
        CURRENT_DATE - INTERVAL '8 days'
    )
UNION ALL
 
-- Criptomoedas
SELECT
    
    pos_crypto."PositionDate"::date AS data_referencia,
    pos_crypto."AccountNumber"::bigint AS client_id,
    'crypto' AS product_type,
    pos_crypto."AssetName" AS product,
    pos_crypto."FinancialClosing"::numeric(20, 8) AS position_value,
    NULL::varchar(15) AS cnpj_fundo,
    NULL::varchar(50) AS produtos_netz,
    NULL::varchar(50) AS produtos_netz_solutions,
	pos_crypto.id
FROM btg.unmasked_positions_crypto_sor pos_crypto
WHERE
    pos_crypto."PositionDate" BETWEEN '2025-03-25' AND (
        CURRENT_DATE - INTERVAL '8 days'
    )
UNION ALL
 
-- Valores em Transito
SELECT
    
    pos_vet."PositionDate"::date AS data_referencia,
    pos_vet."AccountNumber"::bigint AS client_id,
    'crypto' AS product_type,
    pos_vet."Ticker" AS product,
    pos_vet."FinancialValue"::numeric(20, 8) AS position_value,
    NULL::varchar(15) AS cnpj_fundo,
    NULL::varchar(50) AS produtos_netz,
    NULL::varchar(50) AS produtos_netz_solutions,
	pos_vet.id
FROM btg.unmasked_positions_valores_em_transito_sor pos_vet
WHERE
    pos_vet."PositionDate" BETWEEN '2025-03-25' AND (
        CURRENT_DATE - INTERVAL '8 days'
    ))

INSERT  INTO btg.unmasked_positions_products (data_referencia,
                                              client_id,
											  product_type,
											  product,
											  position_value,
											  cnpj_fundo,
											  produtos_netz,
											  produtos_netz_solutions,
											  id_tab_sor)
											  
SELECT                                        t.data_referencia,
                                              t.client_id,
		                                      t.product_type,
		                                      t.product,
		  									  t.position_value,
		  							          t.cnpj_fundo,
		  									  t.produtos_netz,
		  									  t.produtos_netz_solutions,
		  									  t.id
FROM      unmasked_positions_products_tratado     AS  t
LEFT JOIN btg.unmasked_positions_products         AS  p     ON  t.id = p.id_tab_sor
WHERE     p.id_tab_sor IS NULL;

END;
$BODY$;
ALTER PROCEDURE btg.sp_carga_unmasked_positions_products_sor_para_sot()
    OWNER TO netz_admin;
