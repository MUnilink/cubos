select
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

from SB1010 SB1 (nolock)
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_COD = SB1.B1_COD
        and SD3.D3_TM in (501, 544)
where
        SB1.D_E_L_E_T_ = ''
    and SB1.B1_GRUPO like '1%'
    and SB1.B1_MSBLQL = 2
