select
    concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) as BK_VIAGEMTMS,
    DUD.DUD_VIAGEM as VIAGEM,

    case
        when DTQ.DTQ_STATUS in ('1', '2', '5') then 'ABERTA'
        when DTQ.DTQ_STATUS in ('3', '4') then 'ENCERRADA'
        when DTQ.DTQ_STATUS in ('9') then 'CANCELADA'
        else 'Outros'
    end as STATUS_VGA

from DUD010 DUD
    inner join DTQ010 DTQ
        on DTQ.D_E_L_E_T_ = ''
        and DTQ.DTQ_FILIAL = DUD.DUD_FILIAL
        and DTQ.DTQ_VIAGEM = DUD.DUD_VIAGEM
where
        DUD.D_E_L_E_T_ = ''
