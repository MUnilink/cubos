select
    trim(SRA.RA_FILIAL) as FILIAL,
    concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
    trim(SRA.RA_MAT) as MATRICULA,
    trim(SRA.RA_NOMECMP) as NOME,
    trim(SRJ.RJ_DESC) as FUNCAO,
    trim(SQ3.Q3_DESCSUM) as CARGO,
    cast(SRA.RA_ADMISSA as date) as ADMISSAO,
    cast(SRA.RA_DEMISSA as date) as DEMISSAO,
    cast(SRA.RA_NASC as date) as NASCIMENTO,
    cast(SRA.RA_DTFIMCT as date) as FIM_CONTRATO,
    SRA.RA_SITFOLH as SITUACAO,
    case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
    trim(CTT.CTT_CUSTO) as CC,
    trim(CTT.CTT_DESC01) as CCUSTO,
    trim(CTD.CTD_ITEM) as ITCT,
    trim(CTD.CTD_DESC01) as ATIVIDADE,
    trim(SQB.QB_DEPTO) as DEPTO,
    trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
    trim(SRJ.RJ_CODCBO) as CBO,
    trim(SRA.RA_SEXO) as SEXO,
    trim(SRA.RA_CIC) as CPF,
	
	trim(SR8.R8_CID) as CID,
	trim(TMR.TMR_DOENCA) as DESCRICAO,
	concat(trim(SR8.R8_TIPOAFA), ' - ', (select upper(trim(RCM010.RCM_DESCRI)) from RCM010 where RCM010.RCM_TIPO = SR8.R8_TIPOAFA)) as TIPO_AFASTA,
	
	trim(SR8.R8_NMMED) as EMITENTE,
	trim(SR8.R8_CRMMED) as COD_EMITENTE,
	trim(SR8.R8_IDEOC) as CLASSE_EMITENTE,
	
	cast(SR8.R8_DATA as date) as DATA_ALTER,
	cast(SR8.R8_DATAINI as date) as DATA_INIAFA,
	cast(SR8.R8_DATAFIM as date) as DATA_FIMAFA,
	cast(SR8.R8_DURACAO as numeric(15, 2)) as DURACAO,
	left(SR8.R8_PER, 6) as PERIODO

from SR8010 SR8 (nolock)
	left join TMR010 TMR (nolock)
		on TMR.D_E_L_E_T_ = ''
		and SR8.R8_FILIAL = TMR.TMR_FILIAL
		and SR8.R8_CID = TMR.TMR_CID
	left join SRA010 SRA (nolock)
		on SRA.D_E_L_E_T_ = ''
		and SR8.R8_MAT = SRA.RA_MAT
		and SR8.R8_FILIAL = SRA.RA_FILIAL

		left join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and left(SRA.RA_FILIAL, 4) = CTT.CTT_FILIAL
			and SRA.RA_CC = CTT.CTT_CUSTO
		left join SQB010 SQB (nolock)
			on SQB.D_E_L_E_T_ = ''
			and SQB.QB_FILIAL = left(SRA.RA_FILIAL, 4)
			and SQB.QB_DEPTO = SRA.RA_DEPTO
		left join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SRA.RA_ITEM
		left join SRJ010 SRJ (nolock)
			on SRJ.D_E_L_E_T_ = ''
			and SRJ.RJ_FILIAL = left(SRA.RA_FILIAL, 4)
			and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

			left join SQ3010 SQ3 (nolock)
				on SQ3.D_E_L_E_T_ = ''
				and SQ3.Q3_CARGO = SRJ.RJ_CARGO
				
where
		SR8.D_E_L_E_T_ = ''
	and SR8.R8_TIPOAFA != '001'
