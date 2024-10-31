    select
        left(SCP.CP_OP, 6) as OS,
        trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
        trim(SCP.CP_FILIAL) as FILIAL,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        trim(SB1.B1_GRUPO) as GRUPO_PROD,
        trim(SB1.B1_UM) as UN,
        SCP.CP_QUANT as QTD_PEDIDA,
        SCP.CP_QUJE as QTD_ATENDIDA,
        null as VALOR_APROV,

        trim(SCP.CP_ITEMCTA) as ATIVIDADE,
        trim(SCP.CP_CC) as CC,
        trim(SCP.CP_CONTA) as CONTA,
        (select trim(CT1010.CT1_DESC01) from CT1010 where CT1010.D_E_L_E_T_ = '' and CT1010.CT1_CONTA = SCP.CP_CONTA) as DESC_CONTA,
        null as FORNECEDOR,
	    null as FORNECEDOR_RED,

        coalesce(DBM.DBM_TIPO, SCR.CR_TIPO, '') as TIPO,
        coalesce(DBM.DBM_GRUPO, SCR.CR_GRUPO, '') as GRUPO_APROV,
        coalesce(DBM.DBM_ITGRP, SCR.CR_ITGRP, '') as ITEM_APROV,
        trim(SCP.CP_NUM) as NUMERO,
        trim(SCP.CP_ITEM) as ITEM,
        
        cast(SCP.CP_EMISSAO as date) as DATA,
        cast(SCP.CP_DATPRF as date) as DATA_ITEM,
        left(SCP.CP_EMISSAO, 6) as PERIODO,
        left(SCP.CP_DATPRF, 6) as PERIODO_ITEM,
        
        case SCR.CR_DATALIB when '' then -.5 else datediff(day, SCP.CP_DATPRF, SCR.CR_DATALIB) end as DIAS_APROV,
        upper(trim(coalesce(SCR.CR_YNOMSOL, SCP.CP_SOLICIT))) as SOLICITANTE,
        case when SCR.CR_NUM = '' or SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,
        
        SCR.CR_STATUS,
        case SCR.CR_STATUS
            when 1 then 'PENDENTE'
            when 2 then 'PENDENTE'
            when 3 then 'APROVADA'
            when 5 then 'APROVADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'LIBERADA'
        end as STATUS,

        cast(SCR.CR_NIVEL as int) as NIVEL,
        case DBM.DBM_APROV when 1 then (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = DBM.DBM_USER) else '' end as APROVADOR,
        case DBM.DBM_APROV when 3 then (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = DBM.DBM_USER) else '' end as RECUSA_POR,
        cast(SCR.CR_DATALIB as date) as DATAAPROV
    
    from SCP010 SCP (nolock)
        left join DBM010 DBM (nolock)
            on DBM.D_E_L_E_T_ = ''
            and DBM.DBM_FILIAL = SCP.CP_FILIAL
            and DBM.DBM_NUM = SCP.CP_NUM
            and DBM.DBM_ITEM = SCP.CP_ITEM
            and DBM.DBM_TIPO = 'SA'
            
            left join SCR010 SCR (nolock)
                on SCR.D_E_L_E_T_ = ''
                and SCR.CR_FILIAL = DBM.DBM_FILIAL
                and SCR.CR_NUM = DBM.DBM_NUM
                and SCR.CR_TIPO = DBM.DBM_TIPO
                and SCR.CR_GRUPO = DBM.DBM_GRUPO
                and SCR.CR_ITGRP = DBM.DBM_ITGRP
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SCP.CP_PRODUTO
        left join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_FILIAL = SCP.CP_FILIAL
            and STJ.TJ_ORDEM = left(SCP.CP_OP, 6)
    where
            SCP.D_E_L_E_T_ = ''
