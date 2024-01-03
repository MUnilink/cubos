select
        ZB1010.ZB1_CODDA3,
        ZB1010.ZB1_MSGTIM,
        ZB1010.ZB1_MACRON,
        count(ZB1010.ZB1_MSGTIM) as contador,
        convert(datetime, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0), 113) as ZB1_DATA,
        convert(datetime, lag(datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0), 1, null) over(partition by ZB1010.ZB1_CODDA3, ZB1010.ZB1_MACRON order by ZB1010.ZB1_CODDA3), 113) as ZB1_DTANT,
        
        datediff
        (
                hour,
                lag(datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0), 1, null) over(partition by ZB1010.ZB1_CODDA3, ZB1010.ZB1_MACRON order by ZB1010.ZB1_CODDA3),
                datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0)
        ) as diff

from ZB1010 (nolock)
where ZB1010.D_E_L_E_T_ = ''
        and ZB1010.ZB1_MACRON = 7
        and ZB1010.ZB1_STATUS = 'OK'
group by ZB1010.ZB1_CODDA3, ZB1010.ZB1_MSGTIM, ZB1010.ZB1_MACRON
having count(ZB1010.ZB1_MSGTIM) > 1
