select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_MAT) as contador,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_ESTADO) as UF,
	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(SRA.RA_MAE) as NOME_MAE,
	trim(SRA.RA_PAI) as NOME_PAI,
	convert(date, SRA.RA_NASC, 103) as NASCIMENTO,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
	trim(SRA.RA_RG) as RG,
	trim(SRA.RA_DTRGEXP) as RG_DATAEXP,
	trim(SRA.RA_RGUF) as RG_UFEXP,
	trim(SRA.RA_RGORG) as RG_ORGEXP,
	
	trim(SRA.RA_ENDEREC) as ENDERECO,
	trim(SRA.RA_NUMENDE) as NUMERO,
	trim(SRA.RA_COMPLEM) as COMPLEMENTO,
	trim(SRA.RA_BAIRRO) as BAIRRO,
	trim(SRA.RA_ESTADO) as ESTADO,
	trim(SRA.RA_MUNICIP) as MUNICIPIO_RESI,
	trim(SRA.RA_CEP) as CEP,
	trim(SRA.RA_MUNNASC) as MUNICIPIO_NASC,
	concat(trim(SRA.RA_DDDCELU), trim(SRA.RA_NUMCELU)) as CELULAR,

	trim(SRA.RA_ESTCIVI) as ESTADO_CIVIL,
	
	trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(CTT.CTT_CUSTO) as COD_CC,
	trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	trim(CTD.CTD_ITEM) as COD_ITEM,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	case when SRB.RB_NOME is not null then 'DEP' else case when RHM.RHM_NOME is not null then 'AGG' else 'NAO' end end as TEM_DEPAGG,

	datepart (week, SRA.RA_NASC) as sem_ANIVERSARIO,
	month(SRA.RA_NASC) as mes_ANIVERSARIO,
	day(SRA.RA_NASC) as dia_ANIVERSARIO,
	
	trim(SRB.RB_NOME) DEPENDENTE,
	trim(SRB.RB_CIC) as DEP_CPF,
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
	left join SRB010 SRB (nolock)
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
	inner join RHR010 RHR (nolock)
		on RHR.RHR_FILIAL = SRA.RA_FILIAL
		and RHR.RHR_MAT = SRA.RA_MAT
		and year(RHR.RHR_DATA) = 2023
		and month(RHR.RHR_DATA) = 11
where
		SRA.D_E_L_E_T_ = ''
