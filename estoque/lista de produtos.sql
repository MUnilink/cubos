select
    SB1.B1_GRUPO as GRUPO,
    SB1.B1_COD as PRODUTO,
    SB1.B1_COD as contador,
    trim(SB1.B1_DESC) as DESCRICAO,
    case SB1.B1_MSBLQL when 1 then 'SIM' else 'NAO' end as BLOQUEADO,
    case SB1.D_E_L_E_T_ when '*' then 'SIM' else 'NAO' end as EXCLUIDO,
    convert(date, SB1.B1_DATREF, 103) as DATA_CRIADO,
    trim(SB1.B1_YPARTNU) as PARTNUMBER
from SB1010 SB1 (nolock)
where
        SB1.B1_COD like '1%'
