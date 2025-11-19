-- View: monitoramento.vw_monitoramento_data_extracao

-- DROP VIEW monitoramento.vw_monitoramento_data_extracao;
CREATE OR REPLACE VIEW monitoramento.vw_monitoramento_data_extracao
 AS
SELECT 'xp'::text AS schema,
       'unmasked_movements'::text AS tabela,
       COUNT(*) AS qtde,
       MAX(unmasked_movements."effectiveDate")::timestamp AS ultima_data_referencia,
       MAX(unmasked_movements.data_extracao)::timestamp AS ultima_data_extracao
FROM xp.unmasked_movements
WHERE unmasked_movements.data_extracao >= (CURRENT_DATE - interval '90 days')

UNION ALL

SELECT 'xp'::text AS schema,
       'unmasked_evolution'::text AS tabela,
       COUNT(*) AS qtde,
       MAX(
         CASE
           -- quando vier só a data no formato DD-MM-YYYY
           WHEN "referenceDate" ~ '^\d{2}-\d{2}-\d{4}$'
             THEN to_date("referenceDate", 'DD-MM-YYYY')

           -- quando vier no formato completo YYYY-MM-DD HH24:MI:SS
           WHEN "referenceDate" ~ '^\d{4}-\d{2}-\d{2} '
             THEN to_timestamp("referenceDate", 'YYYY-MM-DD HH24:MI:SS')

           -- fallback: tenta converter como YYYY-MM-DD
           ELSE to_date("referenceDate", 'YYYY-MM-DD')
         END
       ) AS ultima_data_referencia,
       MAX(data_extracao::timestamp) AS ultima_data_extracao
FROM xp.unmasked_evolution
WHERE data_extracao::timestamp >= (CURRENT_DATE - interval '90 days')

