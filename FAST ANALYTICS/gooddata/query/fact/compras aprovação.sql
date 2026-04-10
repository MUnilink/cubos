SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SD1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NF,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACAO,
    case when coalesce(SCP.CP_FILIAL, SC1.C1_FILIAL, SC7.C7_FILIAL) is null then 'P |01||' else 'P |01|01'+ CAST(coalesce(SCP.CP_FILIAL, SC1.C1_FILIAL, SC7.C7_FILIAL) as char (6)) end as BK_FILIAL,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(B1CP.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(B1CP.B1_COD, B1C1.B1_COD, B1C7.B1_COD, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(BMCP.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(BMCP.BM_GRUPO, BMC1.BM_GRUPO, BMC7.BM_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(GRPFOR.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_FORNECEDOR,
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|') AS BK_COMPRADOR,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTTCP.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTTCP.CTT_CUSTO, CTTC1.CTT_CUSTO, CTTC7.CTT_CUSTO, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTDCP.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(CTDCP.CTD_ITEM, CTDC1.CTD_ITEM, CTDC7.CTD_ITEM, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(B1CP.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(B1CP.B1_UM, B1C1.B1_UM, B1C7.B1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    
    case when Y1_COM.Y1_COD is null or Y1_COM.Y1_COD = ''
        then 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|')
        else 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_COM.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_COM.Y1_COD, ' ')), ' '), '|')
    end as ID_NEGOCIANTE,
    
    cast(SCR.CR_EMISSAO as date) as DATA_DOC,
    cast(SCR.CR_DATALIB as date) as DATA_LIB,
    convert(datetime, concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), 113) as DATAHORA_LIB,
    
    case
        when SCR.CR_STATUS = '03' and SCR.CR_NIVEL in ('', '01') then convert(datetime, concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), 113)
        when SCR.CR_STATUS = '03' then convert(datetime, lag(concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), 1, null) over(partition by SCR.CR_FILIAL, SCR.CR_TIPO, SCR.CR_NUM, SCR.CR_STATUS order by SCR.CR_FILIAL, SCR.CR_TIPO, SCR.CR_NUM, SCR.CR_NIVEL), 113)
    else null end as DATAHORA_LIBANT,
    
    trim(concat(SCP.CP_EMISSAO, ' ', SCP.CP_YHORASA)) as DT_SA,
    trim(concat(SC1.C1_EMISSAO, ' ', SC1.C1_YHORASC)) as DT_SC,
    trim(concat(SC7.C7_EMISSAO, ' ', SC7.C7_YHORAPC)) as DT_EMIPC,
    SC7.C7_DATPRF as DT_PRVPC,
    SD1.D1_EMISSAO as DT_EMINF,
    trim(concat(SF1.F1_DTDIGIT, ' ', SF1.F1_YHORANF)) as DT_DIGNF,

    SCR.CR_TIPO as DOC_TIPO,
    SCR.CR_FILIAL as DOC_FILIAL,
    SCR.CR_NUM as DOC_NUM,

    (select upper(trim(SYS_USR.USR_CODIGO)) from SYS_USR where SYS_USR.D_E_L_E_T_ = '' and SYS_USR.USR_ID = coalesce(SCP.CP_USER, SC1.C1_USER)) as SOLICITANTE,
    trim(SCR.CR_USERLIB) as APROVOU_USR,
    trim(SCR.CR_LIBAPRO) as APROVOU_COD,
    trim(SCR.CR_USER) as USR_APROV,
    trim(SCR.CR_APROV) as COD_APROV,
    trim(SCR.CR_NIVEL) as NIVEL,
    trim(SCR.CR_GRUPO) as APROV_GRUPO,
    trim(SCR.CR_ITGRP) as ITEM_GRUPO,
    (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_COD = SCR.CR_LIBAPRO) as APROVANTE,

    cast(SCR.CR_VALLIB as numeric(15, 2)) as VALOR_LIB,
    cast(SCR.CR_TOTAL as numeric(15, 2)) as VALOR_DOC,
    trim(SCR.CR_STATUS) as STATUS_APROV

