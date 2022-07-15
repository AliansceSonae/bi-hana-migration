CREATE OR REPLACE PROCEDURE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NATUREZA_PB` () 
BEGIN

TRUNCATE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NATUREZA_PB`;

INSERT INTO
    `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NATUREZA_PB`(CODNATPB, ZENATPB, CHANGE_TIME)
SELECT
    ROW_NUMBER() OVER (
        PARTITION BY CONST
        ORDER BY
            ZENATPB
    ) AS CODNATPB,
    ZENATPB,
    CURRENT_TIMESTAMP()
FROM
    `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_NATUREZA_PB_4B`();
END