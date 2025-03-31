    select
        SB1.B1_COD as contador,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
        trim(SB1.B1_UM) as UN,

        SB2.B2_CM1 as CM_ATUAL,
        SB2.B2_VATU1 as VALOR_ATUAL,
        SB2.B2_QATU as QTD_ATUAL,
        
        substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
        cast(SD3.D3_EMISSAO as date) as EMISSAO,
        SD3.D3_OP as OP,
        SD3.D3_YOS as OS_PORT,
        SD3.D3_NUMSA as SA,
        SD3.D3_FILIAL as FILIAL,
        SD3.D3_LOCAL as ARMAZEM,
        SD3.D3_TM as TM,
        SD3.D3_CF as CF,
        SD3.D3_DOC as DOC,
        SD3.D3_NUMSEQ as SEQ,
        SD3.D3_ESTORNO as ESTORNO,
        SD3.D3_CC as CCUSTO,
        SD3.D3_ITEMCTA as ATIVIDADE,
        
        SD3.D3_CUSTO1 as CUSTO,
        case when SD3.D3_CF like 'R%' then -1*SD3.D3_CUSTO1 else SD3.D3_CUSTO1 end as CUSTO_MOV,
        SD3.D3_QUANT as QTD,
        case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV,
        'INT' as TIPO_MOV
        
    from SD3010 SD3 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
        inner join SB2010 SB2 (nolock)
            on SB2.D_E_L_E_T_ = ''
            and SB2.B2_FILIAL = SD3.D3_FILIAL
            and SB2.B2_LOCAL = SD3.D3_LOCAL
            and SB2.B2_COD = SD3.D3_COD
    where
            SD3.D_E_L_E_T_ = ''
union
    select
        SB1.B1_COD as contador,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
        trim(SB1.B1_UM) as UN,

        SB2.B2_CM1 as CM_ATUAL,
        SB2.B2_VATU1 as VALOR_ATUAL,
        SB2.B2_QATU as QTD_ATUAL,
        
        substring(SD1.D1_DTDIGIT, 1, 6) as PERIODO,
        cast(SD1.D1_DTDIGIT as date) as EMISSAO,
        SD1.D1_OP as OP,
        SD1.D1_YOS as OS_PORT,
        null as SA,
        SD1.D1_FILIAL as FILIAL,
        SD1.D1_LOCAL as ARMAZEM,
        SD1.D1_TES as TM,
        SD1.D1_CF as CF,
        SD1.D1_DOC as DOC,
        null as SEQ,
        null as ESTORNO,
        SD1.D1_CC as CCUSTO,
        SD1.D1_ITEMCTA as ATIVIDADE,
        
        SD1.D1_CUSTO as CUSTO,
        SD1.D1_CUSTO as CUSTO_MOV,
        SD1.D1_QUANT as QTD,
        SD1.D1_QUANT as QTD_MOV,
        'ENT' as TIPO_MOV
        
    from SD1010 SD1 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD1.D1_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
        inner join SB2010 SB2 (nolock)
            on SB2.D_E_L_E_T_ = ''
            and SB2.B2_FILIAL = SD1.D1_FILIAL
            and SB2.B2_LOCAL = SD1.D1_LOCAL
            and SB2.B2_COD = SD1.D1_COD
    where
            SD1.D_E_L_E_T_ = ''
union
    select
        SB1.B1_COD as contador,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
        trim(SB1.B1_UM) as UN,

        SB2.B2_CM1 as CM_ATUAL,
        SB2.B2_VATU1 as VALOR_ATUAL,
        SB2.B2_QATU as QTD_ATUAL,
        
        substring(SD2.D2_EMISSAO, 1, 6) as PERIODO,
        cast(SD2.D2_EMISSAO as date) as EMISSAO,
        SD2.D2_OP as OP,
        null as OS_PORT,
        null as SA,
        SD2.D2_FILIAL as FILIAL,
        SD2.D2_LOCAL as ARMAZEM,
        SD2.D2_TES as TM,
        SD2.D2_CF as CF,
        SD2.D2_DOC as DOC,
        null as SEQ,
        null as ESTORNO,
        SD2.D2_CCUSTO as CCUSTO,
        SD2.D2_ITEMCC as ATIVIDADE,
        
        SD2.D2_CUSTO1 as CUSTO,
        -1*SD2.D2_CUSTO1 as CUSTO_MOV,
        SD2.D2_QUANT as QTD,
        -1*SD2.D2_QUANT as QTD_MOV,
        'SAI' as TIPO_MOV
        
    from SD2010 SD2 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD2.D2_COD
            and SB1.B1_GRUPO like '1%'
            and SB1.B1_MSBLQL = 2
        inner join SB2010 SB2 (nolock)
            on SB2.D_E_L_E_T_ = ''
            and SB2.B2_FILIAL = SD2.D2_FILIAL
            and SB2.B2_LOCAL = SD2.D2_LOCAL
            and SB2.B2_COD = SD2.D2_COD
    where
            SD2.D_E_L_E_T_ = ''
