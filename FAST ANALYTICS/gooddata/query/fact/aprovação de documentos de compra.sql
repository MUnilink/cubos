SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SF1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NF,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACAO,
    case when SD1.D1_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SD1.D1_FILIAL as char (6)) end as BK_FILIAL,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_COD, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_FORNECE, ' '))+RTRIM(COALESCE(SD1.D1_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(GRPFOR.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_FORNECEDOR,
    'P |01|SA4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA4.A4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF1.F1_TRANSP, ' ')), ' '), '|') AS BK_TRANSPORTADORA,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(FAMAT.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_TIPO, ' ')), ' '), '|') AS BK_FAMILIA_MATERIAL,
    'P |01|ACU010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACU.ACU_FILIAL, ' '))+'|'+RTRIM(COALESCE(ACU.ACU_COD, ' ')), ' '), '|') AS BK_FAMILIA_COMERCIAL,
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|') AS BK_COMPRADOR,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CFOP.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_CF, ' ')), ' '), '|') AS BK_CFOP,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_TES, ' ')), ' '), '|') AS BK_TES,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    
    case when Y1_COM.Y1_COD is null or Y1_COM.Y1_COD = ''
        then 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|')
        else 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_COM.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_COM.Y1_COD, ' ')), ' '), '|')
    end as ID_NEGOCIADOR,
    
    case
        when (SC7.C7_QUJE > 0) and (SC7.C7_QUJE < SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('R', ' ')), ' '), '|')
        when (SC7.C7_QUJE >= SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('I', ' ')), ' '), '|')
    else 'P |'+'|' end as BK_SITUACAO_COMPRA,

    trim(concat(SCP.CP_DATPRF, ' ', SCP.CP_YHORASA)) as DATA_SAPRF,
    trim(concat(SCP.CP_EMISSAO, ' ', SCP.CP_YHORASA)) as DATA_SAEMI,
    trim(concat(SCP.CP_YDATAPR, ' ', SCP.CP_YHORAPR)) as DATA_SAPRERE,
    trim(concat(SCP.CP_YDATABA, ' ', SCP.CP_YHORABA)) as DATA_SABAIXA,
    
    trim(concat(SC1.C1_EMISSAO, ' ', SC1.C1_YHORASC)) as DATA_SC,
    trim(concat(SC7.C7_EMISSAO, ' ', SC7.C7_YHORAPC)) as DATA_EMIPC,
    trim(concat(SF1.F1_DTDIGIT, ' ', SF1.F1_YHORANF)) as DATA_DIGNF,
    SC7.C7_DATPRF as DATA_PRVPC,

    trim(CRPC.CR_APROV) as APRPC_ITEM_APROVA,
    trim(CRPC.CR_GRUPO) as APRPC_GRUPO_APROV,
    trim(CRPC.CR_ITGRP) as APRPC_ITEM_GRUPO,
    trim(CRPC.CR_NIVEL) as APRPC_NIVEL,
    convert(datetime, concat(CRPC.CR_DATALIB, ' ', CRPC.CR_YHRLIB), 113) as APRPC_DATAHORALIB,
    cast(CRPC.CR_DATALIB as date) as APRPC_DATALIB,
    (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = CRPC.CR_USERLIB) as APRPC_APROVADOPOR,
    cast(CRPC.CR_VALLIB as numeric(15, 2)) as APRPC_VALORLIB,
    cast(CRPC.CR_TOTAL as numeric(15, 2)) as APRPC_VALORDOC,

    concat
    (
        trim(CRPC.CR_STATUS), ' - ',
        case CRPC.CR_STATUS
            when 1 then 'PENDENTE'
            when 2 then 'PENDENTE'
            when 3 then 'LIBERADA'
            when 4 then 'BLOQUEADA'
            when 5 then 'LIBERADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'OUTROS'
        end
    ) as STATUS_APRPC,

    (select upper(trim(SYS_USR.USR_CODIGO)) from SYS_USR where SYS_USR.D_E_L_E_T_ = '' and SYS_USR.USR_ID = SC1.C1_USER) as SOLICITANTE_SC,
    trim(CRSC.CR_APROV) as APRSC_ITEM_APROVA,
    trim(CRSC.CR_GRUPO) as APRSC_GRUPO_APROV,
    trim(CRSC.CR_ITGRP) as APRSC_ITEM_GRUPO,
    trim(CRSC.CR_NIVEL) as APRSC_NIVEL,
    convert(datetime, concat(CRSC.CR_DATALIB, ' ', CRSC.CR_YHRLIB), 113) as APRSC_DATAHORALIB,
    cast(CRSC.CR_DATALIB as date) as APRSC_DATALIB,
    (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = CRSC.CR_USERLIB) as APRSC_APROVADOPOR,
    cast(CRSC.CR_VALLIB as numeric(15, 2)) as APRSC_VALORLIB,
    cast(CRSC.CR_TOTAL as numeric(15, 2)) as APRSC_VALORDOC,

    (select upper(trim(SYS_USR.USR_CODIGO)) from SYS_USR where SYS_USR.D_E_L_E_T_ = '' and SYS_USR.USR_ID = SCP.CP_USER) as SOLICITANTE_SA,
    trim(CRSA.CR_APROV) as APRSA_ITEM_APROVA,
    trim(CRSA.CR_GRUPO) as APRSA_GRUPO_APROV,
    trim(CRSA.CR_ITGRP) as APRSA_ITEM_GRUPO,
    trim(CRSA.CR_NIVEL) as APRSA_NIVEL,
    convert(datetime, concat(CRSA.CR_DATALIB, ' ', CRSA.CR_YHRLIB), 113) as APRSA_DATAHORALIB,
    cast(CRSA.CR_DATALIB as date) as APRSA_DATALIB,
    (select upper(trim(max(SAK010.AK_LOGIN))) from SAK010 (nolock) where SAK010.D_E_L_E_T_ = '' and SAK010.AK_USER = CRSA.CR_USERLIB) as APRSA_APROVADOPOR,
    cast(CRSA.CR_VALLIB as numeric(15, 2)) as APRSA_VALORLIB,
    cast(CRSA.CR_TOTAL as numeric(15, 2)) as APRSA_VALORDOC,
    
    concat
    (
        trim(CRSC.CR_STATUS), ' - ',
        case CRSC.CR_STATUS
            when 1 then 'PENDENTE'
            when 2 then 'PENDENTE'
            when 3 then 'LIBERADA'
            when 4 then 'BLOQUEADA'
            when 5 then 'LIBERADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'OUTROS'
        end
    ) as STATUS_APRSC,
    concat
    (
        trim(CRSA.CR_STATUS), ' - ',
        case CRSA.CR_STATUS
            when 1 then 'PENDENTE'
            when 2 then 'PENDENTE'
            when 3 then 'LIBERADA'
            when 4 then 'BLOQUEADA'
            when 5 then 'LIBERADA'
            when 6 then 'REJEITADA'
            when 7 then 'REJEITADA'
            else 'OUTROS'
        end
    ) as STATUS_APRSA

