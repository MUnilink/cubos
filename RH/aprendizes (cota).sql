select
	FUNCIONARIO.RA_FILIAL as FILIAL,
	FUNCIONARIO.RA_MAT as MATRICULA,
	FUNCIONARIO.RA_NOME as FUNCIONARIO,
	FUNCIONARIO.RA_CC as COD_CC,
	FUNCIONARIO.RA_SITFOLH as STATUS,
	CC.CTT_DESC01 as CENTRO_CUSTO,
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
				where SRA010.RA_CODFUNC in ('556', '675', '686', '687', '715', '716', '732', '733', '735', '739', '740', '742', '746', '766', '769', '770', '771', '782', '786')
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

from SRA010 as FUNCIONARIO (nolock)
	inner join CTT010 as CC (nolock)
    	on CC.D_E_L_E_T_ = ''
    	and substring(FUNCIONARIO.RA_FILIAL, 1, 4) = CC.CTT_FILIAL
    	and FUNCIONARIO.RA_CC = CC.CTT_CUSTO
where FUNCIONARIO.D_E_L_E_T_ = ''