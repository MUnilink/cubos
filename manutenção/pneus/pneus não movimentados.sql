select
    ST9.T9_CODBEM as contador,
    ST9.T9_CODBEM,
    ST9.T9_SITBEM,
    ST9.T9_STATUS,
    trim(TQY.TQY_DESTAT) as STATUS_PNEU,
    ST9.T9_LOCPAD,
    ST9.T9_CODESTO,
    ST9.T9_CONTACU,
    trim(isnull(TQT.TQT_DESMED, '-')) as TQT_DESMED,
    convert(date, ST9.T9_DTCOMPR, 103) as T9_DTCOMPR,
    
    TQS.TQS_KMOR,
	TQS.TQS_KMR1,
	TQS.TQS_KMR2,
	TQS.TQS_KMR3,
	TQS.TQS_KMR4,
	TQS.TQS_KMR5,
	TQS.TQS_KMR6,
	TQS.TQS_KMR7,
	TQS.TQS_KMOR + TQS.TQS_KMR1 + TQS.TQS_KMR2 + TQS.TQS_KMR3 + TQS.TQS_KMR4 + TQS.TQS_KMR5 + TQS.TQS_KMR6 + TQS.TQS_KMR7 as kmTOT,
    TQS.TQS_POSIC

from ST9010 ST9 (nolock)
    inner join TQS010 TQS (nolock)
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = ST9.T9_CODBEM

        left join TQT010 TQT (nolock) /* medida do pneu */
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
    
    inner join TQY010 TQY (nolock)
        on TQY.D_E_L_E_T_ = ''
        and TQY.TQY_STATUS = ST9.T9_STATUS
where
        ST9.D_E_L_E_T_ = ''
    and not exists
    (
        select * from STZ010 where STZ010.D_E_L_E_T_ = '' and STZ010.TZ_CODBEM = TQS.TQS_CODBEM
    )
