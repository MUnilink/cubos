select
    SCP.CP_FILIAL as FILIAL,
    SCP.CP_LOCAL as ARMAZEM,
    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,

    case when SCP.CP_QUANT = SCP.CP_QUJE then 'TOT. ATENDIDA'
    else
        case when SCP.CP_QUJE = 0.0 then 'PENDENTE'
        else
            case when SCP.CP_QUANT > SCP.CP_QUJE then 'PAR. ATENDIDA'
            else 'OUTROS'
            end
        end
    end as SA_ATENDIDA,

    SD3.D3_DOC,
    SD3.D3_TM,
    SD3.D3_CF,
    SD3.D3_CC,
    SD3.D3_ITEMCTA,
    convert(date, SD3.D3_EMISSAO, 103) as D3_EMISSAO,
    SD3.D3_LOCALIZ,
    SD3.D3_USUARIO,
    SD3.D3_NUMSEQ,
    
    SB1.B1_COD,
    SB1.B1_DESC,
    trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
    
    convert(date, SCP.CP_EMISSAO, 103) as DATA_SA,
    substring(SCP.CP_EMISSAO, 1, 6) as PERIODO,
    SCP.CP_USER,
    SCP.CP_CODSOLI,
    SCP.CP_PREREQU,
    SCP.CP_STATUS,
    SCP.CP_STATSA,
    SCP.CP_SALBLQ,

    SCQ.CQ_NUMREQ,
    SCQ.CQ_QUANT,
    SCQ.CQ_QTDISP,
    SCP.CP_NUMSC,
    SCP.CP_ITSC

from SCP010 SCP (nolock)
    left join SCQ010 SCQ (nolock)
        on SCQ.D_E_L_E_T_ = ''
        and SCQ.CQ_FILIAL = SCP.CP_FILIAL
        and SCQ.CQ_NUM = SCP.CP_NUM
        and SCQ.CQ_ITEM = SCP.CP_ITEM
    left join SD3010 SD3 (nolock)
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_FILIAL = SCP.CP_FILIAL
        and SD3.D3_NUMSA = SCP.CP_NUM
        and SD3.D3_ITEMSA = SCP.CP_ITEM
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SCP.CP_PRODUTO

where SCP.D_E_L_E_T_ = ''
