CREATE OR REPLACE TABLE PROCEDURE `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_GRPABL` () 
BEGIN
		DELETE FROM `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_GRPABL` WHERE 1=1;

		INSERT INTO `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_GRPABL`
		(ZCODABL, ZGRABL, CDGRPABL, DSGRPABL, CHANGE_TIME)
		SELECT
		 ZCODABL, ZGRABL, CDGRPABL, DSGRPABL, CURRENT_TIMESTAMP() AS CHANGE_TIME
		FROM `also-analytics-model-prod.2_NEGOCIO_S4.TF_GRPABL_4B`();

END;