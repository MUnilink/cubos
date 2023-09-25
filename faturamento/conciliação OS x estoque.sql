    SELECT
        ZC2.ZC2_NUM + '-' + ZC2.ZC2_ITEM as OS_ITEM,
        ZC2.ZC2_COD as PRODUTO,
        ZC2.ZC2_DESC as DESCRICAO,
        CONVERT(date, ZC2.ZC2_COMPET) as PERIODO,
        ZC2.ZC2_CHVOS,
        ZC2.ZC2_TOTAL as TOTAL_OS,
        0 as TOTAL_ESTOQUE,
        R_E_C_N_O_
    FROM ZC2010 ZC2
    WHERE
            ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_COMPET != ''
        and ZC2.ZC2_TIPO = '4'

union

    SELECT
        'ESTOQUE',
        SD3.D3_COD,
        SB1.B1_DESC as DESCICAO,
        CONVERT(date, SD3.D3_EMISSAO),
        SD3.D3_YCHVOS as ZC2_CHVOS,
        0 as TOTAL_OS,
        SD3.D3_CUSTO1 as TOTAL_ESTOQUE,
        SD3.R_E_C_N_O_
    FROM SD3010 SD3
        inner join SB1010 SB1
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
    WHERE
            SD3.D_E_L_E_T_ = ''
        and SD3.D3_YCHVOS != ''
