    select
        SB1.B1_COD as contador,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,
        substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
        convert(date, SD3.D3_EMISSAO, 103) as EMISSAO,
        SD3.D3_LOCAL as ARMAZEM,
        SD3.D3_FILIAL as FILIAL,
        SD3.D3_TM as TM,
        SD3.D3_CF as CF,
        SD3.D3_DOC as DOC,
        SD3.D3_CUSTO1 as CUSTO_MOV
    from SD3010 SD3 (nolock)
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
    where
            SD3.D_E_L_E_T_ = ''
union
    select
        SB1.B1_COD as contador,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,
        substring(SD1.D1_DTDIGIT, 1, 6) as PERIODO,
        convert(date, SD1.D1_DTDIGIT, 103) as EMISSAO,
        SD1.D1_LOCAL as ARMAZEM,
        SD1.D1_FILIAL as FILIAL,
        SD1.D1_TES as TM,
        SD1.D1_CF as CF,
        SD1.D1_DOC as DOC,
        SD1.D1_CUSTO as CUSTO_MOV
    from SD1010 SD1 (nolock)
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD1.D1_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
    where
            SD1.D_E_L_E_T_ = ''
