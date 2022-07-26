CREATE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_ALUGPERC`
(
  CSHP_CDSHOPPING STRING(5),
  INTRENO_VICNCN STRING(20),
  CC_CDCONTRATO STRING(20),
  RECNNR STRING(13),
  BUKRS STRING(4),
  TERMTYPE STRING(4),
  XTERMTYPE STRING(40),
  TERMNO STRING(4),
  VALIDFROM DATE,
  VALIDTO DATE,
  IS_MASTER STRING(1),
  SALESRULE STRING(4),
  USECF4POST STRING(1),
  ITEMNO STRING(3),
  SALESCURR STRING(5),
  SALESUNIT STRING(3),
  MINSALES NUMERIC(15, 2),
  MAXSALES NUMERIC(15, 2),
  RENTPERCENT NUMERIC(5, 2),
  MINQUANTITY NUMERIC(17, 4),
  MAXQUANTITY NUMERIC(17, 4),
  PRICEPERUNIT NUMERIC(19, 6),
  MINRENT NUMERIC(15, 2),
  CHANGE_TIME TIMESTAMP
);