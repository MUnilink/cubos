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
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF1.F1_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CFOP.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_CF, ' ')), ' '), '|') AS BK_CFOP,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_TES, ' ')), ' '), '|') AS BK_TES,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    
    case when Y1_COM.Y1_COD is null or Y1_COM.Y1_COD = ''
        then 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|')
        else 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_COM.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_COM.Y1_COD, ' ')), ' '), '|')
    end as ID_NEGOCIADOR,
    
    case
        when (SC7.C7_QUJE > 0) and (SC7.C7_QUJE < SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('R', ' ')), ' '), '|')
        when (SC7.C7_QUJE >= SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('I', ' ')), ' '), '|')
    else 'P |'+'|' end as BK_SITUACAO_COMPRA,
    
    (
        select max('P |01|SAK010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|'))
        from SCR010 SCR
            inner join SAK010
                on SAK010.D_E_L_E_T_ = ''
                and SAK010.AK_COD = SCR.CR_LIBAPRO
        where
                SCR.D_E_L_E_T_ = ''
            and SCR.CR_FILIAL = SC7.C7_FILIAL
            and SCR.CR_NUM = SC7.C7_NUM
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

    SD1.D1_QUANT as QTD_ATENDIDA,
    SD1.D1_TOTAL as VALOR_TOTAL,

    trim(concat(SC1.C1_EMISSAO, ' ', SC1.C1_YHORASC)) as DATA_SC,
    SD1.D1_EMISSAO as DATA_EMINF,
    trim(concat(SF1.F1_DTDIGIT, ' ', SF1.F1_YHORANF)) as DATA_DIGNF, /* data */
    trim(concat(SC7.C7_EMISSAO, ' ', SC7.C7_YHORAPC)) as DATA_EMIPC,
    SC7.C7_DATPRF as DATA_PRVPC,

    (
        select max(coalesce(concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), ''))
        from SCR010 SCR
        where
            SCR.D_E_L_E_T_ = ''
        and nullif(SCR.CR_LIBAPRO, '') is not null
        and SCR.CR_STATUS < 6
        and SCR.CR_TIPO = 'SC'
        and SCR.CR_NUM = SC1.C1_NUM
        and SCR.CR_NIVEL =
        (
            select max(SCR010.CR_NIVEL)
            from SCR010
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
        select max(coalesce(concat(SCR.CR_DATALIB, ' ', SCR.CR_YHRLIB), ''))
        from SCR010 SCR
        where
            SCR.D_E_L_E_T_ = ''
        and nullif(SCR.CR_LIBAPRO, '') is not null
        and SCR.CR_STATUS < 6
        and SCR.CR_TIPO = 'PC'
        and SCR.CR_NUM = SC7.C7_NUM
        and SCR.CR_NIVEL =
        (
            select max(SCR010.CR_NIVEL)
            from SCR010
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

FROM SC7010 SC7
    left join SB1010 SB1
        on SB1.D_E_L_E_T_ = ' '
        and SB1.B1_FILIAL = '      '
        and SB1.B1_COD = SC7.C7_PRODUTO
    left join SA2010 SA2
        on SA2.D_E_L_E_T_ = ' '
        and SA2.A2_FILIAL = '      '
        and SA2.A2_COD = SC7.C7_FORNECE
        and SA2.A2_LOJA = SC7.C7_LOJA
    left join SBM010 SBM
        on SBM.D_E_L_E_T_ = ' '
        and SBM.BM_FILIAL = SB1.B1_FILIAL
        and SBM.BM_GRUPO = SB1.B1_GRUPO
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
        and SD1.D1_COD = SC7.C7_PRODUTO
        and SD1.D_E_L_E_T_ = ' '

        left join SF1010 SF1
            on SF1.F1_FILIAL = SD1.D1_FILIAL
            and SF1.F1_DOC = SD1.D1_DOC
            and SF1.F1_SERIE = SD1.D1_SERIE
            and SF1.F1_FORNECE = SD1.D1_FORNECE
            and SF1.F1_LOJA = SD1.D1_LOJA
            and SF1.D_E_L_E_T_ = ' '

    left join SCR010 CRPC
        on CRPC.D_E_L_E_T_ = ''
        and CRPC.CR_TIPO = 'PC'
        and CRPC.CR_FILIAL = SC1.C1_FILIAL
        and CRPC.CR_NUM = SC1.C1_NUM
    full join SC1010 SC1
        on SC1.C1_FILIAL = SC7.C7_FILIAL
        and SC1.C1_NUM = SC7.C7_NUMSC
        and SC1.C1_ITEM = SC7.C7_ITEMSC
        and SC1.C1_PRODUTO = SC7.C7_PRODUTO
        and SC1.D_E_L_E_T_ = ' '

        left join SCR010 CRSC
            on CRSC.D_E_L_E_T_ = ''
            and CRSC.CR_TIPO = 'SC'
            and CRSC.CR_FILIAL = SC1.C1_FILIAL
            and CRSC.CR_NUM = SC1.C1_NUM

        full join SCP010 SCP
            on SC1.C1_FILIAL = SCP.CP_FILIAL
            and SC1.C1_NUM = SCP.CP_NUMSC
            and SC1.C1_ITEM = SCP.CP_ITEMSC
            and SC1.C1_PRODUTO = SCP.CP_PRODUTO
            and SC1.D_E_L_E_T_ = ' '

            left join SCR010 CRSA
                on CRSA.D_E_L_E_T_ = ''
                and CRSA.CR_TIPO = 'SA'
                and CRSA.CR_FILIAL = SCP.CP_FILIAL
                and CRSA.CR_NUM = SCP.CP_NUM
where
        SD1.D1_DTDIGIT BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and SD1.D1_ORIGLAN <> 'LF'
    and SD1.D1_TIPO NOT IN ('D', 'B')
    and SD1.D_E_L_E_T_ = ' '
