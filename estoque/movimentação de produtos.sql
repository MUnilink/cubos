    select
        (
            select max(SB9010.B9_QINI)
            from SB9010
            where
                    left(SB9010.B9_DATA, 6) = left(SD3.D3_EMISSAO, 6)
                and SB9010.B9_FILIAL = SD3.D3_FILIAL
                and SB9010.B9_LOCAL = SD3.D3_LOCAL
                and SB9010.B9_COD = SD3.D3_COD
                and SB9010.D_E_L_E_T_ = ''
        ) as QTD_INI,
        
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
        null as CLIFOR_COD,
        null as CLIFOR_LOJA,
        null as CLIFOR_DESC,
        SD3.D3_NUMSEQ as SEQ,
        SD3.D3_ESTORNO as ESTORNO,
        trim(SD3.D3_CC) as CCUSTO,
        trim(SD3.D3_ITEMCTA) as ATIVIDADE,
        
        SD3.D3_CUSTO1 as CUSTO,
        case when SD3.D3_CF like 'R%' then -1*SD3.D3_CUSTO1 else SD3.D3_CUSTO1 end as CUSTO_MOV,
        SD3.D3_QUANT as QTD,
        case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV,
        case when SD3.D3_CF like 'R%' then 'SAI EST' when SD3.D3_CF like 'D%' then 'ENT EST' else 'outros' end as TIPO_MOV
        
    from SD3010 SD3 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
            and SB1.B1_GRUPO like '1[1-2]%'
            and SB1.B1_GRUPO != '1130'
        inner join SB2010 SB2 (nolock)
            on SB2.D_E_L_E_T_ = ''
            and SB2.B2_FILIAL = SD3.D3_FILIAL
            and SB2.B2_LOCAL = SD3.D3_LOCAL
            and SB2.B2_COD = SD3.D3_COD
    where
            SD3.D_E_L_E_T_ = ''
union
    select
        (
            select max(SB9010.B9_QINI)
            from SB9010
            where
                    left(SB9010.B9_DATA, 6) = left(SD1.D1_DTDIGIT, 6)
                and SB9010.B9_FILIAL = SD1.D1_FILIAL
                and SB9010.B9_LOCAL = SD1.D1_LOCAL
                and SB9010.B9_COD = SD1.D1_COD
                and SB9010.D_E_L_E_T_ = ''
        ) as QTD_INI,
        
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
        trim(SA2.A2_COD) as CLIFOR_COD,
        trim(SA2.A2_LOJA) as CLIFOR_LOJA,
        trim(SA2.A2_NOME) as CLIFOR_DESC,
        null as SEQ,
        null as ESTORNO,
        trim(SD1.D1_CC) as CCUSTO,
        trim(SD1.D1_ITEMCTA) as ATIVIDADE,
        
        SD1.D1_CUSTO as CUSTO,
        SD1.D1_CUSTO as CUSTO_MOV,
        SD1.D1_QUANT as QTD,
        SD1.D1_QUANT as QTD_MOV,
        'ENT NF' as TIPO_MOV
        
    from SD1010 SD1 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD1.D1_COD
            and SB1.B1_GRUPO like '1[1-2]%'
            and SB1.B1_GRUPO != '1130'
        inner join SB2010 SB2 (nolock)
            on SB2.D_E_L_E_T_ = ''
            and SB2.B2_FILIAL = SD1.D1_FILIAL
            and SB2.B2_LOCAL = SD1.D1_LOCAL
            and SB2.B2_COD = SD1.D1_COD
        left join SA2010 SA2 (nolock)
            on SA2.D_E_L_E_T_= ''
            and SA2.A2_COD = SD1.D1_FORNECE
            and SA2.A2_LOJA = SD1.D1_LOJA
    where
            SD1.D_E_L_E_T_ = ''
union
    select
        (
            select max(SB9010.B9_QINI)
            from SB9010
            where
                    left(SB9010.B9_DATA, 6) = left(SD2.D2_EMISSAO, 6)
                and SB9010.B9_FILIAL = SD2.D2_FILIAL
                and SB9010.B9_LOCAL = SD2.D2_LOCAL
                and SB9010.B9_COD = SD2.D2_COD
                and SB9010.D_E_L_E_T_ = ''
        ) as QTD_INI,
        
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
        trim(SA1.A1_COD) as CLIFOR_COD,
        trim(SA1.A1_LOJA) as CLIFOR_LOJA,
        trim(SA1.A1_NOME) as CLIFOR_DESC,
        null as SEQ,
        null as ESTORNO,
        trim(SD2.D2_CCUSTO) as CCUSTO,
        trim(SD2.D2_ITEMCC) as ATIVIDADE,
        
        SD2.D2_CUSTO1 as CUSTO,
        -1*SD2.D2_CUSTO1 as CUSTO_MOV,
        SD2.D2_QUANT as QTD,
        -1*SD2.D2_QUANT as QTD_MOV,
        'SAI NF' as TIPO_MOV
        
    from SD2010 SD2 (nolock)
        inner join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD2.D2_COD
            and SB1.B1_GRUPO like '1[1-2]%'
            and SB1.B1_GRUPO != '1130'
        inner join SB2010 SB2 (nolock)
            on SB2.D_E_L_E_T_ = ''
            and SB2.B2_FILIAL = SD2.D2_FILIAL
            and SB2.B2_LOCAL = SD2.D2_LOCAL
            and SB2.B2_COD = SD2.D2_COD
        left join SA1010 SA1 (nolock)
            on SA1.D_E_L_E_T_= ''
            and SA1.A1_COD = SD2.D2_CLIENTE
            and SA1.A1_LOJA = SD2.D2_LOJA
    where
            SD2.D_E_L_E_T_ = ''
