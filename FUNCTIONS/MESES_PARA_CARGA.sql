CREATE OR REPLACE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.MESES_PARA_CARGA`() RETURNS ARRAY<STRING> AS (
(
        ARRAY (SELECT
          dates.CALMONTH
        FROM (
          SELECT
            FORMAT_DATE('%Y%m', CURRENT_DATE()) AS CALMONTH
          UNION ALL
          SELECT
            MAX(FRYE1) || RIGHT(MAX(FRPE1), 2) AS CALMONTH
          FROM
            `also-analytics-model-nonprod.1_AQUISICAO_S4.t001b`
          WHERE
            MKOAR = '+'
          UNION ALL
          SELECT
            MAX(FRYE2) || RIGHT(MAX(FRPE2), 2) AS CALMONTH
          FROM
            `also-analytics-model-nonprod.1_AQUISICAO_S4.t001b`
          WHERE
            MKOAR = '+'
          UNION ALL
          SELECT
            MAX(FRYE3) || RIGHT(MAX(FRPE3), 2) AS CALMONTH
          FROM
            `also-analytics-model-nonprod.1_AQUISICAO_S4.t001b`
          WHERE
            MKOAR = '+'
          UNION ALL
          SELECT
            '202206' AS CALMONTH ) AS dates
    INNER JOIN
      `also-analytics-model-nonprod.1_AQUISICAO_MXM.dm_tempo_mensal` dm_tempo
    ON
      dates.CALMONTH = dm_tempo.CALMONTH
    WHERE
      dates.CALMONTH <> '000000'
    GROUP BY
      dates.CALMONTH
    ORDER BY
      dates.CALMONTH ))
);