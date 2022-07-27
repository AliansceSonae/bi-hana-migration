CREATE OR REPLACE PROCEDURE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.SP_ETL_VENDA_MENSAL`(calmonth ARRAY<STRING>)
BEGIN
	
    FOR elem in (SELECT * FROM UNNEST(calmonth) as CALMONTH)
        DO
	    
	    DELETE FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_MENSAL`
			WHERE CALMONTH = elem.CALMONTH;
			--WHERE DATE_TRUNC(RPDATE, MONTH) = PARSE_DATE('%Y%m%d', elem.CALMONTH || '01');

		INSERT INTO `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_MENSAL`
			SELECT
				*,
				CURRENT_DATETIME('America/Sao_Paulo') AS CHANGE_TIME
			FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_VENDA_MENSAL_4B`(elem.CALMONTH);
		END FOR;
	
END;