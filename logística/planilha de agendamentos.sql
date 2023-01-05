select *
from ZA0010 (nolock)
    inner join DF1010 DF1 (nolock)
        on DF1.DF1_FILIAL = ZA0.ZA0_FILIAL
        and DF1.DF1_NUMAGE = ZA0.ZA0_AGENDA
        and DF1.DF1_ITEAGE = ZA0.ZA0_ITEAGE