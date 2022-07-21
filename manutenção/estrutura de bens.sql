select
    ST9.T9_CCUSTO,
    isnull(STC.TC_CODBEM, 'PNEU OU SR DESATRELADO'),
    case when ST9.T9_CODFAMI = 'VP' and STC.TC_CODBEM is null then 'SR DESATRELADO' else '-' end as STATUS,
    STC.TC_COMPONE,
    TQT.TQT_DESMED
from ST9010 ST9 (nolock)
    left join STC010 STC (nolock)
        on STC.D_E_L_E_T_ = ''
        and STC.TC_CODBEM = ST9.T9_CODBEM

        left join TQS010 TQS (nolock)
            on TQS.D_E_L_E_T_ = ''
            and TQS.TQS_CODBEM = STC.TC_COMPONE

            left join TQT010 TQT (nolock)
                on TQT.D_E_L_E_T_ = ''
                and TQT.TQT_MEDIDA = TQS.TQS_MEDIDA
where ST9.D_E_L_E_T_ = ''
