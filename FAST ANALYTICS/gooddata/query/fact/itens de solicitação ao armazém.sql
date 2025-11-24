SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SF1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NFE,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACOM,
    concat(trim(SCP.CP_FILIAL), trim(SCP.CP_NUM)) as ID_SOLICITAARM,
    case when SC7.C7_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SC7.C7_FILIAL as char (6)) end as BK_FILIAL,
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_FORNECE, ' '))+RTRIM(COALESCE(SC7.C7_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_PRODUTO, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_TES, ' ')), ' '), '|') AS BK_TES,
    'P |01|ACU010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACU.ACU_FILIAL, ' '))+'|'+RTRIM(COALESCE(ACU.ACU_COD, ' ')), ' '), '|') AS BK_FAMILIA_COMERCIAL,
    'P |01|CT1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_CONTA, ' ')), ' '), '|') AS BK_CONTA,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SCP.CP_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(SC7.C7_CONAPRO, ' ')), ' '), '|') AS DESCRICAO_APROVCOMPRA,
    
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|') AS BK_COMPRADOR,
    case when Y1_COM.Y1_COD is null or Y1_COM.Y1_COD = ''
        then 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|')
        else 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_COM.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_COM.Y1_COD, ' ')), ' '), '|')
    end as ID_NEGOCIADOR,
    
    (
        select max('P |01|SAK010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|'))
        from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
        where
                SCR.D_E_L_E_T_ = ''
            and SCR.CR_FILIAL = SCP.CP_FILIAL
            and SCR.CR_NUM = SCP.CP_NUM
            and SCR.CR_STATUS < 6
            and SCR.CR_NIVEL =
            (
                select max(SCR010.CR_NIVEL)
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
    ) as BK_APROVADOR,
    
    case
        when (SC7.C7_QUJE > 0) and (SC7.C7_QUJE < SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('R', ' ')), ' '), '|')
        when (SC7.C7_QUJE >= SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('I', ' ')), ' '), '|')
        else 'P |'+'|'
    end as BK_SITUACAO_COMPRA,
    
    coalesce(SC7.C7_EMISSAO, '') AS DT_SOLICITAARM,
    coalesce(SC7.C7_DATPRF, '') AS DT_PREV_SOLICITAARM,
    coalesce(SC1.C1_EMISSAO, '') AS DT_SOLICITACOM,
    coalesce(SC7.C7_EMISSAO, '') AS DT_PEDIDO,

    (
        select max(coalesce(SCR.CR_DATALIB, ''))
        from SCR010 SCR
        where
            SCR.D_E_L_E_T_ = ''
        and nullif(SCR.CR_LIBAPRO, '') is not null
        and SCR.CR_STATUS < 6
        and SCR.CR_TIPO = 'SA'
        and SCR.CR_FILIAL = SCP.CP_FILIAL
        and SCR.CR_NUM = SCP.CP_NUM
        and SCR.CR_NIVEL =
        (
            select max(SCR010.CR_NIVEL)
            from SCR010 (nolock)
            where
                    SCR010.D_E_L_E_T_ = ''
                and SCR010.CR_TIPO = 'SC'
                and SCR010.CR_FILIAL = SCR.CR_FILIAL
                and SCR010.CR_TIPO = SCR.CR_TIPO
                and SCR010.CR_NUM = SCR.CR_NUM
            group by
                SCR010.CR_FILIAL,
                SCR010.CR_TIPO,
                SCR010.CR_NUM
        )
    ) as DATAAPROV_SC, /* data aprovação SC */
    (
        select max(coalesce(SCR.CR_DATALIB, ''))
        from SCR010 SCR
        where
            SCR.D_E_L_E_T_ = ''
        and nullif(SCR.CR_LIBAPRO, '') is not null
        and SCR.CR_STATUS < 6
        and SCR.CR_TIPO = 'SC'
        and SCR.CR_FILIAL = SC1.C1_FILIAL
        and SCR.CR_NUM = SC1.C1_NUM
        and SCR.CR_NIVEL =
        (
            select max(SCR010.CR_NIVEL)
            from SCR010 (nolock)
            where
                    SCR010.D_E_L_E_T_ = ''
                and SCR010.CR_TIPO = 'SC'
                and SCR010.CR_FILIAL = SCR.CR_FILIAL
                and SCR010.CR_TIPO = SCR.CR_TIPO
                and SCR010.CR_NUM = SCR.CR_NUM
            group by
                SCR010.CR_FILIAL,
                SCR010.CR_TIPO,
                SCR010.CR_NUM
        )
    ) as DATAAPROV_SC, /* data aprovação SC */
    (
        select max(coalesce(SCR.CR_DATALIB, ''))
        from SCR010 SCR
        where
            SCR.D_E_L_E_T_ = ''
        and nullif(SCR.CR_LIBAPRO, '') is not null
        and SCR.CR_STATUS < 6
        and SCR.CR_TIPO = 'PC'
        and SCR.CR_FILIAL = SC7.C7_FILIAL
        and SCR.CR_NUM = SC7.C7_NUM
        and SCR.CR_NIVEL =
        (
            select max(SCR010.CR_NIVEL)
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
    ) as DATAAPROV_PC, /* data aprovação PC */
    
    SCP.CP_QUANT as QTD_SOLICITADA,
    SCP.CP_QUJE as QTD_ATENDIDA,
    SCP.CP_VUNIT as PRECO_ESTIM,
    1 as QTD_SA /* qtd de SAs */

FROM SCP010 SCP
    left join SB1010 SB1
        on SB1.D_E_L_E_T_ = ' '
        and SB1.B1_COD = SCP.CP_PRODUTO
        
        left join SBM010 SBM
            on SBM.D_E_L_E_T_ = ' '
            and SBM.BM_GRUPO = SB1.B1_GRUPO
        left join SAH010 SAH
            on SAH.D_E_L_E_T_ = ''
            and SAH.AH_UNIMED = SB1.B1_COD
        left join ACV010 ACV
            on ACV.D_E_L_E_T_ = ' '
            and coalesce(nullif(ACV.ACV_FILIAL, ''), '0101') = coalesce(nullif(SB1.B1_FILIAL, ''), '0101')
            and ACV.ACV_CODPRO = SB1.B1_COD

            left join ACU010 ACU
                on ACU.D_E_L_E_T_ = ' '
                and ACU.ACU_FILIAL = coalesce(nullif(ACV.ACV_FILIAL, ''), '0101')
                and ACU.ACU_COD = ACV.ACV_CATEGO
/*
    left join SCQ010 SCQ
        on SCQ.D_E_L_E_T_ = ''
        and SCQ.CQ_FILIAL = SCP.CP_FILIAL
        and SCQ.CQ_NUM = SCP.CP_NUM
        and SCQ.CQ_ITEM = SCP.CP_ITEM
    left join SD3010 SD3
        on SD3.D_E_L_E_T_ = ''
        and SD3.D3_FILIAL = SCP.CP_FILIAL
        and SD3.D3_NUMSA = SCP.CP_NUM
        and SD3.D3_ITEMSA = SCP.CP_ITEM
*/
    left join SC1010 SC1
        on SC1.D_E_L_E_T_ = ' '
        and SC1.C1_FILIAL = SCP.CP_FILIAL
        and SC1.C1_NUM = SCP.CP_NUMSC
        and SC1.C1_ITEM = SCP.CP_ITSC

        left join SC7010 SC7
            on SC7.D_E_L_E_T_ = ' '
            and SC7.C7_FILIAL = SC1.C1_FILIAL
            and SC7.C7_NUM = SC1.C1_NUM
            and SC7.C7_ITEM = SC1.C1_ITEM

            left join SA2010 SA2
                on SA2.D_E_L_E_T_ = ' '
                and SA2.A2_FILIAL = '      '
                and SA2.A2_COD = SC7.C7_FORNECE
                and SA2.A2_LOJA = SC7.C7_LOJA
            left join SD1010 SD1
                on SD1.D_E_L_E_T_ = ''
                and SD1.D1_FILIAL = SC7.C7_FILIAL
                and SD1.D1_PEDIDO = SC7.C7_NUM
                and SD1.D1_ITEMPC = SC7.C7_ITEM
        
                left join SF1010 SF1
                    on SF1.F1_FILIAL = SD1.D1_FILIAL
                    and SF1.F1_DOC = SD1.D1_DOC
                    and SF1.F1_SERIE = SD1.D1_SERIE
                    and SF1.F1_FORNECE = SD1.D1_FORNECE
                    and SF1.F1_LOJA = SD1.D1_LOJA
                    and SF1.D_E_L_E_T_ = ' '
            
            left join SE4010 SE4
                on SE4.D_E_L_E_T_ = ' '
                and SE4.E4_FILIAL = '      '
                and SE4.E4_CODIGO = SC7.C7_COND
            left join SF4010 SF4
                on SF4.D_E_L_E_T_ = ' '
                and SF4.F4_FILIAL = '      '
                and SF4.F4_CODIGO = SC7.C7_TES
            left join SY1010 Y1_DIG
                on Y1_DIG.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
                and Y1_DIG.Y1_USER = SC7.C7_USER
                and Y1_DIG.Y1_COD not in (1, 6, 11, 19)
            left join SY1010 Y1_COM
                on Y1_COM.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
                and Y1_COM.Y1_COD = SC7.C7_YNEGOCI
                and Y1_COM.Y1_COD not in (1, 6, 11, 19)
    
    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ' '
        and CTT.CTT_FILIAL = SUBSTRING(SC7.C7_FILIAL, 1, 4)
        and CTT.CTT_CUSTO = SCP.CP_CC
    left join CTD010 CTD
        on CTD.D_E_L_E_T_ = ' '
        and CTD.CTD_FILIAL = '      '
        and CTD.CTD_ITEM = SCP.CP_ITEMCTA
where 
        SCP.CP_EMISSAO BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and SCP.D_E_L_E_T_ = ' '
