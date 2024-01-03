select DTQ.DTQ_FILORI, DTQ.DTQ_VIAGEM, DTR.DTR_CODVEI,
    (
        select
            isnull
            (
                (
                    select top 1 nullif(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '')
                    from ZB1010 (nolock)
                    where
                            ZB1010.D_E_L_E_T_ = ''
                        and ZB1010.ZB1_STATUS = 'OK'
                        and
                            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                            =
                            datetimefromparts(year(APT.DTW_DATREA), month(APT.DTW_DATREA), day(APT.DTW_DATREA), substring(APT.DTW_HORREA, 1, 2), substring(APT.DTW_HORREA, 3, 4), 0, 0)
                        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                        and ZB1010.ZB1_MACRON = 1
                        and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                )
            , APT.DTW_YHODIN)
        from DTW010 APT (nolock)
        where
                APT.D_E_L_E_T_ = ''
            and APT.DTW_FILORI = DTR.DTR_FILORI
            and APT.DTW_VIAGEM = DTR.DTR_VIAGEM
            and APT.DTW_ATIVID = 49
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
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
where
        DTQ.D_E_L_E_T_ = ''
