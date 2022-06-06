select
	SRA010.RA_FILIAL,
	SR8010.R8_PER as PERIODO,
	SRA010.RA_MAT,
	SRA010.RA_NOME,
	SR8010.R8_CID,
	TMR010.TMR_DOENCA,
	SRA010.RA_CC,
	CTT010.CTT_DESC01 as CCUSTO,

	cast(convert(date, SR8010.R8_DATAINI, 103) as varchar) as INI_AFASTAMENTO,
	SR8010.R8_DURACAO as DUR_AFASTAMENTO,
	case when SR8010.R8_DATAFIM is not null then cast(convert(date, SR8010.R8_DATAFIM, 103) as varchar) else '-' end as FIM_AFASTAMENTO,

	substring(SR8010.R8_PER, 1, 4) as PERIODO_ANO,
	substring(SR8010.R8_PER, 5, 6) as PERIODO_MES

from SRA010 (nolock)
	inner join CTT010 (nolock)
    	on CTT010.D_E_L_E_T_ = ''
    	and substring(SRA010.RA_FILIAL, 1, 4) = CTT010.CTT_FILIAL
    	and SRA010.RA_CC = CTT010.CTT_CUSTO
	left join SR8010 (nolock)
		on SR8010.D_E_L_E_T_ = ''
		and SRA010.RA_FILIAL = SR8010.R8_FILIAL
		and SRA010.RA_MAT = SR8010.R8_MAT

		left join TMR010 (nolock)
			on TMR010.D_E_L_E_T_ = ''
			and SR8010.R8_FILIAL = TMR010.TMR_FILIAL
            and SR8010.R8_CID = TMR010.TMR_CID
where
		SRA010.D_E_L_E_T_ = ''