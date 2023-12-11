select
    DTW010.DTW_VIAGEM,
    DTW010.DTW_ATIVID,
    DTW010.DTW_FILORI,
    DTW010.DTW_SEQUEN,
    DTW010.DTW_TAREFA,
    DTW010.DTW_YHODIN,
    DTW010.DTW_YHODFI,
    ZB1010.ZB1_MSGTXT,
    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0) as APONTAMENTO,
    isnull(nullif(replace(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '.', ','), ''), case when DTW010.DTW_ATIVID = 49 then DTW010.DTW_YHODIN when DTW010.DTW_ATIVID = 50 then DTW010.DTW_YHODFI else 0 end) as km
from DTW010 (nolock)
    left join ZB1010 (nolock)
        on ZB1010.D_E_L_E_T_ = ''
        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
        and
            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
            =
            datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
where 
        DTW010.D_E_L_E_T_ = ''
