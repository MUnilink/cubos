SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SF1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NF,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACAO,
    case when SD1.D1_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SD1.D1_FILIAL as char (6)) end as BK_FILIAL,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_COD, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_FORNECE, ' '))+RTRIM(COALESCE(SD1.D1_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|') AS BK_COMPRADOR,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD1.D1_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
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
    SD1.D1_TOTAL as VALOR_TOTAL,

from SCR010 SCR (nolock)
        on SCR.D_E_L_E_T_ = ''
        and SCR.CR_TIPO = 'PC'
        and SCR.CR_FILIAL = SC7.C7_FILIAL
        and SCR.CR_NUM = SC7.C7_NUM
    LEFT JOIN SB1010 SB1
        ON SB1.B1_FILIAL = '      '
        AND SB1.B1_COD = SD1.D1_COD
        AND SB1.D_E_L_E_T_ = ' '
        
        LEFT JOIN SBM010 SBM
            ON SBM.BM_FILIAL = SB1.B1_FILIAL
            AND SBM.BM_GRUPO = SB1.B1_GRUPO
            AND SBM.D_E_L_E_T_ = ' '

    LEFT JOIN SA2010 SA2
        ON SA2.A2_FILIAL = '      '
        AND SA2.A2_COD = SD1.D1_FORNECE
        AND SA2.A2_LOJA = SD1.D1_LOJA
        AND SA2.D_E_L_E_T_ = ' '
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
    
    inner join SC7010 SC7
        on SC7.C7_FILIAL = SD1.D1_FILIAL
        and SC7.C7_NUM = SD1.D1_PEDIDO
        and SC7.C7_ITEM = SD1.D1_ITEMPC
        and SC7.C7_PRODUTO = SD1.D1_COD
        and SC7.D_E_L_E_T_ = ' '

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
WHERE
        SD1.D1_DTDIGIT BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and SD1.D1_ORIGLAN <> 'LF'
    and SD1.D1_TIPO NOT IN ('D', 'B')
    and SD1.D_E_L_E_T_ = ' '