FROM SC7010 SC7
    left join SB1010 SB1
        on SB1.D_E_L_E_T_ = ' '
        and SB1.B1_FILIAL = '      '
        and SB1.B1_COD = SC7.C7_PRODUTO
        
        left join SBM010 SBM
            on SBM.D_E_L_E_T_ = ' '
            and SBM.BM_FILIAL = SB1.B1_FILIAL
            and SBM.BM_GRUPO = SB1.B1_GRUPO
        LEFT JOIN SX5010 FAMAT
            ON FAMAT.X5_FILIAL = '      '
            AND FAMAT.X5_TABELA = '02'
            AND FAMAT.X5_CHAVE = B1_TIPO
            AND FAMAT.D_E_L_E_T_ = ' '
    
    left join SA2010 SA2
        on SA2.D_E_L_E_T_ = ' '
        and SA2.A2_FILIAL = '      '
        and SA2.A2_COD = SC7.C7_FORNECE
        and SA2.A2_LOJA = SC7.C7_LOJA

        LEFT JOIN SX5010 GRPFOR
            ON GRPFOR.X5_FILIAL = '      '
            AND GRPFOR.X5_TABELA = 'Y7'
            AND GRPFOR.X5_CHAVE = SA2.A2_GRUPO
            AND GRPFOR.D_E_L_E_T_ = ' '
    
    left join SE4010 SE4
        on SE4.D_E_L_E_T_ = ' '
        and SE4.E4_FILIAL = '      '
        and SE4.E4_CODIGO = SC7.C7_COND
    left join SF4010 SF4
        on SF4.D_E_L_E_T_ = ' '
        and SF4.F4_FILIAL = '      '
        and SF4.F4_CODIGO = SC7.C7_TES
    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ' '
        and CTT.CTT_FILIAL = left(SC7.C7_FILIAL, 4)
        and CTT.CTT_CUSTO = SC7.C7_CC
    left join SY1010 Y1_DIG
        on Y1_DIG.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
        and Y1_DIG.Y1_USER = SC7.C7_USER
        and Y1_DIG.Y1_COD not in (1, 6, 11, 19)
    left join SY1010 Y1_COM
        on Y1_COM.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
        and Y1_COM.Y1_COD = SC7.C7_YNEGOCI
        and Y1_COM.Y1_COD not in (1, 6, 11, 19)
    
    left join ACV010 ACV
        on ACV.D_E_L_E_T_ = ' '
        and ACV.ACV_FILIAL = SUBSTRING(SC7.C7_FILIAL, 1, 4)
        and ACV.ACV_CODPRO = SC7.C7_PRODUTO

        left join ACU010 ACU
            on ACU.D_E_L_E_T_ = ' '
            and ACU.ACU_FILIAL = ACV.ACV_FILIAL
            and ACU.ACU_COD = ACV.ACV_CATEGO
    
    left join CTD010 CTD
        on CTD.D_E_L_E_T_ = ' '
        and CTD.CTD_FILIAL = '      '
        and CTD.CTD_ITEM = SC7.C7_ITEMCTA
    left join SAH010 SAH
        on SAH.D_E_L_E_T_ = ' '
        and SAH.AH_FILIAL = '      '
        and SAH.AH_UNIMED = SC7.C7_UM
    left join SM2010 SM2
        on SM2.D_E_L_E_T_ = ' '
        and SM2.M2_DATA = SC7.C7_EMISSAO
    
    left join SD1010 SD1
        on SD1.D1_FILIAL = SC7.C7_FILIAL
        and SD1.D1_PEDIDO = SC7.C7_NUM
        and SD1.D1_ITEMPC = SC7.C7_ITEM
        and SD1.D1_NUMSEQ = SC7.C7_SEQUEN
        and SD1.D_E_L_E_T_ = ' '

        LEFT JOIN SX5010 CFOP
            ON CFOP.X5_FILIAL = '      '
            AND CFOP.X5_TABELA = '13'
            AND CFOP.X5_CHAVE = SD1.D1_CF
            AND CFOP.D_E_L_E_T_ = ' '
        left join SF1010 SF1
            on SF1.F1_FILIAL = SD1.D1_FILIAL
            and SF1.F1_DOC = SD1.D1_DOC
            and SF1.F1_SERIE = SD1.D1_SERIE
            and SF1.F1_FORNECE = SD1.D1_FORNECE
            and SF1.F1_LOJA = SD1.D1_LOJA
            and SF1.D_E_L_E_T_ = ' '

            LEFT JOIN SA4010 SA4
                ON SA4.A4_FILIAL = '      '
                AND SA4.A4_COD = SF1.F1_TRANSP
                AND SA4.D_E_L_E_T_ = ' '

    left join SCR010 CRPC
        on CRPC.D_E_L_E_T_ = ''
        and CRPC.CR_TIPO = 'PC'
        and CRPC.CR_FILIAL = SC7.C7_FILIAL
        and CRPC.CR_NUM = SC7.C7_NUM
    full join SC1010 SC1
        on SC1.C1_FILIAL = SC7.C7_FILIAL
        and SC1.C1_PEDIDO = SC7.C7_NUM
        and SC1.C1_ITEMPED = SC7.C7_ITEM
        and SC1.C1_PRODUTO = SC7.C7_PRODUTO
        and SC1.D_E_L_E_T_ = ' '

        left join SCR010 CRSC
            on CRSC.D_E_L_E_T_ = ''
            and CRSC.CR_TIPO = 'SC'
            and CRSC.CR_FILIAL = SC1.C1_FILIAL
            and CRSC.CR_NUM = SC1.C1_NUM
        full join SCP010 SCP
            on SCP.CP_FILIAL = SC1.C1_FILIAL
            and SCP.CP_NUMSC = SC1.C1_NUM
            and SCP.CP_ITSC = SC1.C1_ITEM
            and SCP.CP_PRODUTO = SC1.C1_PRODUTO
            and SCP.D_E_L_E_T_ = ' '

            left join SCR010 CRSA
                on CRSA.D_E_L_E_T_ = ''
                and CRSA.CR_TIPO = 'SA'
                and CRSA.CR_FILIAL = SCP.CP_FILIAL
                and CRSA.CR_NUM = SCP.CP_NUM
where
        SC7.C7_EMISSAO BETWEEN '20251001' and '20260131'
    and SC7.D_E_L_E_T_ = ' '
