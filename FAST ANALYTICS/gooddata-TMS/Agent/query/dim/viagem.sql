select
    concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
    DTQ.DTQ_VIAGEM,

    case DTQ.DTQ_STATUS
        when '1' then 'EXCLUIDA'
        when '2' then 'EM TRANSITO'
        when '3' then 'ENCERRADA'
        when '4' then 'CHEGADA EM FILIAL'
        when '5' then 'FECHADA'
        when '9' then 'CANCELADA'
        else 'OUTROS'
    end as DTQ_STATUS,

    <<CODE_INSTANCE>> AS INSTANCIA

from DTQ010 DTQ (nolock)
where DTQ.D_E_L_E_T_ = ''
