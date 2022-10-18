select
    SB1.B1_COD as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    case SB1.B1_MSBLQL when 1 then 'SIM' else 'NAO' end as BLOQUEADO
from SB1010 SB1 (nolock)
where
        SB1.D_E_L_E_T_ = ''
    and SB1.B1_COD like '1%'
