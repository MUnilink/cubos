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

        SCR.CR_TIPO as TIPO,
        trim(isnull(SCP.CP_NUM, '-')) as NUMERO,
        trim(isnull(SCP.CP_ITEM, '-')) as ITEM,
        convert(date, SCP.CP_EMISSAO, 103) as DATA,
        convert(date, SCP.CP_DATPRF, 103) as DATA_ITEM,
        substring(SCP.CP_EMISSAO, 1, 6) as PERIODO,
        substring(SCP.CP_DATPRF, 1, 6) as PERIODO_ITEM,
        trim(isnull(SCP.CP_OBS, '-')) as OBS,
        
        trim(isnull(upper(SCP.CP_SOLICIT), '-')) as SOLICITANTE,

        case when SCR.CR_NUM = '' or SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,
        
        case SCR.CR_STATUS
            when 2 then 'PENDENTE'
            when 3 then 'APROVADA'
            when 5 then 'APROVADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'LIBERADA'
        end as STATUS,
        
        case DBM.DBM_APROV when 1 then upper(trim(SAK.AK_LOGIN)) else '' end as APROVADOR,
        SCR.CR_GRUPO,
        SCR.CR_ITGRP,
        SCR.CR_STATUS,
        convert(date, SCR.CR_DATALIB, 103) as DATAAPROV,
        STJ.TJ_CODBEM

    from SCP010 SCP (nolock)
        left join SCR010 SCR (nolock)
            on SCR.D_E_L_E_T_ = ''
            and SCR.CR_FILIAL = SCP.CP_FILIAL
            and SCR.CR_NUM = SCP.CP_NUM
            and SCR.CR_TIPO = 'SA'
            
        left join DBM010 DBM (nolock)
            on DBM.D_E_L_E_T_ = ''
            and DBM.DBM_FILIAL = SCP.CP_FILIAL
            and DBM.DBM_NUM = SCP.CP_NUM
            and DBM.DBM_ITEM = SCP.CP_ITEM
            and DBM.DBM_TIPO = 'SA'

            left join SAK010 SAK (nolock)
                on SAK.D_E_L_E_T_ = ''
                and SAK.AK_USER = DBM.DBM_USER
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SCP.CP_PRODUTO
        left join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_FILIAL = SCP.CP_FILIAL
            and STJ.TJ_ORDEM = substring(SCP.CP_OP, 1, 6)
    where
            SCP.D_E_L_E_T_ = ''
        and year(SCP.CP_DATPRF) > 2022
union
    select
        trim(isnull(SC7.C7_FILIAL, '-')) as FILIAL,
        substring(SC7.C7_OP, 1, 6) as OS,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,
        SC7.C7_QUANT as QTD_PEDIDA,
        SC7.C7_QUJE as QTD_ATENDIDA,

        trim(isnull(SC7.C7_ITEMCTA, '-')) as ATIVIDADE,
        trim(isnull(SC7.C7_CC, '-')) as CC,
        trim(isnull(SC7.C7_CONTA, '-')) as CONTA,
        (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SC7.C7_CONTA) DESC_CONTA,

        SCR.CR_TIPO as TIPO,
        trim(isnull(SC7.C7_NUM, '-')) as NUMERO,
        trim(isnull(SC7.C7_ITEM, '-')) as ITEM,
        convert(date, SC7.C7_EMISSAO, 103) as DATA,
        convert(date, SC7.C7_DATPRF, 103) as DATA_ITEM,
        substring(SC7.C7_EMISSAO, 1, 6) as PERIODO,
        substring(SC7.C7_DATPRF, 1, 6) as PERIODO_ITEM,
        trim(isnull(SC7.C7_OBS, '-')) as OBS,
        
        trim(isnull(upper(SC7.C7_SOLICIT), '-')) as SOLICITANTE,

        case when SCR.CR_NUM = '' or SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,
        
        case SCR.CR_STATUS
            when 2 then 'PENDENTE'
            when 3 then 'APROVADA'
            when 5 then 'APROVADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'LIBERADA'
        end as STATUS,
        
        upper(trim(SAK.AK_LOGIN)) as APROVADOR,
        SCR.CR_GRUPO,
        SCR.CR_ITGRP,
        SCR.CR_STATUS,
        convert(date, SCR.CR_DATALIB, 103) as DATAAPROV,
        STJ.TJ_CODBEM

    from SC7010 SC7 (nolock)
        inner join SCR010 SCR (nolock)
            on SCR.D_E_L_E_T_ = ''
            and SCR.CR_FILIAL = SC7.C7_FILIAL
            and SCR.CR_NUM = SC7.C7_NUM
            and SCR.CR_TIPO = 'PC'
            
            left join SAK010 SAK (nolock)
                on SAK.D_E_L_E_T_ = ''
                and SAK.AK_USER = SCR.CR_USERLIB
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SC7.C7_PRODUTO
        left join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_FILIAL = SC7.C7_FILIAL
            and STJ.TJ_ORDEM = substring(SC7.C7_OP, 1, 6)
    where
            SC7.D_E_L_E_T_ = ''
        and year(SC7.C7_DATPRF) > 2022
