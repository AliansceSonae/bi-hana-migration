PROCEDURE `also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_PRINCIPAL_DADOS_MESTRES` () 
BEGIN
	--DECLARE VAR_RESU "TARGET_ECC::ETL_CARGA_MONITOR";
	DECLARE VAR_CALMONTH ARRAY<STRING>;
	
	
	-------------------------
	-- S4 ::: VAR_CALMONTH --
	-------------------------
	SET VAR_CALMONTH = SELECT `also-analytics-model-nonprod.2_NEGOCIO_S4.MESES_PARA_CARGA`();
	
	
	
    ----------------------------
	-- SP_ETL_DIM_NATUREZA_PB --
	----------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NATUREZA_PB` ();
	
	
	
	------------------------
	-- SP_ETL_DIM_EMPRESA --
	------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_EMPRESA` (); 
	
	
	
    ----------------------------------
	-- SP_ETL_DIM_UNIDADE_ECONOMICA --
	----------------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_UNIDADE_ECONOMICA` (); 
	
	
	
    -------------------------
	-- SP_ETL_DIM_EDIFICIO --
	-------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_EDIFICIO` ();
	
	
	
    -------------------------------
	-- SP_ETL_DIM_OBJETO_LOCACAO --
	-------------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_OBJETO_LOCACAO` ();
	
	
	
    ---------------------------
	-- SP_ETL_DIM_GRPABRASCE --
	---------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_GRPABRASCE` ();
	
	
	
    -----------------------
	-- SP_ETL_DIM_GRPABL --
	-----------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_GRPABL` ();
	
	
	
    ---------------------------
	-- SP_ETL_DIM_ATVABRASCE --
	---------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_ATVABRASCE` ();
	
	
	
    -------------------------
	-- SP_ETL_DIM_SHOPPING --
	-------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_SHOPPING` ();
	
	
	
    -------------------------
	-- SP_ETL_DIM_CONTRATO --
	-------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONTRATO` ();
	
	
	
    ------------------------------
	-- SP_ETL_DIM_CONTRATO_HIST --
	------------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_CONTRATO_HIST_4M" (:VAR_CALMONTH);
	
	
	
    -----------------------------
	-- SP_ETL_DIM_UNIDADE_HIST --
	-----------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_UNIDADE_HIST`();
	
	
	
    -------------------------------
	-- SP_ETL_DIM_NFANTASIA_HIST --
	-------------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NFANTASIA_HIST` ();
	
	
	
    -------------------------
	-- SP_ETL_DIM_CONDICAO --
	-------------------------
	CALL `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_CONDICAO` ();
	
	
	
    -- -----------------------------
	-- -- SP_ETL_DIM_CLM_DOMINIOS --
	-- -----------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_CLM_DOMINIOS_4M" ();
	
	
	
    -- -----------------------------
	-- -- SP_ETL_DIM_CENTRO_LUCRO --
	-- -----------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_CENTRO_LUCRO_4M" ();
	
	
	
    -- -------------------------------
	-- -- SP_ETL_DIM_DEDUCAOMINALUG --
	-- -------------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_DEDUCAOMINALUG_4M" ();
	
	
	
    -- -------------------------
	-- -- SP_ETL_DIM_ALUGPERC --
	-- -------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_ALUGPERC_4M" ();
	
	
	
    -- ----------------------------------
	-- -- SP_ETL_DIM_ACRESCIMOCONTRATO --
	-- ----------------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_ACRESCIMOCONTRATO_4M" ();
	
	
	
    -- --------------------------------
	-- -- SP_ETL_DIM_ALUGMINCONTRATO --
	-- --------------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_ALUGMINCONTRATO_4M" ();
	
	
	
    -- ------------------------------
	-- -- SP_ETL_DIM_CONDESPEC_CES --
	-- ------------------------------
	-- CALL "also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_CONDESPEC_CES_4M" ();
	
	
	
    -- -----------------------------
	-- -- SP_ETL_DIM_CONDICAO_FAT --
	-- -----------------------------
	-- CALL `also-analytics-model-nonprod.8_CARGA_DADOS.SP_ETL_DIM_CONDICAO_FAT_4M` ();
END;
