select
    STP.TP_CODBEM,
    STP.TP_POSCONT,
    max(STP.TP_DTLEITU) as ULT_CONT
from STP010 STP (nolock)
where STP.D_E_L_E_T_ = ''
group by
    STP.TP_CODBEM,
    STP.TP_POSCONT