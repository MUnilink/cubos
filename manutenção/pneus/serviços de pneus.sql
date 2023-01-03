select
	ST9.T9_CODBEM as CONTADOR,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
    SB1.B1_COD,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,

    TR7.TR7_LOTE,
    TR7.TR7_SERVIC,
    TR8.TR8_ORDEM,
    convert(datetime, concat(TR7.TR7_DTLOTE, ' ', TR7.TR7_HRLOTE), 103) as DATA_LOTE,
    convert(datetime, concat(TR7.TR7_DTRECI, ' ', TR7.TR7_HRRECI), 103) as DATA_RECEBIMENTO,
    SC1.C1_NUM,
    SC7.C7_NUM,
    SER.D1_DOC,
    SER.D1_SERIE,
    convert(date, SER.D1_DTDIGIT, 103) as D1_DTDIGIT,
    TR7.TR7_NFE,
    TR7.TR7_SERIE

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
    and SER.D1_DTDIGIT = RET.D1_DTDIGIT
