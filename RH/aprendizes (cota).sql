select
	trim(isnull(FUNCIONARIO.RA_FILIAL, '-')) as FILIAL,
	trim(isnull(FUNCIONARIO.RA_MAT, '-')) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
	trim(isnull(FUNCIONARIO.RA_NOME, '-')) as FUNCIONARIO,
	trim(isnull(FUNCIONARIO.RA_MUNICIP, '-')) as MUNICIPIO,
	trim(isnull(FUNCIONARIO.RA_ESTADO, '-')) as UF,
	trim(isnull(FUNCIONARIO.RA_CC, '-')) as COD_CC,
	trim(isnull(FUNCIONARIO.RA_SITFOLH, '-')) as STATUS,
	trim(isnull(CC.CTT_DESC01, '-')) as CENTRO_CUSTO,

	convert(date, FUNCIONARIO.RA_ADMISSA, 103) as ADMISSAO,
    case when trim(FUNCIONARIO.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	(
		select cast(count(distinct SRA010.RA_MAT) as decimal)
		from SRA010 (nolock)
		where
				SRA010.RA_FILIAL = FUNCIONARIO.RA_FILIAL
			and SRA010.RA_MAT = FUNCIONARIO.RA_MAT
	) as geral,
	(
		select cast(count(distinct SRA010.RA_MAT) as decimal)
		from SRA010 (nolock)
		where
				SRA010.RA_FILIAL = FUNCIONARIO.RA_FILIAL
			and SRA010.RA_MAT = FUNCIONARIO.RA_MAT
			and SRA010.RA_CODFUNC not in ('664', '665')
			and SRA010.RA_MAT not in
			(
				select SRA010.RA_MAT
				from SRA010
					inner join SRJ010
						on SRJ010.RJ_FILIAL = substring(SRA010.RA_FILIAL, 1, 4)
						and SRJ010.RJ_FUNCAO = SRA010.RA_CODFUNC
				where SRA010.RA_CODFUNC in ('556', '675', '686', '687', '715', '716', '732', '733', '735', '739', '740', '742', '746', '766', '769', '770', '771', '782', '786', '788', '802')
			)
	) as celetistas,
	(
		select cast(count(distinct SRA010.RA_MAT) as decimal)
		from SRA010 (nolock)
		where
				SRA010.RA_FILIAL = FUNCIONARIO.RA_FILIAL
			and SRA010.RA_MAT = FUNCIONARIO.RA_MAT
			and SRA010.RA_CODFUNC in ('664', '665')
	) as aprendizes

from SRA010 FUNCIONARIO (nolock)
	left join CTT010 CC (nolock)
    	on CC.D_E_L_E_T_ = ''
    	and FUNCIONARIO.RA_CC = CC.CTT_CUSTO
where
		FUNCIONARIO.D_E_L_E_T_ = ''
	and FUNCIONARIO.RA_SITFOLH != 'D'
