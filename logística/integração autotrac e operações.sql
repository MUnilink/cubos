select
    DTQ010.DTQ_VIAGEM,
    DTR010.DTR_ITEM,
    DTR010.DTR_CODVEI,
    DTW010.DTW_ATIVID,
    ZB1010.ZB1_MSGTXT,
    ZB1010.ZB1_MSGTIM,
    DTW010.DTW_DATREA,
    DTW010.DTW_HORREA,
    datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0) as AUTOTRAC_DATAHORA,
    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0) as DTW_DATAHORA,
    cast(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)) as float)

from DTW010 (nolock)
    left join ZB1010 (nolock)
        on ZB1010.D_E_L_E_T_ = ''
        and
            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
            =
            datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
    inner join DTQ010 (nolock)
        on DTQ010.D_E_L_E_T_ = ''
        and DTW010.DTW_FILORI = DTQ010.DTQ_FILORI
        and DTQ010.DTQ_VIAGEM = DTW010.DTW_VIAGEM

        inner join DTR010 (nolock)
            on DTR010.D_E_L_E_T_ = ''
            and DTR010.DTR_FILORI = DTQ010.DTQ_FILORI
            and DTR010.DTR_VIAGEM = DTQ010.DTQ_VIAGEM
where
        DTW010.D_E_L_E_T_ = ''
    and DTW010.DTW_VIAGEM = '007950'
