select 
    trim(SRA.RA_FILIAL) as FILIAL,
    trim(SRA.RA_MAT) as MATRICULA,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQ3.Q3_DESCSUM) as CARGO,
    convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
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

    (select trim(SR6010.R6_DESC) from SR6010 (nolock) where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPF.PF_TURNODE) as TURNO_ORI,
    trim(SPF.PF_SEQUEDE) as SEQ_ORI,
    trim(SPF.PF_REGRADE) as REGRA_ORI,
    (select trim(SR6010.R6_DESC) from SR6010 (nolock) where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SPF.PF_TURNOPA) as TURNO_DES,
    trim(SPF.PF_SEQUEPA) as SEQ_DES,
    trim(SPF.PF_REGRAPA) as REGRA_DES,
    cast(SPF.PF_DATA as date) as DATA,
    left(SPF.PF_DATA, 6) as PERIODO
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
