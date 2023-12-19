select
	SRA.RA_FILIAL,
	SR8.R8_PER as PERIODO,
	SRA.RA_MAT,
	SRA.RA_NOMECMP,
	SRA.RA_SALARIO as SALARIO,
	SRA.RA_SEXO as SEXO,
	convert(date, SRA.RA_NASC, 103) as NASCIMENTO,
	SRA.RA_MUNICIP as MUNICIPIO,
	SRA.RA_ESTADO as UF,
	SR8.R8_CID,
	TMR.TMR_DOENCA,
	SRA.RA_CC,

	case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	coalesce(datediff(year, SRA.RA_NASC, RHR.RHR_DATA), datediff(year, SRA.RA_NASC, RHS.RHS_DATA), null) as IDADE,

	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,

	CTT.CTT_DESC01 as CCUSTO,
	CTD.CTD_DESC01 as ATIVIDADE,

	cast(convert(date, SR8.R8_DATAINI, 103) as varchar) as INI_AFASTAMENTO,
	SR8.R8_DURACAO as DUR_AFASTAMENTO,
	case when SR8.R8_DATAFIM is not null then cast(convert(date, SR8.R8_DATAFIM, 103) as varchar) else '-' end as FIM_AFASTAMENTO,

	substring(SR8.R8_PER, 1, 4) as PERIODO_ANO,
	substring(SR8.R8_PER, 5, 6) as PERIODO_MES

from SR8010 SR8 (nolock)
	left join TMR010 TMR (nolock)
		on TMR.D_E_L_E_T_ = ''
		and SR8.R8_FILIAL = TMR.TMR_FILIAL
		and SR8.R8_CID = TMR.TMR_CID
	left join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SR8.R8_MAT = SRA.RA_MAT
		and SR8.R8_FILIAL = SRA.RA_FILIAL
		left join RHR010 RHR (nolock)
			on RHR.D_E_L_E_T_ = ''
			and RHR.RHR_FILIAL = SRA.RA_FILIAL
			and RHR.RHR_MAT = SRA.RA_MAT
		left join RHS010 RHS (nolock)
			on RHS.D_E_L_E_T_ = ''
			and RHS.RHS_FILIAL = SRA.RA_FILIAL
			and RHS.RHS_MAT = SRA.RA_MAT

		inner join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and substring(SRA.RA_FILIAL, 1, 4) = CTT.CTT_FILIAL
			and SRA.RA_CC = CTT.CTT_CUSTO
		inner join SQB010 SQB (nolock)
			on SQB.D_E_L_E_T_ = ''
			and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
			and SQB.QB_DEPTO = SRA.RA_DEPTO
		inner join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SRA.RA_ITEM
		inner join SRJ010 SRJ (nolock)
			on SRJ.D_E_L_E_T_ = ''
			and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
			and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
				
where
		SRA.D_E_L_E_T_ = ''
		and (SRA.RA_MAT, SR8.R8_DATAINI) in (
			select 
				RA_MAT,
				max(R8_DATAINI)
			from SR8010
			group by RA_MAT
		)
		or SR8.R8_CID is null