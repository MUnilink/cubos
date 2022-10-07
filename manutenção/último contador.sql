select
    trim(STP.TP_CODBEM) as TP_CODBEM,
    max(STP.TP_POSCONT) as MAX_CONT,
    convert(date, max(STP.TP_DTLEITU), 103) as ULT_CONT
from STP010 STP (nolock)
where
        STP.D_E_L_E_T_ = ''
    and STP.TP_CODBEM like 'CM50%'
group by
    STP.TP_CODBEM