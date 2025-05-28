select
	SRC.RC_FILIAL as FILIAL,
	trim(SRC.RC_CC) + ' - ' + trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	SRC.RC_MAT as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
	SRA.RA_NOMECMP as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	SRB.RB_COD as DEPENDENTE,
	SRA.RA_SEXO as SEXO_FUN,
	SRB.RB_SEXO as SEXO_DEP,

	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,

	count(distinct SRC.RC_MAT) as CONTADOR_FUN,
	count(distinct SRB.RB_COD) as CONTADOR_DEP,
	sum(SRC.RC_VALOR) as RC_VALOR,
	SRC.RC_PD as VERBA,
	year(concat(SRC.RC_PERIODO, '01')) as PERIODO_ANO,
	month(concat(SRC.RC_PERIODO, '01')) as PERIODO_MES,
	
	case when SRC.RC_PD in ('088', '565', '571') then 1 else 0 end as QUANT,
	case when SRC.RC_PD in ('088', '565', '571') then sum(SRC.RC_VALOR) else 0.0 end as VALOR_FUNCIONARIO,
	case when SRC.RC_PD in ('738') then sum(SRC.RC_VALOR) else 0.0 end as VALOR_EMPRESA

from SRC010 SRC (nolock)
	inner join CTT010 CTT (nolock)
    	on CTT.D_E_L_E_T_ = ''
    	and substring(SRC.RC_FILIAL, 1, 4) = CTT.CTT_FILIAL
    	and SRC.RC_CC = CTT.CTT_CUSTO
    inner join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
        and SRA.RA_FILIAL = SRC.RC_FILIAL
        and SRA.RA_MAT = SRC.RC_MAT

		left join SRB010 SRB (nolock)
			on SRB.D_E_L_E_T_ = ''
			and SRB.RB_FILIAL = SRA.RA_FILIAL
			and SRB.RB_MAT = SRA.RA_MAT
			and SRB.RB_PLSAUDE = 1
where
		SRC.D_E_L_E_T_ = ''
	and SRC.RC_PD in ('088', '565', '571', '738')
	and year(concat(SRC.RC_PERIODO, '01')) > 2021
group by
	SRC.RC_FILIAL,
	SRC.RC_MAT,
	SRC.RC_CC,
	SRC.RC_PD,
	CTT.CTT_DESC01,
	SRC.RC_PERIODO,
	SRA.RA_SEXO,
	SRA.RA_NOMECMP,
	SRA.RA_MUNICIP,
	SRA.RA_ESTADO,
	SRA.RA_ADMISSA,
	SRA.RA_SITFOLH,
	SRB.RB_COD,
	SRB.RB_SEXO