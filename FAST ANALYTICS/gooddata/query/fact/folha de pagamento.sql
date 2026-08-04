	select
		case when SRA.RA_FILIAL is null then 'P |01||' else 'P |01|01'+ cast(SRA.RA_FILIAL as char(6)) end as BK_FILIAL,
        'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRC.RC_ITEM, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
        'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRC.RC_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
        concat(trim(SRA.RA_FILIAL), trim(SRA.RA_MAT)) as ID_FUNCIONARIO,
        concat(trim(SRJ.RJ_FILIAL), trim(SRJ.RJ_FUNCAO)) as ID_FUNCAO,
        concat(trim(SQ3.Q3_FILIAL), trim(SQ3.Q3_CARGO)) as ID_CARGO,

		concat(trim(SRV.RV_FILIAL), trim(SRV.RV_COD)) as ID_VERBA,
        concat(trim(SRY.RY_FILIAL), trim(SRY.RY_CALCULO)) as ID_ROTEIRO,
		trim(SRC.RC_SEQ) as SEQ,
        cast(isnull(SRC.RC_VALOR, 0.0) as numeric(15, 2)) as VALOR,
		cast(isnull(SRC.RC_HORAS, 0.0) as numeric(15, 2)) as HORAS,
		cast(SRC.RC_DTREF as date) as DATARQ

	from SRC010 SRC
		inner join SRA010 SRA
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRC.RC_FILIAL
            and SRA.RA_MAT = SRC.RC_MAT
            
            inner join SRJ010 SRJ
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                left join SQ3010 SQ3
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO
        
        left join CTD010 CTD
            on CTD.CTD_ITEM = SRC.RC_ITEM
            and CTD.D_E_L_E_T_ = ''
        left join CTT010 CTT
            on CTT.CTT_CUSTO = SRC.RC_CC
            and CTT.D_E_L_E_T_ = ''
        left join SRV010 SRV
            on SRV.RV_COD = SRC.RC_PD
            and SRV.D_E_L_E_T_ = ''
        left join SRY010 SRY
            on SRY.RY_CALCULO = SRC.RC_ROTEIR
            and SRY.D_E_L_E_T_ = ''
	where SRC.D_E_L_E_T_ = '' and SRC.RC_DTREF between <<START_DATE>> and <<FINAL_DATE>>
union
	select
		case when SRA.RA_FILIAL is null then 'P |01||' else 'P |01|01'+ cast(SRA.RA_FILIAL as char(6)) end as BK_FILIAL,
        'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRD.RD_ITEM, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
        'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SRD.RD_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
        concat(trim(SRA.RA_FILIAL), trim(SRA.RA_MAT)) as ID_FUNCIONARIO,
        concat(trim(SRJ.RJ_FILIAL), trim(SRJ.RJ_FUNCAO)) as ID_FUNCAO,
        concat(trim(SQ3.Q3_FILIAL), trim(SQ3.Q3_CARGO)) as ID_CARGO,

		concat(trim(SRV.RV_FILIAL), trim(SRV.RV_COD)) as ID_VERBA,
        concat(trim(SRY.RY_FILIAL), trim(SRY.RY_CALCULO)) as ID_ROTEIRO,
		trim(SRD.RD_SEQ) as SEQ,
		cast(isnull(SRD.RD_VALOR, 0.0) as numeric(15, 2)) as VALOR,
		cast(isnull(SRD.RD_HORAS, 0.0) as numeric(15, 2)) as HORAS,
		eomonth(concat(SRD.RD_DATARQ, '01')) as DATARQ

	from SRD010 SRD
		inner join SRA010 SRA
			on SRA.D_E_L_E_T_ = ''
			and SRA.RA_FILIAL = SRD.RD_FILIAL
			and SRA.RA_MAT = SRD.RD_MAT
            
            inner join SRJ010 SRJ
                on SRJ.D_E_L_E_T_ = ''
                and SRJ.RJ_FUNCAO = SRA.RA_CODFUNC

                left join SQ3010 SQ3
                    on SQ3.D_E_L_E_T_ = ''
                    and SQ3.Q3_CARGO = SRJ.RJ_CARGO
        
        left join CTD010 CTD
            on CTD.CTD_ITEM = SRD.RD_ITEM
            and CTD.D_E_L_E_T_ = ''
        left join CTT010 CTT
            on CTT.CTT_CUSTO = SRD.RD_CC
            and CTT.D_E_L_E_T_ = ''
        left join SRV010 SRV
            on SRV.RV_COD = SRD.RD_PD
            and SRV.D_E_L_E_T_ = ''
        left join SRY010 SRY
            on SRY.RY_CALCULO = SRD.RD_ROTEIR
            and SRY.D_E_L_E_T_ = ''
	where SRD.D_E_L_E_T_ = '' and SRD.RD_DATARQ + '01' between <<START_DATE>> and <<FINAL_DATE>>
