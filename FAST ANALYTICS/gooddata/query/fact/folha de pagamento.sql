	select
		case when SRA.RA_FILIAL is null then 'P |01||' else 'P |01|01'+ cast(SRA.RA_FILIAL as char(6)) end as BK_FILIAL,
    	concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRC.RC_ITEM, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
        'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRC.RC_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,

		concat(trim(SRV.RV_FILIAL), trim(SRV.RV_COD)) as ID_VERBA,
        concat(trim(SRY.RY_FILIAL), trim(SRY.RY_CALCULO)) as ID_ROTEIRO,
		trim(SRC.RC_SEQ) as SEQ,
        SRC.RC_VALOR as VALOR,
		SRC.RC_HORAS as HORAS,
		cast(SRC.RC_DTREF as date) as DATARQ

	from SRC010 SRC
		inner join SRA010 SRA
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRC.RC_FILIAL
            and SRA.RA_MAT = SRC.RC_MAT
        left join CTD010 CTD
            on CTD.CTD_ITEM = SRC.RC_ITEM
            and CTD.D_E_L_E_T_ = ''
        left join CTT010 CTT
            on CTT.CTT_CUSTO = SRC.RC_CC
            and CTT.D_E_L_E_T_ = ''
        left join SRV010 SRV
            on SRV.RV_COD = SRC.RC_PD
            and SRV.RV_FILIAL = left(SRC.RC_FILIAL, 4)
            and SRV.D_E_L_E_T_ = ''
        left join SRY010 SRY
            on SRY.RY_CALCULO = SRC.RC_ROTEIR
            and SRY.RY_FILIAL = left(SRC.RC_FILIAL, 4)
            and SRY.D_E_L_E_T_ = ''
	where SRC.D_E_L_E_T_ = '' and SRC.RC_DTREF between <<START_DATE>> and <<FINAL_DATE>>
union
	select
		case when SRA.RA_FILIAL is null then 'P |01||' else 'P |01|01'+ cast(SRA.RA_FILIAL as char(6)) end as BK_FILIAL,
    	concat(substring(trim(SRA.RA_ADMISSA), 6, 1), substring(trim(SRA.RA_MAT), 6, 1), right(trim(SRA.RA_CIC), 2), substring(trim(SRA.RA_MAT), 5, 1), substring(trim(SRA.RA_NASC), 6, 1)) as PSID,
        'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRD.RD_ITEM, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
        'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRD.RD_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,

		concat(trim(SRV.RV_FILIAL), trim(SRV.RV_COD)) as ID_VERBA,
        concat(trim(SRY.RY_FILIAL), trim(SRY.RY_CALCULO)) as ID_ROTEIRO,
		trim(SRD.RD_SEQ) as SEQ,
		SRD.RD_VALOR as VALOR,
		SRD.RD_HORAS as HORAS,
		eomonth(concat(SRD.RD_DATARQ, '01')) as DATARQ

	from SRD010 SRD
		inner join SRA010 SRA
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRD.RD_FILIAL
			and SRA.RA_MAT = SRD.RD_MAT
        left join CTD010 CTD
            on CTD.CTD_ITEM = SRD.RD_ITEM
            and CTD.D_E_L_E_T_ = ''
        left join CTT010 CTT
            on CTT.CTT_CUSTO = SRD.RD_CC
            and CTT.D_E_L_E_T_ = ''
        left join SRV010 SRV
            on SRV.RV_COD = SRD.RD_PD
            and SRV.RV_FILIAL = left(SRD.RD_FILIAL, 4)
            and SRV.D_E_L_E_T_ = ''
        left join SRY010 SRY
            on SRY.RY_CALCULO = SRD.RD_ROTEIR
            and SRY.RY_FILIAL = left(SRD.RD_FILIAL, 4)
            and SRY.D_E_L_E_T_ = ''
	where SRD.D_E_L_E_T_ = '' and concat(SRD.RD_DATARQ, '01') between <<START_DATE>> and <<FINAL_DATE>>
