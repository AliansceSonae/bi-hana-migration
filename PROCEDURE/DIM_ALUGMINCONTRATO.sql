CREATE OR REPLACE TABLE PROCEDURE `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_ALUGMINCONTRATO` () 
	
BEGIN
		DELETE FROM `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_ALUGMINCONTRATO` WHERE 1=1;


		INSERT INTO `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_ALUGMINCONTRATO`
		(CSHP_CDSHOPPING, INTRENO_VICNCN, ROW_NUM, CC_VALIDFROM, CC_VALIDTO, CC_CONDVALUE, CHANGE_TIME)
		SELECT
		 CSHP_CDSHOPPING, INTRENO_VICNCN, ROW_NUM, CC_VALIDFROM, CC_VALIDTO, CC_CONDVALUE, CURRENT_TIMESTAMP() AS CHANGE_TIME
		FROM `also-analytics-model-prod.2_NEGOCIO_S4.TF_ALUGMINCONTRATO_4B`();
			
END;
