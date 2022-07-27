CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_FAT_4B` ()
AS (

WITH var_alug_perc AS (
    SELECT
        REFGUID,
        RENTPERCENT,
        CONDTYPE
    FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_FLUXO_FINANCEIRO_RE_4B`()
    WHERE CONDTYPE = 'Z016'
)

,var_re AS (
    SELECT
        'X'																										AS FLAG_RE,
        RE.CALMONTH																							AS CALMONTH,
        RIGHT(RE.CALMONTH, 2)																				AS MONAT,
        LEFT(RE.CALMONTH, 4)																				AS GJAHR,
        RE.INTRENO_VICNCN																					AS INTRENO_VICNCN,
        SUM(RE.AMOUNT)																						AS BNWHR,
        SUM(RE.ALUG_CONTRATUAL)																				AS ALUG_CONTRATUAL,
        SUM(RE.ALUG_FATURADO)																				AS ALUG_FATURADO,
        SUM(RE.ALUG_LIQUIDO) 																				AS ALUG_LIQUIDO,
        SUM(RE.ALUG_TOT) 																					AS ALUG_TOT,
        SUM(RE.DESC_CARENCIA)																				AS DESC_CARENCIA,
        SUM(RE.ALUG_COMPLEMENTAR)																			AS ALUG_COMPLEMENTAR,
        SUM(RE.ENC_COMUM)																					AS ENC_COMUM,
        SUM(RE.ENC_ESPECIFICO)																				AS ENC_ESPECIFICO,
        SUM(RE.FPP)																							AS FPP,
        SUM(RE.CO)																							AS CO,
        SUM(RE.CO_COM_ESPECIFICO)																			AS CO_COM_ESPECIFICO,
        SUM(RE.CARENCIA) 																					AS CARENCIA,
        SUM(RE.DESCONTO_PRE) 																				AS DESCONTO_PRE,
        SUM(RE.DESC_TOT_RE) 																				AS DESC_TOT_RE,
        MAX(CONTR.CC_FQMFLART_SONAE)																		AS FQMFLART,
        CASE WHEN ABS(SUM(RE.ALUG_CONTRATUAL))		> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_ALUG_CONTRATUAL,
        CASE WHEN ABS(SUM(RE.ALUG_FATURADO)) 		> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_ALUG_FATURADO,
        CASE WHEN ABS(SUM(RE.ALUG_LIQUIDO))  		> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_ALUG_LIQUIDO,
        CASE WHEN ABS(SUM(RE.ALUG_TOT))      		> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_ALUG_TOT,
        CASE WHEN ABS(SUM(RE.DESC_CARENCIA)) 		> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_DESC_CARENCIA,
        CASE WHEN ABS(SUM(RE.ALUG_COMPLEMENTAR))	> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_ALUG_COMPLEMENTAR,
        CASE WHEN ABS(SUM(RE.ENC_COMUM)) 			> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_ENC_COMUM,
        CASE WHEN ABS(SUM(RE.ENC_ESPECIFICO)) 		> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_ENC_ESPECIFICO,
        CASE WHEN ABS(SUM(RE.FPP)) 					> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_FPP,
        CASE WHEN ABS(SUM(RE.CO)) 					> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_CO,
        CASE WHEN ABS(SUM(RE.CO_COM_ESPECIFICO))	> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_CO_COM_ESPECIFICO,
        CASE WHEN ABS(SUM(RE.CARENCIA))				> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_CARENCIA,
        CASE WHEN ABS(SUM(RE.DESCONTO_PRE))			> 0 THEN MAX(CONTR.CC_FQMFLART_SONAE) ELSE 0 END	AS FQMFLART_COM_DESCONTO_PRE,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.ALUG_CONTRATUAL)			  ELSE 0 END 	AS ALUG_CONTRATUAL_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.ALUG_FATURADO)			  ELSE 0 END	AS ALUG_FATURADO_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.ALUG_LIQUIDO)			  ELSE 0 END	AS ALUG_LIQUIDO_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.ALUG_TOT)				  ELSE 0 END	AS ALUG_TOT_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.DESC_CARENCIA)			  ELSE 0 END	AS DESC_CARENCIA_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.ALUG_COMPLEMENTAR)		  ELSE 0 END	AS ALUG_COMPLEMENTAR_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.ENC_COMUM)				  ELSE 0 END	AS ENC_COMUM_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.ENC_ESPECIFICO)			  ELSE 0 END	AS ENC_ESPECIFICO_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.FPP)					 	  ELSE 0 END	AS FPP_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.CO)						  ELSE 0 END	AS CO_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.CO_COM_ESPECIFICO)		  ELSE 0 END	AS CO_COM_ESPECIFICO_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.CARENCIA)				  ELSE 0 END	AS CARENCIA_COM_FQMFLART,
        CASE WHEN MAX(CONTR.CC_FQMFLART_SONAE) > 0 THEN SUM(RE.DESCONTO_PRE)			  ELSE 0 END	AS DESCONTO_PRE_COM_FQMFLART,
        IFNULL(MAX(PERC.RENTPERCENT), 0)														        	AS RENTPERCENT
    FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.FAT_RE`
         AS RE
    INNER JOIN `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONTRATO` 
             AS CONTR
        ON CONTR.INTRENO_VICNCN = RE.INTRENO_VICNCN
    LEFT OUTER JOIN var_alug_perc AS PERC
        ON  PERC.REFGUID  = RE.DOCGUID
        AND PERC.CONDTYPE = RE.CONDTYPE
    WHERE RE.ITEMTYPE = 'OI'
    GROUP BY 
        RE.CALMONTH, 
        RE.INTRENO_VICNCN
)
    
,var_condicao AS (
    SELECT
        'X'								AS FLAG_COND,
        CALMONTH						AS CALMONTH,
        RIGHT(CALMONTH, 2)			AS MONAT,
        LEFT(CALMONTH, 4)				AS GJAHR,
        INTRENO_VICNCN				AS INTRENO_VICNCN,
        CC_AA							AS CC_AA,
        CC_AC							AS CC_AC,
        CC_AM							AS CC_AM,
        CC_DIF						AS CC_DIF,
        CC_EC							AS CC_EC,
        CC_EE							AS CC_EE,
        CC_ESTACAC					AS CC_ESTACAC,
        CC_ESTACAM					AS CC_ESTACAM,
        CC_FP							AS CC_FP,
        CC_PE							AS CC_PE,
        CC_EC							AS VLENCCOMUMFAT,
        CC_EE							AS VLENCESPECFAT,
        CC_FP							AS VLFPPFAT,
        CC_AM							AS VLALUGMINFAT,
        CC_AM							AS VLALUGMINFATDESC,
        CC_AC							AS VLALUGCOMPFAT,
        CC_AM							AS VLALUGMINCONTRATFAT,
        CC_AM + CC_AC				AS VLALUGTOTFAT,
        CC_FQMFLART_COM_AM + CC_FQMFLART_COM_AC			AS VLABLALUGTOTFAT,
        CC_FQMFLART_COM_AC 			AS VLABLALUGCOMPFAT,
        CC_FQMFLART_COM_EC			AS VLABLENCCOMUM,
        CC_FQMFLART_COM_EE 			AS VLABLENCESPECIFICO,      
        CC_FQMFLART_COM_FP 			AS VLABLFUNDOPRO,
        CC_FQMFLART_COM_AM 			AS VLABLALUGMINFATDESC,
        CC_FQMFLART_COM_AM 			AS VLABLALUGMINFAT,     
        CC_EC_COM_FQMFLART 			AS VLENCCOMUMCOMABL,
        CC_EE_COM_FQMFLART 			AS VLENCESPECIFICOCOMABL,
        CC_FP_COM_FQMFLART 			AS VLFUNDOPROCOMABL,
        CC_AM_COM_FQMFLART + CC_AC_COM_FQMFLART			AS VLALUGTOTFATCOMABL,
        CC_AM_COM_FQMFLART 			AS VLALUGMINFATCOMABL,
        CC_AC_COM_FQMFLART 			AS VLALUGCOMPFATCOMABL,
        CC_AM_COM_FQMFLART 			AS VLALUGMINFATDESCCOMABL,
        CC_FQMFLART_COM_AM			AS CC_FQMFLART_COM_AM,
        CC_FQMFLART_COM_AC			AS CC_FQMFLART_COM_AC,
        CC_FQMFLART_COM_EC			AS CC_FQMFLART_COM_EC,
        CC_FQMFLART_COM_EE			AS CC_FQMFLART_COM_EE,
        CC_FQMFLART_COM_FP			AS CC_FQMFLART_COM_FP,
        CC_EC_COM_FQMFLART			AS CC_EC_COM_FQMFLART,
        CC_EE_COM_FQMFLART			AS CC_EE_COM_FQMFLART,
        CC_FP_COM_FQMFLART			AS CC_FP_COM_FQMFLART,
        CC_AM_COM_FQMFLART			AS CC_AM_COM_FQMFLART,
        CC_AC_COM_FQMFLART			AS CC_AC_COM_FQMFLART
    FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_CONTRATO_CONDICAO_MENSAL_4B`()
)

