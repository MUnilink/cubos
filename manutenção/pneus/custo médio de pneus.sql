select
    SB9.B9_FILIAL as FILIAL,
    SB9.B9_LOCAL as ARMAZEM,
    substring(SB9.B9_DATA, 1, 6) as PERIODO,
    SB9.B9_COD as CODIGO,
    SB9.B9_VINI1 as VAL_INI,
    SB9.B9_QINI as QTD_INI,
    SB9.B9_CM1 as CM,
    trim(SB1.B1_DESC) as DESCRICAO
from SB9010 SB9 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SB9.B9_COD
where
        SB9.D_E_L_E_T_ = ''
    and SB9.B9_COD like '1130%'
