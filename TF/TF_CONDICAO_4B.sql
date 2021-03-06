CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_CONDICAO_4B`() AS (
    SELECT
        T01.CONDTYPE,
        T02.XCONDTYPEM AS CONDTYPE_TEXT20,
        T02.XCONDTYPEL AS CONDTYPE_TEXT30,
        T01.CONDPROP,
        T04.XCONDPROP AS CONDPROP_TEXT,
        T01.FLOWTYPE,
        T06.XFLOWTYPE AS FLOWTYPE_TEXT,
        T05.SSOLHAB,
        CASE
            WHEN T05.SSOLHAB = 'H' THEN 'Cr?dito'
            WHEN T05.SSOLHAB = 'S' THEN 'D?bito'
        END AS SSOLHAB_TEXT,
        T01.CALCRULEEXT,
        T08.XSCALCRULE AS CALCRULEEXT_TEXT15,
        T08.XMCALCRULE AS CALCRULEEXT_TEXT30,
        T08.XLCALCRULE AS CALCRULEEXT_TEXT60,
        T01.DISTRULEEXT,
        T10.XSDISTRULE AS DISTRULEEXT_TEXT_15,
        T10.XMDISTRULE AS DISTRULEEXT_TEXT_30,
        T10.XLDISTRULE AS DISTRULEEXT_TEXT_60,
        T01.UNITPRICE
    FROM
        `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdcondtype` AS T01
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdcondtypet` AS T02 ON T02.MANDT = T01.MANDT
        AND T02.CONDTYPE = T01.CONDTYPE
        AND T02.SPRAS = 'P'
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdprop` AS T03 ON T03.CONDPROP = T01.CONDPROP
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdpropt` AS T04 ON T04.CONDPROP = T03.CONDPROP
        AND T04.SPRAS = 'P'
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdflowtype` AS T05 ON T05.MANDT = T01.MANDT
        AND T05.FLOWTYPE = T01.FLOWTYPE
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdflowtypet` AS T06 ON T06.MANDT = T05.MANDT
        AND T06.FLOWTYPE = T05.FLOWTYPE
        AND T06.SPRAS = 'P'
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdcalcext` AS T07 ON T07.MANDT = T01.MANDT
        AND T07.CALCRULEEXT = T01.CALCRULEEXT
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcdcalcextt` AS T08 ON T08.MANDT = T07.MANDT
        AND T08.CALCRULEEXT = T07.CALCRULEEXT
        AND T08.SPRAS = 'P'
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcddistext` AS T09 ON T09.MANDT = T01.MANDT
        AND T09.DISTRULEEXT = T01.DISTRULEEXT
        LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcddistextt` AS T10 ON T10.MANDT = T09.MANDT
        AND T10.DISTRULEEXT = T09.DISTRULEEXT
        AND T10.SPRAS = 'P'
    ORDER BY
        T01.CONDTYPE
);