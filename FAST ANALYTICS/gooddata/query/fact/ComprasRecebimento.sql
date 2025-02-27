SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SD1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NF,
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
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_COM.Y1_FILIAL, ' '))+'|'+RTRIM(coalesce(nullif(Y1_COM.Y1_COD, ''), Y1_DIG.Y1_COD, ' ')), ' '), '|') as ID_NEGOCIADOR,
    
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

    SD1.D1_EMISSAO as DATANF,
    SD1.D1_DTDIGIT as DATA,
    SD1.D1_QUANT as QTD_ATENDIDA,
    SD1.D1_TOTAL as VALOR_TOTAL,
    SC7.C7_EMISSAO as DTEPED,
    SC7.C7_DATPRF as DTPREV,
    SC1.C1_EMISSAO as DTEORD,

    (
        select max(coalesce(SCR.CR_DATALIB, ''))
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
        select max(coalesce(SCR.CR_DATALIB, ''))
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
    
    case when
            (COALESCE(SC7.C7_DATPRF, ' ') = ' ')
            or (SC7.C7_DATPRF = NULL)
            or (COALESCE(SD1.D1_DTDIGIT, ' ') = ' ')
            or (SD1.D1_DTDIGIT = NULL)
            or (SD1.D1_DTDIGIT > SC7.C7_DATPRF)
        then 0
        else datediff(day, SD1.D1_DTDIGIT, SC7.C7_DATPRF)
    end as QTD_DIAS_ADIANTADO,
    
    case when
            (COALESCE(SC7.C7_DATPRF, ' ') = ' ')
            or (SC7.C7_DATPRF = NULL)
            or (COALESCE(SD1.D1_DTDIGIT, ' ') = ' ')
            or (SD1.D1_DTDIGIT = NULL)
            or (SC7.C7_DATPRF > SD1.D1_DTDIGIT)
        then 0
        else datediff(day, SC7.C7_DATPRF, SD1.D1_DTDIGIT)
    end as QTD_DIAS_ATRASO,
    
    case when datediff(day, SD1.D1_DTDIGIT, SC7.C7_DATPRF) > 0 then 1 else 0 end as QTD_ADIANTADA, /* diferença entre data classificação e data prevista */
    case when datediff(day, SC7.C7_DATPRF, SD1.D1_DTDIGIT) < 0 then 1 else 0 end as QTD_ATRASADA, /* diferença entre data prevista e data classificação */
    case when (datediff(day, SD1.D1_DTDIGIT, SC7.C7_DATPRF) = 0) and (datediff(day, SC7.C7_DATPRF, SD1.D1_DTDIGIT) = 0) then 1 else 0 end as QTD_EMDIA, /* recebimento em dia */
    case when (SD1.D1_QUANT >= SC7.C7_QUANT) then 1 else 0 end as QRECUN /* se quantidade atendida maior que quantidade pedida*/

FROM SD1010 SD1
    LEFT JOIN SB1010 SB1
        ON SB1.B1_FILIAL = '      '
        AND SB1.B1_COD = SD1.D1_COD
        AND SB1.D_E_L_E_T_ = ' '
        
        LEFT JOIN SBM010 SBM
            ON SBM.BM_FILIAL = SB1.B1_FILIAL
            AND SBM.BM_GRUPO = SB1.B1_GRUPO
            AND SBM.D_E_L_E_T_ = ' '
        LEFT JOIN SX5010 FAMAT
            ON FAMAT.X5_FILIAL = '      '
            AND FAMAT.X5_TABELA = '02'
            AND FAMAT.X5_CHAVE = B1_TIPO
            AND FAMAT.D_E_L_E_T_ = ' '

    LEFT JOIN SA2010 SA2
        ON SA2.A2_FILIAL = '      '
        AND SA2.A2_COD = SD1.D1_FORNECE
        AND SA2.A2_LOJA = SD1.D1_LOJA
        AND SA2.D_E_L_E_T_ = ' '

        LEFT JOIN SX5010 GRPFOR
            ON GRPFOR.X5_FILIAL = '      '
            AND GRPFOR.X5_TABELA = 'Y7'
            AND GRPFOR.X5_CHAVE = SA2.A2_GRUPO
            AND GRPFOR.D_E_L_E_T_ = ' '
    
    LEFT JOIN CTT010 CTT
        ON CTT.CTT_FILIAL = substring(SD1.D1_FILIAL, 1, 4)
        AND CTT.CTT_CUSTO = SD1.D1_CC
        AND CTT.D_E_L_E_T_ = ' '
    LEFT JOIN CTD010 CTD
        ON CTD.CTD_FILIAL = '      '
        AND CTD.CTD_ITEM = SD1.D1_ITEMCTA
        AND CTD.D_E_L_E_T_ = ' '
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
        LEFT JOIN SE4010 SE4
            ON SE4.E4_FILIAL = '      '
            AND SE4.E4_CODIGO = SF1.F1_COND
            AND SE4.D_E_L_E_T_ = ' '
    
    LEFT JOIN ACV010 ACV
        ON ACV.ACV_FILIAL = substring(SD1.D1_FILIAL, 1, 4)
        AND ACV.ACV_CODPRO = SD1.D1_COD
        AND ACV.D_E_L_E_T_ = ' '
        
        LEFT JOIN ACU010 ACU
            ON ACU.ACU_FILIAL = ACV.ACV_FILIAL
            AND ACU.ACU_COD = ACV.ACV_CATEGO
            AND ACU.D_E_L_E_T_ = ' '
    
    LEFT JOIN SC7010 SC7
        ON SC7.C7_FILIAL = SD1.D1_FILIAL
        AND SC7.C7_NUM = SD1.D1_PEDIDO
        AND SC7.C7_ITEM = SD1.D1_ITEMPC
        AND SC7.C7_PRODUTO = SD1.D1_COD
        AND SC7.D_E_L_E_T_ = ' '

        LEFT JOIN SC1010 SC1
            ON SC1.C1_FILIAL = SC7.C7_FILIAL
            AND SC1.C1_NUM = SC7.C7_NUMSC
            AND SC1.C1_ITEM = SC7.C7_ITEMSC
            AND SC1.C1_PRODUTO = SC7.C7_PRODUTO
            AND SC1.D_E_L_E_T_ = ' '
        left join SY1010 Y1_DIG
            on Y1_DIG.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_DIG.Y1_USER = SC7.C7_USER
            and Y1_DIG.Y1_COD not in (1, 6, 11, 19)
        left join SY1010 Y1_COM
            on Y1_COM.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_COM.Y1_COD = SC7.C7_YNEGOCI
            and Y1_COM.Y1_COD not in (1, 6, 11, 19)
    
    LEFT JOIN SX5010 CFOP
        ON CFOP.X5_FILIAL = '      '
        AND CFOP.X5_TABELA = '13'
        AND CFOP.X5_CHAVE = SD1.D1_CF
        AND CFOP.D_E_L_E_T_ = ' '
    LEFT JOIN SF4010 SF4
        ON SF4.F4_FILIAL = '      '
        AND SF4.F4_CODIGO = SD1.D1_TES
        AND SF4.D_E_L_E_T_ = ' '
    LEFT JOIN SAH010 SAH
        ON SAH.AH_FILIAL = '      '
        AND SAH.AH_UNIMED = SD1.D1_UM
        AND SAH.D_E_L_E_T_ = ' '
WHERE
        SD1.D1_DTDIGIT BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and SD1.D1_ORIGLAN <> 'LF'
    and SD1.D1_TIPO NOT IN ('D', 'B')
    and SD1.D_E_L_E_T_ = ' '
