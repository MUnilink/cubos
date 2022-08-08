select
    DTQ.DTQ_VIAGEM,
    DUP.DUP_CODMOT,
    DTR.DTR_CODVEI,
    DTR.DTR_CODRB1,
    DTR.DTR_CODRB2,
    DTR.DTR_CODRB3
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
