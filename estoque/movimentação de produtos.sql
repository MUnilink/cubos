select
    SB1.B1_COD as contador,
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
    SD3.D3_DOC,
    (select max(convert(date, SD1010.D1_DTDIGIT, 103)) from SD1010 where SD1010.D_E_L_E_T_ = '' and SD1010.D1_COD = SB1.B1_COD) as ULT_COMPRA,
    SB2.B2_FILIAL,
    SB2.B2_LOCAL,
    isnull
    (
        (
            select avg(SB9010.B9_QINI)
            from SB9010 (nolock)
            where
                    SB9010.D_E_L_E_T_ = ''
                and SB9010.B9_FILIAL = SD3.D3_FILIAL
                and SB9010.B9_LOCAL = SD3.D3_LOCAL
                and SB9010.B9_COD = SD3.D3_COD
                and substring(SB9010.B9_DATA, 1, 6) = substring(SD3.D3_EMISSAO, 1, 6)
        ),
        SB2.B2_QATU
    ) as SALDO
from SB1010 SB1 (nolock)
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_COD = SB1.B1_COD
        and SD3.D3_TM in (501, 544)
    left join SB2010 SB2 (nolock)
        on SB2.D_E_L_E_T_ = ''
        and SB2.B2_COD = SB1.B1_COD
where
        SB1.D_E_L_E_T_ = ''
    and SB1.B1_GRUPO like '1%'
    and SB1.B1_MSBLQL = 2
