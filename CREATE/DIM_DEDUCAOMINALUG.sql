CREATE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_DEDUCAOMINALUG`
(
  BUKRS STRING(4) NOT NULL,
  INTRENO_VICNCN STRING(13) NOT NULL,
  RECNNR STRING(13) NOT NULL,
  FLOWTYPE STRING(4) NOT NULL,
  DTINI DATE NOT NULL,
  DTFIM DATE NOT NULL,
  ZFAEL STRING(2),
  ZPRZ1 NUMERIC(5, 2),
  ZZLSPR STRING(1),
  ZPONTEQ STRING(3),
  ZOBS STRING(40),
  DMBTR NUMERIC(23, 2),
  CSHP_CDSHOPPING STRING(5),
  CC_CDCONTRATO STRING(20),
  CPUDT DATE,
  CPUTM TIME,
  USNAM STRING(12),
  UPDDT DATE,
  USNAU STRING(12),
  CC_VLREDUCAO NUMERIC(23, 2),
  CC_TPVALOR STRING(3),
  CHANGE_TIME TIMESTAMP
);