,var_calmonth AS (
    SELECT
        CALMONTH,
        MONAT,
        GJAHR
    FROM (
        SELECT CALMONTH, MONAT, GJAHR FROM var_re		UNION DISTINCT
        SELECT CALMONTH, MONAT, GJAHR FROM var_condicao
    )
    GROUP BY 
        CALMONTH,
        MONAT,
        GJAHR
)
       
,var_desconto AS (
    SELECT 
        INTRENO_VICNCN,
        CALMONTH,
        SUM(VLDESC_POS_TOT)				AS VLDESC_POS_TOT,
        SUM(VLDESC_CONDICIONAL_PRE_TOT)	AS VLDESC_CONDICIONAL_PRE_TOT,
        SUM(VLCANCELAMENTO_TOT)			AS VLCANCELAMENTO_TOT
    FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DESCONTO`
    GROUP BY
        INTRENO_VICNCN,
        CALMONTH
)
           
SELECT 
    CONTR.CSHP_CDSHOPPING		AS CSHP_CDSHOPPING,
    CONTR.CSHP_CDCONTRATO		AS CSHP_CDCONTRATO,
    CONTR.INTRENO_VICNCN		AS INTRENO_VICNCN,
    CONTR.BUKRS 				AS BUKRS,
    CONTR.BUKRS 				AS P_BUKRS,
    CONTR.RECNNR				AS RECNNR,
    CONTR.XMETXT				AS XMETXT,
    CONTR.CDUNIDADE				AS CDUNIDADE,
    CONTR.SMENR 				AS SMENR,
    NULL							AS VBEWA,
    NULL							AS N_VBEWA,
    NULL							AS ZTMOV,
    CONTR.ZZNMFAN				AS ZZNMFAN,
    CONTR.RLS_NOMEREDE			AS RLS_NOMEREDE,
    CONTR.INTRENO				AS INTRENO,
    CONTR.SMIVE 				AS SMIVE,
    NULL							AS SHKZG,
    CONTR.ZZSUGRP_BR			AS ZZSUGRP,
    CONTR.ZZGRPAT_BR			AS ZZGRPAT,
    CONTR.ZZATIVM_BR			AS ZZATIVM,
    CONTR.KEY_ATVABRASCE		AS KEY_ATVABRASCE,
    NULL 							AS ZZDEGRP,
    NULL 							AS ZZDEATV,
    NULL 							AS ZZDESUG,
    CAL.MONAT					AS MONAT,
    CAL.GJAHR					AS GJAHR,
    CAL.CALMONTH				AS CALLMONTH,
    CAL.CALMONTH				AS CALMONTH,
    CONTR.CDTPAQUISICAO			AS CDTPAQUISICAO,
    NULL 							AS ZZDEGRP_PT,
    NULL 							AS ZZDEATV_PT,
    NULL 							AS ZZDESUG_PT,
    CONTR.CC_CDGRUPOABL 		AS CC_CDGRUPOABL,
    CONTR.CDTIPOUNL 			AS CDTIPOUNL,
    CONTR.CC_CDGRUPO			AS CC_CDGRUPO,
    CONTR.SNUNR 				AS SNUNR,
    NULL							AS TIPO_DESCONTO,
    NULL							AS ALPERC,
    NULL							AS DOBRODEZ,
    IFNULL(RE.ENC_COMUM, 0)      			AS VLENCCOMUMFAT,
    IFNULL(RE.ENC_ESPECIFICO, 0) 		AS VLENCESPECFAT,
    IFNULL(RE.FPP, 0)            	AS VLFPPFAT,
    IFNULL(RE.ALUG_FATURADO, 0) - IFNULL(DESCONT.VLDESC_CONDICIONAL_PRE_TOT, 0)	AS VLALUGMINFAT,
    IFNULL(RE.ALUG_FATURADO, 0) - IFNULL(DESCONT.VLDESC_CONDICIONAL_PRE_TOT, 0)	AS VLALUGMINFATDESC, -- Não considera desconto pós :: - IFNULL(DESC.VLDESC_POS_TOT, 0) 
    IFNULL(RE.ALUG_COMPLEMENTAR, 0)												AS VLALUGCOMPFAT,
    IFNULL(RE.ALUG_CONTRATUAL, 0)												AS VLALUGMINCONTRATFAT,
    NULL																		AS VLALUGMINMESANTERIOR,
    IFNULL(RE.ALUG_FATURADO, 0)				   - 
    IFNULL(DESCONT.VLDESC_POS_TOT, 0)			   - 
    IFNULL(DESCONT.VLDESC_CONDICIONAL_PRE_TOT, 0) -
    IFNULL(DESCONT.VLCANCELAMENTO_TOT, 0)		   +
    IFNULL(RE.ALUG_COMPLEMENTAR, 0)							AS VLALUGTOTFAT,
    NULL 													AS VLALUGPERCFAT,
    IFNULL(RE.ALUG_CONTRATUAL, 0)							AS ALUG_CONTRATUAL,
    NULL 													AS VLDESCALUG,
    IFNULL(RE.RENTPERCENT, 0) 								AS PERCFAIXAALUG,
    IFNULL(RE.FQMFLART_COM_ALUG_TOT, 0)						AS VLABLALUGTOTFAT,
    IFNULL(RE.FQMFLART_COM_ALUG_COMPLEMENTAR, 0) 			AS VLABLALUGCOMPFAT,
    CASE WHEN IFNULL(RE.ENC_COMUM, 0)      > 0 THEN RE.FQMFLART ELSE 0 END				AS VLABLENCCOMUM,
    CASE WHEN IFNULL(RE.ENC_ESPECIFICO, 0)  > 0 THEN RE.FQMFLART ELSE 0 END				AS VLABLENCESPECIFICO,      
    CASE WHEN IFNULL(RE.FPP, 0)		        > 0 THEN RE.FQMFLART ELSE 0 END				AS VLABLFUNDOPRO,
    IFNULL(RE.ALUG_CONTRATUAL_COM_FQMFLART, 0) 			    AS VLABLALUGMINFATDESC,
    IFNULL(RE.ALUG_CONTRATUAL_COM_FQMFLART, 0) 				AS VLABLALUGMINFAT,            
    NULL													AS VLABLALUGPERCFAT,
    IFNULL(RE.FQMFLART_COM_ALUG_CONTRATUAL, 0)				AS FQMFLART_COM_ALUG_CONTRATUAL,
    CASE WHEN IFNULL(RE.FQMFLART, 0) > 0 THEN IFNULL(RE.ENC_COMUM, 0)      ELSE 0 END	AS VLENCCOMUMCOMABL,
    CASE WHEN IFNULL(RE.FQMFLART, 0) > 0 THEN IFNULL(RE.ENC_ESPECIFICO, 0)  ELSE 0 END	AS VLENCESPECIFICOCOMABL,
    CASE WHEN IFNULL(RE.FQMFLART, 0) > 0 THEN IFNULL(RE.FPP, 0) 	     ELSE 0 END	AS VLFUNDOPROCOMABL,
    IFNULL(RE.ALUG_TOT_COM_FQMFLART, 0)						AS VLALUGTOTFATCOMABL,
    IFNULL(RE.FQMFLART_COM_ALUG_FATURADO, 0) 							AS VLALUGMINFATCOMABL,
    IFNULL(RE.ALUG_COMPLEMENTAR_COM_FQMFLART, 0) 				AS VLALUGCOMPFATCOMABL,
    IFNULL(RE.FQMFLART_COM_ALUG_FATURADO, 0) 						AS VLALUGMINFATDESCCOMABL,
    NULL 																		AS VLALUGPERCFATCOMABL,
    IFNULL(RE.ALUG_CONTRATUAL_COM_FQMFLART, 0) 							AS ALUG_CONTRATUAL_COM_FQMFLART,
    IFNULL(RE.FQMFLART, CONTR.CC_FQMFLART_SONAE)							AS FQMFLART,
    NULL 															AS ALUGDOBRADO_S,
    IFNULL(RE.BNWHR, 0) 															AS DMBTR,
    IFNULL(RE.BNWHR, 0)														AS WRBTR,
    IFNULL(RE.ALUG_CONTRATUAL, 0)												AS CC_AM,
    IFNULL(RE.ALUG_CONTRATUAL, 0)												AS CC_AA,
    IFNULL(COND.CC_DIF, 0) 										AS CC_DIF,
    IFNULL(COND.CC_ESTACAM, 0) 								AS CC_ESTACAM,
    IFNULL(COND.CC_ESTACAC, 0) 							AS CC_ESTACAC,
    IFNULL(RE.ALUG_COMPLEMENTAR, 0)								AS CC_AC,
    IFNULL(RE.ENC_COMUM, 0)					AS CC_EC,
    IFNULL(RE.ENC_ESPECIFICO, 0)			AS CC_EE,
    IFNULL(RE.FPP, 0)											AS CC_FP,
    IFNULL(RE.BNWHR, 0) 					AS CC_DMBTR,
    IFNULL(COND.CC_PE, 0)									AS CC_PE,
    RE.DESC_TOT_RE							AS DESC_TOT_RE,
    DESCONT.VLDESC_POS_TOT 							AS VLDESC_POS_TOT,
    DESCONT.VLDESC_CONDICIONAL_PRE_TOT 			AS VLDESC_CONDICIONAL_PRE_TOT,
    DESCONT.VLCANCELAMENTO_TOT						AS VLCANCELAMENTO_TOT,
    IFNULL(RE.DESC_TOT_RE, 0)					- 
    IFNULL(DESCONT.VLDESC_POS_TOT, 0)				- 
    IFNULL(DESCONT.VLDESC_CONDICIONAL_PRE_TOT, 0)	-
    IFNULL(DESCONT.VLCANCELAMENTO_TOT, 0)				AS DESC_TOTAL
FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONTRATO`    AS CONTR
CROSS JOIN var_calmonth AS CAL
LEFT OUTER JOIN var_condicao AS COND
    ON  COND.INTRENO_VICNCN = CONTR.INTRENO_VICNCN
    AND COND.CALMONTH 		= CAL.CALMONTH
LEFT OUTER JOIN var_re AS RE
    ON  RE.INTRENO_VICNCN = CONTR.INTRENO_VICNCN
    AND RE.CALMONTH 	  = CAL.CALMONTH
LEFT OUTER JOIN var_desconto AS DESCONT
    ON  DESCONT.INTRENO_VICNCN = CONTR.INTRENO_VICNCN
    AND DESCONT.CALMONTH 		= CAL.CALMONTH
)