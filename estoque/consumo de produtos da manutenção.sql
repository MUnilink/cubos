select
    SB1.B1_COD as contador,
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
    trim(SB1.B1_UM) as UN,
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

    case when SD3.D3_CF like 'R%' then 'SAI' when SD3.D3_CF like 'D%' then 'ENT' else 'NF' end as TIPO_MOV,
    
    SD3.D3_QUANT as QTD,
    case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV,

    (
        select max(SB9010.B9_QINI)
        from SB9010
        where
                left(SB9010.B9_DATA, 6) = left(SD3.D3_EMISSAO, 6)
            and SB9010.B9_FILIAL = SD3.D3_FILIAL
            and SB9010.B9_LOCAL = SD3.D3_LOCAL
            and SB9010.B9_COD = SD3.D3_COD
            and SB9010.D_E_L_E_T_ = ''
    ) as QTD_INI
    
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