UNION ALL

 SELECT 'xp'::text AS schema,
    'unmasked_captacao_resgate'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_captacao_resgate."effectiveDate") AS ultima_data_referencia,
    max(unmasked_captacao_resgate.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM xp.unmasked_captacao_resgate
  WHERE unmasked_captacao_resgate.data_extracao >= (CURRENT_DATE - '90 days'::interval)
 
UNION ALL
 SELECT 'xp'::text AS schema,
    'unmasked_positions'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions."effectiveDate") AS ultima_data_referencia,
    max(unmasked_positions.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM xp.unmasked_positions
  WHERE unmasked_positions.data_extracao >= (CURRENT_DATE - '90 days'::interval)
UNION ALL
 SELECT 'xp'::text AS schema,
    'unmasked_statements'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_statements."reference_date") AS ultima_data_referencia,
    max(unmasked_statements.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM xp.unmasked_statements
  WHERE unmasked_statements.data_extracao >= (CURRENT_DATE - '90 days'::interval)

  
UNION ALL

 SELECT 'xp'::text AS schema,
    'unmasked_comissao_bankers'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_comissao_bankers."data_referencia") AS ultima_data_referencia,
    max(unmasked_comissao_bankers.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM xp.unmasked_comissao_bankers
  WHERE unmasked_comissao_bankers.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_conta_corrente_atual'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_conta_corrente_atual."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_conta_corrente_atual.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_conta_corrente_atual
  WHERE unmasked_positions_conta_corrente_atual.data_extracao >= (CURRENT_DATE - '90 days'::interval)
 
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_clients'::text AS tabela,
    count(*) AS qtde,
	'1900-01-01'  AS  ultima_data_referencia,
    max(unmasked_clients.data_extract) AS ultima_data_extracao
   FROM btg.unmasked_clients
  WHERE unmasked_clients.data_extract >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_rentabilidade'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_rentabilidade."reference_date") AS ultima_data_referencia,
    max(unmasked_rentabilidade.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM btg.unmasked_rentabilidade
  WHERE unmasked_rentabilidade.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_summary_accounts'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_summary_accounts."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_summary_accounts.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_summary_accounts
  WHERE unmasked_positions_summary_accounts.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_comissao_bankers'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_comissao_bankers."data_referencia") AS ultima_data_referencia,
    max(unmasked_comissao_bankers.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM btg.unmasked_comissao_bankers
  WHERE unmasked_comissao_bankers.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
 
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_crypto'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_crypto."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_crypto.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_crypto
  WHERE unmasked_positions_crypto.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_consolidado'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_consolidado."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_consolidado.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_consolidado
  WHERE unmasked_positions_consolidado.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_previdencia'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_previdencia."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_previdencia.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_previdencia
  WHERE unmasked_positions_previdencia.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_renda_fixa'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_renda_fixa."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_renda_fixa.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_renda_fixa
  WHERE unmasked_positions_renda_fixa.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_produtos_estruturados'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_produtos_estruturados."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_produtos_estruturados.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_produtos_estruturados
  WHERE unmasked_positions_produtos_estruturados.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_valores_em_transito'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_valores_em_transito."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_valores_em_transito.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_valores_em_transito
  WHERE unmasked_positions_valores_em_transito.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_fundos_investimento'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_fundos_investimento."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_fundos_investimento.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_fundos_investimento
  WHERE unmasked_positions_fundos_investimento.data_extracao >= (CURRENT_DATE - '90 days'::interval)

 UNION ALL
 
 SELECT 'btg'::text AS schema,
    'unmasked_positions_acoes'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_acoes."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_acoes.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_acoes
  WHERE unmasked_positions_acoes.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions_conta_corrente_investida'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions_conta_corrente_investida."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions_conta_corrente_investida.data_extracao) AS ultima_data_extracao
   FROM btg.unmasked_positions_conta_corrente_investida
  WHERE unmasked_positions_conta_corrente_investida.data_extracao >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_stvm'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_stvm."data_captacao") AS ultima_data_referencia,
    max(unmasked_stvm.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM btg.unmasked_stvm
  WHERE unmasked_stvm.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'btg'::text AS schema,
    'unmasked_positions'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_positions."PositionDate") AS ultima_data_referencia,
    max(unmasked_positions.data_extracao::text)::timestamp without time zone AS ultima_data_extracao
   FROM btg.unmasked_positions
  WHERE unmasked_positions.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'bacen'::text AS schema,
    'unmasked_ipca'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_ipca."data_posicao") AS ultima_data_referencia,
    max(unmasked_ipca.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM bacen.unmasked_ipca
  WHERE unmasked_ipca.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'bacen'::text AS schema,
    'unmasked'::text AS tabela,
    count(*) AS qtde,
	max(unmasked."data_posicao") AS ultima_data_referencia,
    max(unmasked.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM bacen.unmasked
  WHERE unmasked.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'bacen'::text AS schema,
    'unmasked_cdi'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_cdi."data_posicao") AS ultima_data_referencia,
    max(unmasked_cdi.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM bacen.unmasked_cdi
  WHERE unmasked_cdi.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)

  
UNION ALL

SELECT 'interno'::text AS schema,
       'unmasked_meta_assessor_email'::text AS tabela,
       COUNT(*) AS qtde,
       '1900-01-01'::date AS ultima_data_referencia,
       MAX(unmasked_meta_assessor_email.data_extracao)::timestamp AS ultima_data_extracao
FROM interno.unmasked_meta_assessor_email
WHERE unmasked_meta_assessor_email.data_extracao::timestamp >= (CURRENT_DATE - interval '90 days')

UNION ALL

SELECT 'interno'::text AS schema,
       'int_de_para_cliente_assessor'::text AS tabela,
       COUNT(*) AS qtde,
       '1900-01-01'::date AS ultima_data_referencia,
       MAX(int_de_para_cliente_assessor.data_extracao)::timestamp AS ultima_data_extracao
FROM interno.int_de_para_cliente_assessor
WHERE int_de_para_cliente_assessor.data_extracao::timestamp >= (CURRENT_DATE - interval '90 days')

UNION ALL

SELECT 'interno'::text AS schema,
       'unmasked_debentures_mercado_secundario'::text AS tabela,
       COUNT(*) AS qtde,
       MAX(unmasked_debentures_mercado_secundario."data")::date AS ultima_data_referencia,
       MAX(unmasked_debentures_mercado_secundario.data_extracao)::timestamp AS ultima_data_extracao
FROM interno.unmasked_debentures_mercado_secundario
WHERE unmasked_debentures_mercado_secundario.data_extracao::timestamp >= (CURRENT_DATE - interval '90 days')

  
UNION ALL

 SELECT 'interno'::text AS schema,
    'unmasked_de_para_cliente_assessor'::text AS tabela,
    count(*) AS qtde,
	'1900-01-01' AS  ultima_data_referencia,
    max(unmasked_de_para_cliente_assessor.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM interno.unmasked_de_para_cliente_assessor
  WHERE unmasked_de_para_cliente_assessor.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)

UNION ALL

 SELECT 'interno'::text AS schema,
    'unmasked_comissao_bankers'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_comissao_bankers."data_referencia") AS ultima_data_referencia,
    max(unmasked_comissao_bankers.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM interno.unmasked_comissao_bankers
  WHERE unmasked_comissao_bankers.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)

  
UNION ALL

 SELECT 'interno'::text AS schema,
    'unmasked_comissao_solutions'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_comissao_solutions."data_referencia") AS ultima_data_referencia,
    max(unmasked_comissao_solutions.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM interno.unmasked_comissao_solutions
  WHERE unmasked_comissao_solutions.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
 
UNION ALL

 SELECT 'vortx'::text AS schema,
    'unmasked_carteira_json'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_carteira_json."dataAtual")::timestamp without time zone AS ultima_data_ultima,
    max(unmasked_carteira_json.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_carteira_json
  WHERE unmasked_carteira_json.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'vortx'::text AS schema,
    'unmasked_carteira_json_ativos'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_carteira_json_ativos.data_atual)::timestamp without time zone AS ultima_data_referencia,
    max(unmasked_carteira_json_ativos.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_carteira_json_ativos
  WHERE unmasked_carteira_json_ativos.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'vortx'::text AS schema,
    'unmasked_carteira_extrato_bancario_fundo'::text AS tabela,
    count(*) AS qtde,
	'1900-01-01' AS  ultima_data_referencia,
    max(unmasked_carteira_extrato_bancario_fundo.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_carteira_extrato_bancario_fundo
  WHERE unmasked_carteira_extrato_bancario_fundo.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
UNION ALL
 SELECT 'vortx'::text AS schema,
    'unmasked_listagem_cotas'::text AS tabela,
    count(*) AS qtde,
	'1900-01-01' AS  ultima_data_referencia,
    max(unmasked_listagem_cotas.data_extracao) AS ultima_data_extracao
  FROM vortx.unmasked_listagem_cotas
  WHERE unmasked_listagem_cotas.data_extracao >= (CURRENT_DATE - '90 days'::interval)
UNION ALL
 SELECT 'vortx'::text AS schema,
    'unmasked_relatorio_estoque'::text AS tabela,
    count(*) AS qtde,
	MAX("DataAquisicao") AS  ultima_data_referencia,
    max(unmasked_relatorio_estoque.data_extracao)::timestamp without time zone AS ultima_data_extracao
  FROM vortx.unmasked_relatorio_estoque
  WHERE unmasked_relatorio_estoque.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'vortx'::text AS schema,
    'unmasked_carteira_posicoes_cotistas'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_carteira_posicoes_cotistas.data_posicao)::timestamp without time zone AS ultima_data_referencia,
    max(unmasked_carteira_posicoes_cotistas.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_carteira_posicoes_cotistas
  WHERE unmasked_carteira_posicoes_cotistas.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'vortx'::text AS schema,
    'unmasked_relatorio_aquisicao'::text AS tabela,
    count(*) AS qtde,
	MAX("DataAquisicao") AS ultima_data_referencia,
    max(unmasked_relatorio_aquisicao.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_relatorio_aquisicao
  WHERE unmasked_relatorio_aquisicao.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)

UNION ALL
 SELECT 'vortx'::text AS schema,
    'unmasked_relatorio_liquidacao'::text AS tabela,
    count(*) AS qtde,
	'1900-01-01' AS ultima_data_referencia,
    max(unmasked_relatorio_liquidacao.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_relatorio_liquidacao
  WHERE unmasked_relatorio_liquidacao.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)

UNION ALL
 SELECT 'vortx'::text AS schema,
    'unmasked_carteira_json_cotas'::text AS tabela,
    count(*) AS qtde,
	 max(unmasked_carteira_json_cotas.data_extracao)::timestamp without time zone AS ultima_data_referencia,
    max(unmasked_carteira_json_cotas.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_carteira_json_cotas
  WHERE unmasked_carteira_json_cotas.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)

  
UNION ALL

 SELECT 'vortx'::text AS schema,
    'unmasked_carteira_json_carteiras'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_carteira_json_carteiras.data_atual)::timestamp without time zone AS ultima_data_referencia,
    max(unmasked_carteira_json_carteiras.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_carteira_json_carteiras
  WHERE unmasked_carteira_json_carteiras.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval)
  
UNION ALL

 SELECT 'vortx'::text AS schema,
    'unmasked_carteira_json_passivos'::text AS tabela,
    count(*) AS qtde,
	max(unmasked_carteira_json_passivos.data_atual)::timestamp without time zone AS ultima_data_referencia,
    max(unmasked_carteira_json_passivos.data_extracao)::timestamp without time zone AS ultima_data_extracao
   FROM vortx.unmasked_carteira_json_passivos
  WHERE unmasked_carteira_json_passivos.data_extracao::timestamp without time zone >= (CURRENT_DATE - '90 days'::interval);

ALTER TABLE monitoramento.vw_monitoramento_data_extracao
    OWNER TO netz_admin;


