CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_VENDA_DIARIA_4B`() AS (
WITH var_venda_informada_max_dia_mes AS (
		SELECT
			CALMONTH,
			MAX(RPDATE) AS RPDATE,
			INTRENO_VICNCN,
			MAX(SALESTYPE) AS SALESTYPE
		FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_AUDITADA`
		GROUP BY 
			CALMONTH,
			INTRENO_VICNCN
),
								
var_venda_informada_attr AS (
		SELECT
			Q1.CSHP_CDSHOPPING,
			Q1.BUKRS,
			Q1.INTRENO_VICNCN,
			Q1.CSHP_CDCONTRATO,
			Q1.INTRENO,
			Q1.INTRENO_ECC,
			Q1.CSHP_CDCONTRATO_MXM,
			Q1.CC_CDCONTRATO,
			Q1.CALMONTH,
			MAX(Q1.CDTPAQUISICAO)		AS CDTPAQUISICAO,			
			MAX(Q1.ZZGRPAT_BR)			AS ZZGRPAT_BR,			
			MAX(Q1.ZZSUGRP_BR)			AS ZZSUGRP_BR,		
			MAX(Q1.ZZATIVM_BR)			AS ZZATIVM_BR,			
			MAX(Q1.SNUNR)				AS SNUNR,		
			MAX(Q1.CC_CDGRUPOABL)		AS CC_CDGRUPOABL,		
			MAX(Q1.CDTIPOUNL)			AS CDTIPOUNL,			
			MAX(Q1.KEY_GRPABRASCE)		AS KEY_GRPABRASCE,		
			MAX(Q1.KEY_ATVABRASCE)		AS KEY_ATVABRASCE,		
			MAX(Q1.XMETXT)				AS XMETXT,
			MAX(Q1.SMENR)				AS SMENR,
			MAX(Q1.RECNTXT)				AS RECNTXT,
			MAX(Q1.ZZNMFAN)				AS ZZNMFAN,
			MAX(Q1.FQMFLART)			AS FQMFLART,
			MAX(Q1.CC_FQMFLART_SONAE)	AS CC_FQMFLART_SONAE
		FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_AUDITADA` AS Q1
		INNER JOIN var_venda_informada_max_dia_mes AS Q2
			ON  Q2.CALMONTH       = Q1.CALMONTH
			AND Q2.RPDATE         = Q1.RPDATE
			AND Q2.INTRENO_VICNCN = Q1.INTRENO_VICNCN
			AND Q2.SALESTYPE      = Q1.SALESTYPE
		GROUP BY
			Q1.CSHP_CDSHOPPING,
			Q1.BUKRS,
			Q1.INTRENO_VICNCN,
			Q1.CSHP_CDCONTRATO,
			Q1.INTRENO,
			Q1.INTRENO_ECC,
			Q1.CSHP_CDCONTRATO_MXM,
			Q1.CC_CDCONTRATO,
			Q1.CALMONTH
),

var_venda_informada AS (
		SELECT
			VENDA.CSHP_CDSHOPPING,
			VENDA.BUKRS,
			VENDA.INTRENO_VICNCN,
			VENDA.CSHP_CDCONTRATO,
			VENDA.INTRENO,
			VENDA.INTRENO_ECC,
			VENDA.CSHP_CDCONTRATO_MXM,
			VENDA.CC_CDCONTRATO,
			VENDA.CALMONTH,
			VENDA.RPDATE,
			VENDA.SALESTYPE,
			MAX(ATTR.CDTPAQUISICAO) 		AS CDTPAQUISICAO,		
			MAX(ATTR.ZZGRPAT_BR)			AS ZZGRPAT_BR,
			MAX(ATTR.ZZSUGRP_BR)			AS ZZSUGRP_BR,
			MAX(ATTR.ZZATIVM_BR)			AS ZZATIVM_BR,
			MAX(ATTR.SNUNR) 				AS SNUNR,	
			MAX(ATTR.CC_CDGRUPOABL) 		AS CC_CDGRUPOABL,
			MAX(ATTR.CDTIPOUNL) 			AS CDTIPOUNL,
			MAX(ATTR.KEY_GRPABRASCE)		AS KEY_GRPABRASCE,
			MAX(ATTR.KEY_ATVABRASCE)		AS KEY_ATVABRASCE,
			MAX(ATTR.XMETXT)				AS XMETXT,
			MAX(ATTR.SMENR)					AS SMENR,
			MAX(ATTR.RECNTXT)				AS RECNTXT,
			MAX(ATTR.ZZNMFAN)				AS ZZNMFAN,
			MAX(ATTR.FQMFLART)				AS FQMFLART,
			MAX(ATTR.CC_FQMFLART_SONAE)		AS CC_FQMFLART_SONAE,
			SUM(VENDA.NET_SALES)			AS NET_SALES_INTRAMALL,
			SUM(VENDA.GROSS_SALES)			AS GROSS_SALES_INTRAMALL,
			SUM(VENDA.GROSS_SALES) 			AS CC_VOLVED_INTRAMALL
		FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_INTRAMALL` AS VENDA
		LEFT OUTER JOIN var_venda_informada_attr AS ATTR
			ON  ATTR.INTRENO_VICNCN      = VENDA.INTRENO_VICNCN
			AND ATTR.INTRENO_ECC         = VENDA.INTRENO_ECC
			AND ATTR.CSHP_CDCONTRATO_MXM = VENDA.CSHP_CDCONTRATO_MXM
			AND ATTR.CC_CDCONTRATO       = VENDA.CC_CDCONTRATO
			AND ATTR.CALMONTH  = VENDA.CALMONTH
		GROUP BY
			VENDA.CSHP_CDSHOPPING,
			VENDA.BUKRS,
			VENDA.INTRENO_VICNCN,
			VENDA.CSHP_CDCONTRATO,
			VENDA.INTRENO,
			VENDA.INTRENO_ECC,
			VENDA.CSHP_CDCONTRATO_MXM,
			VENDA.CC_CDCONTRATO,
			VENDA.CALMONTH,
			VENDA.RPDATE,
			VENDA.SALESTYPE
),		
-- Venda Auditada
var_venda_auditada_max_dia_mes AS (
		SELECT
			CALMONTH,
			MAX(RPDATE) AS RPDATE,
			INTRENO_VICNCN,
			MAX(SALESTYPE) AS SALESTYPE
		FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_AUDITADA`
		GROUP BY 
			CALMONTH,
			INTRENO_VICNCN
),
			
var_venda_auditada_attr AS (
		SELECT
			Q1.CSHP_CDSHOPPING,
			Q1.BUKRS,
			Q1.INTRENO_VICNCN,
			Q1.CSHP_CDCONTRATO,
			Q1.INTRENO,
			Q1.INTRENO_ECC,
			Q1.CSHP_CDCONTRATO_MXM,
			Q1.CC_CDCONTRATO,
			Q1.CALMONTH,
			MAX(Q1.CDTPAQUISICAO)		AS CDTPAQUISICAO,
			MAX(Q1.ZZGRPAT_BR)			AS ZZGRPAT_BR,
			MAX(Q1.ZZSUGRP_BR)			AS ZZSUGRP_BR,
			MAX(Q1.ZZATIVM_BR)			AS ZZATIVM_BR,
			MAX(Q1.SNUNR)				AS SNUNR,
			MAX(Q1.CC_CDGRUPOABL)		AS CC_CDGRUPOABL,
			MAX(Q1.CDTIPOUNL)			AS CDTIPOUNL,
			MAX(Q1.KEY_GRPABRASCE)		AS KEY_GRPABRASCE,
			MAX(Q1.KEY_ATVABRASCE)		AS KEY_ATVABRASCE,
			MAX(Q1.XMETXT)				AS XMETXT,
			MAX(Q1.SMENR)				AS SMENR,
			MAX(Q1.RECNTXT)				AS RECNTXT,
			MAX(Q1.ZZNMFAN)				AS ZZNMFAN,
			MAX(Q1.FQMFLART)			AS FQMFLART,
			MAX(Q1.CC_FQMFLART_SONAE)	AS CC_FQMFLART_SONAE
		FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_VENDA_AUDITADA_4B` () AS Q1
		INNER JOIN var_venda_auditada_max_dia_mes AS Q2
			ON  Q2.CALMONTH       = Q1.CALMONTH
			AND Q2.RPDATE         = Q1.RPDATE
			AND Q2.INTRENO_VICNCN = Q1.INTRENO_VICNCN
			AND Q2.SALESTYPE      = Q1.SALESTYPE
		GROUP BY
			Q1.CSHP_CDSHOPPING,
			Q1.BUKRS,
			Q1.INTRENO_VICNCN,
			Q1.CSHP_CDCONTRATO,
			Q1.INTRENO,
			Q1.INTRENO_ECC,
			Q1.CSHP_CDCONTRATO_MXM,
			Q1.CC_CDCONTRATO,
			Q1.CALMONTH
),
	
