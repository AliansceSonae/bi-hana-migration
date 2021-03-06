CREATE OR REPLACE TABLE FUNCTION `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_CONTRATO_4B`() AS (
WITH var_atvabrasce AS (
SELECT
    ATA_DSATIVIDADE,
    ATA_CDSHOPPING,
    MAX(ATA_CDATIVIDADE) AS ATA_CDATIVIDADE
FROM
    `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_ATVABRASCE`
GROUP BY
    ATA_DSATIVIDADE,
    ATA_CDSHOPPING
),

var_atvabrasce_fallback AS (
SELECT
    ATA_DSATIVIDADE,
    ATA_CDSHOPPING,
    MAX(ATA_CDATIVIDADE) AS ATA_CDATIVIDADE
FROM
    `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_ATVABRASCE`
WHERE
    ATA_DSATIVIDADE = 'OUTROS'
GROUP BY
    ATA_DSATIVIDADE,
    ATA_CDSHOPPING
),

var_unidade_max AS (
SELECT
    INTRENO_VICNCN,
    CASE
        WHEN MAX(CALMONTH_MAX) = FORMAT_DATE('%Y%m', CURRENT_TIMESTAMP()) THEN MAX(CALMONTH_MAX)
        WHEN MAX(CALMONTH_MIN) = FORMAT_DATE('%Y%m', CURRENT_TIMESTAMP()) THEN MAX(CALMONTH_MIN)
        ELSE IFNULL(MAX(CALMONTH_MAX), MAX(CALMONTH_MIN))
    END AS CALMONTH
FROM
    (
        SELECT
            INTRENO_VICNCN,
            MAX(CALMONTH) AS CALMONTH_MAX,
            NULL AS CALMONTH_MIN
        FROM
            `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_UNIDADE_HIST`
        WHERE
            CALMONTH <= FORMAT_DATE('%Y%m', CURRENT_TIMESTAMP())
        GROUP BY
            INTRENO_VICNCN
        UNION DISTINCT
        SELECT
            INTRENO_VICNCN,
            NULL AS CALMONTH_MAX,
            MIN(CALMONTH) AS CALMONTH_MIN
        FROM
            `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_UNIDADE_HIST`
        WHERE
            CALMONTH >= FORMAT_DATE('%Y%m', CURRENT_TIMESTAMP())
        GROUP BY
            INTRENO_VICNCN
    )
GROUP BY
    INTRENO_VICNCN
),

var_unidade AS (
SELECT
    UNIDADE.*
FROM
    `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_UNIDADE_HIST` AS UNIDADE
    INNER JOIN var_unidade_max AS UNIDADE_MAX ON UNIDADE_MAX.INTRENO_VICNCN = UNIDADE.INTRENO_VICNCN
    AND UNIDADE_MAX.CALMONTH = UNIDADE.CALMONTH
),

var_vibdobjass AS (
SELECT
    T1.OBJNRSRC,
    MAX(T1.OBJNRTRG) AS OBJNRTRG
FROM
    `also-analytics-model-nonprod.1_AQUISICAO_S4.vibdobjass` AS T1
    INNER JOIN (
        SELECT
            OBJNRSRC,
            MIN(OBJASSTYPE) AS OBJASSTYPE
        FROM
            `also-analytics-model-nonprod.1_AQUISICAO_S4.vibdobjass`
        WHERE
            OBJASSTYPE IN ('10', '15')
        GROUP BY
            OBJNRSRC
    ) AS T2 ON T1.OBJNRSRC = T2.OBJNRSRC
    AND T1.OBJASSTYPE = T2.OBJASSTYPE
GROUP BY
    T1.OBJNRSRC
),

var_edificio_falback AS (
SELECT
    VIBDOBJASS.OBJNRSRC,
    MAX(UE.CSHP_CDSHOPPING) AS CSHP_CDSHOPPING
FROM
    `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_UNIDADE_ECONOMICA` AS UE
    INNER JOIN var_vibdobjass AS VIBDOBJASS ON UE.OBJNR = VIBDOBJASS.OBJNRTRG
GROUP BY
    VIBDOBJASS.OBJNRSRC
),

var_rede AS (
SELECT
    MAX(T1.ZCODREDE) AS ZCODREDE,
    T1.ZREDE
FROM
    (
        SELECT
            ZCODREDE,
            UPPER(ZREDE) AS ZREDE
        FROM
            `also-analytics-model-nonprod.1_AQUISICAO_S4.ztre003_rede`
    ) AS T1
GROUP BY
    T1.ZREDE
),

var_vibpobjrel AS (
SELECT
    T3.INTRENO,
    MAX(T3.PARTNER_TR0200) AS PARTNER_TR0200,
    MAX(T3.PARTNER_TR0600) AS PARTNER_TR0600,
    MAX(T3.PARTNER_TR0605) AS PARTNER_TR0605,
    MAX(T3.PARTNER_TR0806) AS PARTNER_TR0806
FROM
    (
        SELECT
            T1.INTRENO,
            CASE
                WHEN T1.ROLE = 'TR0200' THEN PARTNER
                ELSE NULL
            END AS PARTNER_TR0200,
            CASE
                WHEN T1.ROLE = 'TR0600' THEN PARTNER
                ELSE NULL
            END AS PARTNER_TR0600,
            CASE
                WHEN T1.ROLE = 'TR0605' THEN PARTNER
                ELSE NULL
            END AS PARTNER_TR0605,
            CASE
                WHEN T1.ROLE = 'TR0806' THEN PARTNER
                ELSE NULL
            END AS PARTNER_TR0806
        FROM
            `also-analytics-model-nonprod.1_AQUISICAO_S4.vibpobjrel`  AS T1
            INNER JOIN (
                SELECT
                    MAX(OBJRELGUID) AS OBJRELGUID,
                    INTRENO,
                    ROLE
                FROM
                    `also-analytics-model-nonprod.1_AQUISICAO_S4.vibpobjrel`
                WHERE
                    VALIDTO >= FORMAT_DATE('%Y%m', CURRENT_TIMESTAMP())
                    AND ROLE IN ('TR0200', 'TR0600', 'TR0605', 'TR0806')
                GROUP BY
                    INTRENO,
                    ROLE
            ) AS T2 ON T2.OBJRELGUID = T1.OBJRELGUID
    ) AS T3
GROUP BY
    T3.INTRENO
),

var_cto_re AS (
SELECT
    INTRENO_VICNCN,
    MAX(FLAG_CTO_1) AS FLAG_CTO_1,
    MAX(FLAG_CTO_2) AS FLAG_CTO_2
FROM
    (
        SELECT
            CALMONTH,
            INTRENO_VICNCN,
            CASE
                WHEN CALMONTH = FORMAT_DATE('%Y%m', CURRENT_TIMESTAMP()) THEN MAX(FLAG_CTO)
                ELSE NULL
            END AS FLAG_CTO_1,
            CASE
                WHEN CALMONTH = FORMAT_DATE('%Y%m', DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH)) THEN MAX(FLAG_CTO)
                ELSE NULL
            END AS FLAG_CTO_2
        FROM
            `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_FLUXO_FINANCEIRO_RE_4B` ()
        WHERE
            CALMONTH BETWEEN FORMAT_DATE('%Y%m', DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH))
            AND FORMAT_DATE('%Y%m', CURRENT_TIMESTAMP())
        GROUP BY
            CALMONTH,
            INTRENO_VICNCN
    )
