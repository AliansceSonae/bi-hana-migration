CREATE OR REPLACE PROCEDURE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_OBJETO_LOCACAO` () 

BEGIN
		DELETE FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_OBJETO_LOCACAO` WHERE 1=1;

    CREATE OR REPLACE TABLE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_OBJETO_LOCACAO`
    AS
    SELECT *, CURRENT_TIMESTAMP() AS CHANGE_TIME
		FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_OBJETO_LOCACAO_4B` ();

		-- INSERT INTO `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_OBJETO_LOCACAO`
		-- (CSHP_CDSHOPPING,INTRENO_VIBDRO,INTRENO_VIBDBU,BUKRS,SWENR,SMENR,OBJNR,IMKEY,VALIDFROM,VALIDTO,ROTYPE,
		--  ROTYPE_TEXT,SNUNR,SNUNR_TEXT15,SNUNR_TEXT30,XMETXT,SGRNR,SGENR,SGEBT,RLGESCH,SSTCKBIS,XSTANDNR,SSTOCKW,
		--  ZZCLASS_TP_UTIL,ZVENDLOC,ZVENDLOC_TEXT,ZPISO,ZVENDDESC,FQMFLART,FEINS,CC_ABL,CDTIPOUNL,INTRENO_VIBDBE,
		--  CHANGE_TIME)
		-- SELECT
		--  CSHP_CDSHOPPING,INTRENO_VIBDRO,INTRENO_VIBDBU,BUKRS,SWENR,SMENR,OBJNR,IMKEY,VALIDFROM,VALIDTO,ROTYPE,
		--  ROTYPE_TEXT,SNUNR,SNUNR_TEXT15,SNUNR_TEXT30,XMETXT,SGRNR,SGENR,SGEBT,RLGESCH,SSTCKBIS,XSTANDNR,SSTOCKW,
		--  ZZCLASS_TP_UTIL,ZVENDLOC,ZVENDLOC_TEXT,ZPISO,ZVENDDESC,FQMFLART,FEINS,CC_ABL,CDTIPOUNL,INTRENO_VIBDBE,
		--  CURRENT_TIMESTAMP() AS CHANGE_TIME
		-- FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_OBJETO_LOCACAO_4B` ();
END;