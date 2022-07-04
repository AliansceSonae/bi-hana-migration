CREATE OR REPLACE TABLE FUNCTION also-analytics-model-prod.2_NEGOCIO_S4.TF_UNIDADE_HIST_4B 
RETURNS TABLE ( INTRENO_VICNCN STRING (20),
				INTRENO_VIBDRO STRING (20),
				CALMONTH VARCHAR (6), 
				FQMFLART DECIMAL (14, 4), 
				FQMFLART_STR VARCHAR (15), 
				FEINS STRING (3)
)
LANGUAGE SQLSCRIPT
SQL SECURITY DEFINER
  AS 

 BEGIN 
 	DECLARE var_date_begin DATE;
	DECLARE var_date_end DATE;
	
	var_date_begin = '20210101';
	var_date_end = ADD_YEARS(:var_date_begin, 10);
	
	
	
	var_contr =
		SELECT 
			INTRENO AS INTRENO_VICNCN,
			OBJNR,
			CASE WHEN RECNBEG IS NULL				THEN :var_date_begin
				 WHEN RECNBEG = ''				THEN :var_date_begin
				 WHEN RECNBEG <	:var_date_begin	THEN :var_date_begin
				 ELSE RECNBEG
			END AS RECNBEG,
			CASE WHEN RECNENDABS IS NULL			THEN :var_date_end
				 WHEN RECNENDABS = '' 			THEN :var_date_end
				 WHEN RECNENDABS > :var_date_end	THEN :var_date_end
				 ELSE RECNENDABS
			END AS RECNENDABS
		FROM also-analytics-model-prod.1_AQUISICAO_S4.VICNCN;
			
			
			
	var_contr_tempo =
		SELECT 
			CONTR.INTRENO_VICNCN,
			CONTR.OBJNR,
			TEMPO.CALMONTH,
			CONTR.RECNBEG,
			CONTR.RECNENDABS
		FROM :var_contr AS CONTR
		INNER JOIN TARGET::DIM_TEMPO_MENSAL AS TEMPO
			ON  TO_VARCHAR(CONTR.RECNBEG   , 'YYYYMM') <= TEMPO.CALMONTH
			AND TO_VARCHAR(CONTR.RECNENDABS, 'YYYYMM') >= TEMPO.CALMONTH
		WHERE TEMPO.CALMONTH BETWEEN TO_VARCHAR(:var_date_begin, 'YYYYMM') AND TO_VARCHAR(:var_date_end, 'YYYYMM');
 

 
	var_vibdobjass =
		SELECT
			VIBDOBJASS.MANDT,
			VIBDOBJASS.OBJNRSRC,
			VIBDOBJASS.OBJASSTYPE,
			VIBDOBJASS.OBJNRTRG,
			MAX(VIBDOBJASS.VALIDFROM) AS VALIDFROM,
			TEMPO.CALMONTH
		FROM also-analytics-model-prod.1_AQUISICAO_S4.VIBDOBJASS   AS VIBDOBJASS
		INNER JOIN TARGET::DM_TEMPO_MENSAL AS TEMPO
			ON  MAP(LEFT(VIBDOBJASS.VALIDFROM, 6), '000000', TO_VARCHAR(:var_date_begin, 'YYYYMM'), LEFT(VIBDOBJASS.VALIDFROM, 6)) <= TEMPO.CALMONTH
		    AND LEFT(VIBDOBJASS.VALIDTO  , 6)                       																   >= TEMPO.CALMONTH
		INNER JOIN also-analytics-model-prod.1_AQUISICAO_S4.VICNCN AS CONTR
			ON CONTR.OBJNR = VIBDOBJASS.OBJNRSRC
		WHERE VIBDOBJASS.OBJASSTYPE = '10'
		  AND TEMPO.CALMONTH BETWEEN TO_VARCHAR(:var_date_begin, 'YYYYMM') AND TO_VARCHAR(:var_date_end, 'YYYYMM')
		GROUP BY 			
			VIBDOBJASS.MANDT,
			VIBDOBJASS.OBJNRSRC,
			VIBDOBJASS.OBJASSTYPE,
			VIBDOBJASS.OBJNRTRG,
			TEMPO.CALMONTH;
		
		
		
	var_vibdobjass_max =
		SELECT
			T1.MANDT,
			T1.OBJNRSRC,
			T1.OBJASSTYPE,
			T1.OBJNRTRG,
			T1.VALIDFROM,
			T1.CALMONTH
		FROM :var_vibdobjass AS T1
		INNER JOIN 
			(
				SELECT
					MANDT,
					OBJNRSRC,
					OBJASSTYPE,
					MIN(OBJNRTRG) AS OBJNRTRG,
					CALMONTH
				FROM :var_vibdobjass
				WHERE OBJASSTYPE = '10'
				GROUP BY
					MANDT,
					OBJNRSRC,
					OBJASSTYPE,
					CALMONTH
			) AS T2
		ON  T1.MANDT      = T2.MANDT
		AND T1.OBJNRSRC   = T2.OBJNRSRC
		AND T1.OBJASSTYPE = T2.OBJASSTYPE
		AND T1.OBJNRTRG   = T2.OBJNRTRG
		AND T1.CALMONTH   = T2.CALMONTH;
		
		
		
	
		SELECT 
			CONTR.INTRENO_VICNCN			AS INTRENO_VICNCN,
			OBJLOC.INTRENO_VIBDRO			AS INTRENO_VIBDRO,
			CONTR.CALMONTH					AS CALMONTH,
			IFNULL(MEDICAO.FQMFLART, 0)		AS FQMFLART,
			IFNULL(MEDICAO.FQMFLART, 0)		AS FQMFLART_STR,
			IFNULL(MEDICAO.FEINS, 'M2') 	AS FEINS
		FROM :var_contr_tempo AS CONTR
		LEFT OUTER JOIN :var_vibdobjass_max AS VIBDOBJASS
			ON  CONTR.OBJNR    = VIBDOBJASS.OBJNRSRC
			AND CONTR.CALMONTH = VIBDOBJASS.CALMONTH
		LEFT OUTER JOIN also-analytics-model-prod.DIM_OBJETO_LOCACAO_4P
			(placeholder.$$IP_ATUALIDADE_DADOS$$=>:IP_ATUALIDADE_DADOS) AS OBJLOC
			ON  VIBDOBJASS.OBJNRTRG = OBJLOC.OBJNR
		LEFT OUTER JOIN aliansceSonae.4_presentation.financeiro.s4::CVW_OBJETO_LOCACAO_MEDICAO_MENSAL_4P
			(placeholder.$$IP_ATUALIDADE_DADOS$$=>:IP_ATUALIDADE_DADOS) AS MEDICAO
			ON  MEDICAO.INTRENO_VIBDRO = OBJLOC.INTRENO_VIBDRO
			AND MEDICAO.CALMONTH       = CONTR.CALMONTH
		WHERE OBJLOC.INTRENO_VIBDRO IS NOT NULL;