select
    SB1.B1_COD as contador,
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
	trim(isnull(SB1.B1_UM, '-')) as UN,
    isnull(SB1.B1_UPRC, 0.0) as ULT_PRECO,
    SB2.B2_FILIAL as FILIAL,
    SB2.B2_LOCAL as ARMAZEM,
    SB2.B2_QATU as QTD,
    SB2.B2_VATU1 as VALOR,
    SB2.B2_CM1 as CM
from SB2010 SB2 (nolock)
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SB2.B2_COD
where
        SB2.D_E_L_E_T_ = ''
