select
    SCP.CP_FILIAL as FILIAL,
    SCP.CP_LOCAL as ARMAZEM,
    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,

    case
        when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
        when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        when SCP.CP_QUANT > SCP.CP_QUJE then 'PAR. ATENDIDA'
        else 'OUTROS'
    end as SA_ATENDIDA,

    SD3.D3_OP,
    SD3.D3_ORDEM,
    SD3.D3_DOC,
    SD3.D3_TM,
    SD3.D3_CF,
    SD3.D3_CC,
    SD3.D3_ITEMCTA,
    convert(date, SD3.D3_EMISSAO, 103) as D3_EMISSAO,
    SD3.D3_LOCALIZ,
    upper(trim(SD3.D3_USUARIO)) as D3_USUARIO,
    SD3.D3_NUMSEQ,
    SD3.D3_ESTORNO,
        
    trim(SB1.B1_COD) as B1_COD,
    trim(SB1.B1_DESC) as B1_DESC,
    trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
    
    convert(date, SCP.CP_EMISSAO, 103) as DATA_SA,
    substring(SCP.CP_EMISSAO, 1, 6) as PERIODO,
    SCP.CP_USER,
    SCP.CP_CODSOLI,
    SCP.CP_NUMSC,
    SCP.CP_ITSC

from SCP010 SCP (nolock)
    inner join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SCP.CP_PRODUTO
        and SB1.B1_GRUPO in ('1208', '1209')
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_FILIAL = SCP.CP_FILIAL
        and SD3.D3_NUMSA = SCP.CP_NUM
        and SD3.D3_ITEMSA = SCP.CP_ITEM
where SCP.D_E_L_E_T_ = ''
