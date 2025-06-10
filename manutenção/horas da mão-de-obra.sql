select
	trim(STL.TL_FILIAL) as FILIAL,
	trim(STL.TL_ORDEM) as OS,
	trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
	trim(STL.TL_PLANO) as PLANO,
	trim(STL.TL_TAREFA) as COD_TAREFA,

	case STL.TL_SEQRELA
		when 0 then 'PREVISTO'
		else 'REALIZADO'
	end as STATUS_INSUMO,

	case STL.TL_TIPOREG
		when 'M' then 'MÃO-DE-OBRA'
		when 'E' then 'ESPECIALIDADE'
		else 'OUTROS'
	end as TIPO_CUSTO,

	case STL.TL_TIPOREG
		when 'M' then trim(ST1.T1_NOME)
		when 'E' then trim(ST0.T0_NOME)
		else 'OUTROS'
	end as DESC_INSUMO,

	STL.TL_QUANTID,
	STL.TL_CUSTO,

	convert(datetime, datetimefromparts(year(STL.TL_DTINICI), month(STL.TL_DTINICI), day(STL.TL_DTINICI), substring(STL.TL_HOINICI, 1, 2), substring(STL.TL_HOINICI, 4, 5), 0, 0), 113) as INI_APONT,
	convert(datetime, datetimefromparts(year(STL.TL_DTFIM), month(STL.TL_DTFIM), day(STL.TL_DTFIM), substring(STL.TL_HOFIM, 1, 2), substring(STL.TL_HOFIM, 4, 5), 0, 0), 113) as FIM_APONT,
	datediff(minute, concat(STL.TL_DTINICI, ' ', STL.TL_HOINICI), concat(STL.TL_DTFIM, ' ', STL.TL_HOFIM))/60.0 as HORAS_APONT,

	convert(date, STL.TL_DTINICI, 103) as DT_INI,
	convert(date, STL.TL_DTFIM, 103) as DT_FIM,

	trim(STL.TL_HOINICI) as HORA_INI,
	trim(STL.TL_HOFIM) as HORA_FIM,

	substring(STL.TL_DTINICI, 1, 6) as PERIODO_INI,
	substring(STL.TL_DTFIM, 1, 6) as PERIODO_FIM,

	SRA.RA_MAT as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
	SRA.RA_HRSMES HORAS_MES

from STL010 STL (nolock)
	left join ST0010 ST0 (nolock)
		on ST0.D_E_L_E_T_ = ''
		and ST0.T0_ESPECIA = STL.TL_CODIGO
	left join ST1010 ST1 (nolock)
		on ST1.D_E_L_E_T_ = ''
		and ST1.T1_FILIAL = STL.TL_FILIAL
		and ST1.T1_CODFUNC = STL.TL_CODIGO

		left join SRA010 SRA (nolock)
			on ST1.D_E_L_E_T_ = ''
			and ST1.T1_FILIAL = SRA.RA_FILIAL
			and ST1.T1_CODFUNC = SRA.RA_MAT
	
	inner join STJ010 STJ (nolock)
		on STJ.D_E_L_E_T_ = ''
		and STJ.TJ_ORDEM = STL.TL_ORDEM
		and STJ.TJ_PLANO = STL.TL_PLANO
		and STJ.TJ_FILIAL = STL.TL_FILIAL
		and STJ.TJ_SERVICO not in ('CONSEP', 'REFORP')
		and year(STJ.TJ_DTORIGI) > 2021
where
		STL.D_E_L_E_T_ = ''
	and STL.TL_TIPOREG in ('E', 'M')
