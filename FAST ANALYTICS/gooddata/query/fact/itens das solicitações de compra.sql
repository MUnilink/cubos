SELECT
    'P |01|01' AS BK_EMPRESA,
    concat('SD1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NF,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACAO,
    case when SC1.C1_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SC1.C1_FILIAL as char (6)) end as BK_FILIAL,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC1.C1_FORNECE, ' '))+RTRIM(COALESCE(SC1.C1_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC1.C1_PRODUTO, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC1.C1_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC1.C1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|') AS BK_COMPRADOR,
    'P |01|ACU010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACU.ACU_FILIAL, ' '))+'|'+RTRIM(COALESCE(ACU.ACU_COD, ' ')), ' '), '|') AS BK_FAMILIA_COMERCIAL,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SF1.F1_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    case
        when (SC1.C1_QUJE > 0) and (SC1.C1_QUJE < SC1.C1_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('R', ' ')), ' '), '|')
        when (SC1.C1_QUJE >= SC1.C1_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('I', ' ')), ' '), '|')
        else 'P |'+'|'
    end as BK_SITUACAO_COMPRA,
    
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC1.C1_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(SC1.C1_APROV, ' ')), ' '), '|') AS DESCRICAO_APROVCOMPRA,
    concat(Y1_COM.Y1_FILIAL, Y1_COM.Y1_COD) as ID_NEGOCIADOR,

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
    
    SC1.C1_NUM as SC,
    COALESCE(SC1.C1_EMISSAO, ' ') as DATA,
    COALESCE(SC1.C1_DATPRF, ' ') as DTENTR,
    SC7.C7_EMISSAO as PC_DATA,
    SD1.D1_DTDIGIT as NF_DATA,

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
    
    SC1.C1_QUANT as QTD_SOLICITADA,
    SC1.C1_QUJE as QTD_ATENDIDA,
    SC1.C1_PRECO as VALOR_UNITARIO,
    SC1.C1_TOTAL as VALOR_TOTAL,
    trim(SC1.C1_OBS) as OBS_SC

FROM SC1010 SC1
    left join SB1010 SB1
        on SB1.D_E_L_E_T_ = ' '
        and SB1.B1_FILIAL = '      '
        and SB1.B1_COD = SC1.C1_PRODUTO
    left join SA2010 SA2
        on SA2.D_E_L_E_T_ = ' '
        and SA2.A2_FILIAL = '      '
        and SA2.A2_COD = SC1.C1_FORNECE
        and SA2.A2_LOJA = SC1.C1_LOJA
    left join SBM010 SBM
        on SBM.D_E_L_E_T_ = ' '
        and SBM.BM_FILIAL = SB1.B1_FILIAL
        and SBM.BM_GRUPO = SB1.B1_GRUPO
    left join CTT010 CTT
        on CTT.D_E_L_E_T_ = ' '
        and CTT.CTT_FILIAL = SUBSTRING(SC1.C1_FILIAL, 1, 4)
        and CTT.CTT_CUSTO = SC1.C1_CC
    left join ACV010 ACV
        on ACV.D_E_L_E_T_ = ' '
        and ACV.ACV_FILIAL = SUBSTRING(SC1.C1_FILIAL, 1, 4)
        and ACV.ACV_CODPRO = SC1.C1_PRODUTO

        left join ACU010 ACU
            on ACU.D_E_L_E_T_ = ' '
            and ACU.ACU_FILIAL = ACV.ACV_FILIAL
            and ACU.ACU_COD = ACV.ACV_CATEGO
    
    left join CTD010 CTD
        on CTD.D_E_L_E_T_ = ' '
        and CTD.CTD_FILIAL = '      '
        and CTD.CTD_ITEM = SC1.C1_ITEMCTA
    left join SC7010 SC7
        on SC7.D_E_L_E_T_ = ' '
        and SC7.C7_FILIAL = SC1.C1_FILIAL
        and SC7.C7_NUMSC = SC1.C1_NUM
        and SC7.C7_ITEMSC = SC1.C1_ITEM

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
			on SE4.D_E_L_E_T_ = ''
			and SE4.E4_CODIGO = SC7.C7_COND
        left join SY1010 Y1_DIG
            on Y1_DIG.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_DIG.Y1_USER = SC7.C7_USER
            and Y1_DIG.Y1_COD not in (1, 6, 11, 19)
        left join SY1010 Y1_COM
            on Y1_COM.Y1_FILIAL = left(SC7.C7_FILIAL, 2)
            and Y1_COM.Y1_COD = SC7.C7_YNEGOCI
            and Y1_COM.Y1_COD not in (1, 6, 11, 19)
    
    left join SAH010 SAH
        on SAH.D_E_L_E_T_ = ' '
        and SAH.AH_FILIAL = '      '
        and SAH.AH_UNIMED = SC1.C1_UM
    left join SM2010 SM2
        on SM2.D_E_L_E_T_ = ' '
        and SM2.M2_DATA = SC1.C1_EMISSAO
where
        SC1.C1_EMISSAO between <<START_DATE>> and <<FINAL_DATE>>
    and SC1.D_E_L_E_T_ = ' '
