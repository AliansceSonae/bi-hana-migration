CREATE OR REPLACE TABLE FUNCTION  `also-analytics-model-prod.2_NEGOCIO_S4.TF_GRPABL_4B` ()
AS

SELECT
    ZCODABL,
    ZGRABL,
    'S' || ZCODABL	AS CDGRPABL,
    LEFT(ZGRABL, 30)	AS DSGRPABL
FROM `also-analytics-model-prod.1_AQUISICAO_S4.ztre001_abl`