select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
	trim(SRA.RA_MAT) as CONTADOR,
	trim(SRA.RA_NOME) as NOME,
	trim(SRJ.RJ_DESC) as FUNCAO,
	SX5.X5_DESCRI as ESCOLARIDADE,

	datepart (week, SRA.RA_NASC) as sem_ANIVERSARIO,
	month(SRA.RA_NASC) as mes_ANIVERSARIO,
	day(SRA.RA_NASC) as dia_ANIVERSARIO,
	convert(date, SRA.RA_NASC, 103) as NASCIMENTO,
	convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,

	trim(CTT.CTT_CUSTO) as COD_CC,
	trim(CTT.CTT_DESC01) as CENTRO_CUSTO,
	trim(CTD.CTD_ITEM) as COD_ITEM,
	trim(CTD.CTD_DESC01) as ATIVIDADE,

	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,

	cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,
	case when SRA.RA_ADCPERI = 2 then SRA.RA_SALARIO *.3 else 0.0 end as PERICULOSIDADES,
	case when SRA.RA_ADCINS = 4 then 1100 *.4 else 0.0 end as INSALUBRIDADE
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
where SRA.D_E_L_E_T_ = ''
