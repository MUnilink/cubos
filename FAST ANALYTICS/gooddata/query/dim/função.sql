    select
        concat(trim(SQ3.Q3_FILIAL), trim(SQ3.Q3_CARGO)) as ID_FUNCAO,
        trim(SQ3.Q3_CARGO) as COD_FUNCAO,
        trim(SQ3.Q3_DESCSUM) as DESC_FUNCAO,
        null as APP_PORT
    from SQ3010 SQ3
    where SQ3.D_E_L_E_T_ = ''
union
        select null, null, null, null
