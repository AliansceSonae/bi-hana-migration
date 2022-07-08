CREATE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONTRATO`
(
  INTRENO_VICNCN STRING(20) NOT NULL,
  INTRENO_ECC STRING(20),
  INTRENO_VIBDRO STRING(20),
  INTRENO_VIBDBU STRING(20),
  INTRENO_VIBDBE STRING(20),
  BUKRS STRING(4),
  SWENR STRING(8),
  RECNNR STRING(13),
  OBJNR STRING(22),
  IMKEY STRING(8),
  RECNTYPE STRING(4),
  RECNTYPE_TEXT15 STRING(15),
  RECNTYPE_TEXT30 STRING(30),
  RECNBEG DATE,
  RECNENDABS DATE,
  ZZREDFIM DATE,
  RECNTXT STRING(80),
  RECNDACTIV DATE,
  RECNTXTOLD STRING(20),
  RECNBUKRSCOLLECT STRING(4),
  RECNNRCOLLECT STRING(13),
  RECNDAT DATE,
  RECNEND1ST DATE,
  RECNNOTPER DATE,
  RECNNOTRECEIPT DATE,
  RECNNOTREASON STRING(2),
  RECNNOTREASON_TEXT15 STRING(15),
  RECNNOTREASON_TEXT30 STRING(30),
  RECNDAKTKU DATE,
  BENOCN STRING(8),
  TRANSPOSSFROM DATE,
  TRANSPOSSTO DATE,
  ZZLJRISCO STRING(3),
  ZZBRINCEND STRING(3),
  ZCODABL STRING(3),
  ZZCLASS_ZGRABL STRING(40),
  ZCODABRASCE STRING(3),
  ZZCLASS_ZGRABRASCE STRING(40),
  ZCODREDE STRING(5),
  ZZCLASS_ZREDE STRING(40),
  ZCODGAR STRING(3),
  ZZCLASS_ZTPGARANTIA STRING(40),
  CODNATPB INT64,
  ZZCLASS_ZNATPB STRING(40),
  ZZINTEREST_PERCENT NUMERIC(5, 2),
  ZZFINE_PERCENT NUMERIC(5, 2),
  ZZMONETARY_INDEX STRING(5),
  ZZINDEX_YEAR STRING(4),
  ZZRECSF STRING(20),
  ZZREDILJ DATE,
  ZZRECONS DATE,
  ZZRECOB STRING(1),
  ZZRENED STRING(1),
  ZZRECES STRING(13),
  ZZREIREF DATE,
  ZZREFREF DATE,
  ZZREPREF DATE,
  XMETXT STRING(60),
  PARTNER_TR0200 STRING(10),
  PARTNER_TR0200_NAME STRING(256),
  PARTNER_TR0600 STRING(10),
  PARTNER_TR0600_NAME STRING(256),
  PARTNER_TR0605 STRING(10),
  PARTNER_TR0605_NAME STRING(256),
  PARTNER_TR0806 STRING(10),
  PARTNER_TR0806_NAME STRING(256),
  ADJMFIRSTDATE DATE,
  CC_PERIO_REAJUSTE STRING(3),
  CC_FQMFLART_SONAE NUMERIC(14, 4),
  FQMFLART NUMERIC(14, 4),
  FEINS STRING(3),
  CDTPAQUISICAO INT64,
  CSHP_CDSHOPPING STRING(5),
  CSHP_CDCONTRATO STRING(20),
  CSHP_CDCONTRATO_MXM STRING(20),
  CSHP_NMFANTASIA STRING(50),
  CSHP_DTCADASTRO DATE,
  CSHP_DTINICIO DATE,
  CSHP_DTFIM DATE,
  CSHP_DTENCERRAMENTO DATE,
  CSHP_DDREAJUSTE INT64,
  CSHP_DTBASEREAJUSTE DATE,
  CSHP_PCMULTA NUMERIC(5, 2),
  CSHP_PCJUROS NUMERIC(5, 2),
  CSHP_DTINAUGURA DATE,
  CSHP_PRAZO INT64,
  CSHP_DTASSINATURA DATE,
  CSHP_CDSTATUS INT64,
  CSHP_IDREDELOJA STRING(5),
  RLS_NOMEREDE STRING(100),
  CSHP_DTINCLUSAO DATE,
  CSHP_DTDISTRATO DATE,
  CC_CDGRUPO STRING(50),
  CC_ABL NUMERIC(15, 2),
  CSHP_CDATIVIDADE STRING(10),
  CSHP_VBPOSSUIACRESESP INT64,
  CC_CDGRUPOABL STRING(2),
  CSHP_CDTIPOUNL STRING(5),
  INTRENO STRING(20),
  DMIBEG DATE,
  DMIEND DATE,
  ZZNMFAN STRING(40),
  CDUNIDADE STRING(20),
  SMENR STRING(8),
  ZZGRPAT_BR STRING(3),
  ZZSUGRP_BR STRING(3),
  ZZATIVM_BR STRING(4),
  SNUNR STRING(4),
  DKUEZU DATE,
  DAKTV DATE,
  USR08 DATE,
  SMIVE STRING(20),
  CDTIPOUNL STRING(5),
  ABNNR STRING(20),
  KEY_GRPABRASCE STRING(20),
  KEY_ATVABRASCE STRING(20),
  CC_CDCONTRATO STRING(20),
  CC_SMIVE STRING(20),
  CC_DIAS_VENCTO INT64,
  FLAG_ATIVO STRING(1),
  FLAG_CTO STRING(1),
  CHANGE_TIME TIMESTAMP
);