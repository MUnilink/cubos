    select
        concat(trim(ZA7.ZA7_FILIAL), trim(ZA7.ZA7_COD)) as ID_DESPESA,
        trim(ZA7.ZA7_COD) as COD_DESPESA,
        trim(ZA7.ZA7_DESC) as DESC_DESPESA
    from ZA7010 ZA7
    where ZA7.D_E_L_E_T_ = ''
union
    select null, null, null