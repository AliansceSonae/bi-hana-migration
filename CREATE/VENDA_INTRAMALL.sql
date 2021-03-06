CREATE OR REPLACE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.VENDA_INTRAMALL`
(
  BUKRS STRING,
  RECNNR STRING,
  INTRENO_VICNCN STRING,
  INTRENO STRING,
  INTRENO_ECC STRING,
  CC_CDCONTRATO STRING,
  CSHP_CDCONTRATO STRING,
  CSHP_CDCONTRATO_MXM STRING,
  SWENR STRING,
  RECNTXT STRING,
  ZZNMFAN STRING,
  XMETXT STRING,
  SMENR STRING,
  ZZGRPAT_BR INT64,
  ZZSUGRP_BR INT64,
  ZZATIVM_BR INT64,
  SNUNR STRING,
  CC_CDGRUPOABL STRING,
  CDTIPOUNL STRING,
  KEY_GRPABRASCE STRING,
  KEY_ATVABRASCE STRING,
  CC_FQMFLART_SONAE NUMERIC,
  FQMFLART NUMERIC,
  RPDATE DATE,
  SALESTYPE STRING,
  SALESREPORTTYPE STRING,
  SALESREPORTTYPE_TEXT STRING,
  NET_SALES NUMERIC,
  GROSS_SALES NUMERIC,
  CSHP_CDSHOPPING STRING,
  CDUNIDADE STRING,
  CDCONTRATO STRING,
  CDCONTRATOS STRING,
  NMFANTASIA STRING,
  CDTPAQUISICAO INT64,
  CSHP_CDTIPOUNL STRING,
  DTINAUGURA STRING,
  DTENCERRAMENTO STRING,
  CALMONTH STRING,
  MONTH_YEAR STRING,
  DATE_SQL DATE,
  MONTH STRING,
  YEAR STRING,
  WEEK STRING,
  WEEK_MONTH STRING,
  DTSTARTWEEK DATE,
  DTFINISHWEEK DATE,
  VBDIAUTIL INT64,
  NUPRAZOINFVND INT64,
  FLGINFORMOU STRING,
  COUNTER_FLGINFORMOU INT64,
  COUNTER INT64,
  FLGWEEKINF STRING,
  PROTOCOLO STRING,
  VLVENDA NUMERIC,
  COUNTER_SUM INT64,
  COUNTER_WEEK_SUM INT64,
  WEEK_NUM INT64,
  SHOP_WEEK_SUM INT64,
  CC_VOLVED NUMERIC,
  SOURCE_SYSTEM STRING,
  CHANGE_TIME DATETIME
)
PARTITION BY
  DATE_TRUNC(RPDATE, MONTH)
CLUSTER BY
  CSHP_CDSHOPPING;

