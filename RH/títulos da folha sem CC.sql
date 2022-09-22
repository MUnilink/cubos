select
    SE2.E2_FILIAL,
    SE2.E2_PREFIXO,
    SE2.E2_NUM,
    RC1.RC1_DESCRI,
    RC1.RC1_TIPO,
    SE2.E2_CCUSTO
from SE2010 SE2 (nolock)
    inner join RC1010 RC1 (nolock)
        on RC1.D_E_L_E_T_ = ''
        and RC1.RC1_FILTIT = SE2.E2_FILIAL
        and RC1.RC1_PREFIX = SE2.E2_PREFIXO
        and RC1.RC1_NUMTIT = SE2.E2_NUM     
where SE2.D_E_L_E_T_ = ''
