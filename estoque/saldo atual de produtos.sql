select
    SB1.B1_COD as contador,
    trim(SB1.B1_COD) as PRODUTO,
	trim(SB1.B1_DESC) as NOMEPRODUTO,
	trim(SB1.B1_GRUPO) as GRUPO,
    trim(SB1.B1_CONTA) as CONTA_ATIVO,
    isnull(SB1.B1_UPRC, 0.0) as ULT_PRECO,
    SB2.B2_FILIAL as FILIAL_ATU,
    SB2.B2_LOCAL as ARMAZEM_ATU,
    SB2.B2_QATU as QTD_ATU,
    SB2.B2_VATU1 as VALOR_ATU,
    SB2.B2_CM1 as CM_ATU,
    substring(SB9.B9_DATA, 1, 6) as PERIODO,
    SB9.B9_FILIAL as FILIAL_INI,
    SB9.B9_LOCAL as ARMAZEM_INI,
    SB9.B9_QINI as QTD_INI,
    SB9.B9_VINI1 as VALOR_INI,
    SB9.B9_CM1 as CM_INI,
    trim(SB1.B1_UM) as UN
from SB9010 SB9 (nolock)
    left join SB2010 SB2 (nolock)
        on SB2.D_E_L_E_T_ = ''
        and SB2.B2_COD = SB9.B9_COD
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SB9.B9_COD
where
        SB9.B9_COD like '1%' and SB9.B9_DATA like '202312%' and SB9.D_E_L_E_T_ = ''
