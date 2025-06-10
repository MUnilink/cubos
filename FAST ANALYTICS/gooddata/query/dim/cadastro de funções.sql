    select
        concat(trim(SRJ.RJ_FILIAL), trim(SRJ.RJ_CARGO)) as ID_CARGO,
        trim(SRJ.RJ_CARGO) as COD_CARGO,
        trim(SRJ.RJ_DESCSUM) as DESC_CARGO,
    from SRJ010 SRJ
    where SRJ.D_E_L_E_T_ = ''
union
        select null, null, null
