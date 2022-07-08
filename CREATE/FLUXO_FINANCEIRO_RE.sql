CREATE TABLE  `also-analytics-model-nonprod.3_MATERIALIZADO_S4.FLUXO_FINANCEIRO_RE` (
	CALMONTH STRING (6),
	CSHP_CDSHOPPING STRING (5),
	INTRENO_VICNCN STRING (20),
	CC_CDCONTRATO STRING (20),
	RECNNR STRING (13),
	BUKRS STRING (4),
	CFPAYGUID BYTES (16),
	CONDGUID BYTES (16),
	REFGUID BYTES (16),
	DBERVON DATE,
	DBERBIS DATE,
	DFAELL DATE,
	DDISPO DATE,
	ATAGE INT,
	AMMRHY INT,
	ATTRHY INT,
	FLOWTYPE STRING (4),
	XFLOWTYPE STRING (30),
	ORIGFLOWTYPE STRING (4),
	REFFLOWREL STRING (3),
	CFSTATUS STRING (1),
	CFSTATUS_TEXT  STRING (60),
	FDELETE STRING (1),
	PARTNEROBJNR STRING (22),
	CONDTYPE STRING (4),
	CONDTYPE_TEXT20 STRING (20),
	POSTINGDATE DATE,
	DOCUMENTDATE DATE,
	BOOK_FLOWTYPE STRING (4),
	REVERSAL_FOR BYTES (16),
	FOLLOWUP_FOR BYTES (16),
	BOOK_REFFLOWREL STRING (3),
	SSOLHAB STRING (1),
	BBWHR DECIMAL (23, 2),
	BNWHR DECIMAL (23, 2),
	RENTPERCENT DECIMAL(5, 2),
	SALES DECIMAL(15, 2),
	SALESRENT DECIMAL(15, 2),
	PAYNET DECIMAL(15, 2),
	RECEIVABLENET DECIMAL(15, 2),
	BALANCENET DECIMAL(15, 2),
	ALUG_CONTRATUAL DECIMAL (23, 2),
	ALUG_FATURADO DECIMAL (23, 2),
	ALUG_LIQUIDO DECIMAL (23, 2),
	ALUG_TOT DECIMAL (23, 2),
	DESC_CARENCIA DECIMAL (23, 2),
	ALUG_COMPLEMENTAR DECIMAL (23, 2),
	ENC_COMUM DECIMAL (23, 2),
	ENC_ESPECIFICO DECIMAL (23, 2),
	FPP DECIMAL (23, 2),
	CO DECIMAL (23, 2),
	CO_COM_ESPECIFICO DECIMAL (23, 2),
	CARENCIA DECIMAL (23, 2),
	DESCONTO_PRE DECIMAL (23, 2),
	IPTU DECIMAL (23, 2),
	TX_TRANSF DECIMAL (23, 2),
	FLAG_CTO STRING(1),
	ICON_CFSTATUS STRING(2),
	ICON_CFSTATUS_TEXT STRING(50),
	CHANGE_TIME TIMESTAMP
)
