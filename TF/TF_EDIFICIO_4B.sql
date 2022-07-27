CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-prod.2_NEGOCIO_S4.TF_EDIFICIO_4B` ()
AS

WITH var_vibdbu AS (
    SELECT
        MANDT,
        BUKRS,
        INTRENO AS INTRENO_VIBDBU,
        SWENR,
        SGENR,
        OBJNR,
        IMKEY,
        XGETXT,
        RGEBART,
        BANZGE,
        AUGESCH,
        VALIDFROM,
        VALIDTO
    FROM `also-analytics-model-prod.1_AQUISICAO_S4.vibdbu`
)
            
,var_unid_econ AS (
    SELECT
        A.INTRENO_VIBDBE,
        A.BUKRS,
        A.SWENR,
        A.CSHP_CDSHOPPING
    FROM `also-analytics-model-prod.2_NEGOCIO_S4.TF_UNIDADE_ECONOMICA_4B` AS A
    INNER JOIN (
                    SELECT
                        MAX(INTRENO_VIBDBE) AS INTRENO_VIBDBE,
                        BUKRS,
                        SWENR
                    FROM `also-analytics-model-prod.2_NEGOCIO_S4.TF_UNIDADE_ECONOMICA_4B`
                    GROUP BY 	
                        BUKRS,
                        SWENR
                ) AS B
    ON A.INTRENO_VIBDBE = B.INTRENO_VIBDBE
)

SELECT
    VIBDBU.BUKRS,
    VIBDBU.INTRENO_VIBDBU,
    UNID_ECON.INTRENO_VIBDBE,
    VIBDBU.SWENR,
    VIBDBU.SGENR,
    VIBDBU.OBJNR,
    VIBDBU.IMKEY,
    VIBDBU.XGETXT,
    VIBDBU.RGEBART,
    TIV5T.XKBEZ					AS RGEBART_TEXT15,
    TIV5T.XMBEZ 				AS RGEBART_TEXT30,
    VIBDBU.BANZGE,
    VIBDBU.AUGESCH,
    VIBDBU.VALIDFROM,
    VIBDBU.VALIDTO,
    VITMOA.GSBER,
    VITMOA.PRCTR,
    VITMOA.TXJCD,
    UNID_ECON.CSHP_CDSHOPPING
FROM var_vibdbu AS VIBDBU
LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.tiv5t` AS TIV5T
    ON 	TIV5T.MANDT   = VIBDBU.MANDT
    AND TIV5T.SOBJART = VIBDBU.RGEBART
    AND TIV5T.SPRAS   = 'P'
LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.vitmoa` AS VITMOA
    ON 	VITMOA.MANDT    = VIBDBU.MANDT
    AND VITMOA.INTRENO  = VIBDBU.INTRENO_VIBDBU
    AND VITMOA.TERMTYPE = '1120'
    AND VITMOA.VALIDTO  = '99991231'
LEFT OUTER JOIN var_unid_econ AS UNID_ECON
    ON  UNID_ECON.BUKRS = VIBDBU.BUKRS
    AND UNID_ECON.SWENR = VIBDBU.SWENR