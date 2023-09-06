    select
        SB1.B1_COD as contador,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,

        SB9.B9_CM1 as CM_INI,
        SB9.B9_VINI1 as VALOR_INI,
        SB9.B9_QINI as QTD_INI,
        cast(SB9.B9_DATA as date) as DATA_INI,
        
        substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
        cast(SD3.D3_EMISSAO as date) as EMISSAO,
        SD3.D3_FILIAL as FILIAL,
        SD3.D3_LOCAL as ARMAZEM,
        SD3.D3_TM as TM,
        SD3.D3_CF as CF,
        SD3.D3_DOC as DOC,
        SD3.D3_CUSTO1 as CUSTO_MOV,
        SD3.D3_QUANT as QTD_MOV,
        'INT' as TIPO_MOV
        
    from SD3010 SD3 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
        left join SB9010 SB9 (nolock)
            on SB9.D_E_L_E_T_ = ''
            and SB9.B9_FILIAL = SD3.D3_FILIAL
            and SB9.B9_LOCAL = SD3.D3_LOCAL
            and SB9.B9_COD = SD3.D3_COD
            and datediff(month, SB9.B9_DATA, SD3.D3_EMISSAO) = 1
    where
            SD3.D_E_L_E_T_ = ''
union
    select
        SB1.B1_COD as contador,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,

        SB9.B9_CM1 as CM_INI,
        SB9.B9_VINI1 as VALOR_INI,
        SB9.B9_QINI as QTD_INI,
        cast(SB9.B9_DATA as date) as DATA_INI,
        
        substring(SD1.D1_DTDIGIT, 1, 6) as PERIODO,
        cast(SD1.D1_DTDIGIT as date) as EMISSAO,
        SD1.D1_FILIAL as FILIAL,
        SD1.D1_LOCAL as ARMAZEM,
        SD1.D1_TES as TM,
        SD1.D1_CF as CF,
        SD1.D1_DOC as DOC,
        SD1.D1_CUSTO as CUSTO_MOV,
        SD1.D1_QUANT as QTD_MOV,
        'ENT' as TIPO_MOV
        
    from SD1010 SD1 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD1.D1_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
        left join SB9010 SB9 (nolock)
            on SB9.D_E_L_E_T_ = ''
            and SB9.B9_FILIAL = SD1.D1_FILIAL
            and SB9.B9_LOCAL = SD1.D1_LOCAL
            and SB9.B9_COD = SD1.D1_COD
            and datediff(month, SB9.B9_DATA, SD1.D1_DTDIGIT) = 1
    where
            SD1.D_E_L_E_T_ = ''
union
    select
        SB1.B1_COD as contador,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,

        SB9.B9_CM1 as CM_INI,
        SB9.B9_VINI1 as VALOR_INI,
        SB9.B9_QINI as QTD_INI,
        cast(SB9.B9_DATA as date) as DATA_INI,
        
        substring(SD2.D2_EMISSAO, 1, 6) as PERIODO,
        cast(SD2.D2_EMISSAO as date) as EMISSAO,
        SD2.D2_FILIAL as FILIAL,
        SD2.D2_LOCAL as ARMAZEM,
        SD2.D2_TES as TM,
        SD2.D2_CF as CF,
        SD2.D2_DOC as DOC,
        SD2.D2_CUSTO1 as CUSTO_MOV,
        SD2.D2_QUANT as QTD_MOV,
        'SAI' as TIPO_MOV
        
    from SD2010 SD2 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD2.D2_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
        left join SB9010 SB9 (nolock)
            on SB9.D_E_L_E_T_ = ''
            and SB9.B9_FILIAL = SD2.D2_FILIAL
            and SB9.B9_LOCAL = SD2.D2_LOCAL
            and SB9.B9_COD = SD2.D2_COD
            and datediff(month, SB9.B9_DATA, SD2.D2_EMISSAO) = 1
    where
            SD2.D_E_L_E_T_ = ''
