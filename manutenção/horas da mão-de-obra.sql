select
	trim(STL010.TL_FILIAL) as TL_FILIAL,
	trim(STL010.TL_ORDEM) as TL_ORDEM,
	trim(STL010.TL_CODBEM) as TL_CODBEM,
	trim(STL010.TL_PLANO) as TL_PLANO,

	trim(STL010.TL_TAREFA) as COD_TAREFA,
	trim(STL010.TL_CODIGO) as COD_PRODUTO_SERVIÇO,
	trim(SRA010.RA_MAT) as MATRICULA,
	trim(SRA010.RA_NOME) as FUNCIONARIO,
	isnull(trim(ST1010.T1_NOME), '-') as T1_NOME,
	ST1010.T1_SALARIO,
	SRA010.RA_HRSMES,

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

	trim(STL010.TL_HOINICI) as TL_HOINICI,
	trim(STL010.TL_HOFIM) as TL_HOFIM,

	year(STL010.TL_DTINICI) as ANO_INICIO,
	year(STL010.TL_DTFIM) as ANO_FIM,

	month(STL010.TL_DTINICI) as MES_INICIO,
	month(STL010.TL_DTFIM) as MES_FIM

from STL010 (nolock)
	inner join ST1010 (nolock)
		on ST1010.D_E_L_E_T_ = ''
		and ST1010.T1_FILIAL = STL010.TL_FILIAL
		and ST1010.T1_CODFUNC = STL010.TL_CODIGO

		left join SRA010 (nolock)
			on  ST1010.D_E_L_E_T_ = ''
			and ST1010.T1_FILIAL =  SRA010.RA_FILIAL
			and ST1010.T1_CODFUNC = SRA010.RA_MAT


where
		STL010.D_E_L_E_T_ = ''