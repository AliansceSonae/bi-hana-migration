CREATE OR REPLACE PROCEDURE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.PARCELAMENTO` () 
OPTIONS(strict_mode=false)
BEGIN
	
    CREATE OR REPLACE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.PARCELAMENTO`
    AS
    SELECT *, CURRENT_TIMESTAMP() AS CHANGE_TIME FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_PARCELAMENTO_4B`();
END;