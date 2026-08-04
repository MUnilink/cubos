select
    trim(SB9.B9_FILIAL) as FILIAL,
    trim(SB9.B9_LOCAL) as ARMAZEM,
    trim(NNR.NNR_DESCRI) as DESC_ARM,
    left(SB9.B9_DATA, 6) as PERIODO,
    trim(SB1.B1_COD) as PRODUTO,
    trim(SB1.B1_DESC) as NOMEPRODUTO,
    concat(trim(SB1.B1_GRUPO), ' - ', (select upper(trim(SBM010.BM_DESC)) from SBM010 where SBM010.D_E_L_E_T_ = '' and SBM010.BM_GRUPO = SB1.B1_GRUPO)) as GRUPO,
    trim(SB1.B1_UM) as UN,
    cast(SB9.B9_QINI as numeric(15, 2)) as QTD_INI,
    cast(SB9.B9_VINI1 as numeric(15, 2)) as VL_INI,
    cast(SB9.B9_CM1 as numeric(15, 2)) as CM,

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
        and SD3.D3_FILIAL = SB9.B9_FILIAL
        and SD3.D3_LOCAL = SB9.B9_LOCAL
        and SD3.D3_COD = SB9.B9_COD
        and left(SD3.D3_EMISSAO, 6) = left(SB9.B9_DATA, 6)
    left join NNR010 NNR
        on NNR.D_E_L_E_T_ = ''
        and NNR.NNR_FILIAL = SB9.B9_FILIAL
        and NNR.NNR_CODIGO = SB9.B9_LOCAL
where
        SB9.D_E_L_E_T_ = ''
    and SB9.B9_DATA >=:PERIODO
