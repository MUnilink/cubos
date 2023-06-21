select
    ST9.T9_CODBEM,
    ST9.T9_STATUS,
    ST9.T9_CODESTO,
    ST9.T9_CONTACU,
    trim(isnull(TQT.TQT_DESMED, '-')) as TQT_DESMED,
    convert(date, ST9.T9_DTCOMPR, 103) as T9_DTCOMPR,
    TQS.TQS_POSIC
from ST9010 ST9 (nolock)
    left join TQS010 TQS (nolock)
        on TQS.D_E_L_E_T_ = ''
        and TQS.TQS_CODBEM = ST9.T9_CODBEM

        left join TQT010 as TQT /* medida do pneu */
            on TQT.D_E_L_E_T_ = ''
            and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
where
        ST9.D_E_L_E_T_ = ''
    and not exists
    (
        select * from STZ010 where STZ010.D_E_L_E_T_ = '' and STZ010.TZ_CODBEM = TQS.TQS_CODBEM
    )
