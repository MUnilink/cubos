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

    SRR.RR_PERIODO,
    SRR.RR_PD,
    SRR.RR_VALOR

from SRG010 SRG (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRG.RG_FILIAL
        and SRA.RA_MAT = SRG.RG_MAT

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
    
    inner join SRR010 SRR (nolock)
        on SRR.D_E_L_E_T_ = ''
        and SRR.RR_FILIAL = SRG.RG_FILIAL
        and SRR.RR_MAT = SRG.RG_MAT
where SRH.D_E_L_E_T_ = ''
