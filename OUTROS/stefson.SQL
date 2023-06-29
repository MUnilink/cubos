select 
	SRA.RA_NOME as RA_NOME,
	SRA.RA_MAT as RA_MATRICULA,
	convert(date, SRA.RA_ADMISSA, 103) as RA_ADMISSAO,
	year(SRA.RA_ADMISSA) as ANO_ADMISSAO,
	case when SRA.RA_SITFOLH = '' then 'OK' else SRA.RA_SITFOLH end as RA_SITU_FOLHA,
	
	SRJ.RJ_DESC as RJ_DESC_FUNCAO,
	
	SQB.QB_DESCRIC as QB_DEPARTAMENTO
from SRA010 SRA (nolock)
	inner join SRJ010 SRJ
		on SRA.D_E_L_E_T_ = ''
		and SRA.RA_CODFUNC = SRJ.RJ_FUNCAO
	inner join SQB010 SQB
		on SQB.D_E_L_E_T_ = ''
		and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
		and SQB.QB_DEPTO = SRA.RA_DEPTO
where SRA.RA_DEMISSA = ''
order by RA_NOME