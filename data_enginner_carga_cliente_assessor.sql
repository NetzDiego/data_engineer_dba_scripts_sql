-- PROCEDURE: interno.sp_carrega_int_de_para_cliente_assessor()

-- DROP PROCEDURE IF EXISTS interno.sp_carrega_int_de_para_cliente_assessor();

CREATE OR REPLACE PROCEDURE interno.sp_carrega_int_de_para_cliente_assessor()
LANGUAGE 'plpgsql'
AS $BODY$

BEGIN 
INSERT  INTO  interno.unmasked_de_para_cliente_assessor  ("Nome assessor",
                                                     "Data de Início",
													 "Nova Meta diária",
													 "Nova Meta Mensal",
													 "Meta anual",
													 "Email",
													 "Classificação",
													 "Tipo assessor",
													 "data_extracao",
													 "id")

SELECT                                               I."Nome assessor",
                                                     I."Data de Início",
													 I."Nova Meta diária",
													 I."Nova Meta Mensal",
													 I."Meta anual",
													 I."Email",
													 I."Classificação",
													 I."Tipo assessor",
													 I."data_extracao",
													 I."id"
FROM          interno.unmasked_meta_assessor_email        AS I
LEFT JOIN     interno.unmasked_de_para_cliente_assessor  AS ICA           ON  ICA.id = I.id 
WHERE         ICA.id  IS NULL;
END;
$BODY$;
ALTER PROCEDURE interno.sp_carrega_int_de_para_cliente_assessor()
    OWNER TO netz_admin;
