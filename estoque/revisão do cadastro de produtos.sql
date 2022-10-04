select
    SB1010.B1_GRUPO as GRUPO,
    SB1010.B1_COD as PRODUTO,
    SB1010.B1_DESC as DESCRICAO,
    case SB1010.B1_MSBLQL when 1 then 'SIM' else 'NAO' end as BLOQUEADO,
    convert(date, SB1010.B1_DATREF, 103) as DATA_CRIADO,
    SB1010.B1_YPARTNU as PARTNUMBER,

    SB1.B1_GRUPO as dup_GRUPO,
    SB1.B1_COD as dup_PRODUTO,
    SB1.B1_DESC as dup_DESCRICAO,
    case SB1.B1_MSBLQL when 1 then 'SIM' else 'NAO' end as dup_BLOQUEADO,
    convert(date, SB1.B1_DATREF, 103) as dup_DATA_CRIADO,
    SB1.B1_YPARTNU as dup_PARTNUMBER
from SB1010 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1010.B1_COD != SB1.B1_COD
        and SB1010.B1_DESC = SB1.B1_DESC
        and SB1010.B1_YPARTNU = SB1.B1_YPARTNU
        and SB1.B1_COD like '1%'
where SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD like '1%'
