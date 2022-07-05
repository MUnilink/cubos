select
    substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)),
    ZB1010.ZB1_CODDA3,
    DTW010.*
from DTW010 (nolock)
    inner join ZB1010 (nolock)
        on ZB1010.D_E_L_E_T_ = ''
        and
            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
            =
            datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
where
        DTW010.D_E_L_E_T_ = ''
    and DTW010.DTW_ATIVID in ('050')
    and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
