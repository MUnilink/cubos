select
    SB9.B9_FILIAL,
    SB9.B9_LOCAL,
    substring(SB9.B9_DATA, 1, 6),
    SB9.B9_COD,
    SB9.B9_VINI1,
    SB9.B9_QINI,
    SB9.B9_CM1
from SB9010 SB9 (nolock)
where
        SB9.D_E_L_E_T_ = ''
    and SB9.B9_COD like '1130%'
    and SB9.B9_QINI != 0
