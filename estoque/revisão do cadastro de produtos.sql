select
    SB1010.B1_GRUPO as GRUPO,
    SB1010.B1_COD as PRODUTO,
    SB1010.B1_DESC as DESCRICAO,
    SB1010.B1_MSBLQL as BLOQUEADO,
    SB1010.B1_DATREF as ,
    SB1010.B1_YPARTNU as ,

    SB1.B1_GRUPO as dup_GRUPO,
    SB1.B1_COD as dup_COD,
    SB1.B1_DESC as dup_DESC,
    SB1.B1_MSBLQL as dup_MSBLQL,
    SB1.B1_DATREF as dup_DATREF,
    SB1.B1_YPARTNU as dup_YPARTNU
from SB1010 (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1010.B1_COD != SB1.B1_COD
        and SB1010.B1_DESC = SB1.B1_DESC
        and SB1010.B1_YPARTNU = SB1.B1_YPARTNU
        and SB1.B1_COD like '1%'
where SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD like '1%'
