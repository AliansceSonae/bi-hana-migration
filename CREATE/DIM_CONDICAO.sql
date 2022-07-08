CREATE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONDICAO`
(
  CONDTYPE STRING(4) NOT NULL,
  CONDTYPE_TEXT20 STRING(20),
  CONDTYPE_TEXT30 STRING(30),
  CONDPROP STRING(4),
  CONDPROP_TEXT STRING(30),
  FLOWTYPE STRING(4),
  FLOWTYPE_TEXT STRING(30),
  CALCRULEEXT STRING(4),
  CALCRULEEXT_TEXT15 STRING(15),
  CALCRULEEXT_TEXT30 STRING(30),
  CALCRULEEXT_TEXT60 STRING(60),
  DISTRULEEXT STRING(4),
  DISTRULEEXT_TEXT_15 STRING(15),
  DISTRULEEXT_TEXT_30 STRING(30),
  DISTRULEEXT_TEXT_60 STRING(60),
  SSOLHAB STRING(1),
  SSOLHAB_TEXT STRING(8),
  UNITPRICE NUMERIC(19, 6),
  CHANGE_TIME TIMESTAMP
);