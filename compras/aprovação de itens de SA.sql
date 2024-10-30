    select
        trim(isnull(SCP.CP_FILIAL, '-')) as FILIAL,
        substring(SCP.CP_OP, 1, 6) as OS,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,
        SCP.CP_QUANT as QTD_PEDIDA,
        SCP.CP_QUJE as QTD_ATENDIDA,
        null as VALOR_APROV,

        trim(isnull(SCP.CP_ITEMCTA, '-')) as ATIVIDADE,
        trim(isnull(SCP.CP_CC, '-')) as CC,
        trim(isnull(SCP.CP_CONTA, '-')) as CONTA,
        null as FORNECEDOR,
	    null as FORNECEDOR_RED,

        coalesce(DBM.DBM_TIPO, SCR.CR_TIPO, '') as TIPO,
        coalesce(DBM.DBM_GRUPO, SCR.CR_GRUPO, '') as GRUPO,
        coalesce(DBM.DBM_ITGRP, SCR.CR_ITGRP, '') as ITGRP,
        SCR.CR_TIPO as TIPO,
        trim(SCR.CR_NIVEL) as NIVEL,
        trim(isnull(SCP.CP_NUM, '-')) as NUMERO,
        trim(isnull(SCP.CP_ITEM, '-')) as ITEM,
        cast(SCP.CP_EMISSAO as date) as DATA,
        cast(SCP.CP_DATPRF as date) as DATA_ITEM,
        left(SCP.CP_EMISSAO, 6) as PERIODO,
        left(SCP.CP_DATPRF, 6) as PERIODO_ITEM,
        trim(isnull(SCP.CP_OBS, '-')) as OBS,
        case SCR.CR_DATALIB when '' then -.5 else datediff(day, SCP.CP_DATPRF, SCR.CR_DATALIB) end as DIAS_APROV,
        upper(trim(isnull(SCR.CR_YNOMSOL, SCP.CP_SOLICIT))) as SOLICITANTE,

        (
            select count(distinct SCR.CR_NIVEL)
            from SCR010 (nolock)
            where
                    SCR010.D_E_L_E_T_ = ''
                and SCR010.CR_TIPO = 'PC'
                and SCR010.CR_FILIAL = SCR.CR_FILIAL
                and SCR010.CR_TIPO = SCR.CR_TIPO
                and SCR010.CR_NUM = SCR.CR_NUM
            group by
                SCR010.CR_FILIAL,
                SCR010.CR_TIPO,
                SCR010.CR_NUM
        )

        case when SCR.CR_NUM = '' or SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,
        
        case SCR.CR_STATUS
            when 1 then 'PENDENTE'
            when 2 then 'PENDENTE'
            when 3 then 'APROVADA'
            when 5 then 'APROVADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'LIBERADA'
        end as STATUS,
        
        case DBM.DBM_APROV when 1 then (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = DBM.DBM_USER) else '' end as APROVADOR,
        SCR.CR_GRUPO,
        SCR.CR_ITGRP,
        SCR.CR_STATUS,
        convert(date, SCR.CR_DATALIB, 103) as DATAAPROV,
        STJ.TJ_CODBEM

    from SCP010 SCP (nolock)
        left join DBM010 DBM (nolock)
            on DBM.D_E_L_E_T_ = ''
            and DBM.DBM_FILIAL = SCP.CP_FILIAL
            and DBM.DBM_NUM = SCP.CP_NUM
            and DBM.DBM_ITEM = SCP.CP_ITEM
            
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
            and STJ.TJ_ORDEM = substring(SCP.CP_OP, 1, 6)
    where
            SCR.CR_TIPO = 'SA'
        and SCP.CP_EMISSAO > 20240930
        and SCP.D_E_L_E_T_ = ''