from SCR010 SCR (nolock)
    left join SC7010 SC7
        on SCR.D_E_L_E_T_ = ''
        and SCR.CR_TIPO = 'PC'
        and SCR.CR_FILIAL = SC7.C7_FILIAL
        and SCR.CR_NUM = SC7.C7_NUM
        
        left join SA2010 SA2
            ON SA2.A2_FILIAL = '      '
            AND SA2.A2_COD = SC7.C7_FORNECE
            AND SA2.A2_LOJA = SC7.C7_LOJA
            AND SA2.D_E_L_E_T_ = ' '
        left join SY1010 Y1_DIG
            on Y1_DIG.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_DIG.Y1_USER = SC7.C7_USER
            and Y1_DIG.Y1_COD not in (1, 6, 11, 19)
        left join SY1010 Y1_COM
            on Y1_COM.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_COM.Y1_COD = SC7.C7_YNEGOCI
            and Y1_COM.Y1_COD not in (1, 6, 11, 19)
        left join CTT010 CTTC7
            on CTTC7.CTT_FILIAL = substring(SC7.C7_FILIAL, 1, 4)
            and CTTC7.CTT_CUSTO = SC7.C7_CC
            and CTTC7.D_E_L_E_T_ = ' '
        left join CTD010 CTDC7
            on CTDC7.CTD_FILIAL = '      '
            and CTDC7.CTD_ITEM = SC7.C7_ITEMCTA
            and CTDC7.D_E_L_E_T_ = ' '
        left join SD1010 SD1
            on SD1.D1_FILIAL = SC7.C7_FILIAL
            and SD1.D1_PEDIDO = SC7.C7_NUM
            and SD1.D1_ITEMPC = SC7.C7_ITEM
            and SD1.D1_COD = SC7.C7_PRODUTO
            and SD1.D_E_L_E_T_ = ' '

            left join SF1010 SF1
                on SF1.F1_FILIAL = SD1.D1_FILIAL
                and SF1.F1_DOC = SD1.D1_DOC
                and SF1.F1_SERIE = SD1.D1_SERIE
                and SF1.F1_FORNECE = SD1.D1_FORNECE
                and SF1.F1_LOJA = SD1.D1_LOJA
                and SF1.D_E_L_E_T_ = ' '
        
        left join SB1010 B1C7
            on B1C7.D_E_L_E_T_ = ''
            and B1C7.B1_COD = SC7.C7_PRODUTO
            
            left join SBM010 BMC7
                on BMC7.BM_FILIAL = B1C7.B1_FILIAL
                and BMC7.BM_GRUPO = B1C7.B1_GRUPO
                and BMC7.D_E_L_E_T_ = ' '

    left join SC1010 SC1
        on SCR.D_E_L_E_T_ = ''
        and SCR.CR_TIPO = 'SC'
        and SCR.CR_FILIAL = SC1.C1_FILIAL
        and SCR.CR_NUM = SC1.C1_NUM

        left join CTT010 CTTC1
            on CTTC1.CTT_FILIAL = substring(SC1.C1_FILIAL, 1, 4)
            and CTTC1.CTT_CUSTO = SC1.C1_CC
            and CTTC1.D_E_L_E_T_ = ' '
        left join CTD010 CTDC1
            on CTDC1.CTD_FILIAL = '      '
            and CTDC1.CTD_ITEM = SC1.C1_ITEMCTA
            and CTDC1.D_E_L_E_T_ = ' '
        left join SB1010 B1C1
            on B1C1.D_E_L_E_T_ = ''
            and B1C1.B1_COD = SC1.C1_PRODUTO
            
            left join SBM010 BMC1
                on BMC1.BM_FILIAL = B1C1.B1_FILIAL
                and BMC1.BM_GRUPO = B1C1.B1_GRUPO
                and BMC1.D_E_L_E_T_ = ' '
    
    left join SCP010 SCP
        on SCR.D_E_L_E_T_ = ''
        and SCR.CR_TIPO = 'SA'
        and SCR.CR_FILIAL = SCP.CP_FILIAL
        and SCR.CR_NUM = SCP.CP_NUM
        
        left join CTT010 CTTCP
            on CTTCP.CTT_FILIAL = substring(SCP.CP_FILIAL, 1, 4)
            and CTTCP.CTT_CUSTO = SCP.CP_CC
            and CTTCP.D_E_L_E_T_ = ' '
        left join CTD010 CTDCP
            on CTDCP.CTD_FILIAL = '      '
            and CTDCP.CTD_ITEM = SCP.CP_ITEMCTA
            and CTDCP.D_E_L_E_T_ = ' '
        left join SB1010 B1CP
            on B1CP.D_E_L_E_T_ = ''
            and B1CP.B1_COD = SCP.CP_PRODUTO
            
            left join SBM010 BMCP
                on BMCP.BM_FILIAL = B1CP.B1_FILIAL
                and BMCP.BM_GRUPO = B1CP.B1_GRUPO
                and BMCP.D_E_L_E_T_ = ' '
where
        SCR.D_E_L_E_T_ = ' '
    and SCR.CR_STATUS in ('03', '06')
    and SCR.CR_EMISSAO BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
