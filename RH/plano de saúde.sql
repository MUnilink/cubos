select
    trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	trim(CTT.CTT_CUSTO) as CC,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(CTD.CTD_ITEM) as AT,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
    substring(concat('01', RHK.RHK_PERINI), 1, 6) as TIT_PERIODO,

    trim(DEP.RB_NOME) DEPENDENTE,
	convert(date, DEP.RB_DTNASC, 103) as NASC_DEP,
	trim(DEP.RB_SEXO) as SEXO_DEP,
    substring(concat('01', RHL.RHL_PERINI), 1, 6) as DEP_PERIODO,

    trim(AGG.RB_NOME) AGREGADO,
	convert(date, AGG.RB_DTNASC, 103) as NASC_AGG,
	trim(AGG.RB_SEXO) as SEXO_AGG,
    substring(concat('01', RHM.RHM_PERINI), 1, 6) as AGG_PERIODO,
    
    RHR.RHR_VLRFUN as VALOR_FUNC,
    RHR.RHR_VLREMP as VALOR_EMPR,
    RHR.RHR_PD,
    RHR.RHR_TPLAN as TIPO_LANCAMENTO,
    RHR.RHR_TPPLAN as TIPO_PLANO,
    RHR.RHR_PLANO as PLANO,
    RHR.RHR_ORIGEM as ORIGEM,
    RHR.RHR_CODIGO as COD_DEPAGG

from RHR010 RHR (nolock)
    left join RHK010 RHK (nolock)
        on RHK.D_E_L_E_T_ = ''
        and RHK.RHK_FILIAL = RHR.RHR_FILIAL
        and RHK.RHK_MAT = RHR.RHR_MAT
        and RHK.RHK_TPPLAN = RHR.RHR_TPPLAN
        and RHK.RHK_PLANO = RHR.RHR_PLANO
        and RHK.RHK_TPFORN = RHR.RHR_TPFORN
        and RHK.RHK_CODFOR = RHR.RHR_CODFOR

        left join SRA010 SRA (nolock)
            on SRA.D_E_L_E_T_ = ''
            and SRA.RA_FILIAL = RHR.RHR_FILIAL
            and SRA.RA_MAT = RHR.RHR_MAT

            inner join SQB010 SQB (nolock)
                on SQB.D_E_L_E_T_ = ''
                and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SQB.QB_DEPTO = SRA.RA_DEPTO
            inner join SRJ010 SRJ (nolock)
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
            inner join CTT010 CTT (nolock)
                on CTT.D_E_L_E_T_ = ''
                and CTT.CTT_CUSTO = SRA.RA_CC
            inner join CTD010 CTD (nolock)
                on CTD.D_E_L_E_T_ = ''
                and CTD.CTD_ITEM = SRA.RA_ITEM

    left join RHL010 RHL (nolock)
        on RHL.D_E_L_E_T_ = ''
        and RHL.RHL_FILIAL = RHR.RHR_FILIAL
        and RHL.RHL_MAT = RHR.RHR_MAT
        and RHL.RHL_CODIGO = RHR.RHR_CODIGO
        and RHL.RHL_TPPLAN = RHR.RHR_TPPLAN
        and RHL.RHL_PLANO = RHR.RHR_PLANO
        and RHL.RHL_TPFORN = RHR.RHR_TPFORN
        and RHL.RHL_CODFOR = RHR.RHR_CODFOR

        left join SRB010 DEP (nolock)
            on DEP.D_E_L_E_T_ = ''
            and DEP.RB_FILIAL = RHL.RHL_FILIAL
            and DEP.RB_MAT = RHL.RHL_MAT
            and DEP.RB_COD = RHL.RHL_CODIGO
    
    left join RHM010 RHM (nolock)
        on RHM.D_E_L_E_T_ = ''
        and RHM.RHM_FILIAL = RHR.RHR_FILIAL
        and RHM.RHM_MAT = RHR.RHR_MAT
        and RHM.RHM_CODIGO = RHR.RHR_CODIGO
        and RHM.RHM_TPPLAN = RHR.RHR_TPPLAN
        and RHM.RHM_PLANO = RHR.RHR_PLANO
        and RHM.RHM_TPFORN = RHR.RHR_TPFORN
        and RHM.RHM_CODFOR = RHR.RHR_CODFOR

        left join SRB010 AGG (nolock)
            on AGG.D_E_L_E_T_ = ''
            and AGG.RB_FILIAL = RHL.RHL_FILIAL
            and AGG.RB_MAT = RHL.RHL_MAT
            and AGG.RB_COD = RHL.RHL_CODIGO
where RHR.D_E_L_E_T_ = ''
