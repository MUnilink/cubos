	select
		trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
		trim(SRA.RA_MUNICIP) as MUNICIPIO,
		trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
		case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
		trim(SRA.RA_SITFOLH) as SITUACAO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        trim(SRJ.RJ_CODCBO) as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

		trim(SQ3.Q3_CARGO) as CARGO,
		trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
		trim(SRJ.RJ_FUNCAO) as FUNCAO,
		trim(SRJ.RJ_DESC) as DESC_FUNCAO,

		trim(SRC.RC_PERIODO) as PERIODO,
		trim(SRC.RC_PD) as VERBA,
		trim(SRC.RC_SEQ) as SEQ,
		trim(SRC.RC_ROTEIR) as ROTEIRO,

		case when nullif(SRV.RV_YCPOR, '') is not null then 'OPP' when nullif(SRV.RV_YCTMS, '') is not null then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
		
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		case SRV.RV_COD
			when '183' then 'VALOR A RECEBER'
			when '999' then 'VALOR A RECEBER'
		else trim(SRV.RV_DESCDET) end as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as TIPO_VERBA,

		SRC.RC_VALOR as VALOR,
		SRC.RC_HORAS as HORAS,
		SRJ.RJ_YHRPADR as HORAS_PADRAO,

		null as DATARQ,
		null as STATUS_LANC,
		null as INSS,
		null as IR,
		null as FGTS,

		case when lag(SRC.RC_MAT, 1, 0) over (partition by SRC.RC_FILIAL, SRC.RC_PERIODO, SRC.RC_MAT order by SRC.R_E_C_N_O_) = 0 then 1 else 0 end as contador_func

	from SRC010 SRC (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRC.RC_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRC.RC_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRC.RC_FILIAL
			and SRA.RA_MAT = SRC.RC_MAT

			left join SQB010 SQB (nolock)
				on SQB.D_E_L_E_T_ = ''
				and SQB.QB_DEPTO = isnull(SRC.RC_DEPTO, SRA.RA_DEPTO)
			left join SRJ010 SRJ (nolock)
				on SRJ.D_E_L_E_T_ = ''
				and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
				and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
			left join SQ3010 SQ3 (nolock)
				on SQ3.D_E_L_E_T_ = ''
				and SQ3.Q3_CARGO = SRA.RA_CARGO
		
		left join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and CTT.CTT_CUSTO = SRC.RC_CC
		left join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SRC.RC_ITEM
	where SRC.D_E_L_E_T_ = ''
union
	select
		trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
        trim(SRA.RA_NOMECMP) as NOME,
		trim(SRA.RA_MUNICIP) as MUNICIPIO,
		trim(SRA.RA_ESTADO) as UF,
        convert(date, SRA.RA_ADMISSA, 103) as ADMISSAO,
		case when trim(SRA.RA_SITFOLH) != 'D' then 'S' else 'N' end as ATIVO,
		trim(SRA.RA_SITFOLH) as SITUACAO,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTT.CTT_DESC01) as CCUSTO,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(CTD.CTD_DESC01) as ATIVIDADE,
        trim(SQB.QB_DEPTO) as DEPTO,
        trim(SQB.QB_DESCRIC) as DEPARTAMENTO,
        null as CBO,
        trim(SRA.RA_SEXO) as SEXO,
        trim(SRA.RA_CIC) as CPF,

		trim(SQ3.Q3_CARGO) as CARGO,
		trim(SQ3.Q3_DESCSUM) as DESC_CARGO,
		trim(SRJ.RJ_FUNCAO) as FUNCAO,
		trim(SRJ.RJ_DESC) as DESC_FUNCAO,

		trim(SRD.RD_PERIODO) as PERIODO,
		trim(SRD.RD_PD) as VERBA,
		trim(SRD.RD_SEQ) as SEQ,
		trim(SRD.RD_ROTEIR) as ROTEIRO,

		case when nullif(SRV.RV_YCPOR, '') is not null then 'OPP' when nullif(SRV.RV_YCTMS, '') is not null then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
		
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		case SRV.RV_COD
			when '183' then 'VALOR A RECEBER'
			when '999' then 'VALOR A RECEBER'
		else trim(SRV.RV_DESCDET) end as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as TIPO_VERBA,

		SRD.RD_VALOR as VALOR,
		SRD.RD_HORAS as HORAS,
		null as HORAS_PADRAO,

		SRD.RD_DATARQ as DATARQ,
		SRD.RD_STATUS as STATUS_LANC,
		SRD.RD_INSS as INSS,
		SRD.RD_IR as IR,
		SRD.RD_FGTS as FGTS,

		case when lag(SRD.RD_MAT, 1, 0) over (partition by SRD.RD_FILIAL, SRD.RD_PERIODO, SRD.RD_MAT order by SRD.R_E_C_N_O_) = 0 then 1 else 0 end as contador_func

	from SRD010 SRD (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRD.RD_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRD.RD_FILIAL
			and SRA.RA_MAT = SRD.RD_MAT
		
			left join SQB010 SQB (nolock)
				on SQB.D_E_L_E_T_ = ''
				and SQB.QB_DEPTO = isnull(SRD.RD_DEPTO, SRA.RA_DEPTO)
			left join SRJ010 SRJ (nolock)
				on SRJ.D_E_L_E_T_ = ''
				and SRJ.RJ_FILIAL = substring(SRA.RA_FILIAL, 1, 4)
				and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

				left join SQ3010 SQ3 (nolock)
					on SQ3.D_E_L_E_T_ = ''
					and SQ3.Q3_CARGO = SRJ.RJ_CARGO

		left join CTT010 CTT (nolock)
			on CTT.D_E_L_E_T_ = ''
			and CTT.CTT_CUSTO = SRD.RD_CC
		left join CTD010 CTD (nolock)
			on CTD.D_E_L_E_T_ = ''
			and CTD.CTD_ITEM = SRD.RD_ITEM
	where
			datediff(month, concat(SRD.RD_DATARQ, '01'), getdate()) < 7
		and SRD.D_E_L_E_T_ = ''
