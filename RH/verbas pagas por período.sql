	select
		trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
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

		trim(isnull(SRC.RC_PERIODO, '-')) as PERIODO,
		trim(isnull(SRC.RC_PD, '-')) as VERBA,
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		
		case SRC.RC_PD
			when '183' then 'VALOR A RECEBER'
			when '999' then 'VALOR A RECEBER'
		else '' end as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as RV_TIPOCOD,

		SRC.RC_VALOR as VALOR,
		SRC.RC_HORAS as HORAS,
		SRA.RA_SALARIO as SALARIO

	from SRC010 SRC (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRC.RC_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRC.RC_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRC.RC_FILIAL
			and SRA.RA_MAT = SRC.RC_MAT

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
	where SRC.D_E_L_E_T_ = ''
union
	select
		trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOME) as NOME,
        trim(SRJ.RJ_DESC) as FUNCAO,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
        case SRA.RA_SITFOLH when '' then 'OK' else SRA.RA_SITFOLH end as SITUACAO,
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

		trim(isnull(SRD.RD_PERIODO, '-')) as PERIODO,
		trim(isnull(SRD.RD_PD, '-')) as VERBA,
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		
		case SRD.RD_PD
			when '183' then 'VALOR A RECEBER'
			when '999' then 'VALOR A RECEBER'
		else '' end as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as RV_TIPOCOD,

		SRD.RD_VALOR as VALOR,
		SRD.RD_HORAS as HORAS,
		SRA.RA_SALARIO as SALARIO
	from SRD010 SRD (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRD.RD_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRD.RD_FILIAL
			and SRA.RA_MAT = SRD.RD_MAT

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
			SRD.D_E_L_E_T_ = ''
		and substring(SRD.RD_PERIODO, 1, 4) > 2021
