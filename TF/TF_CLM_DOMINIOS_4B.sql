CREATE OR REPLACE TABLE FUNCTION also-analytics-model-prod.2_NEGOCIO_S4TF_CLM_DOMINIOS_4B () AS

SELECT DISTINCT
	FQM.COMPANY_CODE AS CHAVE,
	'EMPRESA' AS DOMINIO,
	CASE WHEN FQM.COMPANY_CODE = '2000' THEN 'Shop. Parque D.Pedro - 2000'
			WHEN FQM.COMPANY_CODE = '1077' THEN 'Blv. Shopping Bel?m - 1077'
			WHEN FQM.COMPANY_CODE = '1082' THEN '2008 Empr. Comerciais - 1082'	
			WHEN FQM.COMPANY_CODE = '2026' THEN 'Complexo Comer. Colina - 2026'
			ELSE BUTXT||' - '||BUKRS  END AS TEXTO,
	BUTXT||' - '||BUKRS  AS TEXTO LONGO			     
FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.T001` EMP
	ON EMP.BUKRS = FQM.COMPANY_CODE
WHERE EMP.LAND1 = 'BR'

UNION ALL

--'NIVEL_CERTEZA'
SELECT DISTINCT
	FQM.CERTAINTY_LEVEL AS CHAVE,
	'NIVEL_CERTEZA' AS DOMINIO,
	CASE WHEN FQM.CERTAINTY_LEVEL = 'PAYRQ' THEN  'Previs?o de Pagamentos - Ordem de Pagamento (FI)'
		WHEN FQM.CERTAINTY_LEVEL = 'PAY_N'  THEN  'Previs?o de Pagamentos - Fornecedores'
		WHEN FQM.CERTAINTY_LEVEL = 'PYORD' THEN 'Previs?o de Pagamentos - Ordem de Pagamento (TRM)'
		WHEN FQM.CERTAINTY_LEVEL = 'MEMO' THEN  'Previs?o de Pagamentos - Folha e D?bito Autom?tico'
		WHEN FQM.CERTAINTY_LEVEL = 'MMPO' THEN  'Planejado de Compras - Pedido'
		WHEN FQM.CERTAINTY_LEVEL = 'MMPR' THEN  'Planejado Compras - Requisi??o de Compras'
		WHEN FQM.CERTAINTY_LEVEL = 'MMSA' THEN  'Planejado COmpras - Remessa de Compras'
		WHEN FQM.CERTAINTY_LEVEL = 'ACTUAL' THEN  'Realizado'
		WHEN FQM.CERTAINTY_LEVEL = 'LEASE' THEN 'Planejado Faturamento - Contratos'
		WHEN FQM.CERTAINTY_LEVEL = 'REC_N' THEN  'Previs?o de Recebimentos - Clientes'
		WHEN FQM.CERTAINTY_LEVEL = 'SI_CIT' THEN  'Movimenta??es n?o Conciliadas'
		WHEN FQM.CERTAINTY_LEVEL = 'TRM_D' THEN  'Planejado Opera??es Financeiras - Aplica??es e Financiamentos'
		WHEN FQM.CERTAINTY_LEVEL = 'SDSA' THEN  'Planejado Servi?os - Presta??o de Servi?os'
		WHEN FQM.CERTAINTY_LEVEL = 'SDSO' THEN  'Planejado Servi?os - Presta??o de Servi?os'
	ELSE DD.DDTEXT END AS TEXTO,
	DD.DDTEXT AS TEXTO_LONGO
FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.DD07T` DD
	ON DD.DOMVALUE_L = FQM.CERTAINTY_LEVEL
WHERE DD.DDLANGUAGE = 'P' and DD.DOMNAME = 'FQM_CERTAINTY_LEVEL'
		
		
UNION ALL

