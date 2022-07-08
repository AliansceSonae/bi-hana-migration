CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_UNIDADE_ECONOMICA_4B` ()
AS 

WITH var_vzobject AS (
    SELECT 
        ADROBJTYP,
        ADROBJNR,
        MAX(ADRNR) AS ADRNR
    FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.vzobject` 
    WHERE ADROBJTYP = 'VI'
        AND ADROBJNR IN (SELECT INTRENO FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.vibdbe`)
    GROUP BY 			
        ADROBJTYP,
        ADROBJNR
),
        
var_adrc AS (
    SELECT
        T1.*,
        T1.STREET || ', ' || T1.HOUSE_NUM1 || ' - ' || T1.CITY2 AS SHP_DSENDERECO
    FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.adrc` AS T1
    INNER JOIN (
        SELECT
            ADDRNUMBER,
            MAX(DATE_FROM) AS DATE_FROM
        FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.adrc`ADRC
        WHERE ADDRNUMBER IN (SELECT ADRNR FROM var_vzobject GROUP BY ADRNR)
        GROUP BY
            ADDRNUMBER) AS T2
    ON  T2.ADDRNUMBER = T1.ADDRNUMBER
    AND T2.DATE_FROM  = T1.DATE_FROM
),

var_vitmoa AS (
    SELECT T1.*
    FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.vitmoa` AS T1
    INNER JOIN (
        SELECT
            MANDT, 
            INTRENO, 
            TERMTYPE, 
            TERMNO, 
            MAX(VALIDFROM) AS VALIDFROM
        FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.vitmoa`
        WHERE INTRENO IN (SELECT INTRENO FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.vibdbe`)
            AND TERMTYPE = '1120'
        GROUP BY
            MANDT, 
            INTRENO, 
            TERMTYPE, 
            TERMNO) AS T2
    ON  T1.MANDT    = T2.MANDT
    AND T1.INTRENO  = T2.INTRENO
    AND T1.TERMTYPE = T2.TERMTYPE
    AND T1.TERMNO   = T2.TERMNO
)

    SELECT
        VIBDBE.INTRENO									AS INTRENO_VIBDBE,
        VIBDBE.BUKRS									AS BUKRS,
        T001T.TXTMD										AS TXTMD,
        VIBDBE.SWENR									AS SWENR,
        VIBDBE.OBJNR									AS OBJNR,
        VIBDBE.IMKEY									AS IMKEY,
        VIBDBE.XWETEXT									AS XWETEXT,
        VITMOA.PRCTR									AS PRCTR,
        VZOBJECT.ADRNR									AS ADRNR,
        ADRC.STREET										AS STREET,
        ADRC.HOUSE_NUM1 								AS HOUSE_NUM1,
        ADRC.CITY2										AS CITY2,
        ADRC.CITY1										AS CITY1,
        ADRC.REGION 									AS REGION,
        ADRC.POST_CODE1 								AS POST_CODE1,
        ADRC.SHP_DSENDERECO 							AS SHP_DSENDERECO,
        CASE WHEN VIBDBE.SWENR = 'BBA'   THEN 'SNB'
            WHEN VIBDBE.SWENR = 'BBE'   THEN 'BBE'
            WHEN VIBDBE.SWENR = 'BBH'   THEN 'BBH'
            WHEN VIBDBE.SWENR = 'BBR'   THEN 'BBR'
            WHEN VIBDBE.SWENR = 'BCA'   THEN 'BCA'
            WHEN VIBDBE.SWENR = 'BLS'   THEN 'SH11'
            WHEN VIBDBE.SWENR = 'BSC'   THEN 'BSC'
            WHEN VIBDBE.SWENR = 'BVV'   THEN 'BVV'
            WHEN VIBDBE.SWENR = 'CAS'   THEN 'CAS'
            WHEN VIBDBE.SWENR = 'CAX'   THEN 'CAX'
            WHEN VIBDBE.SWENR = 'FRA'   THEN 'SH04'
            WHEN VIBDBE.SWENR = 'MAN'   THEN 'SH10'
            WHEN VIBDBE.SWENR = 'MTR'   THEN 'SH02'
            WHEN VIBDBE.SWENR = 'PAS'   THEN 'SH12'
            WHEN VIBDBE.SWENR = 'PDP'   THEN 'SH06'
            WHEN VIBDBE.SWENR = 'PSB'   THEN 'PSB'
            WHEN VIBDBE.SWENR = 'PSM'   THEN 'PSM'
            WHEN VIBDBE.SWENR = 'PSS'   THEN 'SH08'
            WHEN VIBDBE.SWENR = 'REC'   THEN 'REC'
            WHEN VIBDBE.SWENR = 'SBA01' THEN 'NAC'
            WHEN VIBDBE.SWENR = 'SBA02' THEN 'RIG'
            WHEN VIBDBE.SWENR = 'SCL'   THEN 'SH09'
            WHEN VIBDBE.SWENR = 'SGR'   THEN 'SGR'
            WHEN VIBDBE.SWENR = 'SLB'   THEN 'SLB'
            WHEN VIBDBE.SWENR = 'SPG'   THEN 'SPG'
            WHEN VIBDBE.SWENR = 'SPS'   THEN 'SPS'
            WHEN VIBDBE.SWENR = 'STB'   THEN 'TDS'
            WHEN VIBDBE.SWENR = 'SWP'   THEN 'SWP'
            WHEN VIBDBE.SWENR = 'UBE'   THEN 'SH13'
            WHEN VIBDBE.SWENR = 'VPS'   THEN 'VPS'
            ELSE EMPRESA.CSHP_CDSHOPPING
    END 												AS CSHP_CDSHOPPING
    FROM `also-analytics-model-nonprod.1_AQUISICAO_S4.vibdbe` AS VIBDBE
    LEFT OUTER JOIN `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_EMPRESA_4B`() AS EMPRESA
        ON EMPRESA.BUKRS = VIBDBE.BUKRS
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.biw_t001t` AS T001T
        ON 	T001T.MANDT = VIBDBE.MANDT
        AND T001T.BUKRS = VIBDBE.BUKRS
        AND T001T.LANGU = 'P'
    LEFT OUTER JOIN var_vitmoa AS VITMOA
        ON  VITMOA.MANDT   = VIBDBE.MANDT
        AND VITMOA.INTRENO = VIBDBE.INTRENO
    LEFT OUTER JOIN var_vzobject AS VZOBJECT
        ON VZOBJECT.ADROBJNR = VIBDBE.INTRENO
    LEFT OUTER JOIN var_adrc AS ADRC
        ON ADRC.ADDRNUMBER = VZOBJECT.ADRNR