select
    trim(isnull(SCP.CP_FILIAL, '-')) as FILIAL,
    substring(SCP.CP_OP, 1, 6) as OS,
    trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
    trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
    trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
    trim(isnull(SB1.B1_UM, '-')) as UN,
    SCP.CP_QUANT as QTD_PEDIDA,
    SCP.CP_QUJE as QTD_ATENDIDA,

    trim(isnull(SCP.CP_ITEMCTA, '-')) as ATIVIDADE,
    trim(isnull(SCP.CP_CC, '-')) as CC,
    trim(isnull(SCP.CP_CONTA, '-')) as CONTA,
    (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SCP.CP_CONTA) DESC_CONTA,

    trim(isnull(SCP.CP_NUM, '-')) as NUMERO,
    trim(isnull(SCP.CP_ITEM, '-')) as ITEM,
    convert(date, SCP.CP_EMISSAO, 103) as DATA,
    convert(date, SCP.CP_DATPRF, 103) as DATA_ITEM,
    substring(SCP.CP_EMISSAO, 1, 6) as PERIODO,
    substring(SCP.CP_DATPRF, 1, 6) as PERIODO_ITEM,
    trim(isnull(SCP.CP_OBS, '-')) as OBS,
    
    trim(isnull(upper(SCP.CP_SOLICIT), '-')) as SOLICITANTE,

    case when SCR.CR_NUM = '' or SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,
    case SCR.CR_DATALIB when '' then 'NÃO APROVADA' else 'LIBERADA' end as STATUS,
    upper(trim(SAK.AK_LOGIN)) as APROVADOR,
    SCR.CR_GRUPO,
    SCR.CR_ITGRP,
    SCR.CR_STATUS,
    convert(date, SCR.CR_DATALIB, 103) as DATAAPROV

from SCP010 SCP (nolock)
    left join SCR010 SCR (nolock)
        on SCR.D_E_L_E_T_ = ''
        and SCR.CR_FILIAL = SCP.CP_FILIAL
        and SCR.CR_NUM = SCP.CP_NUM
        and SCR.CR_TIPO = 'SA'
        
        left join SAK010 SAK (nolock)
            on SAK.D_E_L_E_T_ = ''
            and SAK.AK_USER = SCR.CR_USERLIB
    
    left join SB1010 SB1 (nolock)
        on SB1.D_E_L_E_T_ = ''
        and SB1.B1_COD = SCP.CP_PRODUTO
where SCP.D_E_L_E_T_ = ''
