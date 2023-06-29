select
    STC.TC_CODBEM,
    STC.TC_COMPONE,
    STC.TC_COMPONE as contador,
    ST9.T9_STATUS,
    ST9.T9_CODESTO,
    ST9.T9_CONTACU,
    convert(date, ST9.T9_DTCOMPR, 103) as T9_DTCOMPR,
    TQS.TQS_POSIC
from STC010 STC (nolock)
    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and ST9.T9_CODBEM = STC.TC_COMPONE

        left join TQS010 TQS (nolock)
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = ST9.T9_CODBEM
where
        STC.D_E_L_E_T_ = ''
