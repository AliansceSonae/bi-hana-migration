CREATE OR REPLACE PROCEDURE `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NFANTASIA_HIST` () 

BEGIN
		DELETE FROM `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NFANTASIA_HIST` WHERE 1=1;


		INSERT INTO `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NFANTASIA_HIST`
		(INTRENO,CALMONTH,UDATETIME,ZZNMFAN,ZZNMFAN_OLD,ZZNMFAN_NEW,CONTADOR,CHANGE_TIME)
		SELECT
			INTRENO,CALMONTH,UDATETIME,ZZNMFAN,ZZNMFAN_OLD,ZZNMFAN_NEW,CONTADOR,CURRENT_TIMESTAMP() AS CHANGE_TIME
		FROM `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_NFANTASIA_HIST_4B`();
END;