GROUP BY
    INTRENO_VICNCN
),

var_grpabrasce AS (
SELECT
    Q1.*
FROM
    `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_GRPABRASCE` AS Q1
    INNER JOIN (
        SELECT
            SHP_CDSHOPPING,
            ZGRABRASCE,
            MAX(KEY_GRPABRASCE) AS KEY_GRPABRASCE
        FROM
            `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_GRPABRASCE`
        GROUP BY
            SHP_CDSHOPPING,
            ZGRABRASCE
    ) AS Q2 ON Q2.SHP_CDSHOPPING = Q1.SHP_CDSHOPPING
    AND Q2.KEY_GRPABRASCE = Q1.KEY_GRPABRASCE
),

var_data_base_reajuste_max AS (
SELECT
    Q1.INTRENO_VICNCN,
    Q1.TERMTYPE,
    Q1.TERMNO,
    MAX(Q1.VALIDFROM) AS VALIDFROM
FROM
    `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_CONTRATO_CLAUSULA_4B`() AS Q1
    INNER JOIN (
        SELECT
            INTRENO_VICNCN,
            TERMTYPE,
            MAX(TERMNO) AS TERMNO
        FROM
            `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_CONTRATO_CLAUSULA_4B` ()
        WHERE
            TERMTYPE = '1300'
        GROUP BY
            INTRENO_VICNCN,
            TERMTYPE
    ) AS Q2 ON Q2.INTRENO_VICNCN = Q1.INTRENO_VICNCN
    AND Q2.TERMTYPE = Q1.TERMTYPE
    AND Q2.TERMNO = Q1.TERMNO
GROUP BY
    Q1.INTRENO_VICNCN,
    Q1.TERMTYPE,
    Q1.TERMNO
),

