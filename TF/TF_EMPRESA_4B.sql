CREATE OR REPLACE TABLE FUNCTION`also-analytics-model-prod.2_NEGOCIO_S4.TF_EMPRESA_4B` () AS

WITH var_empresa_grupo AS (
    SELECT
        BUKRSF AS BUKRS, 
        MAX(CSHP_CDSHOPPING) AS CSHP_CDSHOPPING
    FROM `also-analytics-model-prod.2_NEGOCIO_S4.TF_EMPRESA_GRUPO_4B` ()
    GROUP BY
        BUKRSF
)	 	 

SELECT
    T001.BUKRS,
    T001.BUTXT,
    T001.ORT01,
    MAP.CSHP_CDSHOPPING
FROM `also-analytics-model-prod.1_AQUISICAO_S4.t001` AS T001
LEFT OUTER JOIN var_empresa_grupo AS MAP
    ON T001.BUKRS = MAP.BUKRS
WHERE LAND1   = 'BR'
    AND XTEMPLT = ''