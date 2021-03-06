CREATE OR REPLACE TABLE PROCEDURE `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_ALUGPERC` () 

BEGIN
		DELETE FROM `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_ALUGPERC` WHERE 1=1;

		INSERT INTO `also-analytics-model-prod.3_MATERIALIZADO_S4.DIM_ALUGPERC`
		(BUKRS, CSHP_CDSHOPPING, INTRENO_VICNCN, CC_CDCONTRATO, RECNNR, TERMTYPE, XTERMTYPE, TERMNO, ITEMNO, VALIDFROM, 
		 VALIDTO, USECF4POST, IS_MASTER, SALESRULE, SALESCURR, SALESUNIT, MINSALES, MAXSALES, MINQUANTITY, MAXQUANTITY, 
		 MINRENT, RENTPERCENT, PRICEPERUNIT, CHANGE_TIME)
		SELECT
		 BUKRS, CSHP_CDSHOPPING, INTRENO_VICNCN, CC_CDCONTRATO, RECNNR, TERMTYPE, XTERMTYPE, TERMNO, ITEMNO, VALIDFROM, 
		 VALIDTO, USECF4POST, IS_MASTER, SALESRULE, SALESCURR, SALESUNIT, MINSALES, MAXSALES, MINQUANTITY, MAXQUANTITY, 
		 MINRENT, RENTPERCENT, PRICEPERUNIT, CURRENT_TIMESTAMP() AS CHANGE_TIME
		FROM `also-analytics-model-prod.2_NEGOCIO_S4.TF_ALUGPERC_4B`();
			
END;
