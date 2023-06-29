    select
        SD3.D3_FILIAL as FILIAL,
        SD3.D3_CC as CC,
        SD3.D3_ITEMCTA as ITEMCTA,
        SD3.D3_LOCAL as ARMAZEM,
        SD3.D3_EMISSAO as DATA_MOV,
        SD3.D3_COD as COD,
        SD3.D3_CF as REQDEV,
        SD3.D3_DOC as DOC,
        
        substring(SD3.D3_EMISSAO, 1, 6) as PERIODO_MOV,
        trim(SB1.B1_DESC) as DESC_PRODUTO,
        substring(SD3.D3_OP, 1, 6) as OS,
        SD3.D3_TM + ' - ' + trim(isnull(SF5.F5_TEXTO, SF4.F4_TEXTO)) as TM

    from SD3010 SD3 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
        left join SF5010 SF5 (nolock)
            on SF5.D_E_L_E_T_ = ''
            and SF5.F5_CODIGO = case SD3.D3_TM when 499 then 498 when 999 then 998 else SD3.D3_TM end
        left join SD1010 SD1 (nolock)
            on SD1.D_E_L_E_T_ = ''
            and SD1.D1_FILIAL = SD3.D3_FILIAL
            and SD1.D1_DOC = SD3.D3_DOC
            and SD1.D1_COD = SD3.D3_COD

            left join SF4010 SF4 (nolock)
                on SF4.D_E_L_E_T_ = ''
                and SF4.F4_CODIGO = SD1.D1_TES
        
        left join SB9010 SB9 (nolock)
            on SB9.D_E_L_E_T_ = ''
            and SB9.B9_FILIAL = SD3.D3_FILIAL
            and SB9.B9_LOCAL = SD3.D3_LOCAL
            and SB9.B9_COD = SD3.D3_COD
    where
            SD3.D_E_L_E_T_ = ''
        and year(SD3.D3_EMISSAO) > 2021

union
    
    select
        SD1.D1_FILIAL as FILIAL,
        SD1.D1_CC as CC,
        SD1.D1_ITEMCTA as ITEMCTA,
        SD1.D1_LOCAL as ARMAZEM,
        SD1.D1_DTDIGIT as DATA_MOV,
        SD1.D1_COD as COD,
        null as REQDEV,
        SD1.D1_DOC as DOC,

        substring(SD1.D1_DTDIGIT, 1, 6) as PERIODO_MOV,
        trim(SB1.B1_DESC) as DESC_PRODUTO,
        substring(SD1.D1_OP, 1, 6) as OS,
        null as TM

    from SD1010 SD1 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD1.D1_COD

            left join SF4010 SF4 (nolock)
                on SF4.D_E_L_E_T_ = ''
                and SF4.F4_CODIGO = SD1.D1_TES
        
        left join SB9010 SB9 (nolock)
            on SB9.D_E_L_E_T_ = ''
            and SB9.B9_FILIAL = SD1.D1_FILIAL
            and SB9.B9_LOCAL = SD1.D1_LOCAL
            and SB9.B9_COD = SD1.D1_COD
    where
            SD1.D_E_L_E_T_ = ''
        and year(SD1.D1_DTDIGIT) > 2021
