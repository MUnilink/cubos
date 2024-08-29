    select distinct
        cast(ZC2.ZC2_TIPO as int) as TIPO_ITEM,
        trim(ZC2.ZC2_COD) as RECURSO,
        case
            when cast(ZC2.ZC2_TIPO as int) in (1, 4, 5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (1, 4, 11))
            when cast(ZC2.ZC2_TIPO as int) in (2, 14) then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (2, 14))
            when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13))
            when cast(ZC2.ZC2_TIPO as int) = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7)
            else null
        end as DESC_RECURSO,
        case
            when cast(ZC2.ZC2_TIPO as int) in (1, 4, 5, 11) then 'SB1'
            when cast(ZC2.ZC2_TIPO as int) in (2, 14) then 'SQ3'
            when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13) then 'ST9'
            when cast(ZC2.ZC2_TIPO as int) = 7 then 'ZA7'
            else null
        end as TABELA
    from ZC2010 ZC2
    where ZC2.D_E_L_E_T_ = ''

union select null, null, null, null
