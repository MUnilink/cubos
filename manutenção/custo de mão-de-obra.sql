select
	trim(STL010.TL_FILIAL) as TJ_FILIAL,
	trim(STL010.TL_ORDEM) as TL_ORDEM,
	trim(STL010.TL_CODBEM) as TJ_CODBEM,
	trim(STL010.TL_PLANO) as TJ_PLANO,

	trim(STL010.TL_TAREFA) as COD_TAREFA,
	trim(STL010.TL_CODIGO) as COD_PRODUTO_SERVIÇO,
	trim(SRA010.RA_MAT) as MATRICULA,
	trim(SRA010.RA_NOME) as FUNCIONARIO,
	isnull(trim(ST0010.T0_NOME), '-') as T0_NOME,
	isnull(trim(ST1010.T1_NOME), '-') as T1_NOME,
	trim(ST1010.T1_SALARIO),

	case STL010.TL_SEQRELA
		when 0 then 'PREVISTO'
		else 'REALIZADO'
	end as STATUS,

	case when (SRA010.RA_MAT = STL010.TL_CODIGO) then 'OK' else 'DIFERENTE' end as MATMNT_MATGPE,

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

from STJ010 (nolock)
	inner join STL010 (nolock)
		on STL010.D_E_L_E_T_ = ''
		and STL010.TL_ORDEM = STJ010.TJ_ORDEM
		and STL010.TL_PLANO = STJ010.TJ_PLANO
		and STL010.TL_FILIAL = STJ010.TJ_FILIAL

		left join SRA010 (nolock)
			on SRA010.D_E_L_E_T_ = ''
			and SRA010.RA_FILIAL = STL010.TL_FILIAL
			and SRA010.RA_MAT = STL010.TL_CODIGO

		left join ST0010 (nolock)
			on ST0010.D_E_L_E_T_ = ''
			and ST0010.T0_ESPECIA = STL010.TL_CODIGO
		left join ST1010 (nolock)
			on ST1010.D_E_L_E_T_ = ''
			and ST1010.T1_FILIAL = STL010.TL_FILIAL
			and ST1010.T1_CODFUNC = STL010.TL_CODIGO
where
		STJ010.D_E_L_E_T_ = ''