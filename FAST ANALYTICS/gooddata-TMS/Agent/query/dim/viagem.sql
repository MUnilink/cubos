select
    DTQ.DTQ_FILORI +
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = VIAGEM.DTQ_FILORI
            and DTW010.DTW_VIAGEM = VIAGEM.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    )
    + DTQ.DTQ_VIAGEM, as ID_VIAGEM,
    DTQ.DTQ_VIAGEM,
    DUP.DUP_CODMOT,
    DTR.DTR_CODVEI,
    DTR.DTR_CODRB1,
    DTR.DTR_CODRB2,
    DTR.DTR_CODRB3,

    case DTQ.DTQ_STATUS
        when '1' then 'EXCLUIDA'
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

        inner join DUP010 DUP (nolock)
            on DUP.D_E_L_E_T_ = ''
            and DUP.DUP_FILORI = DTR.DTR_FILORI
            and DUP.DUP_VIAGEM = DTR.DTR_VIAGEM
            and DUP.DUP_ITEDTR = DTR.DTR_ITEM
            and DUP.DUP_CODVEI = DTR.DTR_CODVEI
where DTQ.D_E_L_E_T_ = ''
