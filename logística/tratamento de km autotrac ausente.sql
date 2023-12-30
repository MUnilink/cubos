select DTQ.DTQ_FILORI, DTQ.DTQ_VIAGEM,
    (
        select
        (
            select substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
            from ZB1010 (nolock)
            where
                    ZB1010.D_E_L_E_T_ = ''
                and
                    dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                    =
                    datetimefromparts(year(DTW.DTW_DATREA), month(DTW.DTW_DATREA), day(DTW.DTW_DATREA), substring(DTW.DTW_HORREA, 1, 2), substring(DTW.DTW_HORREA, 3, 4), 0, 0)
                and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                and ZB1010.ZB1_MACRON = 7
                and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
        )
        from DTW010 DTW (nolock)
        where
                DTW.D_E_L_E_T_ = ''
            and DTW.DTW_FILORI = DTR.DTR_FILORI
            and DTW.DTW_VIAGEM = DTR.DTR_VIAGEM
            and DTW.DTW_ATIVID = 50
    ) as km_fim_atual,

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
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
where
        DTQ.D_E_L_E_T_ = ''
    and DTQ.DTQ_VIAGEM between 11949 and 12696
