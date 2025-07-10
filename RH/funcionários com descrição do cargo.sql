select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
	trim(SRA.RA_MAT) as contador,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_MUNICIP) as MUNICIPIO,
	trim(SRA.RA_ESTADO) as UF,
	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQ3.Q3_CARGO) as COD_CARGO,
	trim(SQ3.Q3_DESCSUM) as CARGO,
	(select concat(trim(SR6010.R6_TURNO), ' - ', trim(SR6010.R6_DESC)) from SR6010 where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SRA.RA_TNOTRAB) as TURNO,
	
	concat(trim(CTT.CTT_CUSTO), ' - ', trim(CTT.CTT_DESC01)) as CCUSTO,
	concat(trim(CTD.CTD_ITEM), ' - ', trim(CTD.CTD_DESC01)) as ATIVIDADE,
	concat(trim(SQB.QB_DEPTO), ' - ', trim(SQB.QB_DESCRIC)) as DEPARTAMENTO,
	
	cast(SRA.RA_ADMISSA as date) as ADMISSAO,
	cast(SRA.RA_DEMISSA as date) as DEMISSAO,
	cast(SRA.RA_DTFIMCT as date) as FIMCTR,
	left(SRA.RA_ADMISSA, 6) as PERIODO_ADMISSAO,
	left(SRA.RA_DEMISSA, 6) as PERIODO_DEMISSAO,
	left(SRA.RA_DTFIMCT, 6) as PERIODO_FIMCTR,
	case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
	trim(SRA.RA_SITFOLH) as SITUACAO,
	trim(SRA.RA_ACUMBH) as ACUMULA_BANCO,
	
	cast(SRA.RA_NASC as date) as NASCIMENTO,
	trim(SRA.RA_ENDEREC) as ENDERECO,
	trim(SRA.RA_NUMENDE) as NUMERO,
	trim(SRA.RA_COMPLEM) as COMPLEMENTO,
	trim(SRA.RA_BAIRRO) as BAIRRO,
	trim(SRA.RA_ESTADO) as ESTADO,
	trim(SRA.RA_MUNICIP) as MUNICIPIO_RESI,
	trim(SRA.RA_CEP) as CEP,
	trim(SRA.RA_MUNNASC) as MUNICIPIO_NASC,
	trim(SRA.RA_LOGRTP) as TIPO_LOGRA,
	trim(SRA.RA_MAE) as NOME_MAE,
	trim(SRA.RA_PAI) as NOME_PAI,
	trim(SRA.RA_RG) as RG,
	cast(SRA.RA_DTRGEXP as date) as RG_DATAEXP,
	trim(SRA.RA_RGUF) as RG_UFEXP,
	trim(SRA.RA_RGORG) as RG_ORGEXP,
	trim(SRA.RA_PIS) as PIS_TITULAR,
	trim(SRA.RA_EMAIL) as TITULAR_EMAIL,
	
	trim(SX5.X5_DESCRI) as ESCOLARIDADE,
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

	cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,

	case when trim(SRA.RA_SITFOLH) = 'A' then 0 when SRA.RA_CODFUNC in ('664', '665', '556', '675', '686', '687', '715', '716', '732', '733', '735', '739', '740', '742', '746', '766', '769', '770', '771', '782', '786', '788', '802', '888', '847', '677', '886', '887', '859', '732', '872', '864', '733', '766', '371', '445', '842') then 0 else 1 end as QTD_EFETIVO,
	case when SRA.RA_CODFUNC in ('664', '665') then 1 else 0 end as QTD_APRENDIZ,
	case SRA.RA_DEFIFIS when 1 then 1 else 0 end as QTD_PCD,
	1 as QTD_GERAL

from SRA010 SRA (nolock)
	inner join SRJ010 SRJ (nolock)
		on SRJ.D_E_L_E_T_ = ''
		and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
        and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

		left join SQ3010 SQ3 (nolock)
			on SQ3.D_E_L_E_T_ = ''
			and SQ3.Q3_CARGO = SRJ.RJ_CARGO
    
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
