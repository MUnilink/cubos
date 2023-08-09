select
    trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	trim(CTT.CTT_CUSTO) as CC,
	trim(CTT.CTT_DESC01) as CCUSTO,
	trim(CTD.CTD_ITEM) as AT,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,

	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,

	datepart (week, SRA.RA_NASC) as sem_ANIVERSARIO,
	
	trim(SRB.RB_NOME) DEPENDENTE,
	convert(date, SRB.RB_DTNASC, 103) as DEP_NASC,
	trim(SRB.RB_SEXO) as DEP_SEXO,
	datediff(year, SRB.RB_DTNASC, getdate()) as DEP_IDADE,
	SRB.RB_TPDEP as DEP_ES,
	SRB.RB_TIPIR as DEP_IR,
	SRB.RB_TIPSF as DEP_SF,

	trim(RHM.RHM_NOME) as AGG_NOME,
	convert(date, RHM.RHM_DTNASC, 103) as AGG_NASC,
	trim(RHM.RHM_YSEXO) as AGG_SEXO,
	datediff(year, RHM.RHM_DTNASC, getdate()) as AGG_IDADE,
	RHM.RHM_TPCALC as AGG_ES,

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
	left join RHM010 RHM (nolock)
		on RHM.D_E_L_E_T_ = ''
		and RHM.RHM_FILIAL = SRA.RA_FILIAL
		and RHM.RHM_MAT = SRA.RA_MAT
	inner join SQB010 SQB (nolock)
		on SQB.D_E_L_E_T_ = ''
		and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
		and SQB.QB_DEPTO = SRA.RA_DEPTO
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
