    select
        concat(trim(SRJ.RJ_FILIAL), trim(SRJ.RJ_FUNCAO)) as ID_FUNCAO,
        trim(SRJ.RJ_CARGO) as COD_FUNCAO,
        trim(SRJ.RJ_DESCSUM) as DESC_FUNCAO,
    from SRJ010 SRJ
    where SRJ.D_E_L_E_T_ = ''
union
        select null, null, null
