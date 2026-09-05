	select
		trim(SRA.RA_FILIAL) as FILIAL,
        trim(SRA.RA_MAT) as MATRICULA,
    	concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(SRA.RA_NOMECMP) as NOME,
		trim(SRA.RA_MUNICIP) as MUNICIPIO,
		trim(SRA.RA_ESTADO) as UF,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
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
		concat(trim(SRA.RA_CATEFD), ' - ', substring((select max(upper(trim(RCC010.RCC_CONTEU))) from RCC010 where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S049' and left(RCC010.RCC_CONTEU, 3) = SRA.RA_CATEFD), 6, 250)) as CAT_ESOCIAL,

		trim(SRC.RC_PERIODO) as PERIODO,
		trim(SRC.RC_PD) as VERBA,
		trim(SRC.RC_SEQ) as SEQ,
		trim(SRC.RC_ROTEIR) as ROTEIRO,

		case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
		
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		trim(SRV.RV_DESCDET) as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as TIPO_VERBA,

		trim(RCN.RCN_CODIGO) as IDVERBA,
    	trim(RCN.RCN_DESCRI) as IDVERBA_NOME,

		SRC.RC_VALOR as VALOR,
		SRC.RC_HORAS as HORAS,
		SRJ.RJ_YHRPADR as HORAS_PADRAO,

		null as DATARQ,
		null as STATUS_LANC,
		null as INSS,
		null as IR,
		null as FGTS,
		case when trim(SRA.RA_SITFOLH) = 'D' then (select max(concat(trim(SRG010.RG_TIPORES), ' - ', trim(substring(RCC010.RCC_CONTEU, 3, 30)))) from RCC010 inner join SRG010 on SRG010.D_E_L_E_T_ = '' and left(RCC010.RCC_CONTEU, 2) = trim(SRG010.RG_TIPORES) where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S043' and SRG010.RG_FILIAL = SRA.RA_FILIAL and SRG010.RG_MAT = SRA.RA_MAT) end as TIPO_RESCISAO,

		case when RCN.RCN_CODIGO in ('0045', '0021', '0047', '0102', '0126', '0202', '0303', '0546', '0678', '0836', '0977', '1411') then 1 else 0 end as contador_func

	from SRC010 SRC (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRC.RC_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRC.RC_PD = SRV.RV_COD

			left join RCN010 RCN (nolock)
				on RCN.D_E_L_E_T_ = ''
				and RCN.RCN_CODIGO = SRV.RV_CODFOL
		
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
    	concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(SRA.RA_NOMECMP) as NOME,
		trim(SRA.RA_MUNICIP) as MUNICIPIO,
		trim(SRA.RA_ESTADO) as UF,
        cast(SRA.RA_ADMISSA as date) as ADMISSAO,
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
		concat(trim(SRA.RA_CATEFD), ' - ', substring((select max(upper(trim(RCC010.RCC_CONTEU))) from RCC010 where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S049' and left(RCC010.RCC_CONTEU, 3) = SRA.RA_CATEFD), 6, 250)) as CAT_ESOCIAL,

		trim(SRD.RD_PERIODO) as PERIODO,
		trim(SRD.RD_PD) as VERBA,
		trim(SRD.RD_SEQ) as SEQ,
		trim(SRD.RD_ROTEIR) as ROTEIRO,

		case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO,
		
		trim(isnull(SRV.RV_DESC, '-')) as DESC_VERBA1,
		trim(SRV.RV_DESCDET) as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as TIPO_VERBA,

		trim(RCN.RCN_CODIGO) as IDVERBA,
    	trim(RCN.RCN_DESCRI) as IDVERBA_NOME,

		SRD.RD_VALOR as VALOR,
		SRD.RD_HORAS as HORAS,
		null as HORAS_PADRAO,

		SRD.RD_DATARQ as DATARQ,
		SRD.RD_STATUS as STATUS_LANC,
		SRD.RD_INSS as INSS,
		SRD.RD_IR as IR,
		SRD.RD_FGTS as FGTS,
		case when trim(SRA.RA_SITFOLH) = 'D' then (select max(concat(trim(SRG010.RG_TIPORES), ' - ', trim(substring(RCC010.RCC_CONTEU, 3, 30)))) from RCC010 inner join SRG010 on SRG010.D_E_L_E_T_ = '' and left(RCC010.RCC_CONTEU, 2) = trim(SRG010.RG_TIPORES) where RCC010.D_E_L_E_T_ = '' and RCC010.RCC_CODIGO = 'S043' and SRG010.RG_FILIAL = SRA.RA_FILIAL and SRG010.RG_MAT = SRA.RA_MAT) end as TIPO_RESCISAO,

		case when RCN.RCN_CODIGO in ('0045', '0021', '0047', '0102', '0126', '0202', '0303', '0546', '0678', '0836', '0977', '1411') then 1 else 0 end as contador_func

	from SRD010 SRD (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRD.RD_PD = SRV.RV_COD
				
			left join RCN010 RCN (nolock)
				on RCN.D_E_L_E_T_ = ''
				and RCN.RCN_CODIGO = SRV.RV_CODFOL
		
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
			SRD.RD_DATARQ >=:PERIODO_INI
		and SRD.D_E_L_E_T_ = ''
