select
	case SRA.RA_FILIAL
		when '010101' then 'MATRIZ'
		when '010102' then 'PECÉM'
		else '-'
	end as FILIAL,

	trim(CTT.CTT_CUSTO) as COD_CC,
	trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	trim(CTD.CTD_ITEM) as COD_ITEM,
	trim(CTD.CTD_DESC01) as ATIVIDADE,

	trim(SRJ.RJ_DESC) as FUNCAO,
	
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as FUNCIONARIO,
	trim(SRA.RA_SEXO) as SEXO_FUNC,

	datepart (week, SRA.RA_NASC) as sem_ANIVERSARIO,
	month(SRA.RA_NASC) as mes_ANIVERSARIO,
	convert(date, SRA.RA_NASC, 103) as NASC_FUNC,

	trim(SRB.RB_NOME) DEPENDENTE,
	convert(date, SRB.RB_DTNASC, 103) as NASC_DEP,
	trim(SRB.RB_SEXO) as SEXO_DEP,

	month(SRA.RA_NASC) as MES_FUNC,
	month(SRB.RB_DTNASC) as MES_DEP,

	case SRB.RB_GRAUPAR
		when 'C' then 'CÔNJUGE'
		when 'F' then 'FILHO/A'
		when 'O' then 'OUTROS'
		else '-'
	end as PARENTESCO

from SRA010 SRA (nolock)
	inner join SRB010 SRB (nolock)
		on SRB.D_E_L_E_T_ = ''
		and SRB.RB_FILIAL = SRA.RA_FILIAL
		and SRB.RB_MAT = SRA.RA_MAT
	inner join SRJ010 SRJ (nolock)
		on SRJ.D_E_L_E_T_ = ''
		and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
        and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
	inner join CTT010 CTT (nolock)
    	on CTT.D_E_L_E_T_ = ''
    	and CTT.CTT_CUSTO = SRA.RA_CC
    inner join CTD010 CTD (nolock)
    	on CTD.D_E_L_E_T_ = ''
    	and CTD.CTD_ITEM = SRA.RA_ITEM
where
		SRA.D_E_L_E_T_ = ''
	and SRA.RA_SITFOLH != 'D'
