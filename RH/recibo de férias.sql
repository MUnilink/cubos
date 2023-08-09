select
    trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
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
    convert(date, RH_DATABAS, 103) as INI_PERIODO,
    convert(date, RH_DBASEAT, 103) as FIM_PERIODO,
    convert(date, RH_DATAINI, 103) as INI_FERIAS,
    convert(date, RH_DATAFIM, 103) as FIM_FERIAS,
    convert(date, RH_DTAVISO, 103) as AVISO,
    convert(date, RH_DTRECIB, 103) as PAGAMENTO,
    
    SRH.RH_DFERVEN,
    SRH.RH_DFERIAS,
    SRH.RH_DABONPE as DIASABONO,
    SRH.RH_DFALTAS,
    SRH.RH_ABOPEC,
    SRH.RH_PERC13S,

    SRR.RR_VALOR

from SRH010 SRH (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRH.RH_FILIAL
        and SRA.RA_MAT = SRH.RH_MAT

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
    
    inner join SRR010 SRR (nolock)
        on SRR.D_E_L_E_T_ = ''
        and SRR.RR_FILIAL = SRH.RH_FILIAL
        and SRR.RR_MAT = SRH.RH_MAT
        and SRR.RR_PD = '470'
where SRH.D_E_L_E_T_ = ''
