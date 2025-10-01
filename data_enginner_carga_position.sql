-- PROCEDURE: btg.sp_carga_positions()

-- DROP PROCEDURE IF EXISTS btg.sp_carga_positions();

CREATE OR REPLACE PROCEDURE btg.sp_carga_positions(
	)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
WITH clientes AS (
    SELECT
        lpad(ltrim(trim("Codigo Cliente"::varchar), '0'), 9, '0') AS codigo_cliente,
        MIN("Datainiciotaxaadm"::date) AS min_datainiciotaxaadm
    FROM interno.unmasked_de_para_cliente_assessor
    GROUP BY "Codigo Cliente"
),
posicoes_filtradas AS (
    SELECT *
    FROM btg.unmasked_positions
    WHERE "EndPositionValue" IS NOT NULL
      AND "EndPositionValue" <> 0
),

rentabilidade_por_conta_data AS (
    SELECT
        lpad(conta::varchar, 9, '0') AS conta_pad,
        "data",
        SUM(rentabilidade) AS rentabilidade_total
    FROM btg.unmasked_nnm_detalhado_excel
    GROUP BY lpad(conta::varchar, 9, '0'), "data"
),

produtos_por_conta_data AS (
    SELECT
        lpad("AccountNumber"::varchar, 9, '0') AS conta_pad,
        "PositionDate"::date AS data,
        COUNT(DISTINCT "MarketName") AS qtd_produtos
    FROM posicoes_filtradas
    GROUP BY lpad("AccountNumber"::varchar, 9, '0'), "PositionDate"::date
),

base AS (
    SELECT
        REGEXP_REPLACE(COALESCE(bap."AccountNumber"::text, ''), '[\/\-\s]', '', 'g') ||
        REGEXP_REPLACE(COALESCE(to_char(bap."PositionDate"::date, 'YYYYMMDD'), ''), '[\/\-\s]', '', 'g') ||
        REGEXP_REPLACE(COALESCE(bap."MarketName", ''), '[\/\-\s]', '', 'g') ||
        REGEXP_REPLACE(COALESCE(bap.product_type, ''), '[\/\-\s]', '', 'g') AS chave_forte,

        bap."PositionDate"::date AS position_date,
        bap."MarketName" AS market_name,
        bap.product_type,
        bap."AccountNumber" AS account_number,
        bap."EndPositionValue"::numeric AS end_position_value,
        rpd.rentabilidade_total / NULLIF(pqd.qtd_produtos, 0) AS profitandloss,

        ROW_NUMBER() OVER (
            PARTITION BY bap."PositionDate"::date, bap."MarketName", bap."AccountNumber"
            ORDER BY bap."PositionDate" DESC
        ) AS rn
    FROM posicoes_filtradas bap
    LEFT JOIN clientes c
        ON lpad(bap."AccountNumber"::varchar, 9, '0') = c.codigo_cliente
    LEFT JOIN interno.unmasked_calendario_anbima ca
        ON bap."PositionDate" = ca."data"
    LEFT JOIN rentabilidade_por_conta_data rpd
        ON lpad(bap."AccountNumber"::varchar, 9, '0') = rpd.conta_pad
       AND bap."PositionDate"::date = rpd."data"
    LEFT JOIN produtos_por_conta_data pqd
        ON lpad(bap."AccountNumber"::varchar, 9, '0') = pqd.conta_pad
       AND bap."PositionDate"::date = pqd.data
    WHERE
        bap."PositionDate"::date >= COALESCE(c.min_datainiciotaxaadm, '9999-12-31'::date)
        AND ca.tipo_dia = 'Dia Util'
		-- AND "AccountNumber" = '008561790'  and "MarketName" = 'Renda Fixa'  and "PositionDate" = '2025-03-27'
),

positions_chave_forte AS (
    SELECT
        REGEXP_REPLACE(COALESCE("AccountNumber"::text, ''), '[\/\-\s]', '', 'g') ||
        REGEXP_REPLACE(COALESCE("PositionDate"::text, ''), '[\/\-\s]', '', 'g') ||
        REGEXP_REPLACE(COALESCE("MarketName", ''), '[\/\-\s]', '', 'g') ||
        REGEXP_REPLACE(COALESCE(product_type, ''), '[\/\-\s]', '', 'g') AS chave_forte,
        "PositionDate",
        "MarketName",
        product_type,
        "AccountNumber",
        "EndPositionValue",
        profitandloss
    FROM btg.unmasked_positions_fkt
)

INSERT  INTO btg.unmasked_positions_fkt ("PositionDate","MarketName","product_type","AccountNumber","EndPositionValue","profitandloss")
    SELECT
    b.position_date,
    b.market_name,
    b.product_type,
    b.account_number,
    b.end_position_value,
    b.profitandloss
FROM base AS b
LEFT JOIN positions_chave_forte AS p  ON b.chave_forte = p.chave_forte
WHERE b.rn = 1  
AND   p.chave_forte IS NULL
ORDER BY b.position_date, b.account_number, b.market_name;
END;
$BODY$;
ALTER PROCEDURE btg.sp_carga_positions()
    OWNER TO netz_admin;
