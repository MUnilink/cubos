SELECT
    ZC2.ZC2_NUM as NUM_OS,
    ZC2.ZC2_ITEM as OS_ITEM,
    ZC2.ZC2_COD as PRODUTO,
    trim(ZA7.ZA7_DESC) as DESCRICAO,
    CONVERT(date, ZC2.ZC2_COMPET) as PERIODO,
    ZC2.ZC2_TOTAL as TOTAL_OS,
    ZC2.R_E_C_N_O_

FROM ZC2010 ZC2 (nolock)
    inner join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and ZA7.ZA7_COD = ZC2.ZC2_COD
WHERE
        ZC2.D_E_L_E_T_ = ''
    AND ZC2.ZC2_COMPET != ''
    AND ZC2.ZC2_TIPO = 7
