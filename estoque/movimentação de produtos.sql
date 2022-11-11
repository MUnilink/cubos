select
    SB1.B1_COD,
    SB1.B1_DESC,
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
	trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
	trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
	trim(isnull(SB1.B1_UM, '-')) as UN,
    isnull(SB1.B1_UPRC, 0.0) as ULT_PRECO,
    substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
    SD3.D3_LOCAL,
    SD3.D3_FILIAL,
    SD3.D3_TM,
    SD3.D3_CF,
    SD3.D3_DOC
from SD3010 SD3 (nolock)
    right join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
where SD3.D_E_L_E_T_ = ''
