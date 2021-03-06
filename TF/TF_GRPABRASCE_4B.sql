CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_GRPABRASCE_4B`() AS (
WITH var_abrasce AS (
    SELECT
        ZCODABRASCE,
        ZGRABRASCE
    FROM
        `also-analytics-model-nonprod.1_AQUISICAO_S4.ztre002_abrasce`
    UNION 
    ALL
    SELECT
        '98' AS ZCODABRASCE,
        'ESTACIONAMENTO' AS ZGRABRASCE
    UNION 
    ALL
    SELECT
        '99' AS ZCODABRASCE,
        'OUTROS' AS ZGRABRASCE
)
SELECT
    'S4' || '-' || SHOPPING.CSHP_CDSHOPPING || '-' || ABRASCE.ZCODABRASCE AS KEY_GRPABRASCE,
    SHOPPING.CSHP_CDSHOPPING AS SHP_CDSHOPPING,
    ABRASCE.ZCODABRASCE AS ZCODABRASCE,
    ABRASCE.ZGRABRASCE AS GRA_DSGRUPO,
    ABRASCE.ZGRABRASCE AS ZGRABRASCE,
    1 AS CONTADOR
FROM
    var_abrasce AS ABRASCE
    CROSS JOIN (
        SELECT
            SHP_CDSHOPPING AS CSHP_CDSHOPPING
        FROM
            `also-analytics-model-nonprod.1_AQUISICAO_MXM.dm_shopping_as`
        WHERE
            SHP_CDSHOPPING <> '00001'
        GROUP BY
            SHP_CDSHOPPING
    ) AS SHOPPING
);