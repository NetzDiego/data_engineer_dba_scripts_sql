CREATE TABLE IF NOT EXISTS ot.unmasked_carteiras
(   id_tab           INT GENERATED ALWAYS AS IDENTITY  PRIMARY KEY,  
    carteira_id      INT,
    fundo            VARCHAR(50),
    quantidade       NUMERIC(20,2),
    valor            NUMERIC(20,2),
    valor_cota       NUMERIC(20,2),
    valor_bruto      NUMERIC(20,2),
    cnpj             CHAR(14),
    data_referencia  DATE,
    tipo_carteira    VARCHAR(30),
    codigo_cota      VARCHAR(50),
    classe           VARCHAR(30),
    valor_liquido    NUMERIC(20,2),
    id               VARCHAR(30),
    saldo            NUMERIC(20,2),
    tipo             VARCHAR(30),
    data_liquidacao_prevista DATE,
    descricao        VARCHAR(200),
    codigo           VARCHAR(20),
    data_extracao    DATE,
	id_tab_old       INT)



CREATE   PROCEDURE   sp_atualiza_sot_ot_carteira()
LANGUAGE plpgsql
AS  $$
BEGIN
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
    id_tab_old
)
SELECT
    SOR.carteira_id,
    SOR.fundo,
    SOR.quantidade,
    SOR.valor,
    SOR.valor_cota,
    SOR.valor_bruto,
    SOR.cnpj,
    TO_DATE(SOR.data_referencia, 'YYYY-MM-DD'),
    SOR.tipo_carteira,
    SOR.codigo_cota,
    SOR.classe,
    SOR.valor_liquido,
    SOR.id,
    SOR.saldo::numeric(20,2),
    SOR.tipo,
    TO_DATE(SOR.data_liquidacao_prevista, 'YYYY-MM-DD'),
    SOR.descricao,
    SOR.codigo,
    SOR.data_extracao,
    SOR.id_tab
FROM unmasked_carteiras AS SOR
LEFT JOIN ot.unmasked_carteiras AS SOT ON SOT.id_tab_old = SOR.id_tab
WHERE SOT.id_tab_old IS NULL;
END;
$$;



