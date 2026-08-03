select
	trim(SRA.RA_FILIAL) as FILIAL,
	trim(SRA.RA_MAT) as MATRICULA,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
	trim(SRA.RA_MAT) as contador,
	trim(SRA.RA_NOMECMP) as NOME,
	trim(SRA.RA_ESTADO) as UF,
	trim(SRJ.RJ_CODCBO) as CBO,
	trim(SRA.RA_SEXO) as SEXO,
	trim(SRA.RA_CIC) as CPF,
	trim(SRJ.RJ_FUNCAO) as COD_FUNCAO,
	trim(SRJ.RJ_DESC) as FUNCAO,
	trim(SQ3.Q3_CARGO) as COD_CARGO,
	trim(SQ3.Q3_DESCSUM) as CARGO,
	trim(SRA.RA_TNOTRAB) as TURNO_COD,
	(select concat(trim(SR6010.R6_TURNO), ' - ', trim(SR6010.R6_DESC)) from SR6010 where SR6010.D_E_L_E_T_ = '' and SR6010.R6_TURNO = SRA.RA_TNOTRAB) as TURNO,
	trim(SRA.RA_SEQTURN) as TURNO_SEQ,
	trim(SRA.RA_ACUMBH) as ACUMULA_BANCO,
	trim(SRA.RA_BHFOL) as BANCO_FOLHA,
	SRA.RA_HRSMES as HORAS_MES,
	
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
	case SRA.RA_YPARENT when 1 then 'S' when 2 then 'N' else 'outros' end as PAIMAE,
	(select upper(trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_CHAVE = SRA.RA_ESTCIVI and SX5010.X5_TABELA = '33') as ESTADO_CIVIL,
	trim(RCE.RCE_DESCRI) as SINDICATO,
	
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
	trim(SRA.RA_NUMCP) as CTPS,
	trim(SRA.RA_SERCP) as CTPS_SERIE,
	trim(SRA.RA_EMAIL) as TITULAR_EMAIL,
	trim(SRA.RA_DDDFONE) as TELEFONE_DDD,
	trim(SRA.RA_TELEFON) as TELEFONE_NUM,
	
	(select upper(trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_CHAVE = SRA.RA_GRINRAI and SX5010.X5_TABELA = '26') as ESCOLARIDADE,
	datepart(week, SRA.RA_NASC) as sem_ANIVERSARIO,
	month(SRA.RA_NASC) as mes_ANIVERSARIO,
	day(SRA.RA_NASC) as dia_ANIVERSARIO,

	concat(trim(SRA.RA_CATFUNC), ' - ', (select upper(trim(SX5010.X5_DESCRI)) from SX5010 (nolock) where SX5010.D_E_L_E_T_ = '' and SX5010.X5_CHAVE = SRA.RA_CATFUNC and SX5010.X5_TABELA = '28')) as CAT_FUNC,
	case SRA.RA_TPCONTR
		when 1 then upper('Indeterminado')
		when 2 then upper('Determinado')
		when 3 then upper('Intermitente')
		else 'outros'
	end as TIPO_CONTRATO,
	trim(SRA.RA_CODUNIC) as COD_UNICO,
	
	case when SRA.RA_ADCPERI = 2 then SRA.RA_SALARIO *.3 else 0.0 end as VL_PERICULOSIDADES,
	case when SRA.RA_ADCINS = 4 then 1100 *.4 else 0.0 end as VL_INSALUBRIDADE,
	case when SRA.RA_ADTPOSE like '%T' then 0.015*SRA.RA_SALARIO else 0.0 end as VL_ADIC_TEMPO,
	cast(SRA.RA_YAJCUST as numeric(15, 2)) as VL_AJCUSTO,
	cast(SRA.RA_SALARIO as numeric(15, 2)) as SALARIO,

	case SRA.RA_ADCPERI when '1' then 'Não' when '2' then 'Sim' else 'outros' end as PERICULOSIDADES,
	case SRA.RA_ADCINS when '1' then 'Não' when '2' then 'Insalubridade Mínima' when '3' then 'Insalubridade Média' when '4' then 'Insalubridade Máxima' else 'outros' end as INSALUBRIDADE,
	SRA.RA_ADTPOSE as ADIC_TEMPO,

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

	concat(trim(SRA.RA_VIEMRAI), ' - ', (select upper(trim(SX5010.X5_DESCRI)) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_CHAVE = SRA.RA_VIEMRAI and SX5010.X5_TABELA = '25')) as VINC_RAIS,
	concat(trim(SRA.RA_CATEFD), ' - ', substring((select max(upper(trim(RCC010.RCC_CONTEU))) from RCC010 where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S049' and left(RCC010.RCC_CONTEU, 3) = SRA.RA_CATEFD), 3, 250)) as CAT_ESOCIAL,
	concat(trim(SRA.RA_AFASFGT), ' - ', substring((select max(upper(trim(RCC010.RCC_CONTEU))) from RCC010 where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S046' and left(RCC010.RCC_CONTEU, 2) = SRA.RA_AFASFGT), 3, 200)) as AFA_FGTS,

	case when SRA.RA_CATEFD in ('103', '901') or SRA.RA_CODFUNC in ('732', '929', '688', '926', '687', '590', '771', '914', '844', '928', '931', '677', '895', '766', '847', '855', '888', '886', '895', '390', '861', '862', '829', '860', '887', '864', '734') then 0 else 1 end as QTD_EFETIVO,
	case when SRA.RA_CATEFD = '103' then 1 else 0 end as QTD_APRENDIZ,
	case when SRA.RA_CATEFD = '901' then 1 else 0 end as QTD_ESTAGIAR,
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
    
	left join CTT010 CTT (nolock)
    	on CTT.D_E_L_E_T_ = ''
    	and CTT.CTT_CUSTO = SRA.RA_CC
    left join CTD010 CTD (nolock)
    	on CTD.D_E_L_E_T_ = ''
    	and CTD.CTD_ITEM = SRA.RA_ITEM
	left join SQB010 SQB (nolock)
		on SQB.D_E_L_E_T_ = ''
		and SQB.QB_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
		and SQB.QB_DEPTO = SRA.RA_DEPTO
	left join RCE010 RCE (nolock)
		on RCE.D_E_L_E_T_ = ''
		and RCE.RCE_CODIGO = SRA.RA_SINDICA
		and RCE.RCE_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
where SRA.D_E_L_E_T_ = ''
