CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-prod.2_NEGOCIO_S4.TF_EMPRESA_GRUPO_4B` () AS 
WITH var_empresa_grupo AS (
    SELECT
        MANDT,
        BUKRS,
        BUKRSF,
        FLOWTYPECNDS,
        SWENR,
        PRCTR,
        CASE
            WHEN SWENR = 'BBA' THEN 'SNB'
            WHEN SWENR = 'BBE' THEN 'BBE'
            WHEN SWENR = 'BBH' THEN 'BBH'
            WHEN SWENR = 'BBR' THEN 'BBR'
            WHEN SWENR = 'BCA' THEN 'BCA'
            WHEN SWENR = 'BLS' THEN 'SH11'
            WHEN SWENR = 'BSC' THEN 'BSC'
            WHEN SWENR = 'BVV' THEN 'BVV'
            WHEN SWENR = 'CAS' THEN 'CAS'
            WHEN SWENR = 'CAX' THEN 'CAX'
            WHEN SWENR = 'FRA' THEN 'SH04'
            WHEN SWENR = 'MAN' THEN 'SH10'
            WHEN SWENR = 'MTR' THEN 'SH02'
            WHEN SWENR = 'PAS' THEN 'SH12'
            WHEN SWENR = 'PDP' THEN 'SH06'
            WHEN SWENR = 'PSB' THEN 'PSB'
            WHEN SWENR = 'PSM' THEN 'PSM'
            WHEN SWENR = 'PSS' THEN 'SH08'
            WHEN SWENR = 'REC' THEN 'REC'
            WHEN SWENR = 'SBA01' THEN 'NAC'
            WHEN SWENR = 'SBA02' THEN 'RIG'
            WHEN SWENR = 'SCL' THEN 'SH09'
            WHEN SWENR = 'SGR' THEN 'SGR'
            WHEN SWENR = 'SLB' THEN 'SLB'
            WHEN SWENR = 'SPG' THEN 'SPG'
            WHEN SWENR = 'SPS' THEN 'SPS'
            WHEN SWENR = 'STB' THEN 'TDS'
            WHEN SWENR = 'SWP' THEN 'SWP'
            WHEN SWENR = 'UBE' THEN 'SH13'
            WHEN SWENR = 'VPS' THEN 'VPS'
            ELSE SWENR
        END AS CSHP_CDSHOPPING
    FROM
        `also-analytics-model-prod.1_AQUISICAO_S4.ztfi001_mpf`
),
var_cepct_max AS (
    SELECT
        Q1.SPRAS,
        Q1.PRCTR,
        Q1.DATBI,
        MAX(Q1.KOKRS) AS KOKRS
    FROM
        `also-analytics-model-prod.1_AQUISICAO_S4.cepct` AS Q1
        INNER JOIN (
            SELECT
                SPRAS,
                PRCTR,
                MAX(DATBI) AS DATBI
            FROM
                `also-analytics-model-prod.1_AQUISICAO_S4.cepct`
            WHERE
                SPRAS = 'P'
            GROUP BY
                SPRAS,
                PRCTR
        ) AS Q2 ON Q1.SPRAS = Q2.SPRAS
        AND Q1.PRCTR = Q2.PRCTR
        AND Q1.DATBI = Q2.DATBI
    GROUP BY
        Q1.SPRAS,
        Q1.PRCTR,
        Q1.DATBI
),
var_cepct AS (
    SELECT
        Q1.PRCTR,
        Q1.LTEXT
    FROM
        `also-analytics-model-prod.1_AQUISICAO_S4.cepct` AS Q1
        INNER JOIN var_cepct_max AS Q2 ON Q1.SPRAS = Q2.SPRAS
        AND Q1.PRCTR = Q2.PRCTR
        AND Q1.DATBI = Q2.DATBI
        AND Q1.KOKRS = Q2.KOKRS
    GROUP BY
        Q1.PRCTR,
        Q1.LTEXT
)
SELECT
    GRUPO.BUKRS,
    GRUPO.BUKRSF,
    EMP1.BUTXT AS BUKRS_TEXT,
    EMP2.BUTXT AS BUKRSF_TEXT,
    GRUPO.FLOWTYPECNDS,
    FLOW.XFLOWTYPE,
    GRUPO.SWENR,
    GRUPO.PRCTR,
    CEPCT.LTEXT,
    GRUPO.CSHP_CDSHOPPING
FROM
    var_empresa_grupo AS GRUPO
    LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.t001` AS EMP1 ON EMP1.MANDT = GRUPO.MANDT
    AND EMP1.BUKRS = GRUPO.BUKRS
    LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.t001` AS EMP2 ON EMP2.MANDT = GRUPO.MANDT
    AND EMP2.BUKRS = GRUPO.BUKRSF
    LEFT OUTER JOIN var_cepct AS CEPCT ON CEPCT.PRCTR = GRUPO.PRCTR
    LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.tivcdflowtypet` AS FLOW ON FLOW.FLOWTYPE = GRUPO.FLOWTYPECNDS
    AND FLOW.SPRAS = 'P'