union
    select
        trim(isnull(SCP.CP_FILIAL, '-')) as FILIAL,
        substring(SCP.CP_OP, 1, 6) as OS,
        trim(isnull(SB1.B1_COD, '-')) as PRODUTO,
        trim(isnull(SB1.B1_DESC, '-')) as NOMEPRODUTO,
        trim(isnull(SB1.B1_GRUPO, '-')) as GRUPO,
        trim(isnull(SB1.B1_UM, '-')) as UN,
        SCP.CP_QUANT as QTD_PEDIDA,
        SCP.CP_QUJE as QTD_ATENDIDA,
        null as VALOR_APROV,

        trim(isnull(SCP.CP_ITEMCTA, '-')) as ATIVIDADE,
        trim(isnull(SCP.CP_CC, '-')) as CC,
        trim(isnull(SCP.CP_CONTA, '-')) as CONTA,
        null as FORNECEDOR,
	    null as FORNECEDOR_RED,

        coalesce(DBM.DBM_TIPO, SCR.CR_TIPO, '') as TIPO,
        coalesce(DBM.DBM_GRUPO, SCR.CR_GRUPO, '') as GRUPO,
        coalesce(DBM.DBM_ITGRP, SCR.CR_ITGRP, '') as ITGRP,
        SCR.CR_TIPO as TIPO,
        trim(SCR.CR_NIVEL) as NIVEL,
        trim(isnull(SCP.CP_NUM, '-')) as NUMERO,
        trim(isnull(SCP.CP_ITEM, '-')) as ITEM,
        cast(SCP.CP_EMISSAO as date) as DATA,
        cast(SCP.CP_DATPRF as date) as DATA_ITEM,
        left(SCP.CP_EMISSAO, 6) as PERIODO,
        left(SCP.CP_DATPRF, 6) as PERIODO_ITEM,
        trim(isnull(SCP.CP_OBS, '-')) as OBS,
        case SCR.CR_DATALIB when '' then -.5 else datediff(day, SCP.CP_DATPRF, SCR.CR_DATALIB) end as DIAS_APROV,
        upper(trim(isnull(SCR.CR_YNOMSOL, SCP.CP_SOLICIT))) as SOLICITANTE,

        (
            select count(distinct SCR.CR_NIVEL)
            from SCR010 (nolock)
            where
                    SCR010.D_E_L_E_T_ = ''
                and SCR010.CR_TIPO = 'PC'
                and SCR010.CR_FILIAL = SCR.CR_FILIAL
                and SCR010.CR_TIPO = SCR.CR_TIPO
                and SCR010.CR_NUM = SCR.CR_NUM
            group by
                SCR010.CR_FILIAL,
                SCR010.CR_TIPO,
                SCR010.CR_NUM
        )

        case when SCR.CR_NUM = '' or SCR.CR_NUM is null then 'SEM ALÇADA' else 'COM ALÇADA' end as ALCADA,
        
        case SCR.CR_STATUS
            when 1 then 'PENDENTE'
            when 2 then 'PENDENTE'
            when 3 then 'APROVADA'
            when 5 then 'APROVADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'LIBERADA'
        end as STATUS,
        
        upper(trim(SAK010.AK_LOGIN)) as APROVADOR,
        SCR.CR_GRUPO,
        SCR.CR_ITGRP,
        SCR.CR_STATUS,
        convert(date, SCR.CR_DATALIB, 103) as DATAAPROV,
        STJ.TJ_CODBEM

    from SCP010 SCP (nolock)
        inner join SCR010 SCR (nolock)
            on SCR.D_E_L_E_T_ = ''
            and SCR.CR_FILIAL = SC7.C7_FILIAL
            and SCR.CR_NUM = SC7.C7_NUM
            
            left join SAK010 SAK (nolock)
                on SAK.D_E_L_E_T_ = ''
                and SAK.AK_USER = SCR.CR_USERLIB
        
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SCP.CP_PRODUTO
        left join STJ010 STJ (nolock)
            on STJ.D_E_L_E_T_ = ''
            and STJ.TJ_FILIAL = SCP.CP_FILIAL
            and STJ.TJ_ORDEM = substring(SCP.CP_OP, 1, 6)
    where
            SCR.CR_TIPO = 'PC'
        and SCR.CR_EMISSAO > 20240930
        and SCR.D_E_L_E_T_ = ''