--'CENTRO_LUCRO'
	SELECT DISTINCT
		FQM.PROFIT_CENTER AS CHAVE,
		'CENTRO_LUCRO' AS DOMINIO,
		CASE WHEN C.KTEXT LIKE 'Corp/Est Comum' THEN 'Corporativo' ELSE
		C.KTEXT END AS TEXTO,
		C.KTEXT AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
	LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.CEPCT` C
		ON C.PRCTR = FQM.PROFIT_CENTER
	WHERE KTEXT NOT LIKE '%Anul%'	
		
	UNION ALL
	
--'LANCAMENTOS_BSEG'
SELECT DISTINCT
		FQM.FI_DOCUMENT_NUMBER || FQM.COMPANY_CODE || FQM.FI_FISCAL_YEAR AS CHAVE,
		'LANCAMENTOS_BSEG' AS DOMINIO,
		B.SGTXT AS TEXTO,
		B.SGTXT AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM, `also-analytics-model-prod.1_AQUISICAO_S4.BSEG` B
	WHERE B.BELNR = FQM.FI_DOCUMENT_NUMBER 
		AND B.BUKRS = FQM.COMPANY_CODE
		AND B.GJAHR = FQM.FI_FISCAL_YEAR
		AND B.KOKRS = 1000
		AND B.SGTXT != ''
		AND B.BELNR || B.BUKRS || B.GJAHR || B.BSCHL = 
									(SELECT BELNR || BUKRS || GJAHR || MIN(TO_NUMBER(BSCHL)) AS POSTING_KEY
									FROM `also-analytics-model-prod.1_AQUISICAO_S4.BSEG`
									WHERE B.BELNR = BELNR 
										AND B.BUKRS = BUKRS
										AND B.GJAHR = GJAHR
										AND KOKRS = 1000
										AND SGTXT != ''
									GROUP BY BELNR, BUKRS, GJAHR)
		
UNION ALL

--'REFERENCIA'
	SELECT DISTINCT
		FQM.FI_DOCUMENT_NUMBER || FQM.COMPANY_CODE || FQM.FI_FISCAL_YEAR AS CHAVE,
		'REFERENCIA' AS DOMINIO,
		B.XBLNR AS TEXTO,
		B.XBLNR AS TEXTO_LONG
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
	LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.BKPF` B
		ON B.BELNR = FQM.FI_DOCUMENT_NUMBER 
		AND B.BUKRS = FQM.COMPANY_CODE
		AND B.GJAHR = FQM.FI_FISCAL_YEAR
				
UNION ALL

--'NOME_CLIENTE'
	SELECT DISTINCT
		FQM.CUSTOMER_NUMBER AS CHAVE,
		'NOME_CLIENTE' AS DOMINIO,
		CASE WHEN B.NAME_ORG1 = '' THEN B.MC_NAME1 ELSE B.NAME_ORG1 END  AS TEXTO,
		CASE WHEN B.NAME_ORG1 = '' THEN B.MC_NAME1 ELSE B.NAME_ORG1 END  AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
	LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.BUT000` B
		ON B.PARTNER = FQM.CUSTOMER_NUMBER
				
UNION ALL

--'NOME_FORNECEDOR'
	SELECT DISTINCT
		FQM.VENDOR_NUMBER AS CHAVE,
		'NOME_FORNECEDOR' AS DOMINIO,
		B.NAME_ORG1 AS TEXTO,
		B.NAME_ORG1 AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
	LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.BUT000` B
		ON B.PARTNER = FQM.VENDOR_NUMBER
			
UNION ALL

--'NIVEL_TESOURARIA'
	SELECT DISTINCT
		FQM.PLANNING_LEVEL AS CHAVE,
		'NIVEL_TESOURARIA' AS DOMINIO,
		T.LTEXT AS TEXTO,
		T.LTEXT AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` FQM, `also-analytics-model-prod.1_AQUISICAO_S4.T036T` T
	WHERE T.EBENE = FQM.PLANNING_LEVEL
		AND SPRAS = 'P'
				
UNION ALL

--'RAZAO_SOCIAL_PARC'
	SELECT DISTINCT
		FQM.PARTNER AS CHAVE,
		'RAZAO_SOCIAL_PARC' AS DOMINIO,
		B.NAME_ORG1 AS TEXTO,
		B.NAME_ORG1 AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
	LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.BUT000` B
		ON B.PARTNER = FQM.PARTNER
		
UNION ALL

--'CONTA_RAZAO'
	SELECT DISTINCT
		FQM.FI_ACCOUNT AS CHAVE,
		'CONTA_RAZAO' AS DOMINIO,
		SK.TXT20 AS TEXTO,
		SK.TXT20 AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
	LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.SKAT` SK
		ON SK.SAKNR = FQM.FI_ACCOUNT
	WHERE SK.KTOPL = 'PCBR'
		
UNION ALL

--'TIPO_CONTA'
	SELECT DISTINCT
		FQM.FI_ACCOUNT_TYPE AS CHAVE,
		'TIPO_CONTA' AS DOMINIO,
		DD.DDTEXT AS TEXTO,
		DD.DDTEXT AS TEXTO_LONGO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
	LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.DD07T` DD
		ON DD.DOMVALUE_L = FQM.FI_ACCOUNT_TYPE
	WHERE DD.DDLANGUAGE = 'P' and DD.DOMNAME = 'KOART'
	
UNION ALL
	
--'STATUS_CONTA'
SELECT DISTINCT
	F.ACC_ID AS CHAVE,
	'STATUS_CONTA' AS DOMINIO,
	DD.DDTEXT AS TEXTO,
	DD.DDTEXT AS TEXTO_LONGO
FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD` F,
	(SELECT
		ACC_ID,
		MAX(TO_NUMBER(REVISION)) AS REVISION
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD`
	GROUP BY ACC_ID) M,
	`also-analytics-model-prod.1_AQUISICAO_S4.DD07T` DD
WHERE DD.DDLANGUAGE = 'P' and DD.DOMVALUE_L = F.STATUS
	AND DD.DOMNAME = 'FCLM_BAM_ACC_STATUS'
	AND F.ACC_ID = M.ACC_ID
	AND F.REVISION = M.REVISION
	AND F.ACC_ID IN (SELECT DISTINCT BANK_ACCOUNT_ID FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL`)
	
UNION ALL
		
--'CONTA_BANCARIA'
	SELECT DISTINCT
	F.ACC_ID AS CHAVE,
	'CONTA_BANCARIA' AS DOMINIO,
	Q.COMPANY_CODE || ' - ' ||F.DESCRIPTION AS TEXTO,
	Q.COMPANY_CODE || ' - ' ||F.DESCRIPTION AS TEXTO_LONGO
--	F.DESCRIPTION||' :: (Emp.: '||Q.COMPANY_CODE||' - '||BUTXT||')' AS TEXTO_LONGO
FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD_T` F
INNER JOIN (SELECT ACC_ID,MAX(TO_NUMBER(REVISION)) AS REVISION FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD_T` GROUP BY ACC_ID) M
ON F.ACC_ID = M.ACC_ID AND F.REVISION = M.REVISION
INNER JOIN (SELECT DISTINCT	FQM.BANK_ACCOUNT_ID, FQM.COMPANY_CODE, EMP.BUTXT
			FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL` AS FQM
			LEFT OUTER JOIN `also-analytics-model-prod.1_AQUISICAO_S4.T001` EMP ON EMP.BUKRS = FQM.COMPANY_CODE	WHERE EMP.LAND1 = 'BR') Q
ON F.ACC_ID = Q.BANK_ACCOUNT_ID

/*	SELECT DISTINCT
		F.ACC_ID AS CHAVE,
		'CONTA_BANCARIA' AS DOMINIO,
		F.DESCRIPTION AS TEXTO
		--F.BANKS AS TEXTO
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD_T` F,
		(SELECT
			ACC_ID,
			MAX(TO_NUMBER(REVISION)) AS REVISION
		FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD_T`
		GROUP BY ACC_ID) M
	WHERE F.ACC_ID = M.ACC_ID
		AND F.REVISION = M.REVISION
		AND F.ACC_ID IN (SELECT DISTINCT BANK_ACCOUNT_ID FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL`)
*/

UNION ALL

--'NUMERO_CONTA'
SELECT DISTINCT
	F.ACC_ID AS CHAVE,
	'NUMERO_CONTA' AS DOMINIO,
	F.ACC_NUM AS TEXTO,
	F.ACC_NUM AS TEXTO_LONGO
	--F.BANKS AS TEXTO
FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD` F,
	(SELECT
		ACC_ID,
		MAX(TO_NUMBER(REVISION)) AS REVISION
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD`
	GROUP BY ACC_ID) M
WHERE F.ACC_ID = M.ACC_ID
	AND F.REVISION = M.REVISION
	AND F.ACC_ID IN (SELECT DISTINCT BANK_ACCOUNT_ID FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL`)
	
UNION ALL
	
--'CHAVE_BANCO'
SELECT DISTINCT
	F.ACC_ID AS CHAVE,
	'CHAVE_BANCO' AS DOMINIO,
	F.BANKL AS TEXTO,
	F.BANKL AS TEXTO_LONGO
FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD` F,
	(SELECT
		ACC_ID,
		MAX(TO_NUMBER(REVISION)) AS REVISION
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD`
	GROUP BY ACC_ID) M
WHERE F.ACC_ID = M.ACC_ID
	AND F.REVISION = M.REVISION
	AND F.ACC_ID IN (SELECT DISTINCT BANK_ACCOUNT_ID FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL`)
	
UNION ALL
	
--'PAIS_BANCO'
SELECT DISTINCT
	F.ACC_ID AS CHAVE,
	'PAIS_BANCO' AS DOMINIO,
	F.BANKS AS TEXTO,
	F.BANKS AS TEXTO_LONGO
FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD` F,
	(SELECT
		ACC_ID,
		MAX(TO_NUMBER(REVISION)) AS REVISION
	FROM `also-analytics-model-prod.1_AQUISICAO_S4.FCLM_BAM_AMD`
	GROUP BY ACC_ID) M
WHERE F.ACC_ID = M.ACC_ID
	AND F.REVISION = M.REVISION
	AND F.ACC_ID IN (SELECT DISTINCT BANK_ACCOUNT_ID FROM `also-analytics-model-prod.1_AQUISICAO_S4.FQM_FLOW_FINAL`)
