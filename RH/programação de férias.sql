select
    trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,

	trim(CTT.CTT_CUSTO) as CC,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(CTD.CTD_ITEM) as AT,
	trim(CTD.CTD_DESC01) as ATIVIDADE,

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
    SRH.RH_PERC13S

from SRH010 SRH (nolock)
    inner join SRA010 SRA (nolock)
        on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRH.RH_FILIAL
        and SRA.RA_MAT = SRH.RH_MAT

        inner join SRJ010 SRJ (nolock)
            on SRJ.D_E_L_E_T_ = ''
            and substring(SRA.RA_FILIAL, 1, 4) = SRJ.RJ_FILIAL
            and SRA.RA_CODFUNC = SRJ.RJ_FUNCAO
        inner join CTT010 CTT (nolock)
            on CTT.D_E_L_E_T_ = ''
            and SRA.RA_CC = CTT.CTT_CUSTO
        inner join CTD010 CTD (nolock)
            on CTD.D_E_L_E_T_ = ''
    	    and SRA.RA_ITEM = CTD.CTD_ITEM
where SRH.D_E_L_E_T_ = ''
