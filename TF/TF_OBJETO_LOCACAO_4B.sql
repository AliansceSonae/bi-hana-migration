CREATE OR REPLACE TABLE FUNCTION also-analytics-model-prod.2_NEGOCIO_S4.TF_OBJETO_LOCACAO_4B ()
AS

WITH var_max AS (
		SELECT
			INTRENO_VIBDRO,
			MAX(CALMONTH) AS CALMONTH
		FROM aliansceSonae.4_presentation.financeiro.s4::CVW_OBJETO_LOCACAO_MENSAL_4P
		WHERE CALMONTH <= TO_VARCHAR(NOW(), 'YYYYMM')
		GROUP BY INTRENO_VIBDRO
)
	
SELECT
	OBJLOC.INTRENO_VIBDRO,
	OBJLOC.INTRENO_VIBDBU,
	OBJLOC.INTRENO_VIBDBE,
	OBJLOC.BUKRS,
	OBJLOC.SWENR,
	OBJLOC.SMENR,
	OBJLOC.OBJNR,
	OBJLOC.IMKEY,
	OBJLOC.VALIDFROM,
	OBJLOC.VALIDTO,
	OBJLOC.ROTYPE,
	OBJLOC.ROTYPE_TEXT,
	OBJLOC.SNUNR,
	OBJLOC.SNUNR_TEXT15,
	OBJLOC.SNUNR_TEXT30,
	OBJLOC.XMETXT,
	OBJLOC.SGRNR,
	OBJLOC.SGENR,
	OBJLOC.SGEBT,
	OBJLOC.RLGESCH,
	OBJLOC.SSTCKBIS,
	OBJLOC.XSTANDNR,
	OBJLOC.SSTOCKW,
	OBJLOC.ZZCLASS_TP_UTIL,
	OBJLOC.ZVENDLOC,
	OBJLOC.ZVENDLOC_TEXT,
	OBJLOC.ZPISO,
	OBJLOC.ZVENDDESC,
	OBJLOC.CSHP_CDSHOPPING,
	OBJLOC.FQMFLART, 
	OBJLOC.FEINS, 
	OBJLOC.CC_ABL,
	OBJLOC.CDTIPOUNL
FROM aliansceSonae.4_presentation.financeiro.s4::CVW_OBJETO_LOCACAO_MENSAL_4P AS OBJLOC
INNER JOIN :var_max AS OBJLOC_MAX
	ON  OBJLOC_MAX.INTRENO_VIBDRO = OBJLOC.INTRENO_VIBDRO
	AND OBJLOC_MAX.CALMONTH       = OBJLOC.CALMONTH