union
    select
        left(SC7.C7_OP, 6) as OS,
        trim(STJ.TJ_CODBEM) as EQUIPAMENTO,
        trim(SC7.C7_FILIAL) as FILIAL,
        trim(SB1.B1_COD) as PRODUTO,
        trim(SB1.B1_DESC) as NOMEPRODUTO,
        trim(SB1.B1_GRUPO) as GRUPO_PROD,
        trim(SB1.B1_UM) as UN,
        SC7.C7_QUANT as QTD_PEDIDA,
        SC7.C7_QUJE as QTD_ATENDIDA,
        SCR.CR_TOTAL as VALOR_APROV,

        trim(SC7.C7_ITEMCTA) as ATIVIDADE,
        trim(SC7.C7_CC) as CC,
        trim(SC7.C7_CONTA) as CONTA,
        null as DESC_CONTA,
        trim(SA2.A2_NOME) as FORNECEDOR,
	    trim(SA2.A2_NREDUZ) as FORNECEDOR_RED,

        SCR.CR_TIPO as TIPO,
        SCR.CR_GRUPO as GRUPO_APROV,
        SCR.CR_ITGRP as ITEM_APROV,
        trim(SC7.C7_NUM) as NUMERO,
        trim(SC7.C7_ITEM) as ITEM,
        
        cast(SC7.C7_EMISSAO as date) as DATA,
        cast(SC7.C7_DATPRF as date) as DATA_ITEM,
        left(SC7.C7_EMISSAO, 6) as PERIODO,
        left(SC7.C7_DATPRF, 6) as PERIODO_ITEM,
        
        case SCR.CR_DATALIB when '' then -.5 else datediff(day, SC7.C7_DATPRF, SCR.CR_DATALIB) end as DIAS_APROV,
        upper(trim(isnull(nullif(SCR.CR_YNOMSOL, ''), (select max(SY1010.Y1_NOME) from SY1010 (nolock) where SY1010.Y1_USER = SC7.C7_USER)))) as SOLICITANTE,
        case when SCR.CR_NUM = '' or SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,
        
        SCR.CR_STATUS,
        case SCR.CR_STATUS
            when '' then 'PENDENTE'
            when 1 then 'PENDENTE'
            when 2 then 'PENDENTE'
            when 3 then 'APROVADA'
            when 5 then 'APROVADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'LIBERADA'
        end as STATUS,

        cast(SCR.CR_NIVEL as int) as NIVEL,
        case when SCR.CR_NIVEL =
        (
            select max(SCR010.CR_NIVEL)
            from SCR010 (nolock)
            where
                    SCR010.D_E_L_E_T_ = ''
                and SCR010.CR_TIPO = SCR.CR_TIPO
                and SCR010.CR_FILIAL = SCR.CR_FILIAL
                and SCR010.CR_NUM = SCR.CR_NUM
                and SCR010.CR_STATUS in (3, 5)
        ) then (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_LIBAPRO) else null
        end as APROVADOR,

        case when SCR.CR_NIVEL =
        (
            select max(SCR010.CR_NIVEL)
            from SCR010 (nolock)
            where
                    SCR010.D_E_L_E_T_ = ''
                and SCR010.CR_TIPO = SCR.CR_TIPO
                and SCR010.CR_FILIAL = SCR.CR_FILIAL
                and SCR010.CR_NUM = SCR.CR_NUM
                and SCR010.CR_STATUS in (6, 7)
        ) then (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_LIBAPRO) else null
        end as RECUSA_POR,
        cast(SCR.CR_DATALIB as date) as DATAAPROV

    from SC7010 SC7 (nolock)
        inner join SCR010 SCR (nolock)
            on SCR.D_E_L_E_T_ = ''
            and SCR.CR_FILIAL = SC7.C7_FILIAL
            and SCR.CR_NUM = SC7.C7_NUM
            
            left join SAK010 SAK (nolock)
                on SAK.D_E_L_E_T_ = ''
                and SAK.AK_USER = SCR.CR_USERLIB
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SC7.C7_PRODUTO
        left join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_FILIAL = SC7.C7_FILIAL
            and STJ.TJ_ORDEM = left(SC7.C7_OP, 6)
        inner join SA2010 SA2 (nolock)
            on SA2.D_E_L_E_T_ = ''
            and SA2.A2_COD = SC7.C7_FORNECE
            and SA2.A2_LOJA = SC7.C7_LOJA
    where
            SC7.D_E_L_E_T_ = ''
        and SCR.CR_TIPO = 'PC'
