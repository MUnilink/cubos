select
    STJ.TJ_TERMINO,
    SC1.*
from SC1010 SC1 (nolock)
    inner join STJ010 STJ (nolock)
        on STJ.D_E_L_E_T_ = ''
        and STJ.TJ_ORDEM = substring(SC1.C1_OP, 1, 6)
where SC1.D_E_L_E_T_ = ''