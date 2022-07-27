CREATE OR REPLACE PROCEDURE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.FAT_RE` () 
OPTIONS(strict_mode=false)
BEGIN
    CREATE OR REPLACE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.FAT_RE`
    AS
    SELECT
		*, CURRENT_TIMESTAMP() AS CHANGE_TIME
		FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_FAT_RE_4B` ();
END;
