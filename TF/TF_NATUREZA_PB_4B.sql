CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-prod.2_NEGOCIO_S4.TF_NATUREZA_PB_4B`() AS

SELECT
    '1' AS CONST,
    T1.ZENATPB
FROM
    (
        SELECT
            CASE
                WHEN ZZCLASS_ZNATPB IS NULL THEN 'OUTROS'
                WHEN ZZCLASS_ZNATPB = '' THEN 'OUTROS'
                ELSE UPPER(ZZCLASS_ZNATPB)
            END AS ZENATPB
        FROM
            `also-analytics-model-prod.1_AQUISICAO_S4.vicncn`
    ) AS T1
GROUP BY
    T1.ZENATPB
ORDER BY
    T1.ZENATPB