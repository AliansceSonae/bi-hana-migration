CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_VENDA_MENSAL_4B`(IP_COMPETEC STRING) 
AS (
declare IP_COMPETEC STRING;
SET IP_COMPETEC = '202204';

WITH var_competec_atual AS (
		SELECT CALMONTH
		FROM `also-analytics-model-nonprod.1_AQUISICAO_MXM.dm_tempo_mensal`
        WHERE CALMONTH <> '000000' AND
		PARSE_DATE('%Y%m', CALMONTH) BETWEEN DATE_SUB(PARSE_DATE('%Y%m%d', CONCAT(IP_COMPETEC, '01')), INTERVAL 1 YEAR) 
        AND PARSE_DATE('%Y%m%d', CONCAT(IP_COMPETEC, '01'))
)
, var_maior_venda AS (
        SELECT 
            INTRENO_VICNCN,
            CALMONTH,
            MAX(INTRENO_ECC)					AS INTRENO_ECC,
            MAX(CSHP_CDCONTRATO_MXM)			AS CSHP_CDCONTRATO_MXM,
            MAX(CC_CDCONTRATO)				    AS CC_CDCONTRATO,
            MAX(XMETXT)						    AS XMETXT,
            MAX(SMENR)						    AS SMENR,
            MAX(RECNTXT)						AS RECNTXT,
            MAX(ZZNMFAN)						AS ZZNMFAN,
            MAX(FQMFLART)						AS FQMFLART,
            MAX(CC_FQMFLART_SONAE)			    AS CC_FQMFLART_SONAE,
            SUM(CC_VOLVED)                      AS CC_VOLVED, 
            SUM(CC_VOLVED_COM_FQMFLART)         AS CC_VOLVED_COM_FQMFLART,
            SUM(CC_FQMFLART_COM_VOLVED)         AS CC_FQMFLART_COM_VOLVED,
            SUM(GROSS_SALES_AUD_FIS)            AS GROSS_SALES_AUD_FIS,
            SUM(GROSS_SALES_REDU_Z)             AS GROSS_SALES_REDU_Z,
            SUM(GROSS_SALES_PROJET)             AS GROSS_SALES_PROJET,
            SUM(NET_SALES_INTRAMALL)            AS NET_SALES_INTRAMALL,
            SUM(GROSS_SALES_INTRAMALL)          AS GROSS_SALES_INTRAMALL,
            SUM(NET_SALES)                      AS NET_SALES,
            SUM(GROSS_SALES)                    AS GROSS_SALES
		FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_DIARIA`
        WHERE DATE_TRUNC(RPDATE, MONTH) = PARSE_DATE('%Y%m%d', IP_COMPETEC || '01')
		GROUP BY
			INTRENO_VICNCN,
			CALMONTH
)
, var_venda AS (
		SELECT 
			VENDA.INTRENO_VICNCN,
			VENDA.INTRENO_ECC,
			VENDA.CSHP_CDCONTRATO_MXM,
			VENDA.CC_CDCONTRATO,
			VENDA.CALMONTH,
            FORMAT_DATE('%Y%m%d', DATE_SUB(PARSE_DATE('%Y%m%d', VENDA.CALMONTH || '01'), INTERVAL 1 YEAR)) AS CALMONTH_ADD_YEAR,
			VENDA.XMETXT,
			VENDA.SMENR,
			VENDA.RECNTXT,
			VENDA.ZZNMFAN,
			TEMPO.CALMONTH_PREVIOUS AS CALMONTH_ANT,
			VENDA.FQMFLART,
			VENDA.CC_FQMFLART_SONAE,
			VENDA.NET_SALES,
			VENDA.GROSS_SALES,
			VENDA.CC_VOLVED,
            VENDA.GROSS_SALES_AUD_FIS,
            VENDA.GROSS_SALES_REDU_Z,
            VENDA.GROSS_SALES_PROJET,
            VENDA.NET_SALES_INTRAMALL,
            VENDA.GROSS_SALES_INTRAMALL,
			CASE WHEN CC_FQMFLART_SONAE	= 0 THEN 0 ELSE 1 END AS FLAG_FQMFLART_ZERO,
			CASE WHEN CC_VOLVED			= 0 THEN 0 ELSE 1 END AS FLAG_VOLVED_ZERO
		FROM var_maior_venda AS VENDA
		LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_MXM.dm_tempo_mensal` AS TEMPO
			ON TEMPO.CALMONTH = VENDA.CALMONTH
        INNER JOIN var_competec_atual AS COMPETEC_ATUAL
            ON COMPETEC_ATUAL.CALMONTH = VENDA.CALMONTH
        ORDER BY CALMONTH
)	
, var_venda_atual_anterior AS (
    SELECT
        CONTR.CSHP_CDSHOPPING																AS CSHP_CDSHOPPING,
        CONTR.BUKRS 																		AS BUKRS,
        CONTR.INTRENO_VICNCN																AS INTRENO_VICNCN,
        CONTR.INTRENO																		AS CSHP_CDCONTRATO,
        CONTR.INTRENO																		AS INTRENO,
        CONTR.INTRENO_ECC																	AS INTRENO_ECC,
        CONTR.CSHP_CDCONTRATO_MXM															AS CSHP_CDCONTRATO_MXM,
        CONTR.CC_CDCONTRATO 																AS CC_CDCONTRATO,
        VENDA_ATUAL.CALMONTH				AS CALMONTH,
        IFNULL(VENDA_ATUAL.FQMFLART, CONTR.FQMFLART)									AS FQMFLART,
        CONTR.CDTPAQUISICAO																	AS CDTPAQUISICAO,
        IFNULL(VENDA_ATUAL.SMENR, CONTR.SMENR)											AS SMENR,
        IFNULL(VENDA_ATUAL.XMETXT, CONTR.XMETXT)										AS XMETXT,
        CONTR.ZZGRPAT_BR																	AS ZZGRPAT_BR,
        CONTR.ZZSUGRP_BR																	AS ZZSUGRP_BR,
        CONTR.ZZATIVM_BR																	AS ZZATIVM_BR,
        CONTR.SNUNR 																		AS SNUNR,
        CONTR.CC_CDGRUPOABL 																AS CC_CDGRUPOABL,
        CONTR.CDTIPOUNL 																	AS CDTIPOUNL,
        CONTR.KEY_GRPABRASCE																AS KEY_GRPABRASCE,
        CONTR.KEY_ATVABRASCE																AS KEY_ATVABRASCE,
        IFNULL(VENDA_ATUAL.ZZNMFAN, CONTR.ZZNMFAN) 										AS ZZNMFAN,
        IFNULL(VENDA_ATUAL.RECNTXT, CONTR.RECNTXT) 										AS RECNTXT,
        IFNULL(VENDA_ATUAL.CC_VOLVED, 0)													AS CC_VOLVED,
        IFNULL(VENDA_ATUAL.CC_FQMFLART_SONAE, CONTR.CC_FQMFLART_SONAE)					AS CC_FQMFLART_SONAE,
        IFNULL(VENDA_ATUAL.CC_VOLVED * VENDA_ATUAL.FLAG_FQMFLART_ZERO, 0)				AS CC_VOLVED_COM_FQMFLART,
        IFNULL(VENDA_ATUAL.CC_FQMFLART_SONAE * VENDA_ATUAL.FLAG_VOLVED_ZERO, 0)			AS CC_FQMFLART_COM_VOLVED,
        VENDA_ATUAL.GROSS_SALES_AUD_FIS,
        VENDA_ATUAL.GROSS_SALES_REDU_Z,
        VENDA_ATUAL.GROSS_SALES_PROJET,
        VENDA_ATUAL.NET_SALES_INTRAMALL,
        VENDA_ATUAL.GROSS_SALES_INTRAMALL,
        IFNULL(VENDA_ATUAL.NET_SALES, 0)													AS NET_SALES,
        IFNULL(VENDA_ATUAL.GROSS_SALES, 0)													AS GROSS_SALES
    FROM (
        SELECT INTRENO_VICNCN FROM var_venda GROUP BY INTRENO_VICNCN
    ) AS TODOS
    LEFT OUTER JOIN var_venda AS VENDA_ATUAL
        ON  VENDA_ATUAL.INTRENO_VICNCN = TODOS.INTRENO_VICNCN
    LEFT OUTER JOIN `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONTRATO` AS CONTR
        ON CONTR.INTRENO_VICNCN = TODOS.INTRENO_VICNCN
)

    SELECT
        CSHP_CDSHOPPING,
        BUKRS,
        INTRENO_VICNCN,
        CSHP_CDCONTRATO,
        INTRENO,
        INTRENO_ECC,
        CSHP_CDCONTRATO_MXM,
        CC_CDCONTRATO,
        CALMONTH,
        MAX(FQMFLART) 					AS FQMFLART,
        CDTPAQUISICAO,
        SMENR,
        XMETXT,
        ZZGRPAT_BR,
        ZZSUGRP_BR,
        ZZATIVM_BR,
        SNUNR,
        CC_CDGRUPOABL,
        CDTIPOUNL,
        KEY_GRPABRASCE,
        KEY_ATVABRASCE,
        ZZNMFAN,
        RECNTXT,
        SUM(CC_VOLVED)					AS CC_VOLVED,
        MAX(CC_FQMFLART_SONAE)			AS CC_FQMFLART_SONAE,
        SUM(CC_VOLVED_COM_FQMFLART)		AS CC_VOLVED_COM_FQMFLART,
        SUM(CC_FQMFLART_COM_VOLVED)		AS CC_FQMFLART_COM_VOLVED,
        SUM(GROSS_SALES_AUD_FIS) AS GROSS_SALES_AUD_FIS,
        SUM(GROSS_SALES_REDU_Z) AS GROSS_SALES_REDU_Z,
        SUM(GROSS_SALES_PROJET) AS GROSS_SALES_PROJET,
        SUM(NET_SALES_INTRAMALL) AS NET_SALES_INTRAMALL,
        SUM(GROSS_SALES_INTRAMALL) AS GROSS_SALES_INTRAMALL,
        SUM(NET_SALES)					AS NET_SALES,
        SUM(GROSS_SALES)				AS GROSS_SALES
    FROM var_venda_atual_anterior
    GROUP BY
        CSHP_CDSHOPPING,
        BUKRS,
        INTRENO_VICNCN,
        CSHP_CDCONTRATO,
        INTRENO,
        INTRENO_ECC,
        CSHP_CDCONTRATO_MXM,
        CC_CDCONTRATO,
        CALMONTH,
        CDTPAQUISICAO,
        SMENR,
        XMETXT,
        ZZGRPAT_BR,
        ZZSUGRP_BR,
        ZZATIVM_BR,
        SNUNR,
        CC_CDGRUPOABL,
        CDTIPOUNL,
        KEY_GRPABRASCE,
        KEY_ATVABRASCE,
        ZZNMFAN,
        RECNTXT
);