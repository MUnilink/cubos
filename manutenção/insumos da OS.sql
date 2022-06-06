select
	trim(STJ010.TJ_FILIAL) as TJ_FILIAL,
	trim(STL010.TL_ORDEM) as TL_ORDEM,
	trim(STJ010.TJ_CODBEM) as TJ_CODBEM,
	trim(STJ010.TJ_PLANO) as TJ_PLANO,
	trim(STL010.TL_TAREFA) as COD_TAREFA,
	isnull(trim(ST5010.T5_DESCRIC), '-') as TAREFA,
	trim(ST9010.T9_PLACA) as PLACA,
	trim(TQR010.TQR_DESMOD) as MODELO,
	trim(STL010.TL_CODIGO) as 'COD PRODUTO/SERVIÇO',
	isnull(trim(SA2010.A2_NOME), isnull(trim(SB1010.B1_DESC), isnull(trim(SH4010.H4_DESCRI), isnull(trim(ST0010.T0_NOME), isnull(trim(ST1010.T1_NOME), '-'))))) as 'PRODUTO/SERVIÇO',
	isnull(trim(SA2010.A2_NOME), '-') as A2_NOME,
	isnull(trim(SB1010.B1_DESC), '-') as B1_DESC,
	isnull(trim(SH4010.H4_DESCRI), '-') as H4_DESCRI,
	isnull(trim(ST0010.T0_NOME), '-') as T0_NOME,
	isnull(trim(ST1010.T1_NOME), '-') as T1_NOME,

	case STL010.TL_SEQRELA
		when 0 then 'PREVISTO'
		else 'REALIZADO'
	end as STATUS,

	STL010.TL_QUANTID,
	STL010.TL_CUSTO,

	case STL010.TL_DTINICI
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(STL010.TL_DTINICI, 1 ,8), 103) as varchar)
	end as TL_DTINICI,

	case STL010.TL_DTFIM
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(STL010.TL_DTFIM, 1 ,8), 103) as varchar)
	end as TL_DTFIM,

	case STJ010.TJ_DTMRINI
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(STJ010.TJ_DTMRINI, 1 ,8), 103) as varchar)
	end as TJ_DTMRINI,

	case STJ010.TJ_DTMRFIM
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(STJ010.TJ_DTMRFIM, 1 ,8), 103) as varchar)
	end as TJ_DTMRFIM,

	trim(STL010.TL_HOINICI) as TL_HOINICI,
	trim(STL010.TL_HOFIM) as TL_HOFIM,

	case STJ010.TJ_DTORIGI
		when null then '-'
		when '' then '-'
		when '        ' then '-'
		else cast(convert(date, substring(STJ010.TJ_DTORIGI, 1, 8), 103) as varchar)
	end as DATA_OS,


	year(STJ010.TJ_DTORIGI) as ANO_OS,
	month(STJ010.TJ_DTORIGI) as MES_OS,

	year(STL010.TL_DTINICI) as ANO_INICIO,
	year(STL010.TL_DTFIM) as ANO_FIM,

	month(STL010.TL_DTINICI) as MES_INICIO,
	month(STL010.TL_DTFIM) as MES_FIM,

	STL010.TL_LOCAL,

	row_number() over
	(
		partition by
			STL010.TL_FILIAL,
			STL010.TL_ORDEM,
			STJ010.TJ_CODBEM,
			STJ010.TJ_PLANO,
			STL010.TL_TAREFA,
			STL010.TL_CODIGO,
			STL010.TL_QUANTID,

			STL010.TL_DTINICI,
			STL010.TL_DTFIM,
			STL010.TL_HOINICI,
			STL010.TL_HOFIM,
			STJ010.TJ_DTMRINI,
			STJ010.TJ_DTMRFIM
		order by
			STL010.TL_FILIAL,
			STL010.TL_ORDEM,
			STJ010.TJ_CODBEM
	) as contador

from STJ010 (nolock)
	inner join ST9010 (nolock)
		on ST9010.D_E_L_E_T_ = ''
		and ST9010.T9_CODBEM = STJ010.TJ_CODBEM

			left join TQR010 (nolock)
				on 	TQR010.D_E_L_E_T_ = ''
				and TQR010.TQR_TIPMOD = ST9010.T9_TIPMOD

	inner join STL010 (nolock)
		on STL010.D_E_L_E_T_ = ''
		and STL010.TL_ORDEM = STJ010.TJ_ORDEM
		and STL010.TL_PLANO = STJ010.TJ_PLANO
		and STL010.TL_FILIAL = STJ010.TJ_FILIAL

		left join ST5010 (nolock)
			on ST5010.D_E_L_E_T_ = ''
			and ST5010.T5_CODBEM = STL010.TL_CODBEM
			and ST5010.T5_TAREFA = STL010.TL_TAREFA

		left join SA2010 (nolock)
			on SA2010.D_E_L_E_T_ = ''
			and SA2010.A2_COD = STL010.TL_CODIGO
		left join SB1010 (nolock)
			on SB1010.D_E_L_E_T_ = ''
			and SB1010.B1_COD = STL010.TL_CODIGO
		left join SH4010 (nolock)
			on SH4010.D_E_L_E_T_ = ''
			and SH4010.H4_CODIGO = STL010.TL_CODIGO
		left join ST0010 (nolock)
			on ST0010.D_E_L_E_T_ = ''
			and ST0010.T0_ESPECIA = STL010.TL_CODIGO
		left join ST1010 (nolock)
			on ST1010.D_E_L_E_T_ = ''
			and ST1010.T1_FILIAL = STL010.TL_FILIAL
			and ST1010.T1_CODFUNC = STL010.TL_CODIGO
where
		STJ010.D_E_L_E_T_ = ''