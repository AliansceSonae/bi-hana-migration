CREATE OR REPLACE TABLE PROCEDURE `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_UNIDADE_HIST` () 

BEGIN
		DELETE FROM `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_UNIDADE_HIST` WHERE 1=1;


		INSERT INTO `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_UNIDADE_HIST`
		(INTRENO_VICNCN,INTRENO_VIBDRO,CALMONTH,FQMFLART,FQMFLART_STR,FEINS,CHANGE_TIME)
		SELECT
		INTRENO_VICNCN,INTRENO_VIBDRO,CALMONTH,FQMFLART,FQMFLART_STR,FEINS,CURRENT_TIMESTAMP() AS CHANGE_TIME
		FROM `also-analytics-model-prod.2_NEGOCIO_S4.TF_UNIDADE_HIST_4B` ();

END;
