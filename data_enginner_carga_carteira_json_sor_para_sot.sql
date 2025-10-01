-- PROCEDURE: vortx.sp_carga_vortx_api_carteira_json_sor_para_sot()

-- DROP PROCEDURE IF EXISTS vortx.sp_carga_vortx_api_carteira_json_sor_para_sot();

CREATE OR REPLACE PROCEDURE vortx.sp_carga_vortx_api_carteira_json_sor_para_sot(
	)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN 

WITH   vortx_api_carteira_json_sor
AS
(SELECT 		   						     REPLACE(REPLACE(REPLACE(COALESCE("dataAtual"::date::text, ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("cnpjFundo", ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("titulo", ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("categoria", ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("detalhes", ''), ' ', ''), '-', ''), '/', '') AS chave_forte,
                                             "dataAtual",
        									 "empresa",
		                                     "cnpjFundo",
		                                     "carteira",
		                                     "nome",
		                                     "nomeResumido",
		                                     "pl", 
		                                     "quantidadeCotas",
		                                     "valorCota",
		                                     "variacaoCota",
		                                     "tipoCondominio",
		                                     "tipoMoeda",
	                                       	 "tipoFundo",
											 "ultimaPosicao",
											 "status", 
											 "categoria",
											 "tipoRenda", 
											 "titulo",
											 "fundo", 
											 "cnpj",
											 "quantidade", 
											 "valorBruto",
										     "tributos",
											 "valorLiquido",
											 "isin", 
											 "despesa",
											 "detalhes",
											 "valor",
											 "tipo_passivo",
										     "plTotal_passivo",
											 "instituicao",
											 "saldo",
											 "id",
											 "data_extracao" 
FROM          vortx_api_carteira_json        AS  SOR),

vortx_api_carteira_json_sot
AS
(SELECT 		   							 REPLACE(REPLACE(REPLACE(COALESCE("data_atual"::text, ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("cnpj_fundo", ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("titulo", ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("categoria", ''), ' ', ''), '-', ''), '/', '') ||
                                             REPLACE(REPLACE(REPLACE(COALESCE("detalhes", ''), ' ', ''), '-', ''), '/', '') AS chave_forte,
                                             "data_atual",
        									 "empresa",
		                                     "cnpj_fundo",
		                                     "carteira",
		                                     "nome",
		                                     "nome_resumido",
		                                     "pl", 
		                                     "quantidade_cotas",
		                                     "valor_cota",
		                                     "variacao_cota",
		                                     "tipo_condominio",
		                                     "tipo_moeda",
	                                       	 "tipo_fundo",
											 "ultima_posicao",
											 "status", 
											 "categoria",
											 "tipo_renda", 
											 "titulo",
											 "fundo", 
											 "cnpj",
											 "quantidade", 
											 "valor_bruto",
										     "tributos",
											 "valor_liquido",
											 "isin", 
											 "despesa",
											 "detalhes",
											 "valor",
											 "tipo_passivo",
										     "pl_total_passivo",
											 "instituicao",
											 "saldo",
											 "id",
											 "data_extracao" 
FROM                   vortx.vortx_api_carteira_json         AS  SOT)

INSERT  INTO  vortx.vortx_api_carteira_json (data_atual,
                                             empresa,
											 cnpj_fundo,
											 carteira,
											 nome,
											 nome_resumido,
											 pl,
											 quantidade_cotas,
											 valor_cota,
											 variacao_cota,
											 tipo_condominio,
											 tipo_moeda,
											 tipo_fundo,
											 ultima_posicao, 
											 status,
											 categoria,
											 tipo_renda,
											 titulo, 
											 fundo,
											 cnpj,
											 quantidade,
											 valor_bruto,
											 tributos, 
											 valor_liquido,
											 isin,
											 despesa,
											 detalhes,
											 valor,
											 tipo_passivo,
											 pl_total_passivo,
											 instituicao,
											 saldo,
											 id_tab_sor,
											 data_extracao) 

SELECT 		   								 SOR."dataAtual",
        									 SOR."empresa",
		                                     SOR."cnpjFundo",
		                                     SOR."carteira",
		                                     SOR."nome",
		                                     SOR."nomeResumido",
		                                     SOR."pl", 
		                                     SOR."quantidadeCotas",
		                                     SOR."valorCota",
		                                     SOR."variacaoCota",
		                                     SOR."tipoCondominio",
		                                     SOR."tipoMoeda",
	                                       	 SOR."tipoFundo",
											 SOR."ultimaPosicao",
											 SOR."status", 
											 SOR."categoria",
											 SOR."tipoRenda", 
											 SOR."titulo",
											 SOR."fundo", 
											 SOR."cnpj",
											 SOR."quantidade", 
											 SOR."valorBruto",
										     SOR."tributos",
											 SOR."valorLiquido",
											 SOR."isin", 
											 SOR."despesa",
											 SOR."detalhes",
											 SOR."valor",
											 SOR."tipo_passivo",
										     SOR."plTotal_passivo",
											 SOR."instituicao",
											 SOR."saldo",
											 SOR."id",
											 SOR."data_extracao" 
FROM                   vortx_api_carteira_json_sor        AS  SOR
LEFT JOIN              vortx_api_carteira_json_sot        AS  SOT             ON    SOR.chave_forte = SOT.chave_forte
WHERE                  SOT.chave_forte  IS NULL;
END;
$BODY$;
ALTER PROCEDURE vortx.sp_carga_vortx_api_carteira_json_sor_para_sot()
    OWNER TO netz_admin;