var_data_base_reajuste AS (
SELECT
    Q1.INTRENO_VICNCN,
    Q1.TERMTYPE,
    Q1.TERMNO,
    Q1.VALIDFROM,
    MAX(Q1.ADJMFIRSTDATE) AS ADJMFIRSTDATE,
    MAX(CC_PERIO_REAJUSTE) AS CC_PERIO_REAJUSTE
FROM
    `also-analytics-model-nonprod.2_NEGOCIO_S4.TF_CONTRATO_CLAUSULA_4B` () AS Q1
    INNER JOIN var_data_base_reajuste_max AS Q2 ON Q2.INTRENO_VICNCN = Q1.INTRENO_VICNCN
    AND Q2.TERMTYPE = Q1.TERMTYPE
    AND Q2.TERMNO = Q1.TERMNO
    AND Q2.VALIDFROM = Q1.VALIDFROM
GROUP BY
    Q1.INTRENO_VICNCN,
    Q1.TERMTYPE,
    Q1.TERMNO,
    Q1.VALIDFROM
),

var_saida AS (
SELECT
    VICNCN.INTRENO AS INTRENO_VICNCN,
    UNIDADE.INTRENO_VIBDRO,
    OBJLOC.INTRENO_VIBDBU,
    OBJLOC.INTRENO_VIBDBE,
    VICNCN.BUKRS,
    OBJLOC.SWENR,
    VICNCN.RECNNR,
    VICNCN.OBJNR,
    VICNCN.IMKEY,
    VICNCN.RECNTYPE,
    TIV2F.XKBEZ AS RECNTYPE_TEXT15,
    TIV2F.XMBEZ AS RECNTYPE_TEXT30,
    CASE
        WHEN VICNCN.RECNBEG = 00000000 THEN NULL
        ELSE VICNCN.RECNBEG
    END AS RECNBEG,
    CASE
        WHEN VICNCN.RECNENDABS = 00000000 THEN NULL
        ELSE VICNCN.RECNENDABS
    END AS RECNENDABS,
    CASE
        WHEN FORMAT_DATE('%Y%m%d', VICNCN.ZZREDFIM) = 00000000 THEN NULL
        ELSE VICNCN.ZZREDFIM
    END AS ZZREDFIM,
    VICNCN.RECNTXT,
    CASE
        WHEN VICNCN.RECNDACTIV = 00000000 THEN NULL
        ELSE VICNCN.RECNDACTIV
    END AS RECNDACTIV,
    VICNCN.RECNTXTOLD,
    VICNCN.RECNBUKRSCOLLECT,
    VICNCN.RECNNRCOLLECT,
    CASE
        WHEN VICNCN.RECNDAT = 00000000 THEN NULL
        ELSE VICNCN.RECNDAT
    END AS RECNDAT,
    CASE
        WHEN VICNCN.RECNEND1ST = 00000000 THEN NULL
        ELSE VICNCN.RECNEND1ST
    END AS RECNEND1ST,
    CASE
        WHEN VICNCN.RECNNOTPER = 00000000 THEN NULL
        ELSE VICNCN.RECNNOTPER
    END AS RECNNOTPER,
    CASE
        WHEN VICNCN.RECNNOTRECEIPT = 00000000 THEN NULL
        ELSE VICNCN.RECNNOTRECEIPT
    END AS RECNNOTRECEIPT,
    VICNCN.RECNNOTREASON,
    TIVCNNTRET.XSNTREASON AS RECNNOTREASON_TEXT15,
    TIVCNNTRET.XNTREASON AS RECNNOTREASON_TEXT30,
    CASE
        WHEN VICNCN.RECNDAKTKU = 00000000 THEN NULL
        ELSE VICNCN.RECNDAKTKU
    END AS RECNDAKTKU,
    VICNCN.BENOCN,
    CASE
        WHEN VICNCN.TRANSPOSSFROM = 00000000 THEN NULL
        ELSE VICNCN.TRANSPOSSFROM
    END AS TRANSPOSSFROM,
    CASE
        WHEN VICNCN.TRANSPOSSTO = 00000000 THEN NULL
        ELSE VICNCN.TRANSPOSSTO
    END AS TRANSPOSSTO,
    VICNCN.ZZLJRISCO,
    VICNCN.ZZBRINCEND,
    IFNULL(GRPABL.ZCODABL, '-1') AS ZCODABL,
    CASE
        WHEN IFNULL(VICNCN.ZZCLASS_ZGRABL, '') = '' THEN 'N/A'
        ELSE UPPER(VICNCN.ZZCLASS_ZGRABL)
    END AS ZZCLASS_ZGRABL,
    IFNULL(
        GRPABRASCE.ZCODABRASCE,
        GRPABRASCE_DEFAULT.ZCODABRASCE
    ) AS ZCODABRASCE,
    IFNULL(
        GRPABRASCE.ZGRABRASCE,
        GRPABRASCE_DEFAULT.ZGRABRASCE
    ) AS ZZCLASS_ZGRABRASCE,
    IFNULL(ZTRE003_REDE.ZCODREDE, '-1') AS ZCODREDE,
    CASE
        WHEN IFNULL(VICNCN.ZZCLASS_ZREDE, '') = '' THEN 'N/A'
        ELSE UPPER(VICNCN.ZZCLASS_ZREDE)
    END AS ZZCLASS_ZREDE,
    ZTRE004_GARANTIA.ZCODGAR,
    UPPER(VICNCN.ZZCLASS_ZTPGARANTIA) AS ZZCLASS_ZTPGARANTIA,
    NATPB.CODNATPB,
    NATPB.ZENATPB AS ZZCLASS_ZNATPB,
    VICNCN.ZZINTEREST_PERCENT,
    VICNCN.ZZFINE_PERCENT,
    VICNCN.ZZMONETARY_INDEX,
    VICNCN.ZZINDEX_YEAR,
    VICNCN.ZZRECSF,
    CASE
        WHEN VICNCN.ZZREDILJ = 00000000 THEN NULL
        ELSE VICNCN.ZZREDILJ
    END AS ZZREDILJ,
    CASE
        WHEN VICNCN.ZZRECONS = 00000000 THEN NULL
        ELSE VICNCN.ZZRECONS
    END AS ZZRECONS,
    VICNCN.ZZRECOB,
    VICNCN.ZZRENED,
    VICNCN.ZZRECES,
    CASE
        WHEN VICNCN.ZZREIREF = 00000000 THEN NULL
        ELSE VICNCN.ZZREIREF
    END AS ZZREIREF,
    CASE
        WHEN VICNCN.ZZREFREF = 00000000 THEN NULL
        ELSE VICNCN.ZZREFREF
    END AS ZZREFREF,
    CASE
        WHEN VICNCN.ZZREPREF = 00000000 THEN NULL
        ELSE VICNCN.ZZREPREF
    END AS ZZREPREF,
    OBJLOC.XMETXT,
    OBJREL.PARTNER_TR0200,
    UPPER(TRIM(TR0200.MC_NAME2 || ' ' || TR0200.MC_NAME1)) AS PARTNER_TR0200_NAME,
    OBJREL.PARTNER_TR0600,
    UPPER(TRIM(TR0600.MC_NAME2 || ' ' || TR0600.MC_NAME1)) AS PARTNER_TR0600_NAME,
    OBJREL.PARTNER_TR0605,
    UPPER(TRIM(TR0605.MC_NAME2 || ' ' || TR0605.MC_NAME1)) AS PARTNER_TR0605_NAME,
    OBJREL.PARTNER_TR0806,
    UPPER(TRIM(TR0806.MC_NAME2 || ' ' || TR0806.MC_NAME1)) AS PARTNER_TR0806_NAME,
    OBJLOC.FQMFLART,
    OBJLOC.FEINS,
    CASE
        WHEN VICNCN.RECNTYPE = 'Z005' THEN 1
        WHEN OBJLOC.ZVENDLOC = 'VEND' THEN 1
        ELSE 0
    END AS CDTPAQUISICAO,
    IFNULL(OBJLOC.CSHP_CDSHOPPING, EDIFICIO.CSHP_CDSHOPPING) AS CSHP_CDSHOPPING,
    OBJLOC.CDTIPOUNL,
    IFNULL(
        ATVABRASCE.ATA_CDATIVIDADE,
        ATVABRASCE_FALLBACK.ATA_CDATIVIDADE
    ) AS ATA_CDATIVIDADE,
    GRPABL.CDGRPABL,
    IFNULL(
        GRPABRASCE.KEY_GRPABRASCE,
        GRPABRASCE_DEFAULT.KEY_GRPABRASCE
    ) AS KEY_GRPABRASCE,
    IFNULL(
        IFNULL(CTO_RE.FLAG_CTO_1, CTO_RE.FLAG_CTO_2),
        'N'
    ) AS FLAG_CTO,
    REAJUSTE.ADJMFIRSTDATE,
    REAJUSTE.CC_PERIO_REAJUSTE,
    OBJLOC.ZVENDLOC
FROM
    `also-analytics-model-nonprod.1_AQUISICAO_S4.vicncn` AS VICNCN
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tiv2f` AS TIV2F 
    ON TIV2F.MANDT = VICNCN.MANDT
    AND TIV2F.SMVART = VICNCN.RECNTYPE
    AND TIV2F.SPRAS = 'P'
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.tivcnntret` AS TIVCNNTRET 
    ON TIVCNNTRET.MANDT = VICNCN.MANDT
    AND TIVCNNTRET.NTREASON = VICNCN.RECNNOTREASON
    AND TIVCNNTRET.SPRAS = 'P'
    LEFT OUTER JOIN `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_GRPABL` AS GRPABL 
    ON UPPER(VICNCN.ZZCLASS_ZGRABL) = UPPER(GRPABL.ZGRABL)
    LEFT OUTER JOIN var_rede AS ZTRE003_REDE ON UPPER(VICNCN.ZZCLASS_ZREDE) = ZTRE003_REDE.ZREDE
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.ztre004_garantia` AS ZTRE004_GARANTIA 
    ON VICNCN.MANDT = ZTRE004_GARANTIA.MANDT
    AND UPPER(VICNCN.ZZCLASS_ZTPGARANTIA) = UPPER(ZTRE004_GARANTIA.ZTPGARANTIA)
    LEFT OUTER JOIN var_unidade AS UNIDADE ON UNIDADE.INTRENO_VICNCN = VICNCN.INTRENO
    LEFT OUTER JOIN `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_OBJETO_LOCACAO` AS OBJLOC 
    ON OBJLOC.INTRENO_VIBDRO = UNIDADE.INTRENO_VIBDRO
    LEFT OUTER JOIN `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_NATUREZA_PB` AS NATPB 
    ON UPPER(NATPB.ZENATPB) = CASE WHEN VICNCN.ZZCLASS_ZNATPB = '' THEN 'OUTROS' ELSE UPPER(VICNCN.ZZCLASS_ZNATPB) END 
   
    LEFT OUTER JOIN var_atvabrasce AS ATVABRASCE ON OBJLOC.CSHP_CDSHOPPING = ATVABRASCE.ATA_CDSHOPPING
    AND UPPER(NATPB.ZENATPB) = UPPER(ATVABRASCE.ATA_DSATIVIDADE)
    LEFT OUTER JOIN var_atvabrasce_fallback AS ATVABRASCE_FALLBACK ON OBJLOC.CSHP_CDSHOPPING = ATVABRASCE_FALLBACK.ATA_CDSHOPPING
    LEFT OUTER JOIN var_grpabrasce AS GRPABRASCE ON UPPER(VICNCN.ZZCLASS_ZGRABRASCE) = UPPER(GRPABRASCE.ZGRABRASCE)
    AND OBJLOC.CSHP_CDSHOPPING = GRPABRASCE.SHP_CDSHOPPING
    LEFT OUTER JOIN `also-analytics-model-nonprod.3_MATERIALIZADO_S4.DIM_GRPABRASCE` AS GRPABRASCE_DEFAULT ON GRPABRASCE_DEFAULT.KEY_GRPABRASCE = 'S4' || '-' || OBJLOC.CSHP_CDSHOPPING || '-' || '99'
    LEFT OUTER JOIN var_edificio_falback AS EDIFICIO ON EDIFICIO.OBJNRSRC = VICNCN.OBJNR
    LEFT OUTER JOIN var_vibpobjrel AS OBJREL ON OBJREL.INTRENO = VICNCN.INTRENO
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.but000` AS TR0200 ON OBJREL.PARTNER_TR0200 = TR0200.PARTNER
    AND OBJREL.PARTNER_TR0200 IS NOT NULL
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.but000` AS TR0600 ON OBJREL.PARTNER_TR0600 = TR0600.PARTNER
    AND OBJREL.PARTNER_TR0600 IS NOT NULL
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.but000` AS TR0605 ON OBJREL.PARTNER_TR0605 = TR0605.PARTNER
    AND OBJREL.PARTNER_TR0605 IS NOT NULL
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_S4.but000` AS TR0806 ON OBJREL.PARTNER_TR0806 = TR0806.PARTNER
    AND OBJREL.PARTNER_TR0806 IS NOT NULL
    LEFT OUTER JOIN var_cto_re AS CTO_RE ON CTO_RE.INTRENO_VICNCN = VICNCN.INTRENO
    LEFT OUTER JOIN var_data_base_reajuste AS REAJUSTE ON REAJUSTE.INTRENO_VICNCN = VICNCN.INTRENO
),

var_contr_mxm AS (
SELECT
    CSHP_CDSHOPPING,
    CSHP_CDCONTRATO,
    CC_CSHP_CDCONTRATO,
    CSHP_DTCADASTRO,
    ROW_NUMBER() OVER (
        PARTITION BY CSHP_CDSHOPPING,
        CC_CSHP_CDCONTRATO
        ORDER BY
            CSHP_CDSHOPPING,
            CC_CSHP_CDCONTRATO ASC,
            CSHP_DTCADASTRO DESC
    ) AS ROW_NUM
FROM
    (
        SELECT
            CSHP_CDSHOPPING,
            CSHP_CDCONTRATO,
            RIGHT('0000000000' || CONTR_MXM.CSHP_CDCONTRATO, 10) AS CC_CSHP_CDCONTRATO,
            CSHP_DTCADASTRO
        FROM
            `also-analytics-model-nonprod.1_AQUISICAO_MXM.dm_contratoshp_cshp` AS CONTR_MXM
    )
)

-- select * from var_saida
SELECT
    SAIDA.INTRENO_VICNCN,
    CONTR_ECC.INTRENO AS INTRENO_ECC,
    SAIDA.INTRENO_VIBDRO,
    SAIDA.INTRENO_VIBDBU,
    SAIDA.INTRENO_VIBDBE,
    SAIDA.BUKRS,
    SAIDA.SWENR,
    SAIDA.RECNNR,
    SAIDA.OBJNR,
    SAIDA.IMKEY,
    SAIDA.RECNTYPE,
    SAIDA.RECNTYPE_TEXT15,
    SAIDA.RECNTYPE_TEXT30,
    SAIDA.RECNBEG,
    SAIDA.RECNENDABS,
    SAIDA.ZZREDFIM,
    SAIDA.RECNTXT,
    SAIDA.RECNDACTIV,
    SAIDA.RECNTXTOLD,
    SAIDA.RECNBUKRSCOLLECT,
    SAIDA.RECNNRCOLLECT,
    SAIDA.RECNDAT,
    SAIDA.RECNEND1ST,
    SAIDA.RECNNOTPER,
    SAIDA.RECNNOTRECEIPT,
    SAIDA.RECNNOTREASON,
    SAIDA.RECNNOTREASON_TEXT15,
    SAIDA.RECNNOTREASON_TEXT30,
    SAIDA.RECNDAKTKU,
    SAIDA.BENOCN,
    SAIDA.TRANSPOSSFROM,
    SAIDA.TRANSPOSSTO,
    SAIDA.ZZLJRISCO,
    SAIDA.ZZBRINCEND,
    SAIDA.ZCODABL,
    SAIDA.ZZCLASS_ZGRABL,
    SAIDA.ZCODABRASCE,
    SAIDA.ZZCLASS_ZGRABRASCE,
    SAIDA.ZCODREDE,
    SAIDA.ZZCLASS_ZREDE,
    SAIDA.ZCODGAR,
    SAIDA.ZZCLASS_ZTPGARANTIA,
    SAIDA.CODNATPB,
    SAIDA.ZZCLASS_ZNATPB,
    SAIDA.ZZINTEREST_PERCENT,
    SAIDA.ZZFINE_PERCENT,
    SAIDA.ZZMONETARY_INDEX,
    SAIDA.ZZINDEX_YEAR,
    SAIDA.ZZRECSF,
    SAIDA.ZZREDILJ,
    SAIDA.ZZRECONS,
    SAIDA.ZZRECOB,
    SAIDA.ZZRENED,
    SAIDA.ZZRECES,
    SAIDA.ZZREIREF,
    SAIDA.ZZREFREF,
    SAIDA.ZZREPREF,
    SAIDA.XMETXT,
    SAIDA.PARTNER_TR0200,
    SAIDA.PARTNER_TR0200_NAME,
    SAIDA.PARTNER_TR0600,
    SAIDA.PARTNER_TR0600_NAME,
    SAIDA.PARTNER_TR0605,
    SAIDA.PARTNER_TR0605_NAME,
    SAIDA.PARTNER_TR0806,
    SAIDA.PARTNER_TR0806_NAME,
    SAIDA.ADJMFIRSTDATE,
    SAIDA.CC_PERIO_REAJUSTE,
    CASE
        WHEN SAIDA.CDTIPOUNL IN ('04', '00006', '05', '2') THEN 0
        ELSE SAIDA.FQMFLART
    END AS CC_FQMFLART_SONAE,
    SAIDA.FQMFLART,
    SAIDA.FEINS,
    SAIDA.CDTPAQUISICAO,
    SAIDA.CSHP_CDSHOPPING,
    SAIDA.INTRENO_VICNCN AS CSHP_CDCONTRATO,
    CONTR_MXM.CSHP_CDCONTRATO AS CSHP_CDCONTRATO_MXM,
    LEFT(SAIDA.RECNTXT, 50) AS CSHP_NMFANTASIA,
    SAIDA.RECNDACTIV AS CSHP_DTCADASTRO,
    SAIDA.RECNBEG AS CSHP_DTINICIO,
    SAIDA.RECNENDABS AS CSHP_DTFIM,
    SAIDA.RECNNOTPER AS CSHP_DTENCERRAMENTO,
    0 AS CSHP_DDREAJUSTE,
    SAIDA.ADJMFIRSTDATE AS CSHP_DTBASEREAJUSTE,
    SAIDA.ZZFINE_PERCENT AS CSHP_PCMULTA,
    SAIDA.ZZINTEREST_PERCENT AS CSHP_PCJUROS,
    SAIDA.ZZREDILJ AS CSHP_DTINAUGURA,
    DATE_DIFF(PARSE_DATE('%Y%m%d',SAIDA.RECNBEG),PARSE_DATE('%Y%m%d',SAIDA.RECNEND1ST), MONTH) + 1 AS CSHP_PRAZO,
    SAIDA.RECNBEG AS CSHP_DTASSINATURA,
    0 AS CSHP_CDSTATUS,
    SAIDA.ZCODREDE AS CSHP_IDREDELOJA,
    CASE
        WHEN SAIDA.ZZCLASS_ZREDE = 'N/A' THEN LEFT(SAIDA.RECNTXT, 40)
        ELSE SAIDA.ZZCLASS_ZREDE
    END AS RLS_NOMEREDE,
    SAIDA.RECNBEG AS CSHP_DTINCLUSAO,
    SAIDA.RECNNOTPER AS CSHP_DTDISTRATO,
    CASE
        WHEN SAIDA.RECNTYPE = 'Z004' THEN 'S4' || '-' || SAIDA.CSHP_CDSHOPPING || '-' || '98'
        ELSE SAIDA.KEY_GRPABRASCE
    END AS CC_CDGRUPO,
    SAIDA.FQMFLART AS CC_ABL,
    SAIDA.ATA_CDATIVIDADE AS CSHP_CDATIVIDADE,
    0 AS CSHP_VBPOSSUIACRESESP,
    -- CASE
    --     WHEN SAIDA.ZZCLASS_ZGRABRASCE LIKE '%ENTRETENIMENTO%' THEN '04' -- Buscar do S/4 ao inv?s de calcular
    --     WHEN SAIDA.ZZCLASS_ZGRABRASCE LIKE '%LAZER%' THEN '04'
    --     WHEN SAIDA.FQMFLART < 10 THEN '99'
    --     WHEN SAIDA.FQMFLART < 500 THEN '01'
    --     WHEN SAIDA.FQMFLART < 1000 THEN '02'
    --     WHEN SAIDA.FQMFLART >= 1000 THEN '03'
    --     ELSE '01'
    -- END AS CC_CDGRUPOABL,
    SAIDA.CDGRPABL AS CC_CDGRUPOABL,
    SAIDA.CDTIPOUNL AS CSHP_CDTIPOUNL,
    SAIDA.INTRENO_VICNCN AS INTRENO,
    SAIDA.RECNBEG AS DMIBEG,
    SAIDA.RECNENDABS AS DMIEND,
    LEFT(SAIDA.RECNTXT, 40) AS ZZNMFAN,
    LEFT(SAIDA.XMETXT, 20) AS CDUNIDADE,
    LEFT(SAIDA.XMETXT, 8) AS SMENR,
    NULL AS ZZGRPAT_BR,
    NULL AS ZZSUGRP_BR,
    NULL AS ZZATIVM_BR,
    SAIDA.CDGRPABL AS SNUNR,
    SAIDA.RECNNOTPER AS DKUEZU,
    SAIDA.RECNDACTIV AS DAKTV,
    SAIDA.RECNDAT AS USR08,
    SAIDA.RECNNR AS SMIVE,
    SAIDA.CDTIPOUNL AS CDTIPOUNL,
    SAIDA.INTRENO_VICNCN AS ABNNR,
    CASE
        WHEN SAIDA.RECNTYPE = 'Z004' THEN 'S4' || '-' || SAIDA.CSHP_CDSHOPPING || '-' || '98'
        ELSE SAIDA.KEY_GRPABRASCE
    END AS KEY_GRPABRASCE,
    SAIDA.ATA_CDATIVIDADE AS KEY_ATVABRASCE,
    CASE
        WHEN CONTR_MXM.CSHP_CDCONTRATO IS NOT NULL THEN CONTR_MXM.CSHP_CDCONTRATO
        WHEN CONTR_ECC.INTRENO IS NOT NULL THEN CONTR_ECC.INTRENO
        ELSE SAIDA.INTRENO_VICNCN
    END AS CC_CDCONTRATO,
    CASE
        WHEN CONTR_MXM.CSHP_CDCONTRATO IS NOT NULL THEN CONTR_MXM.CSHP_CDCONTRATO
        WHEN CONTR_ECC.INTRENO IS NOT NULL THEN CONTR_ECC.SMIVE
        ELSE SAIDA.RECNNR
    END AS CC_SMIVE,
    DATE_DIFF(PARSE_DATE('%Y%m%d',SAIDA.RECNENDABS), PARSE_DATE('%Y%m%d',SAIDA.RECNBEG), DAY) AS CC_DIAS_VENCTO,
    SAIDA.FLAG_CTO AS FLAG_CTO,
    CASE
        WHEN PARSE_DATE('%Y%m%d',SAIDA.RECNBEG) > CURRENT_DATE() THEN 'N'
        WHEN PARSE_DATE('%Y%m%d',SAIDA.RECNENDABS) < CURRENT_DATE() THEN 'N'
        ELSE 'S'
    END AS FLAG_ATIVO
FROM
    var_saida AS SAIDA
    LEFT OUTER JOIN `also-analytics-model-nonprod.1_AQUISICAO_ECC.dim_contrato_sb` AS CONTR_ECC ON CONTR_ECC.BUKRS = SAIDA.CSHP_CDSHOPPING
    AND CONTR_ECC.SMIVE = RIGHT(SAIDA.RECNTXTOLD, 13)
    LEFT OUTER JOIN var_contr_mxm AS CONTR_MXM ON CONTR_MXM.CSHP_CDSHOPPING = SAIDA.CSHP_CDSHOPPING
    AND (
        CONTR_MXM.CC_CSHP_CDCONTRATO = RIGHT(SAIDA.RECNTXTOLD, 10)
        OR CONTR_MXM.CSHP_CDCONTRATO = SAIDA.RECNTXTOLD
    )
    AND CONTR_MXM.ROW_NUM = 1
WHERE
    SAIDA.CSHP_CDSHOPPING IS NOT NULL
);