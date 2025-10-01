-- PROCEDURE: ot.sp_atualiza_sot_ot_carteira()

-- DROP PROCEDURE IF EXISTS ot.sp_atualiza_sot_ot_carteira();

CREATE OR REPLACE PROCEDURE ot.sp_atualiza_sot_ot_carteira(
	)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
WITH    carteira_chave_forte_sor
AS
    (SELECT
    REPLACE(REPLACE(REPLACE(COALESCE(SOR.carteira_id::text, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOR.fundo, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOR.cnpj, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOR.data_referencia::text, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOR.classe, ''), ' ', ''), '-', ''), '/', '') AS chave_forte,
    SOR.carteira_id,
    SOR.fundo,
    SOR.quantidade,
    SOR.valor,
    SOR.valor_cota,
    SOR.valor_bruto,
    SOR.cnpj,
    TO_DATE(SOR.data_referencia, 'YYYY-MM-DD')  AS  data_referencia,
    SOR.tipo_carteira,
    SOR.codigo_cota,
    SOR.classe,
    SOR.valor_liquido,
    SOR.id,
    SOR.saldo::numeric(20,8),
    SOR.tipo,
    TO_DATE(SOR.data_liquidacao_prevista, 'YYYY-MM-DD')  AS data_liquidacao_prevista,
    SOR.descricao,
    SOR.codigo,
    SOR.data_extracao,
    SOR.id_tab
FROM unmasked_carteiras AS SOR),

carteira_chave_forte_sot
AS
    (SELECT
    REPLACE(REPLACE(REPLACE(COALESCE(SOT.carteira_id::text, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOT.fundo, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOT.cnpj, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOT.data_referencia::text, ''), ' ', ''), '-', ''), '/', '') ||
    REPLACE(REPLACE(REPLACE(COALESCE(SOT.classe, ''), ' ', ''), '-', ''), '/', '') AS chave_forte,
    SOT.carteira_id,
    SOT.fundo,
    SOT.quantidade,
    SOT.valor,
    SOT.valor_cota,
    SOT.valor_bruto,
    SOT.cnpj,
    SOT.data_referencia,
    SOT.tipo_carteira,
    SOT.codigo_cota,
    SOT.classe,
    SOT.valor_liquido,
    SOT.id,
    SOT.saldo::numeric(20,8),
    SOT.tipo,
    SOT.data_liquidacao_prevista,
    SOT.descricao,
    SOT.codigo,
    SOT.data_extracao,
    SOT.id_tab_old
FROM ot.unmasked_carteiras AS SOT)

INSERT INTO ot.unmasked_carteiras (
    carteira_id,
    fundo,
    quantidade,
    valor,
    valor_cota,
    valor_bruto,
    cnpj,
    data_referencia,
    tipo_carteira,
    codigo_cota,
    classe,
    valor_liquido,
    id,
    saldo,
    tipo,
    data_liquidacao_prevista,
    descricao,
    codigo,
    data_extracao,
    id_tab_old)

SELECT
    SOR.carteira_id,
    SOR.fundo,
    SOR.quantidade,
    SOR.valor,
    SOR.valor_cota,
    SOR.valor_bruto,
    SOR.cnpj,
    SOR.data_referencia,
    SOR.tipo_carteira,
    SOR.codigo_cota,
    SOR.classe,
    SOR.valor_liquido,
    SOR.id,
    SOR.saldo::numeric(20,8),
    SOR.tipo,
    SOR.data_liquidacao_prevista,
    SOR.descricao,
    SOR.codigo,
    SOR.data_extracao,
    SOR.id_tab
FROM carteira_chave_forte_sor       AS SOR
LEFT JOIN carteira_chave_forte_sot  AS SOT     ON   SOR.chave_forte = SOT.chave_forte
WHERE     SOT.chave_forte  IS NULL
AND       SOR.id_tab NOT IN (735,508,463,723,597,709,480,496,559,571,759,621,583,633,683,747,609,670,696,547,657,535,645,520); -- 24 linhas estão impactando no left join
END;
$BODY$;
ALTER PROCEDURE ot.sp_atualiza_sot_ot_carteira()
    OWNER TO netz_admin;
