select
    concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) as BK_VIAGEMTMS,
    DUD.DUD_VIAGEM as VIAGEM,

    case DTQ.DTQ_STATUS
        when '1' then upper('Em Aberto')
        when '2' then upper('Em Transito')
        when '3' then upper('Encerrada')
        when '4' then upper('Chegada em Filial')
        when '5' then upper('Fechada')
        when '9' then upper('Cancelada')
        else 'Outros'
    end as STATUS_VGA

from DUD010 DUD
    inner join DTQ010 DTQ
        on DTQ.D_E_L_E_T_ = ''
        and DTQ.DTQ_FILIAL = DUD.DUD_FILIAL
        and DTQ.DTQ_VIAGEM = DUD.DUD_VIAGEM
where
        DUD.D_E_L_E_T_ = ''

union select null, null, null
