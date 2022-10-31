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

    trim(SRB.RB_NOME) DEPENDENTE,
	convert(date, SRB.RB_DTNASC, 103) as NASC_DEP,
	trim(SRB.RB_SEXO) as SEXO_DEP

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

        left join SRB010 SRB (nolock)
            on SRB.D_E_L_E_T_ = ''
            and SRB.RB_FILIAL = RHL.RHL_FILIAL
            and SRB.RB_MAT = RHL.RHL_MAT
            and SRB.RB_COD = RHL.RHL_CODIGO
where SRA.D_E_L_E_T_ = ''
