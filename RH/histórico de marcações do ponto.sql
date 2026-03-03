select 
    trim(SRA.RA_FILIAL) as FILIAL,
    trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQ3.Q3_DESCSUM) as CARGO,
    cast(SRA.RA_ADMISSA as date) as ADMISSAO,
    case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
    trim(CTT.CTT_CUSTO) as CC,
    trim(CTT.CTT_DESC01) as CCUSTO,
    trim(CTD.CTD_ITEM) as ITCT,
    trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
    trim(SRJ.RJ_CODCBO) as CBO,
    trim(SRA.RA_SEXO) as SEXO,
    trim(SRA.RA_CIC) as CPF,

    concat(SPG.PG_TURNO, ' - ', (select trim(SR6010.R6_DESC) from SR6010 (nolock) where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPG.PG_TURNO)) as TURNO,
    case when SPG.TIPO = 'S' then datediff(minute, SPG.APONT_ANT, SPG.APONTAMENTO)/60.0 else 0.0 end as HORAS_TRAB,
    cast(SPG.PG_DATAAPO as date) as DATA_APONT,
    SPG.TIPO,
    SPG.ORDEM_APONT,
    SPG.HORA_APONT,
    SPG.APONTAMENTO,
    SPG.APONT_ANT,
    SPG.PG_DATA,
    SPG.PG_DATAAPO,
    SPG.PG_HORA,
    SPG.PERIODO_APONT,
    SPG.PERIODO_MARCA

from
    (
        select
            SPG010.PG_FILIAL,
            SPG010.PG_MAT,
            SPG010.PG_CC,
            SPG010.PG_DEPTO,
            SPG010.PG_CODFUNC,
            SPG010.PG_TURNO,
            SPG010.PG_RELOGIO,
            SPG010.PG_TPMARCA,
            SPG010.PG_SEMANA,
            SPG010.PG_SEQJRN,
            SPG010.PG_PAPONTA,
            SPG010.PG_DATA,
            SPG010.PG_DATAAPO,
            SPG010.PG_HORA,
            
            CAST(DATEADD(MINUTE, CASE WHEN SPG010.PG_HORA - FLOOR(SPG010.PG_HORA) = 0 THEN 0 ELSE CAST(ROUND((SPG010.PG_HORA - FLOOR(SPG010.PG_HORA)) * 100, 0) AS INT) END, DATEADD(HOUR, CAST(FLOOR(SPG010.PG_HORA) AS INT), '00:00:00')) AS TIME) as HORA_APONT,
            datetimefromparts(YEAR(CAST(SPG010.PG_DATAAPO AS DATE)), MONTH(CAST(SPG010.PG_DATAAPO AS DATE)), DAY(CAST(SPG010.PG_DATAAPO AS DATE)), CAST(FLOOR(SPG010.PG_HORA) AS INT), CASE WHEN SPG010.PG_HORA - FLOOR(SPG010.PG_HORA) = 0 THEN 0 ELSE CAST(ROUND((SPG010.PG_HORA - FLOOR(SPG010.PG_HORA)) * 100, 0) AS INT) END, 0, 0) as APONTAMENTO,
            lag(datetimefromparts(YEAR(CAST(SPG010.PG_DATAAPO AS DATE)), MONTH(CAST(SPG010.PG_DATAAPO AS DATE)), DAY(CAST(SPG010.PG_DATAAPO AS DATE)), CAST(FLOOR(SPG010.PG_HORA) AS INT), CASE WHEN SPG010.PG_HORA - FLOOR(SPG010.PG_HORA) = 0 THEN 0 ELSE CAST(ROUND((SPG010.PG_HORA - FLOOR(SPG010.PG_HORA)) * 100, 0) AS INT) END, 0, 0)) over(partition by SPG010.PG_FILIAL, SPG010.PG_MAT, SPG010.PG_DATAAPO order by SPG010.PG_HORA) as APONT_ANT,

            left(SPG010.PG_TPMARCA, 1) as ORDEM_APONT,
            right(SPG010.PG_TPMARCA, 1) as TIPO,
            row_number() over(partition by SPG010.PG_FILIAL, SPG010.PG_MAT, SPG010.PG_DATAAPO order by SPG010.PG_HORA) as SEQ_APONT,
            
            left(SPG010.PG_DATAAPO, 6) as PERIODO_APONT,
            left(SPG010.PG_DATA, 6) as PERIODO_MARCA
        from SPG010 (nolock)
        where
                SPG010.D_E_L_E_T_ = ''
            and isdate(nullif(SPG010.PG_DATA, '')) = 1
            and isdate(nullif(SPG010.PG_DATAAPO, '')) = 1
            and
                SPG010.PG_HORA in
                (
                    SELECT SPG010.PG_HORA
                    FROM SPG010
                    WHERE
                            SPG010.D_E_L_E_T_ = ''
                        and floor(SPG010.PG_HORA) between 0 and 59
                        and SPG010.PG_HORA - floor(SPG010.PG_HORA) between 0 and 59
                )
    ) SPG
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SPG.PG_FILIAL
        and SRA.RA_MAT = SPG.PG_MAT

        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRA.RA_ITEM

    left join SQB010 SQB (nolock)
        on SQB.D_E_L_E_T_ = ''
            and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SQB.QB_DEPTO = SRA.RA_DEPTO
        inner join SRJ010 SRJ (nolock)
        on SRJ.D_E_L_E_T_ = ''
            and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
            and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

        left join SQ3010 SQ3 (nolock)
            on SQ3.D_E_L_E_T_ = ''
            and SQ3.Q3_CARGO = SRJ.RJ_CARGO

    inner join CTT010 CTT (nolock)
        on CTT.D_E_L_E_T_ = ''
        and CTT.CTT_CUSTO = SPG.PG_CC
where SPG.PG_DATAAPO between :DTINI_MARCA and :DTFIM_MARCA
