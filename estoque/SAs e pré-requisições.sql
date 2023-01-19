select
    SCP.CP_FILIAL as FILIAL,
    SCP.CP_LOCAL as ARMAZEM,
    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,
    trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO,
    
    convert(date, SCP.CP_EMISSAO, 103) as DATA_SA,
    substring(SCP.CP_EMISSAO, 1, 6) as PERIODO,
    SCP.CP_USER,
    SCP.CP_CODSOLI,
    SCP.CP_PREREQU,
    SCP.CP_STATUS,
    SCP.CP_STATSA,
    SCP.CP_SALBLQ,

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
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SCP.CP_PRODUTO
where SCP.D_E_L_E_T_ = ''
