select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    (
        select top 1 isnull(nullif(replace(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '.', ','), ''), DTW010.DTW_YHODFI)
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
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
            and DTW010.DTW_ATIVID = 50
    ) as km_fim,
    (
        select top 1 isnull(nullif(replace(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '.', ','), ''), DTW010.DTW_YHODIN)
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
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
            and DTW010.DTW_ATIVID = 49
    ) as km_ini,

    case DTQ.DTQ_STATUS
        when '1' then 'EXCLUÍDA'
        when '2' then 'EM TRANSITO'
        when '3' then 'ENCERRADA'
        when '4' then 'CHEGADA EM FILIAL'
        when '5' then 'FECHADA'
        when '9' then 'CANCELADA'
        else 'OUTROS'
    end as DTQ_STATUS

from DTQ010 DTQ (nolock)
    inner join DA8010 DA8 (nolock)
        on DA8.D_E_L_E_T_ = ''
        and DA8.DA8_COD = DTQ.DTQ_ROTA
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
where DTQ.D_E_L_E_T_ = '' and DTQ.DTQ_VIAGEM in (11949, 12696)
