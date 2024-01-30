select
    ZC2.ZC2_NUM as NUM_OS,
    ZC2.ZC2_ITEM as OS_ITEM,
    ZC2.ZC2_COD as PRODUTO,
    trim(ZA7.ZA7_DESC) as DESCRICAO,
    ZC2.ZC2_COMPET as PERIODO,
    ZC2.ZC2_TOTAL as TOTAL_OS,
    ZC2.R_E_C_N_O_

from ZC2010 ZC2 (nolock)
    inner join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and ZA7.ZA7_COD = ZC2.ZC2_COD
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_COMPET != ''
    and ZC2.ZC2_TIPO = 7