var_venda_auditada AS (
		SELECT
			VENDA.CSHP_CDSHOPPING,
			VENDA.BUKRS,
			VENDA.INTRENO_VICNCN,
			VENDA.CSHP_CDCONTRATO,
			VENDA.INTRENO,
			VENDA.INTRENO_ECC,
			VENDA.CSHP_CDCONTRATO_MXM,
			VENDA.CC_CDCONTRATO,
			VENDA.CALMONTH,
			VENDA.RPDATE,
			VENDA.SALESTYPE,
			MAX(ATTR.CDTPAQUISICAO) 		    AS CDTPAQUISICAO,		
			MAX(ATTR.ZZGRPAT_BR)			      AS ZZGRPAT_BR,
			MAX(ATTR.ZZSUGRP_BR)			      AS ZZSUGRP_BR,
      MAX(ATTR.ZZATIVM_BR)			      AS ZZATIVM_BR,
			MAX(ATTR.SNUNR) 				        AS SNUNR,	
			MAX(ATTR.CC_CDGRUPOABL) 		    AS CC_CDGRUPOABL,
			MAX(ATTR.CDTIPOUNL) 			      AS CDTIPOUNL,
			MAX(ATTR.KEY_GRPABRASCE)		    AS KEY_GRPABRASCE,
			MAX(ATTR.KEY_ATVABRASCE)		    AS KEY_ATVABRASCE,
			MAX(ATTR.XMETXT)				        AS XMETXT,
			MAX(ATTR.SMENR)					        AS SMENR,
			MAX(ATTR.RECNTXT)				        AS RECNTXT,
			MAX(ATTR.ZZNMFAN)				        AS ZZNMFAN,
			MAX(ATTR.FQMFLART)				      AS FQMFLART,
			MAX(ATTR.CC_FQMFLART_SONAE)		  AS CC_FQMFLART_SONAE,
			SUM(VENDA.GROSS_SALES_AUD_FIS) 	AS GROSS_SALES_AUD_FIS,
			SUM(VENDA.GROSS_SALES_REDU_Z) 	AS GROSS_SALES_REDU_Z,
			SUM(VENDA.GROSS_SALES_PROJET) 	AS GROSS_SALES_PROJET,
			0								                AS NET_SALES_AUDITADA,
			SUM(VENDA.VOLVED_AUD)			      AS GROSS_SALES_AUDITADA,
			SUM(VENDA.VOLVED_AUD) 			    AS CC_VOLVED_AUDITADA
		FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_AUDITADA` AS VENDA
		LEFT OUTER JOIN var_venda_auditada_attr AS ATTR
			ON  ATTR.INTRENO_VICNCN      = VENDA.INTRENO_VICNCN
			AND ATTR.INTRENO_ECC         = VENDA.INTRENO_ECC
			AND ATTR.CSHP_CDCONTRATO_MXM = VENDA.CSHP_CDCONTRATO_MXM
			AND ATTR.CC_CDCONTRATO       = VENDA.CC_CDCONTRATO
			AND ATTR.CALMONTH            = VENDA.CALMONTH
		GROUP BY
			VENDA.CSHP_CDSHOPPING,
			VENDA.BUKRS,
			VENDA.INTRENO_VICNCN,
			VENDA.CSHP_CDCONTRATO,
			VENDA.INTRENO,
			VENDA.INTRENO_ECC,
			VENDA.CSHP_CDCONTRATO_MXM,
			VENDA.CC_CDCONTRATO,
			VENDA.CALMONTH,
			VENDA.RPDATE,
			VENDA.SALESTYPE
),
						
--  Maior Venda		
var_maior_venda AS (
			SELECT
				CSHP_CDSHOPPING,
				BUKRS,
				INTRENO_VICNCN,
				CSHP_CDCONTRATO,
				CALMONTH,
				RPDATE,
				SALESTYPE,
				MAX(INTRENO)															AS INTRENO,
				MAX(INTRENO_ECC)														AS INTRENO_ECC,
				MAX(CSHP_CDCONTRATO_MXM)												AS CSHP_CDCONTRATO_MXM,
				MAX(CC_CDCONTRATO)													AS CC_CDCONTRATO,
				MAX(XMETXT)															AS XMETXT,
				MAX(SMENR)															AS SMENR,
				MAX(RECNTXT)															AS RECNTXT,
				MAX(ZZNMFAN)															AS ZZNMFAN,
				MAX(CDTPAQUISICAO)													AS CDTPAQUISICAO,		
				MAX(ZZGRPAT_BR) 														AS ZZGRPAT_BR,
				MAX(ZZSUGRP_BR) 														AS ZZSUGRP_BR,
				MAX(ZZATIVM_BR) 														AS ZZATIVM_BR,
				MAX(SNUNR) 															AS SNUNR,
				MAX(CC_CDGRUPOABL) 													AS CC_CDGRUPOABL,
				MAX(CDTIPOUNL) 														AS CDTIPOUNL,
				MAX(KEY_GRPABRASCE) 													AS KEY_GRPABRASCE,
				MAX(KEY_ATVABRASCE) 													AS KEY_ATVABRASCE,
				MAX(FQMFLART)															AS FQMFLART,
				MAX(CC_FQMFLART_SONAE)												AS CC_FQMFLART_SONAE,
				SUM(GROSS_SALES_AUD_FIS) 											AS SUM_GROSS_SALES_AUD_FIS,
				SUM(GROSS_SALES_REDU_Z) 											AS SUM_GROSS_SALES_REDU_Z,
				SUM(GROSS_SALES_PROJET) 											AS SUM_GROSS_SALES_PROJET,
				SUM(NET_SALES_INTRAMALL)                                            AS SUM_NET_SALES_INTRAMALL,
				SUM(GROSS_SALES_INTRAMALL)                                          AS SUM_GROSS_SALES_INTRAMALL,
				GREATEST(SUM(NET_SALES_AUDITADA)  , SUM(NET_SALES_INTRAMALL))		AS GREATEST_NET_SALES,
				GREATEST(SUM(GROSS_SALES_AUDITADA), SUM(GROSS_SALES_INTRAMALL))		AS GREATEST_GROSS_SALES,
				GREATEST(SUM(CC_VOLVED_AUDITADA)  , SUM(CC_VOLVED_INTRAMALL))		AS GREATEST_CC_VOLVED
		FROM (
			SELECT
				VENDA.CSHP_CDSHOPPING,
				VENDA.BUKRS,
				VENDA.INTRENO_VICNCN,
				VENDA.CSHP_CDCONTRATO,
				VENDA.INTRENO,
				VENDA.INTRENO_ECC,
				VENDA.CSHP_CDCONTRATO_MXM,
				VENDA.CC_CDCONTRATO,
				VENDA.CALMONTH AS CALMONTH,
				VENDA.RPDATE,
				VENDA.SALESTYPE,
				VENDA.XMETXT,
				VENDA.SMENR,
				VENDA.RECNTXT,
				VENDA.ZZNMFAN,
				VENDA.CDTPAQUISICAO,		
				VENDA.ZZGRPAT_BR,
				VENDA.ZZSUGRP_BR,
				VENDA.ZZATIVM_BR,
				VENDA.SNUNR,
				VENDA.CC_CDGRUPOABL,
				VENDA.CDTIPOUNL,
				VENDA.KEY_GRPABRASCE,
				VENDA.KEY_ATVABRASCE,
				VENDA.FQMFLART,
				VENDA.CC_FQMFLART_SONAE,
				0                               AS GROSS_SALES_AUD_FIS,
				0                               AS GROSS_SALES_REDU_Z,
				0                               AS GROSS_SALES_PROJET,
				0								AS NET_SALES_AUDITADA,
				0								AS GROSS_SALES_AUDITADA,
				0								AS CC_VOLVED_AUDITADA,
				VENDA.NET_SALES_INTRAMALL,
				VENDA.GROSS_SALES_INTRAMALL,
				VENDA.CC_VOLVED_INTRAMALL
			FROM var_venda_informada AS VENDA
		UNION DISTINCT
			SELECT
				VENDA.CSHP_CDSHOPPING,
				VENDA.BUKRS,
				VENDA.INTRENO_VICNCN,
				VENDA.CSHP_CDCONTRATO,
				VENDA.INTRENO,
				VENDA.INTRENO_ECC,
				VENDA.CSHP_CDCONTRATO_MXM,
				VENDA.CC_CDCONTRATO,
				VENDA.CALMONTH,
				VENDA.RPDATE,
				VENDA.SALESTYPE,
				VENDA.XMETXT,
				VENDA.SMENR,
				VENDA.RECNTXT,
				VENDA.ZZNMFAN,
				VENDA.CDTPAQUISICAO,		
				VENDA.ZZGRPAT_BR,
				VENDA.ZZSUGRP_BR,
				VENDA.ZZATIVM_BR,
				VENDA.SNUNR,
				VENDA.CC_CDGRUPOABL,
				VENDA.CDTIPOUNL,
				VENDA.KEY_GRPABRASCE,
				VENDA.KEY_ATVABRASCE,
				VENDA.FQMFLART,
				VENDA.CC_FQMFLART_SONAE,
				VENDA.GROSS_SALES_AUD_FIS,
				VENDA.GROSS_SALES_REDU_Z,
				VENDA.GROSS_SALES_PROJET,
				VENDA.NET_SALES_AUDITADA,
				VENDA.GROSS_SALES_AUDITADA,
				VENDA.CC_VOLVED_AUDITADA,
				0								AS NET_SALES_INTRAMALL,
				0								AS GROSS_SALES_INTRAMALL,
				0 								AS CC_VOLVED_INTRAMALL
			FROM var_venda_auditada AS VENDA)
		GROUP BY
			CSHP_CDSHOPPING,
			BUKRS,
			INTRENO_VICNCN,
			CSHP_CDCONTRATO,
			CALMONTH,
			RPDATE,
			SALESTYPE
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
        RPDATE,
        SALESTYPE,
        FQMFLART,
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
        GREATEST_CC_VOLVED,
        CC_FQMFLART_SONAE,
        CASE WHEN CC_FQMFLART_SONAE = 0	THEN 0 ELSE GREATEST_CC_VOLVED END AS CC_VOLVED_COM_FQMFLART,
        CASE WHEN GREATEST_CC_VOLVED = 0			THEN 0 ELSE FQMFLART  END AS CC_FQMFLART_COM_VOLVED,
		SUM_GROSS_SALES_AUD_FIS,
		SUM_GROSS_SALES_REDU_Z,
		SUM_GROSS_SALES_PROJET,
		SUM_NET_SALES_INTRAMALL,
		SUM_GROSS_SALES_INTRAMALL,
        GREATEST_NET_SALES,
        GREATEST_GROSS_SALES
    FROM var_maior_venda
);