select
	ST9.T9_CODBEM as CONTADOR,
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	ST9.T9_CCUSTO,
	ST9.T9_ITEMCTA,
	ST9.T9_SITBEM,
    
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,

    TR7.TR7_LOTE,
    TR7.TR7_SERVIC,
    convert(datetime, concat(TR7.TR7_DTLOTE, ' ', TR7.TR7_HRLOTE), 103) as DATA_LOTE,
    convert(datetime, concat(TR7.TR7_DTRECI, ' ', TR7.TR7_HRRECI), 103) as DATA_RECEBIMENTO,
    TR7.TR7_NFE,
    TR7.TR7_SERIE,

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

        inner join SC7010 SC7 (nolock)
            on SC7.D_E_L_E_T_ = ''
            and SC7.C7_FILIAL = TR8.TR8_FILIAL
            and SC7.C7_NUM = (select top 1 SC7.C7 = TR8.TR8)
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = ST9.T9_STATUS

where TQS.D_E_L_E_T_ = ''
