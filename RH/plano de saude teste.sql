-- Definir a CTE para consolidar os resultados das três partes da consulta
WITH CTE AS (
    -- Primeira parte: HISTÓRICO COPARTICIPAÇÃO
    SELECT 
        trim(SRA.RA_FILIAL) as FILIAL,
        CASE SRA.RA_FILIAL
            WHEN '010101' THEN 'MATRIZ'
            WHEN '010102' THEN 'FILIAL'
        END as NOME_FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
        trim(SRA.RA_ESTADO) as UF,
        CONVERT(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        CASE SRA.RA_SITFOLH WHEN '' THEN 'OK' ELSE SRA.RA_SITFOLH END as SITUACAO,
        CASE WHEN trim(SRA.RA_SITFOLH) != 'D' THEN 'S' ELSE 'N' END as ATIVO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        DATEDIFF(year, SRA.RA_NASC, RHP.RHP_DTOCOR) as IDADE,
        RHP.RHP_COMPPG as PERIODO,
        CASE WHEN RHP.RHP_PD IN (87, 565, 571) THEN 'HAPVIDA'
            ELSE CASE WHEN RHP.RHP_PD IN (88) THEN 'UNIMED'
                ELSE CASE WHEN RHP.RHP_PD IN (428, 429) THEN 'REDE SAUDE'
                    ELSE CASE WHEN RHP.RHP_PD IN (569, 570, 574, 575, 576, 577, 711, 78) THEN 'ODONTO'
                        ELSE CASE WHEN RHP.RHP_PD IN (624, 625) THEN 'COPARTICIPACAO'
                            ELSE 'OUTROS'
                            END
                        END
                    END
                END
            END as TIPO_VERBA,
        trim(ISNULL(SRV.RV_DESC, '-')) as NOMEVERBA,
        CASE RHP.RHP_ORIGEM
            WHEN 1 THEN SRA.RA_NOME
            WHEN 2 THEN DEP.RB_NOME
            WHEN 3 THEN RHM.RHM_NOME
            ELSE NULL
        END as USUARIO,
        CASE RHP.RHP_ORIGEM
            WHEN 1 THEN 'TITULAR'
            WHEN 2 THEN 'DEPENDENTE'
            WHEN 3 THEN 'AGREGADO'
            ELSE 'OUTROS'
        END as TIPO_USUARIO,
        CASE RHP.RHP_ORIGEM
            WHEN 1 THEN trim(SRA.RA_SEXO)
            WHEN 2 THEN trim(DEP.RB_SEXO)
            WHEN 3 THEN trim(RHM.RHM_YSEXO)
            ELSE 'OUTROS'
        END as SEXO_USUARIO,
        CASE RHP.RHP_ORIGEM
            WHEN 1 THEN CONVERT(date, SRA.RA_NASC, 103)
            WHEN 2 THEN CONVERT(date, DEP.RB_DTNASC, 103)
            WHEN 3 THEN CONVERT(date, RHM.RHM_DTNASC, 103)
            ELSE NULL
        END as NASCIMENTO,
        CASE RHP.RHP_ORIGEM
            WHEN 1 THEN DATEDIFF(year, SRA.RA_NASC, RHP.RHP_DTOCOR)
            WHEN 2 THEN DATEDIFF(year, DEP.RB_DTNASC, RHP.RHP_DTOCOR)
            WHEN 3 THEN DATEDIFF(year, RHM.RHM_DTNASC, RHP.RHP_DTOCOR)
            ELSE NULL
        END as IDADE_USUARIO,
        CASE WHEN RHP.RHP_ORIGEM = 1 THEN RHP.RHP_VLRFUN ELSE 0.0 END as VALOR_FUNC,
        CASE WHEN RHP.RHP_ORIGEM != 1 THEN RHP.RHP_VLRFUN ELSE 0.0 END as VALOR_DEPAGG,
        trim(DEP.RB_PARENT) as PARENTESCO,
        trim(DEP.RB_NOME) as NOME_DEP,
        trim(DEP.RB_SEXO) as SEXO_DEP,
        CONVERT(date, DEP.RB_DTNASC, 103) as NASCIMENTO_DEP,
        DATEDIFF(year, DEP.RB_DTNASC, RHP.RHP_DTOCOR) as IDADE_DEP,
        trim(RHM.RHM_GRAU) as GRAU_AGREGADO,
        trim(RHM.RHM_NOME) as NOME_AGREGADO,
        trim(RHM.RHM_YSEXO) as SEXO_AGREGADO,
        CONVERT(date, RHM.RHM_DTNASC, 103) as NASCIMENTO_AGREGADO,
        DATEDIFF(year, RHM.RHM_DTNASC, RHP.RHP_DTOCOR) as IDADE_AGREGADO,
        RHP.RHP_PD as CODIGO_VERBA,
        RHP.RHP_LIQTOT as VALOR_LIQUIDO,
        RHP.RHP_LIQFOL as VALOR_LIQFOLHA,
        RHP.RHP_VALDESC as VALOR_DESCONTO,
        RHP.RHP_DESCPE as VALOR_DESCONTO_FOLHA,
        RHP.RHP_VALACRE as VALOR_ACRESCIMO,
        RHP.RHP_ACREPE as VALOR_ACRESCIMO_FOLHA,
        RHP.RHP_VLRCOBR as VALOR_COBRADO
    FROM 
        SRARHP as RHP
    INNER JOIN 
        SRAFUNC as SRA 
    ON 
        RHP.RHP_MAT = SRA.RA_MAT
    LEFT JOIN 
        SRJ as SRJ 
    ON 
        SRA.RA_FUNCAO = SRJ.RJ_COD
    LEFT JOIN 
        CTT as CTT 
    ON 
        RHP.RHP_CC = CTT.CTT_CUSTO
    LEFT JOIN 
        CTD as CTD 
    ON 
        RHP.RHP_ITEM = CTD.CTD_ITEM
    LEFT JOIN 
        SQB as SQB 
    ON 
        RHP.RHP_DEPTO = SQB.QB_COD
    LEFT JOIN 
        SRV
    ON 
        RHP.RHP_SERV = SRV.RV_COD
    LEFT JOIN 
        SRARHPDEP as DEP
    ON 
        RHP.RHP_MAT = DEP.RB_MAT AND RHP.RHP_SEQDEP = DEP.RB_SEQDEP
    LEFT JOIN 
        SRARHPM as RHM
    ON 
        RHP.RHP_MAT = RHM.RHM_MAT AND RHP.RHP_SEQDEP = RHM.RHM_SEQDEP
    WHERE 
        RHP.RHP_PD IN (624, 625) -- Considera apenas verbas de coparticipação

    UNION ALL

    -- Segunda parte: HISTÓRICO CONTRACHEQUE
    SELECT 
        trim(SRA.RA_FILIAL) as FILIAL,
        CASE SRA.RA_FILIAL
            WHEN '010101' THEN 'MATRIZ'
            WHEN '010102' THEN 'FILIAL'
        END as NOME_FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        trim(SRA.RA_MUNICIP) as MUNICIPIO,
        trim(SRA.RA_ESTADO) as UF,
        CONVERT(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        CASE SRA.RA_SITFOLH WHEN '' THEN 'OK' ELSE SRA.RA_SITFOLH END as SITUACAO,
        CASE WHEN trim(SRA.RA_SITFOLH) != 'D' THEN 'S' ELSE 'N' END as ATIVO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,
        DATEDIFF(year, SRA.RA_NASC, RHC.RHC_DTOCOR) as IDADE,
        RHC.RHC_PERIODO as PERIODO,
        CASE RHC.RHC_PD
            WHEN 87 THEN 'HAPVIDA'
            WHEN 565 THEN 'UNIMED'
            WHEN 571 THEN 'REDE SAUDE'
            WHEN 428 THEN 'REDE SAUDE'
            WHEN 429 THEN 'REDE SAUDE'
            ELSE 'OUTROS'
        END as TIPO_VERBA,
        trim(SRV.RV_DESC) as NOMEVERBA,
        trim(RHC.RHC_USR) as USUARIO,
        'TITULAR' as TIPO_USUARIO,
        trim(SRA.RA_SEXO) as SEXO_USUARIO,
        CONVERT(date, SRA.RA_NASC, 103) as NASCIMENTO,
        DATEDIFF(year, SRA.RA_NASC, RHC.RHC_DTOCOR) as IDADE_USUARIO,
        RHC.RHC_VLRFUN as VALOR_FUNC,
        0.0 as VALOR_DEPAGG,
        '' as PARENTESCO,
        '' as NOME_DEP,
        '' as SEXO_DEP,
        NULL as NASCIMENTO_DEP,
        NULL as IDADE_DEP,
        '' as GRAU_AGREGADO,
        '' as NOME_AGREGADO,
        '' as SEXO_AGREGADO,
        NULL as NASCIMENTO_AGREGADO,
        NULL as IDADE_AGREGADO,
        RHC.RHC_PD as CODIGO_VERBA,
        RHC.RHC_LIQTOT as VALOR_LIQUIDO,
        RHC.RHC_LIQFOL as VALOR_LIQFOLHA,
        RHC.RHC_VALDESC as VALOR_DESCONTO,
        RHC.RHC_DESCPE as VALOR_DESCONTO_FOLHA,
        RHC.RHC_VALACRE as VALOR_ACRESCIMO,
        RHC.RHC_ACREPE as VALOR_ACRESCIMO_FOLHA,
        0.0 as VALOR_COBRADO
    FROM 
        SRARHC as RHC
    INNER JOIN 
        SRAFUNC as SRA 
    ON 
        RHC.RHC_MAT = SRA.RA_MAT
    LEFT JOIN 
        SRJ as SRJ 
    ON 
        SRA.RA_FUNCAO = SRJ.RJ_COD
    LEFT JOIN 
        CTT as CTT 
    ON 
        RHC.RHC_CC = CTT.CTT_CUSTO
    LEFT JOIN 
        CTD as CTD 
    ON 
        RHC.RHC_ITEM = CTD.CTD_ITEM
    LEFT JOIN 
        SQB as SQB 
    ON 
        RHC.RHC_DEPTO = SQB.QB_COD
    LEFT JOIN 
        SRV
    ON 
        RHC.RHC_SERV = SRV.RV_COD
    WHERE 
        RHC.RHC_PD IN (624, 625) -- Considera apenas verbas de coparticipação
) AS SUBQUERY
ORDER BY 
    FILIAL, MATRICULA, PERIODO;
