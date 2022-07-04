CREATE OR REPLACE TABLE FUNCTION aliansceSonae.2_business.financeiro.s4::TF_FLUXO_FINANCEIRO_RE_4B ()


	var_cfstatus =
		SELECT 'P' AS CFSTATUS, 'Registro planejado'		AS CFSTATUS_TEXT FROM DUMMY UNION
		SELECT 'I' AS CFSTATUS, 'Registro real'			AS CFSTATUS_TEXT FROM DUMMY UNION
		SELECT 'V' AS CFSTATUS, 'Parcialmente estornado'	AS CFSTATUS_TEXT FROM DUMMY;



	var_classificacao =
		SELECT
			COND.CONDTYPE,
			IFNULL(ALUG_CONTRATUAL, 0)	AS ALUG_CONTRATUAL,
			IFNULL(ALUG_FATURADO, 0)		AS ALUG_FATURADO,
			IFNULL(ALUG_LIQUIDO, 0)		AS ALUG_LIQUIDO,
			IFNULL(ALUG_TOT, 0)			AS ALUG_TOT,
			IFNULL(DESC_CARENCIA, 0)		AS DESC_CARENCIA,
			IFNULL(ALUG_COMPLEMENTAR, 0)	AS ALUG_COMPLEMENTAR,
			IFNULL(ENC_COMUM, 0)			AS ENC_COMUM,
			IFNULL(ENC_ESPECIFICO, 0) 	AS ENC_ESPECIFICO,
			IFNULL(FPP, 0)				AS FPP,
			IFNULL(CO, 0) 				AS CO,
			IFNULL(CO_COM_ESPECIFICO, 0)	AS CO_COM_ESPECIFICO,
			IFNULL(CARENCIA, 0)			AS CARENCIA,
			IFNULL(DESCONTO_PRE, 0)		AS DESCONTO_PRE,
			IFNULL(NEGATIVO, 1)			AS NEGATIVO,
			IFNULL(IPTU, 0)				AS IPTU,
			IFNULL(TX_TRANSF, 0)			AS TX_TRANSF
		FROM also-analytics-model-prod.DIM_CONDICAO_4P
			(placeholder.$$IP_ATUALIDADE_DADOS$$=>:IP_ATUALIDADE_DADOS) AS COND
		LEFT OUTER JOIN also-analytics-model-prod.DIM_CONDICAO_FAT_4P
			(placeholder.$$IP_ATUALIDADE_DADOS$$=>:IP_ATUALIDADE_DADOS) AS CLASS
			ON COND.CONDTYPE = CLASS.CONDTYPE;
			
			
			
	var_flow_type =
		SELECT
			FLOW.FLOWTYPE,
			TXT.XFLOWTYPE,
			FLOW.SSOLHAB,
			CASE WHEN FLOW.SSOLHAB = 'H' THEN -1 ELSE 1 END AS NEGATIVO
		FROM also-analytics-model-prod.1_AQUISICAO_S4.TIVCDFLOWTYPE AS FLOW
		LEFT OUTER JOIN also-analytics-model-prod.1_AQUISICAO_S4.TIVCDFLOWTYPET AS TXT
			ON  TXT.FLOWTYPE = FLOW.FLOWTYPE
			AND TXT.SPRAS    = 'P';
			
			
			
	var_icon_cfstatus = 
		SELECT '8X' AS ICON_CFSTATUS, 'Entrada marcada manualmente'		AS ICON_CFSTATUS_TEXT FROM DUMMY UNION
		SELECT 'B4' AS ICON_CFSTATUS, 'Entrada já lançada'				AS ICON_CFSTATUS_TEXT FROM DUMMY UNION
		SELECT 'B3' AS ICON_CFSTATUS, 'Entrada a ser lançada'				AS ICON_CFSTATUS_TEXT FROM DUMMY UNION
		SELECT 'P8' AS ICON_CFSTATUS, 'Entrada especial já lançada'		AS ICON_CFSTATUS_TEXT FROM DUMMY UNION
		SELECT '5B' AS ICON_CFSTATUS, 'Entrada marcada como lançada'		AS ICON_CFSTATUS_TEXT FROM DUMMY;
		
		
		
	var_alug_perc =
		SELECT
			PAY.CFPAYGUID,
			CALCDETAIL.RESULTGUID,
			CALCDETAIL.ITEMNO,
			CALCDETAIL.RENTPERCENT,
			CALCDETAIL.SALES,
			CALCDETAIL.SALESRENT,
			CALCSUM.PAYNET,
			CALCSUM.RECEIVABLENET,
			CALCSUM.BALANCENET,
			ROW_NUMBER() OVER (PARTITION BY PAY.CFPAYGUID ORDER BY CALCDETAIL.RESULTGUID, CALCDETAIL.ITEMNO DESC) AS ROW_NUM
		FROM also-analytics-model-prod.1_AQUISICAO_S4.VICDCFPAY AS PAY
		INNER JOIN also-analytics-model-prod.1_AQUISICAO_S4.VISRCALCSUM AS CALCSUM
			ON  CALCSUM.CONDGUID = PAY.CONDGUID
			AND CALCSUM.PFROM    = PAY.DBERVON
			AND CALCSUM.PTO      = PAY.DBERBIS
		INNER JOIN also-analytics-model-prod.1_AQUISICAO_S4.VISRCALCREFCF AS CALCREFCF
			ON  CALCREFCF.OBJGUID   = CALCSUM.OBJGUID
			AND CALCREFCF.REFCFTYPE = 'P'
		INNER JOIN also-analytics-model-prod.1_AQUISICAO_S4.VISRCALCSB AS CALCSB
			ON CALCSB.OBJGUID = CALCREFCF.OBJGUID
		INNER JOIN also-analytics-model-prod.1_AQUISICAO_S4.VISRCALCDETAIL AS CALCDETAIL
			ON CALCDETAIL.RESULTGUID = CALCSB.RESULTGUID;



	var_saida = 
		SELECT
			LEFT(VIC.POSTINGDATE, 6)											AS CALMONTH,
			CONTR.CSHP_CDSHOPPING												AS CSHP_CDSHOPPING,
			VIC.INTRENO															AS INTRENO_VICNCN,
			CONTR.CC_CDCONTRATO													AS CC_CDCONTRATO,
			CONTR.RECNNR														AS RECNNR,
			CONTR.BUKRS															AS BUKRS,
			VIC.CFPAYGUID														AS CFPAYGUID,
			VIC.CONDGUID														AS CONDGUID,
			VIC.REFGUID															AS REFGUID,
			VIC.DBERVON															AS DBERVON,
			VIC.DBERBIS															AS DBERBIS,
			VIC.DFAELL															AS DFAELL,
			VIC.DDISPO															AS DDISPO,
			VIC.ATAGE															AS ATAGE,
			VIC.AMMRHY															AS AMMRHY,
			VIC.ATTRHY															AS ATTRHY,
			VIC.FLOWTYPE														AS FLOWTYPE,
			FLOWTYPE.XFLOWTYPE													AS XFLOWTYPE,
			VIC.ORIGFLOWTYPE													AS ORIGFLOWTYPE,
			VIC.REFFLOWREL														AS REFFLOWREL,
			VIC.CFSTATUS														AS CFSTATUS,
			STATUS.CFSTATUS_TEXT												AS CFSTATUS_TEXT,
			VIC.FDELETE 														AS FDELETE,
			VIC.PARTNEROBJNR													AS PARTNEROBJNR,
			VIC.CONDTYPE														AS CONDTYPE,
			COND.CONDTYPE_TEXT20												AS CONDTYPE_TEXT20,
			VIC.POSTINGDATE														AS POSTINGDATE,
			VIC.DOCUMENTDATE													AS DOCUMENTDATE,
			VIC.BOOK_FLOWTYPE													AS BOOK_FLOWTYPE,
			VIC.REVERSAL_FOR													AS REVERSAL_FOR,
			VIC.FOLLOWUP_FOR													AS FOLLOWUP_FOR,
			VIC.BOOK_REFFLOWREL 												AS BOOK_REFFLOWREL,
			FLOWTYPE.SSOLHAB													AS SSOLHAB,
			VIC.BBWHR															AS BBWHR,
			VIC.BNWHR															AS BNWHR,
			IFNULL(ALUG_PERC.RENTPERCENT, 0)									AS RENTPERCENT,
			IFNULL(ALUG_PERC.SALES, 0)											AS SALES,
			IFNULL(ALUG_PERC.SALESRENT, 0)										AS SALESRENT,
			IFNULL(ALUG_PERC.PAYNET, 0)											AS PAYNET,
			IFNULL(ALUG_PERC.RECEIVABLENET, 0)									AS RECEIVABLENET,
			IFNULL(ALUG_PERC.BALANCENET, 0)										AS BALANCENET,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.ALUG_CONTRATUAL 		AS ALUG_CONTRATUAL,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.ALUG_FATURADO		AS ALUG_FATURADO,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.ALUG_LIQUIDO			AS ALUG_LIQUIDO,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.ALUG_TOT				AS ALUG_TOT,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.DESC_CARENCIA		AS DESC_CARENCIA,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.ALUG_COMPLEMENTAR	AS ALUG_COMPLEMENTAR,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.ENC_COMUM			AS ENC_COMUM,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.ENC_ESPECIFICO		AS ENC_ESPECIFICO,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.FPP 					AS FPP,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.CO					AS CO,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.CO_COM_ESPECIFICO	AS CO_COM_ESPECIFICO,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.CARENCIA				AS CARENCIA,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.DESCONTO_PRE			AS DESCONTO_PRE,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.IPTU					AS IPTU,
			VIC.BNWHR * FLOWTYPE.NEGATIVO *  CLASS.TX_TRANSF			AS TX_TRANSF,
			CASE WHEN VIC.CONDTYPE IN ('Z001', 'Z004') THEN 'S' ELSE 'N' END	AS FLAG_CTO,
			CASE WHEN VIC.CFSTATUS = 'I' AND VIRADOC.DOCGUID IS NULL     THEN '8X'
			     WHEN VIC.CFSTATUS = 'I' AND VIRADOC.DOCGUID IS NOT NULL THEN 'B4'
			     WHEN VIC.CFSTATUS = 'P'									 THEN 'B3'
			END AS ICON_CFSTATUS
		FROM also-analytics-model-prod.1_AQUISICAO_S4.VICDCFPAY AS VIC
		LEFT OUTER JOIN also-analytics-model-prod.1_AQUISICAO_S4.VIRADOC AS VIRADOC
			ON VIRADOC.DOCGUID = VIC.REFGUID
		LEFT OUTER JOIN :var_flow_type AS FLOWTYPE
			ON VIC.FLOWTYPE = FLOWTYPE.FLOWTYPE
		LEFT OUTER JOIN also-analytics-model-prod.DIM_CONTRATO_4P
			(placeholder.$$IP_ATUALIDADE_DADOS$$=>:IP_ATUALIDADE_DADOS) AS CONTR
			ON  CONTR.INTRENO_VICNCN = VIC.INTRENO
		LEFT OUTER JOIN :var_cfstatus AS STATUS
			ON STATUS.CFSTATUS = VIC.CFSTATUS
		LEFT OUTER JOIN also-analytics-model-prod.DIM_CONDICAO_4P
			(placeholder.$$IP_ATUALIDADE_DADOS$$=>:IP_ATUALIDADE_DADOS) AS COND
			ON COND.CONDTYPE = VIC.CONDTYPE
		LEFT OUTER JOIN :var_classificacao AS CLASS
			ON CLASS.CONDTYPE = VIC.CONDTYPE
		LEFT OUTER JOIN :var_alug_perc AS ALUG_PERC
			ON  ALUG_PERC.CFPAYGUID = VIC.CFPAYGUID
			AND ALUG_PERC.ROW_NUM   = '1'
			AND VIC.CONDTYPE		= 'Z016'
		WHERE VIC.FDELETE = '';
		
		
		
	RETURN
		SELECT
			SAIDA.CALMONTH,
			SAIDA.CSHP_CDSHOPPING,
			SAIDA.INTRENO_VICNCN,
			SAIDA.CC_CDCONTRATO,
			SAIDA.RECNNR,
			SAIDA.BUKRS,
			SAIDA.CFPAYGUID,
			SAIDA.CONDGUID,
			SAIDA.REFGUID,
			SAIDA.DBERVON,
			SAIDA.DBERBIS,
			SAIDA.DFAELL,
			SAIDA.DDISPO,
			SAIDA.ATAGE,
			SAIDA.AMMRHY,
			SAIDA.ATTRHY,
			SAIDA.FLOWTYPE,
			SAIDA.XFLOWTYPE,
			SAIDA.ORIGFLOWTYPE,
			SAIDA.REFFLOWREL,
			SAIDA.CFSTATUS,
			SAIDA.CFSTATUS_TEXT,
			SAIDA.FDELETE,
			SAIDA.PARTNEROBJNR,
			SAIDA.CONDTYPE,
			SAIDA.CONDTYPE_TEXT20,
			SAIDA.POSTINGDATE,
			SAIDA.DOCUMENTDATE,
			SAIDA.BOOK_FLOWTYPE,
			SAIDA.REVERSAL_FOR,
			SAIDA.FOLLOWUP_FOR,
			SAIDA.BOOK_REFFLOWREL,
			SAIDA.SSOLHAB,
			SAIDA.BBWHR,
			SAIDA.BNWHR,
			SAIDA.RENTPERCENT,
			SAIDA.SALES,
			SAIDA.SALESRENT,
			SAIDA.PAYNET,
			SAIDA.RECEIVABLENET,
			SAIDA.BALANCENET,
			SAIDA.ALUG_CONTRATUAL,
			SAIDA.ALUG_FATURADO,
			SAIDA.ALUG_LIQUIDO,
			SAIDA.ALUG_TOT,
			SAIDA.DESC_CARENCIA,
			SAIDA.ALUG_COMPLEMENTAR,
			SAIDA.ENC_COMUM,
			SAIDA.ENC_ESPECIFICO,
			SAIDA.FPP,
			SAIDA.CO,
			SAIDA.CO_COM_ESPECIFICO,
			SAIDA.CARENCIA,
			SAIDA.DESCONTO_PRE,
			SAIDA.IPTU,
			SAIDA.TX_TRANSF,
			SAIDA.FLAG_CTO,
			SAIDA.ICON_CFSTATUS,
			STATUS.ICON_CFSTATUS_TEXT
		FROM :var_saida AS SAIDA
		LEFT OUTER JOIN :var_icon_cfstatus AS STATUS
			ON STATUS.ICON_CFSTATUS = SAIDA.ICON_CFSTATUS;