--Dados para serem inseridos, vem do excel do nicolas freire
INSERT INTO ot.unmasked_carteiras (
    carteira_id, fundo, quantidade, valor, valor_cota, valor_bruto, cnpj,
    data_referencia, tipo_carteira, codigo_cota, classe, valor_liquido,
    tipo, data_liquidacao_prevista, descricao, codigo, id, saldo, data_extracao
)
VALUES
-- 1
(79841, 'OT SOBERANO',
 REPLACE(REPLACE(REPLACE('R$ 297,21', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE(REPLACE('R$ 869.887,24', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE(REPLACE('R$ 2.926,80', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE(REPLACE('R$ 869.887,24', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 '59678384000149', TO_DATE('30/05/2025','DD/MM/YYYY'), 'fechamento',
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 2
(79841, 'EUD FICTOR MEZ 2',
 REPLACE(REPLACE(REPLACE('R$ 54.153,23', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE(REPLACE('R$ 56.212.592,61', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE(REPLACE('R$ 1.038,03', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE(REPLACE('R$ 56.212.592,61', 'R$ ', ''), '.', ''), ',', '.')::numeric,
 '59678384000149', TO_DATE('30/05/2025','DD/MM/YYYY'), 'fechamento',
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 3
(79841, NULL,
 REPLACE(REPLACE('37.928,20', '.', ''), ',', '.')::numeric,
 NULL,
 REPLACE(REPLACE('1.027,24', '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE('38.961.243,32', '.', ''), ',', '.')::numeric,
 '59678384000149', TO_DATE('30/05/2025','DD/MM/YYYY'), 'fechamento',
 NULL, 'NTZ SENIOR 1',
 REPLACE(REPLACE('38.961.243,32', '.', ''), ',', '.')::numeric,
 NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 4
(79841, NULL,
 REPLACE(REPLACE('3.500,00', '.', ''), ',', '.')::numeric,
 NULL,
 REPLACE(REPLACE('1.013,36', '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE('3.546.745,14', '.', ''), ',', '.')::numeric,
 '59678384000149', TO_DATE('30/05/2025','DD/MM/YYYY'), 'fechamento',
 NULL, 'NTZ MEZESP',
 REPLACE(REPLACE('3.546.745,14', '.', ''), ',', '.')::numeric,
 NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 5
(79841, NULL,
 REPLACE(REPLACE('13.838,51', '.', ''), ',', '.')::numeric,
 NULL,
 REPLACE(REPLACE('1.051,35', '.', ''), ',', '.')::numeric,
 REPLACE(REPLACE('14.549.178,26', '.', ''), ',', '.')::numeric,
 '59678384000149', TO_DATE('30/05/2025','DD/MM/YYYY'), 'fechamento',
 NULL, 'Subordinada',
 REPLACE(REPLACE('14.549.178,26', '.', ''), ',', '.')::numeric,
 NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 6
(NULL, NULL,
 REPLACE('13997,90704', ',', '.')::numeric,
 NULL,
 REPLACE('1065,613328', ',', '.')::numeric,
 REPLACE('14916356,3', ',', '.')::numeric,
 '59678384000149', TO_DATE('17/06/2025','DD/MM/YYYY'), 'fechamento',
 NULL, 'Subordinada',
 REPLACE('14916356,3', ',', '.')::numeric,
 NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 7
(NULL, NULL,
 REPLACE('3500', ',', '.')::numeric,
 NULL,
 REPLACE('1024,168674', ',', '.')::numeric,
 REPLACE('3584590,36', ',', '.')::numeric,
 '59678384000149', TO_DATE('17/06/2025','DD/MM/YYYY'), 'fechamento',
 NULL, 'NTZ MEZESP',
 REPLACE('3584590,36', ',', '.')::numeric,
 NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 8
(NULL, NULL,
 REPLACE('3500', ',', '.')::numeric,
 NULL,
 REPLACE('1000,811331', ',', '.')::numeric,
 REPLACE('3502839,66', ',', '.')::numeric,
 '59678384000149', TO_DATE('17/06/2025','DD/MM/YYYY'), 'fechamento',
 NULL, 'NTZ MEZ 1',
 REPLACE('3502839,66', ',', '.')::numeric,
 NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 9
(NULL, NULL,
 REPLACE('48991,89054', ',', '.')::numeric,
 NULL,
 REPLACE('1036,351115', ',', '.')::numeric,
 REPLACE('50772800,37', ',', '.')::numeric,
 '59678384000149', TO_DATE('17/06/2025','DD/MM/YYYY'), 'fechamento',
 NULL, 'NTZ SENIOR 1',
 REPLACE('50772800,37', ',', '.')::numeric,
 NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 10
(NULL, 'OT SOBERANO',
 REPLACE('325,6413066', ',', '.')::numeric,
 REPLACE('959229,3', ',', '.')::numeric,
 REPLACE('2945,662248', ',', '.')::numeric,
 REPLACE('959229,3', ',', '.')::numeric,
 '59678384000149', TO_DATE('17/06/2025','DD/MM/YYYY'), 'fechamento',
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY')),

-- 11
(NULL, 'EUD FICTOR MEZ 2',
 REPLACE('68446,83284', ',', '.')::numeric,
 REPLACE('71900795,33', ',', '.')::numeric,
 REPLACE('1050,461977', ',', '.')::numeric,
 REPLACE('71900795,33', ',', '.')::numeric,
 '59678384000149', TO_DATE('17/06/2025','DD/MM/YYYY'), 'fechamento',
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY'),
 NULL, NULL, NULL, NULL, TO_DATE('08/09/2025','DD/MM/YYYY'));




 
--Criação das extensão
CREATE EXTENSION IF NOT EXISTS dblink;

--Configuração de conexão
SELECT dblink_exec(
  'host=netz-database-server.postgres.database.azure.com dbname=sot user=netz_admin password=producao@3204!# sslmode=require',
  'CALL sp_atualiza_sot_ot_carteira();'
);

--Criação da Function para executar a View 
CREATE OR REPLACE FUNCTION atualiza_sot_ot_carteira()
RETURNS TEXT AS $$
BEGIN
  PERFORM dblink_exec(
    'host=netz-database-server.postgres.database.azure.com dbname=sot user=netz_admin password=producao@3204!# sslmode=require',
    'CALL sp_atualiza_sot_ot_carteira();'
  );
  RETURN 'tabela unmasked_carteira atualizada com sucesso!';
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'Erro ao atualizar a tabela unmasked_carteira: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


SELECT  * FROM atualiza_sot_ot_carteira()




