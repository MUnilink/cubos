select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_MAT) as contador,
	trim(SRA.RA_NOME) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(CTT.CTT_CUSTO) as COD_CC,
	trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	trim(CTD.CTD_ITEM) as COD_ITEM,
	trim(CTD.CTD_DESC01) as ATIVIDADE,
	trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
	convert(date, SRA.RA_NASC, 103) as NASCIMENTO,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	
	SX5.X5_DESCRI as ESCOLARIDADE,
	datepart (week, SRA.RA_NASC) as sem_ANIVERSARIO,
	month(SRA.RA_NASC) as mes_ANIVERSARIO,
	day(SRA.RA_NASC) as dia_ANIVERSARIO,

	case when SRA.RA_ADCPERI = 2 then SRA.RA_SALARIO *.3 else 0.0 end as PERICULOSIDADES,
	case when SRA.RA_ADCINS = 4 then 1100 *.4 else 0.0 end as INSALUBRIDADE,

	case SRA.RA_TPDEFFI 
		when '0' then '0 - NENHUMA'
		when '1' then '1 - FISICA'
		when '2' then '2 - AUDITIVA'
		when '3' then '3 - VISUAL'
		when '4' then '4 - INTELECTUAL'
		when '5' then '5 - MULTIPLA'
		when '6' then '6 - REABILITADO'
	else 'ANONIMIZADO' end as TPDEFFI,

	case SRA.RA_DEFIFIS
		when '1' then '1 - SIM'
		when '2' then '2 - NAO'
	else SRA.RA_DEFIFIS end as DEFIFIS,

	case SRA.RA_PORTDEF 
		when '1*****' then '1 - FISICA'
		when '*2****' then '2 - AUDITIVA'
		when '**3***' then '3 - VISUAL'
		when '***4**' then '4 - MENTAL'
		when '****5*' then '5 - INTELECTUAL'
		when '*****6' then '6 - REABILITADO'
	else 'ANONIMIZADO' end as PORTDEF,

	case SRA.RA_CTPCD
		when '1' then '1 - SIM'
		when '2' then '2 - NAO'
	else trim(SRA.RA_CTPCD) end as CTPCD,

	case SRA.RA_BRPDH
		when '1' then '1 - REABILITADO'
		when '2' then '2 - PORT. DEFI. HABILITADO'
		when '3' then '3 - NAO APLICAVEL'
	else 'ANONIMIZADO' end as BRPDH,

	cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO
from SRA010 SRA (nolock)
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
	inner join SX5010 SX5 (nolock)
		on SX5.D_E_L_E_T_ = ''
		and SX5.X5_CHAVE = SRA.RA_GRINRAI
		and SX5.X5_TABELA = '26'
	inner join SQB010 SQB (nolock)
		on SQB.D_E_L_E_T_ = ''
		and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
		and SQB.QB_DEPTO = SRA.RA_DEPTO
where SRA.D_E_L_E_T_ = ''
