select 
    trim(SRA.RA_FILIAL) as FILIAL,
    trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQ3.Q3_DESCSUM) as CARGO,
    cast(SRA.RA_ADMISSA as date) as ADMISSAO,
    SRA.RA_SITFOLH as SITUACAO,
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

    trim(SPF.PF_TURNODE) as TURNO_ORI_COD,
    (select trim(SR6010.R6_DESC) from SR6010 (nolock) where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPF.PF_TURNODE) as TURNO_ORI,
    trim(SPF.PF_SEQUEDE) as SEQ_ORI,
    trim(SPF.PF_REGRADE) as REGRA_ORI_COD,
    (select trim(SPA010.PA_DESC) from SPA010 (nolock) where SPA010.D_E_L_E_T_ = '' and SPA010.PA_CODIGO = SPF.PF_REGRADE) as REGRA_ORI,
    
    trim(SPF.PF_TURNOPA) as TURNO_DES_COD,
    (select trim(SR6010.R6_DESC) from SR6010 (nolock) where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPF.PF_TURNOPA) as TURNO_DES,
    trim(SPF.PF_SEQUEPA) as SEQ_DES,
    trim(SPF.PF_REGRAPA) as REGRA_DES_COD,
    (select trim(SPA010.PA_DESC) from SPA010 (nolock) where SPA010.D_E_L_E_T_ = '' and SPA010.PA_CODIGO = SPF.PF_REGRAPA) as REGRA_DES,
    
    cast(SPF.PF_DATA as date) as DATA,
    coalesce(((select cast(SPO010.PO_DATAFIM as date) from SPO010 where SPO010.D_E_L_E_T_ = '' and SPO010.PO_FILIAL = SPF.PF_FILIAL and SPF.PF_DATA between SPO010.PO_DATAINI and SPO010.PO_DATAFIM)), (dateadd(month, 1, (select max(SPO010.PO_DATAFIM) from SPO010 where SPO010.D_E_L_E_T_ = '' and SPO010.PO_FILIAL = SPF.PF_FILIAL)))) as PERIODO

from SPF010 SPF (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SPF.PF_FILIAL
        and SRA.RA_MAT = SPF.PF_MAT

        inner join SQB010 SQB (nolock)
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
            and CTT.CTT_CUSTO = SRA.RA_CC
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
            and CTD.CTD_ITEM = SRA.RA_ITEM
where SPF.D_E_L_E_T_ = ''
