CREATE OR REPLACE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_MENSAL`(
   	CSHP_CDSHOPPING STRING(5),
	BUKRS STRING(4),
	INTRENO_VICNCN STRING (20),
	CSHP_CDCONTRATO STRING(20),
	INTRENO STRING(20),
	INTRENO_ECC STRING (20),
	CSHP_CDCONTRATO_MXM STRING(20),
	CC_CDCONTRATO STRING (20),
	CALMONTH STRING(6),
	FQMFLART DECIMAL(13, 2),
	FQMFLART_ANT DECIMAL(15, 4),
	CDTPAQUISICAO INTEGER,
	SMENR STRING(8),
	XMETXT STRING (60),
	ZZGRPAT_BR STRING(3),
	ZZSUGRP_BR STRING(3),
	ZZATIVM_BR STRING(4),
	SMENR_ANT STRING(8),
	XMETXT_ANT STRING (60),
	SNUNR STRING(4),
	CC_CDGRUPOABL STRING(4),
	CDTIPOUNL STRING(5),
	KEY_GRPABRASCE STRING(20),
	KEY_ATVABRASCE STRING(13),
	ZZNMFAN_ANT STRING(40),
	ZZNMFAN STRING(40),
	RECNTXT STRING (80),
	RECNTXT_ANT STRING (80),
	CC_FLAG_MES STRING (3),
	CC_FLAG_YTD STRING (3),
	CC_VOLVED DECIMAL(18, 2),
	CC_VOLVED_ANT DECIMAL(18, 2),
	CC_FQMFLART_SONAE DECIMAL(18, 4),
	CC_FQMFLART_SONAE_ANT DECIMAL(18, 4),
	CC_VOLVED_COM_FQMFLART DECIMAL(13, 2),
	CC_FQMFLART_COM_VOLVED DECIMAL(14, 4),
	CC_VOLVED_COM_FQMFLART_ANT DECIMAL(13, 2),
	CC_FQMFLART_COM_VOLVED_ANT DECIMAL(14, 4),
	NET_SALES DECIMAL (15,2),
	NET_SALES_ANT DECIMAL (15,2),
	GROSS_SALES DECIMAL (15,2),
	GROSS_SALES_ANT DECIMAL (15,2),
	FLAG_VENDA_ZERO STRING(1),
	CHANGE_TIME TIMESTAMP
)
PARTITION BY
  DATE_TRUNC(RPDATE, MONTH)
CLUSTER BY
  CSHP_CDSHOPPING