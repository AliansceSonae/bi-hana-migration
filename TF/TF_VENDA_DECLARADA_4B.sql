CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_VENDA_DECLARADA_4B` () 
AS
WITH var_tivsrrhtt AS (
		SELECT
			SPRAS,
			RHYTHMTYPE,
			MAX(XRHYTHMTYPE) AS XRHYTHMTYPE
		FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.tivsrrhtt`
		WHERE SPRAS = 'P'
		GROUP BY
			SPRAS,
			RHYTHMTYPE
),			
	
var_version AS (
		SELECT
			MANDT,
			INTRENO,
			TERMNO,
			RHYTHMTYPE,
			VALIDFROM,
			MIN(VERSION) AS VERSION
		FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.visrreport`
		GROUP BY 
			MANDT,
			INTRENO,
			TERMNO,
			RHYTHMTYPE,
			VALIDFROM
)
	
SELECT
	CONTR.CSHP_CDSHOPPING								AS CSHP_CDSHOPPING,
	VISRREPORT.INTRENO									AS INTRENO_VICNCN,
	CONTR.INTRENO_ECC									AS INTRENO_ECC,
	CONTR.CSHP_CDCONTRATO								AS CSHP_CDCONTRATO,
	CONTR.CSHP_CDCONTRATO_MXM							AS CSHP_CDCONTRATO_MXM,
	CONTR.CC_CDCONTRATO 								AS CC_CDCONTRATO,
	CONTR.RECNNR										AS RECNNR,
	PARSE_DATE('%Y%m%d', VISRREPORT.VALIDFROM)	AS CALMONTH,
	VISRREPORT.VALIDFROM								AS VALIDFROM,
	VISRREPORT.VALIDTO									AS VALIDTO,
	VISRREPORT.VERSION									AS VERSION,
	VISRREPORT.TERMNO									AS TERMNO,
	VISRREPORT.RHYTHMTYPE								AS RHYTHMTYPE,
	TIVSRRHTT.XRHYTHMTYPE								AS XRHYTHMTYPE,
	VISRREPORT.RPTYPE									AS RPTYPE,
	TIVSRRPTT.XRPTYPE									AS XRPTYPE,
	VISRREPORT.SALESTYPE								AS SALESTYPE,
	CASE VISRREPORT.SALESTYPE
		WHEN 'M01'  THEN 'Volume de vendas de cerveja'
		WHEN 'S01'  THEN 'G�nero aliment�cios'
		WHEN 'S02'  THEN 'Vestu�rio'
		WHEN 'S03'  THEN 'Tabaco'
		WHEN 'Z001' THEN 'Venda Bomboniere'
		WHEN 'Z002' THEN 'Venda Bilheteria'
		WHEN 'Z003' THEN 'Venda Cigarro'
		WHEN 'Z004' THEN 'Venda Games'
		WHEN 'Z005' THEN 'Venda Papelaria'
		WHEN 'Z006' THEN 'Venda Inform�tica'
		WHEN 'Z007' THEN 'Venda Divulga��o'
		WHEN 'Z008' THEN 'Venda Diversas'
		WHEN 'Z009' THEN 'Venda Online'
		WHEN 'Z010' THEN 'Venda Sala Especial'
		WHEN 'Z011' THEN 'Venda Meta'
		WHEN 'Z012' THEN 'Venda Informada'
		ELSE '' 
	END 														AS SALESTYPE_TEXT,
	VISRREPORT.SALESUNIT									AS SALESUNIT,
	VISRREPORT.SALESCURR									AS SALESCURR,
	VISRREPORT.NO_SALES										AS NO_SALES,
	CASE WHEN VERSION.INTRENO IS NULL THEN 'N' ELSE 'S' END AS MAX_VERSION,
	CONTR.RECNTXT											AS RECNTXT,
	CONTR.ZZNMFAN											AS ZZNMFAN,
	CONTR.XMETXT											AS XMETXT,
	CONTR.SMENR												AS SMENR,
	CONTR.CC_FQMFLART_SONAE									AS CC_FQMFLART_SONAE,
	CONTR.FQMFLART											AS FQMFLART,
	VISRREPORT.NET_SALES									AS NET_SALES,
	VISRREPORT.GROSS_SALES									AS GROSS_SALES,
	VISRREPORT.QUANTITY										AS QUANTITY,
	VISRREPORT.STAT_NETSALES								AS STAT_NETSALES,
	VISRREPORT.STAT_GROSSSALES								AS STAT_GROSSSALES,
	VISRREPORT.STAT_QUANTITY								AS STAT_QUANTITY
FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.visrreport` AS VISRREPORT
LEFT OUTER JOIN `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONTRATO` AS CONTR
	ON VISRREPORT.INTRENO = CONTR.INTRENO_VICNCN
LEFT OUTER JOIN var_tivsrrhtt AS TIVSRRHTT
	ON TIVSRRHTT.RHYTHMTYPE = VISRREPORT.RHYTHMTYPE
LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivsrrptt` AS TIVSRRPTT
	ON  TIVSRRPTT.RPTYPE = VISRREPORT.RPTYPE
	AND TIVSRRPTT.SPRAS  = 'P'
LEFT OUTER JOIN var_version AS VERSION
	ON  VISRREPORT.MANDT      = VERSION.MANDT
	AND VISRREPORT.INTRENO    = VERSION.INTRENO
	AND VISRREPORT.TERMNO     = VERSION.TERMNO
	AND VISRREPORT.RHYTHMTYPE = VERSION.RHYTHMTYPE
	AND VISRREPORT.VALIDFROM  = VERSION.VALIDFROM
	AND VISRREPORT.VERSION	  = VERSION.VERSION
