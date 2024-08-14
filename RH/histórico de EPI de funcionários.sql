select
    SB1.B1_COD as contador,
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
    trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
    trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
    trim(isnull(SB1.B1_UM, '-')) as UN,

    SB2.B2_CM1 as CM_ATUAL,
    SB2.B2_VATU1 as VALOR_ATUAL,
    SB2.B2_QATU as QTD_ATUAL,

    SB9.B9_CM1 as CM_INI,
    SB9.B9_VINI1 as VALOR_INI,
    SB9.B9_QINI as QTD_INI,
    cast(SB9.B9_DATA as date) as DATA_INI,
    
    substring(SD3.D3_EMISSAO, 1, 6) as PERIODO,
    cast(SD3.D3_EMISSAO as date) as EMISSAO,
    SD3.D3_OP as OP,
    SD3.D3_NUMSA as SA,
    SD3.D3_FILIAL as FILIAL,
    SD3.D3_LOCAL as ARMAZEM,
    SD3.D3_TM as TM,
    SD3.D3_CF as CF,
    SD3.D3_DOC as DOC,
    SD3.D3_NUMSEQ as SEQ,
    SD3.D3_ESTORNO as ESTORNO,
    case when SD3.D3_CF like 'R%' then -1*SD3.D3_CUSTO1 else SD3.D3_CUSTO1 end as CUSTO_MOV,
    case when SD3.D3_CF like 'R%' then -1*SD3.D3_QUANT else SD3.D3_QUANT end as QTD_MOV,
    SD3.D3_YOS as OS_PORT,
    'INT' as TIPO_MOV
    
from TNF010 TNF
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and SCP.CP_FILIAL = TNF.TNF_FILIAL
        and SCP.CP_NUM = TNF.TNF_NUMSA
        and SCP.CP_ITEM = TNF.TNF_ITEMSA
        
        left join SD3010 SD3 (nolock)
            on SD3.D_E_L_E_T_ = ''
            and SD3.D3_FILIAL = SCP.CP_FILIAL
            and SD3.D3_NUMSA = SCP.CP_NUM
            and SD3.D3_ITEMSA = SCP.CP_ITEM
    
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SD3.D3_COD
        and SB1.B1_GRUPO like '1%'
        and SB1.B1_MSBLQL = 2
where
        TNF.D_E_L_E_T_ = ''
