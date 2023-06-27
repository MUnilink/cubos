select
	SRA.RA_FILIAL,
	SR8.R8_PER as PERIODO,
	SRA.RA_MAT,
	SRA.RA_NOME,
	SR8.R8_CID,
	TMR.TMR_DOENCA,
	SRA.RA_CC,
	CTT.CTT_DESC01 as CCUSTO,

	cast(convert(date, SR8.R8_DATAINI, 103) as varchar) as INI_AFASTAMENTO,
	SR8.R8_DURACAO as DUR_AFASTAMENTO,
	case when SR8.R8_DATAFIM is not null then cast(convert(date, SR8.R8_DATAFIM, 103) as varchar) else '-' end as FIM_AFASTAMENTO,

	substring(SR8.R8_PER, 1, 4) as PERIODO_ANO,
	substring(SR8.R8_PER, 5, 6) as PERIODO_MES

from SRA010 SRA (nolock)
	inner join CTT010 CTT (nolock)
    	on CTT.D_E_L_E_T_ = ''
    	and substring(SRA.RA_FILIAL, 1, 4) = CTT.CTT_FILIAL
    	and SRA.RA_CC = CTT.CTT_CUSTO
	left join SR8010 SR8 (nolock)
		on SR8.D_E_L_E_T_ = ''
		and SRA.RA_FILIAL = SR8.R8_FILIAL
		and SRA.RA_MAT = SR8.R8_MAT

		left join TMR010 TMR (nolock)
			on TMR.D_E_L_E_T_ = ''
			and SR8.R8_FILIAL = TMR.TMR_FILIAL
            and SR8.R8_CID = TMR.TMR_CID
where
		SRA.D_E_L_E_T_ = ''