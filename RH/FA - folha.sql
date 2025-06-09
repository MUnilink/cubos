	select
		trim(SRA.RA_FILIAL) as FILIAL,
    	concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(SQB.QB_DEPTO) as DEPTO,
		trim(SQ3.Q3_CARGO) as CARGO,
		trim(SRJ.RJ_FUNCAO) as FUNCAO,

		trim(SRC.RC_PERIODO) as PERIODO,
		trim(SRC.RC_PD) as VERBA,
		trim(SRC.RC_SEQ) as SEQ,
		trim(SRC.RC_ROTEIR) as ROTEIRO,
		
		trim(SRV.RV_DESC) as DESC_VERBA1,
		trim(SRV.RV_DESCDET) as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as TIPO_VERBA,

		null as STATUS_LANC,
        SRC.RC_VALOR as VALOR,
		SRC.RC_HORAS as HORAS,
		null as DATARQ

	from SRC010 SRC (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRC.RC_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRC.RC_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRC.RC_FILIAL
	where SRC.D_E_L_E_T_ = ''
union
	select
		trim(SRA.RA_FILIAL) as FILIAL,
    	concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        trim(CTT.CTT_CUSTO) as CC,
        trim(CTD.CTD_ITEM) as ITCT,
        trim(SQB.QB_DEPTO) as DEPTO,
		trim(SQ3.Q3_CARGO) as CARGO,
		trim(SRJ.RJ_FUNCAO) as FUNCAO,

		trim(SRD.RD_PERIODO) as PERIODO,
		trim(SRD.RD_PD) as VERBA,
		trim(SRD.RD_SEQ) as SEQ,
		trim(SRD.RD_ROTEIR) as ROTEIRO,
		
		trim(SRV.RV_DESC) as DESC_VERBA1,
		trim(SRV.RV_DESCDET) as DESC_VERBA2,

		case trim(SRV.RV_TIPOCOD)
			when '1' then 'PROVENTO'
			when '2' then 'DESCONTO'
			when '3' then 'BASE PROVENTO'
			when '4' then 'BASE DESCONTO'
			else '-'
		end as TIPO_VERBA,

        SRD.RD_STATUS as STATUS_LANC
		SRD.RD_VALOR as VALOR,
		SRD.RD_HORAS as HORAS,
		SRD.RD_DATARQ as DATARQ

	from SRD010 SRD (nolock)
		inner join SRV010 SRV (nolock)
			on SRV.D_E_L_E_T_ = ''
			and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
			and SRD.RD_PD = SRV.RV_COD
		inner join SRA010 SRA (nolock)
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRD.RD_FILIAL
			and SRA.RA_MAT = SRD.RD_MAT
	where SRD.D_E_L_E_T_ = ''
