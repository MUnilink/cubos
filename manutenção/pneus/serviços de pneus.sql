select
	ST9.T9_CODBEM as CONTADOR,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
    SB1.B1_COD,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    ST9.T9_CODESTO,
    ST9.T9_LOCPAD,
    
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,

    TR7.TR7_LOTE,
    TR7.TR7_SERVIC,
    TR7.TR7_NFE,
    TR7.TR7_SERIE,
    TR7.TR7_FORNEC,
    TR7.TR7_LOJA,
    SA2.A2_NOME as RAZAO_SOCIAL,
    SA2.A2_NREDUZ as NOME_FANTASIA,
    
    TR8.TR8_ORDEM,
    TR8.TR8_MOTIVO as TR8_MOTIVO,
    trim(ST8.T8_NOME) as MOTIVO,
    TR8.TR8_VALOR,
    
    convert(datetime, concat(TR7.TR7_DTLOTE, ' ', TR7.TR7_HRLOTE), 103) as DATA_LOTE,
    convert(datetime, concat(TR7.TR7_DTRECI, ' ', TR7.TR7_HRRECI), 103) as DATA_RECEBIMENTO,
    
    SC1.C1_NUM as NUM_SC,
    convert(date, SC1.C1_EMISSAO, 103) as DATA_SC,
    substring(SC1.C1_OP, 1, 6) as C1_OS,
    trim(SC1.C1_OBS) as OBS_SC,
    SC1.C1_USER,
    SC1.C1_CODCOMP,
    SC1.C1_SOLICIT,
    
    SC7.C7_NUM as NUM_PC,
    convert(date, SC7.C7_EMISSAO, 103) as DATA_PC,
    substring(SC7.C7_OP, 1, 6) as C7_OS,
    trim(SC7.C7_OBS) as OBS_PC,
    
    SER.D1_DOC as NF_SERVICO,
    SER.D1_SERIE as SER_SERVICO,
    convert(date, SER.D1_DTDIGIT, 103) as DT_NFS,

    (
        select concat(REM.D2_DOC, ' - ', RET.D1_DOC)
        from SD2010 REM (nolock)
            left join SD1010 RET (nolock)
                on RET.D_E_L_E_T_ = ''
                and RET.D1_FILIAL = REM.D2_FILIAL
                and RET.D1_DOC = REM.D2_NFORI
                and RET.D1_SERIE = REM.D2_SERIORI
                and RET.D1_ITEM = REM.D2_ITEMORI
        where
                REM.D_E_L_E_T_ = ''
            and REM.D2_TES = 548
            and RET.D1_LOCAL in (21, 22, 23, 24, 26)
            and REM.D2_COD = SB1.B1_COD
            and RET.D1_EMISSAO = SER.D1_DTDIGIT
    ) as REMRET

from TQS010 TQS (nolock)
    inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = TQS.TQS_CODBEM
    inner join TR8010 TR8 (nolock)
        on TR8.D_E_L_E_T_ = ''
        and TR8.TR8_CODBEM = TQS.TQS_CODBEM

        inner join TR7010 TR7 (nolock)
            on TR7.D_E_L_E_T_ = ''
            and TR7.TR7_FILIAL = TR8.TR8_FILIAL
            and TR7.TR7_LOTE = TR8.TR8_LOTE

            inner join SA2010 SA2 (nolock)
                on SA2.D_E_L_E_T_ = ''
                and SA2.A2_COD = TR7.TR7_FORNEC
                and SA2.A2_LOJA = TR7.TR7_LOJA
        
        left join ST8010 ST8 (nolock)
            on ST8.D_E_L_E_T_ = ''
            and ST8.T8_CODOCOR = TR8.TR8_MOTIVO
        left join SC1010 SC1 (nolock)
            on SC1.D_E_L_E_T_ = ''
            and SC1.C1_FILIAL = TR8.TR8_FILIAL
            and substring(SC1.C1_OP, 1, 6) = TR8.TR8_ORDEM
        left join SC7010 SC7 (nolock)
            on SC7.D_E_L_E_T_ = ''
            and SC7.C7_FILIAL = TR8.TR8_FILIAL
            and substring(SC7.C7_OP, 1, 6) = TR8.TR8_ORDEM
        left join SD1010 SER (nolock)
            on SER.D_E_L_E_T_ = ''
            and SER.D1_FILIAL = TR8.TR8_FILIAL
            and substring(SER.D1_OP, 1, 6) = TR8.TR8_ORDEM
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = ST9.T9_STATUS
    inner join TQT010 TQT (nolock)
		on TQT.D_E_L_E_T_ = ''
		and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA

		left join SB1010 SB1 (nolock)
			on SB1.D_E_L_E_T_ = ''
			and substring(SB1.B1_DESC, 6, len(TQT.TQT_DESMED)) = TQT.TQT_DESMED

where
        TQS.D_E_L_E_T_ = ''
