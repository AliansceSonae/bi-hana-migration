CREATE OR REPLACE PROCEDURE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.SP_ETL_VENDA_MENSAL` (calmonth ARRAY<STRING>) 
BEGIN
	
    FOR elem in (SELECT * FROM UNNEST(calmonth) as CALMONTH)
        DO
	    
	    DELETE FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_MENSAL`
			WHERE DATE_TRUNC(RPDATE, MONTH) = PARSE_DATE('%Y%m%d', elem.CALMONTH || '01');

		INSERT INTO `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_MENSAL`
			SELECT
				CALMONTH,
				CSHP_CDSHOPPING,
				CSHP_CDCONTRATO,
				INTRENO,
				INTRENO_VICNCN,
				BUKRS,
				CC_FLAG_MES,
				CC_FLAG_YTD,
				CDTPAQUISICAO,
				ZZGRPAT_BR,
				ZZSUGRP_BR,
				ZZATIVM_BR,
				SNUNR,
				CC_CDGRUPOABL,
				CDTIPOUNL,
				KEY_GRPABRASCE,
				KEY_ATVABRASCE,
				ZZNMFAN,
				SMENR,
				FQMFLART,
				RECNTXT,
				XMETXT,
				CC_FQMFLART_SONAE,
				CC_FQMFLART_COM_VOLVED,
				SUM(CC_VOLVED) AS CC_VOLVED,
				SUM(CC_VOLVED_COM_FQMFLART) AS CC_VOLVED_COM_FQMFLART,
				SUM(NET_SALES) AS NET_SALES,
				SUM(GROSS_SALES) AS GROSS_SALES,
				INTRENO_ECC,
				CSHP_CDCONTRATO_MXM,
				CC_CDCONTRATO,
				FLAG_VENDA_ZERO,
				CURRENT_DATETIME('America/Sao_Paulo') AS CHANGE_TIME
			FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_VENDA_MENSAL_4B`(elem.CALMONTH)
			GROUP BY 
				CALMONTH, CSHP_CDSHOPPING, CSHP_CDCONTRATO, INTRENO, INTRENO_VICNCN, BUKRS, CC_FLAG_MES, CC_FLAG_YTD, CDTPAQUISICAO, ZZGRPAT_BR, 
				ZZSUGRP_BR, ZZATIVM_BR, SNUNR, CC_CDGRUPOABL, CDTIPOUNL, KEY_GRPABRASCE, KEY_ATVABRASCE, ZZNMFAN, ZZNMFAN_ANT, SMENR, SMENR_ANT, 
				FQMFLART, FQMFLART_ANT, RECNTXT, RECNTXT_ANT, XMETXT, XMETXT_ANT, CC_FQMFLART_SONAE, CC_FQMFLART_SONAE_ANT, CC_FQMFLART_COM_VOLVED, 
				CC_FQMFLART_COM_VOLVED_ANT,INTRENO_ECC,CSHP_CDCONTRATO_MXM,CC_CDCONTRATO,FLAG_VENDA_ZERO;
	END FOR;
	
END;