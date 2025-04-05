    select
        SB9.B9_FILIAL as FILIAL,
        SB9.B9_LOCAL as ARMAZEM,
        left(SB9.B9_DATA, 6) as PERIODO,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
        trim(SB1.B1_UM) as UN,
        SB9.B9_QINI as QTD_INI,
        SB9.B9_VINI1 as VL_INI,
        SB9.B9_CM1 as CM,

        cast(SD3.D3_EMISSAO as date) as EMISSAO,
        SD3.D3_OP as OP,
        SD3.D3_YOS as OS_PORT,
        SD3.D3_NUMSA as SA,
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
        case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV
    from SB9010 SB9 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SB9.B9_COD
            and SB1.B1_GRUPO like '1%'
        left join SD3010 SD3 (nolock)
            on SD3.D3_FILIAL = SB9.B9_FILIAL
            and SD3.D3_LOCAL = SB9.B9_LOCAL
            and SD3.D3_COD = SB9.B9_COD
            and left(SD3.D3_EMISSAO, 6) = left(SB9.B9_DATA, 6)
            and SB9.D_E_L_E_T_ = ''
    where
            SB9.D_E_L_E_T_ = ''
        and SB9.B9_LOCAL in ('01', '80')
union
    select
        SB9.B9_FILIAL as FILIAL,
        SB9.B9_LOCAL as ARMAZEM,
        left(SB9.B9_DATA, 6) as PERIODO,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
        trim(SB1.B1_UM) as UN,
        SB9.B9_QINI as QTD_INI,
        SB9.B9_VINI1 as VL_INI,
        SB9.B9_CM1 as CM,

        cast(SD3.D3_EMISSAO as date) as EMISSAO,
        SD3.D3_OP as OP,
        SD3.D3_YOS as OS_PORT,
        SD3.D3_NUMSA as SA,
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
        case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV
    from SB9010 SB9 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SB9.B9_COD
            and SB1.B1_GRUPO like '1%'
        left join SD3010 SD3 (nolock)
            on SD3.D3_FILIAL = SB9.B9_FILIAL
            and SD3.D3_LOCAL = SB9.B9_LOCAL
            and SD3.D3_COD = SB9.B9_COD
            and left(SD3.D3_EMISSAO, 6) = left(SB9.B9_DATA, 6)
            and SB9.D_E_L_E_T_ = ''
    where
            SB9.D_E_L_E_T_ = ''
        and SB9.B9_LOCAL in ('01', '80')
union
    select
        SB9.B9_FILIAL as FILIAL,
        SB9.B9_LOCAL as ARMAZEM,
        left(SB9.B9_DATA, 6) as PERIODO,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
        trim(SB1.B1_UM) as UN,
        SB9.B9_QINI as QTD_INI,
        SB9.B9_VINI1 as VL_INI,
        SB9.B9_CM1 as CM,

        cast(SD3.D3_EMISSAO as date) as EMISSAO,
        SD3.D3_OP as OP,
        SD3.D3_YOS as OS_PORT,
        SD3.D3_NUMSA as SA,
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
        case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV
    from SB9010 SB9 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SB9.B9_COD
            and SB1.B1_GRUPO like '1%'
        left join SD3010 SD3 (nolock)
            on SB9.D_E_L_E_T_ = ''
            and SD1.D1_FILIAL = SB9.B9_FILIAL
            and SD1.D1_LOCAL = SB9.B9_LOCAL
            and SD1.D1_COD = SB9.B9_COD
            and left(SD1.D1_DTDIGIT, 6) = left(SB9.B9_DATA, 6)
    where
            SB9.D_E_L_E_T_ = ''
        and SB9.B9_LOCAL in ('01', '80')