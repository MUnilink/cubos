select
    substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)),
    ZB1010.ZB1_MSGTIM,
    substring(ZB1010.ZB1_MSGTIM, 1, 4),
    substring(ZB1010.ZB1_MSGTIM, 6, 2),
    substring(ZB1010.ZB1_MSGTIM, 9, 2),
    substring(ZB1010.ZB1_MSGTIM, 12, 2),
    substring(ZB1010.ZB1_MSGTIM, 15, 2)
from ZB1010 (nolock)
where ZB1010.D_E_L_E_T_ = ''