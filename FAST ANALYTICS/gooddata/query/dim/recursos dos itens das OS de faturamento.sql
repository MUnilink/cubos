    select distinct
        cast(ZC2.ZC2_TIPO as int) as TIPO_ITEM,

        case
            when ZG1.R_E_C_N_O_ is not null then concat(trim(ZG1.ZG1_TIPO), 'i')
            when cast(ZC2.ZC2_TIPO as int) = 4 then concat(trim(ZC2.ZC2_TIPO), '-', (select max(trim(SB1010.B1_YCTCUST)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 4)) /* madeira 320601001 */
            when cast(ZC2.ZC2_TIPO as int) in (5, 11) and ZC2.ZC2_YFORNE in (52, 4997) then concat(trim(ZC2.ZC2_TIPO), '-', trim(ZC2.ZC2_YFORNE))
            when cast(ZC2.ZC2_TIPO as int) = 7 then concat(trim(ZC2.ZC2_TIPO), '-', trim(ZC2.ZC2_COD))
            when cast(ZC2.ZC2_TIPO as int) in (10, 13) then trim(ZC2.ZC2_TIPO)
            when cast(ZC2.ZC2_TIPO as int) in (2, 14, 3, 6, 9, 12) then concat(trim(ZC2.ZC2_TIPO), 'p')
            else trim(ZC2.ZC2_TIPO)
        end as VARIAVEL_REC,

        case when cast(ZC2.ZC2_TIPO as int) in (5, 11) then concat(trim(ZC2.ZC2_TIPO), ' ', trim(ZC2.ZC2_YFORNE)) else concat(trim(ZC2.ZC2_TIPO), ' ', trim(ZC2.ZC2_COD)) end as ID_RECURSO,
        
        case
            when cast(ZC2.ZC2_TIPO as int) in (5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (1, 4, 11))
            when cast(ZC2.ZC2_TIPO as int) in (1, 4) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (1, 4, 11))
            when cast(ZC2.ZC2_TIPO as int) in (2, 14, 15) then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (2, 14))
            when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13))
            when cast(ZC2.ZC2_TIPO as int) = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7)
            else null
        end as DESC_RECURSO,
        case
            when ZG1.R_E_C_N_O_ is not null then concat(trim(ZG1.ZG1_TABELA), 'i')
            when cast(ZC2.ZC2_TIPO as int) in (1, 4, 5, 11) then 'SB1'
            when cast(ZC2.ZC2_TIPO as int) in (2, 14, 15) then 'SQ3p'
            when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13, 16) then 'ST9p'
            when cast(ZC2.ZC2_TIPO as int) = 7 then 'ZA7'
            else null
        end as TABELA
    from ZC2010 ZC2
        left join ZG1010 ZG1
            on ZG1.D_E_L_E_T_ = ''
            and ZG1.ZG1_FILORI = ZC2.ZC2_FILIAL
            and ZG1.ZG1_CODIGO = ZC2.ZC2_COD
    where ZC2.D_E_L_E_T_ = ''

union select null, null, null, null, null
