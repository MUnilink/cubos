select
	case SRA.RA_FILIAL
		when '010101' then 'MATRIZ'
		when '010102' then 'PECÉM'
		else '-'
	end as FILIAL,
	
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as FUNCIONARIO,
	cast(convert(date, SRA.RA_NASC, 103) as varchar) NASC_FUNC,
	trim(SRA.RA_SEXO) as SEXO_FUNC,
	trim(CTT.CTT_DESC01) as CENTRO_CUSTO,

	trim(SRB.RB_NOME) DEPENDENTE,
	cast(convert(date, SRB.RB_DTNASC, 103) as varchar) NASC_DEP,
	trim(SRB.RB_SEXO) as SEXO_DEP,

	month(SRA.RA_NASC) as MES_FUNC,
	month(SRB.RB_DTNASC) as MES_DEP,

	case SRB.RB_GRAUPAR
		when 'C' then 'CÔNJUGE'
		when 'F' then 'FILHO/A'
		when 'O' then 'OUTROS'
		else '-'
	end as PARENTESCO

from SRA010 as SRA (nolock)
	inner join SRB010 as SRB (nolock)
		on SRB.D_E_L_E_T_ = ''
		and SRB.RB_FILIAL = SRA.RA_FILIAL
		and SRB.RB_MAT = SRA.RA_MAT
	inner join CTT010 as CTT (nolock)
    	on CTT.D_E_L_E_T_ = ''
    	and substring(SRA.RA_FILIAL, 1, 4) = CTT.CTT_FILIAL
    	and SRA.RA_CC = CTT.CTT_CUSTO
where
		SRA.D_E_L_E_T_ = ''
	and SRA.RA_SITFOLH != 'D'
