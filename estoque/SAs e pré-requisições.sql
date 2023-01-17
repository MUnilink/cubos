select
    SCP.CP_FILIAL as FILIAL,
    SCP.CP_NUM as NUM_SA,
    SCP.CP_ITEM as ITEM_SA,
    SCP.CP_UM as UN,
    SCP.CP_QUANT as QTD_SOLICTADA,
    SCP.CP_QUJE as QTD_ATENDIDA,

    trim(isnull(SB1.B1_GRUPO, '-')) as B1_GRUPO

from SCP010 SCP (nolock)
    left join SCQ010 SCQ (nolock)
        on SCQ.D_E_L_E_T_ = ''
        and SCQ.CQ_FILIAL = SCP.CP_FILIAL
        and SCQ.CQ_NUM = SCP.CP_NUM
        and SCQ.CQ_ITEM = SCP.CP_ITEM
        and SCQ.CQ_NUMSQ = SCP.CP_NUM
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SCP.CP_COD
where SCP.D_E_L_E_T_ = ''
