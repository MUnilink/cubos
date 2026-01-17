SELECT
    'P |01|01' AS BK_EMPRESA,
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACAO,
    case when SC7.C7_FILIAL is null then 'P |01||' else 'P |01|01'+ CAST(SC7.C7_FILIAL as char (6)) end as BK_FILIAL,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_FORNECE, ' '))+RTRIM(COALESCE(SC7.C7_LOJA, ' ')), ' '), '|') AS BK_FORNECEDOR,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_PRODUTO, ' ')), ' '), '|') AS BK_ITEM,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_COND, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
    'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,
    'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|') AS BK_COMPRADOR,
    'P |01|SF4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SF4.F4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_TES, ' ')), ' '), '|') AS BK_TES,
    'P |01|ACU010|'+ COALESCE(NULLIF(RTRIM(COALESCE(ACU.ACU_FILIAL, ' '))+'|'+RTRIM(COALESCE(ACU.ACU_COD, ' ')), ' '), '|') AS BK_FAMILIA_COMERCIAL,
    'P |01|CT1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_CONTA, ' ')), ' '), '|') AS BK_CONTA,
    
    case when Y1_COM.Y1_COD is null or Y1_COM.Y1_COD = ''
        then 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_DIG.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_DIG.Y1_COD, ' ')), ' '), '|')
        else 'P |01|SY1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(Y1_COM.Y1_FILIAL, ' '))+'|'+RTRIM(COALESCE(Y1_COM.Y1_COD, ' ')), ' '), '|')
    end as ID_NEGOCIADOR,
    
    COALESCE(NULLIF(RTRIM(COALESCE(SAK010.AK_FILIAL, ' '))+'|'+RTRIM(COALESCE(SAK010.AK_COD, ' ')), ' '), '|') as BK_APROVADOR,
    trim(CRPC.CR_NIVEL) as NIVEL,
    
    case when SA2.A2_COD_MUN = ' ' then 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' ')), ' '), '|') else 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_EST, ' '))+RTRIM(COALESCE(SA2.A2_COD_MUN, ' ')), ' '), '|') end as BK_REGIAO,
    case
        when (SC7.C7_QUJE > 0) and (SC7.C7_QUJE < SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('R', ' ')), ' '), '|')
        when (SC7.C7_QUJE >= SC7.C7_QUANT) then 'P |'+ COALESCE(NULLIF(RTRIM(COALESCE('I', ' ')), ' '), '|')
        else 'P |'+'|'
    end as BK_SITUACAO_COMPRA,
    
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC7.C7_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SBM.BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(SC7.C7_CONAPRO, ' ')), ' '), '|') AS DESCRICAO_APROVCOMPRA,
    
    /* OBSOLETO */ SC7.C7_NUM PEDIDO,
    COALESCE(SC7.C7_EMISSAO, ' ') AS DATA_EMISSAO,
    COALESCE(SC7.C7_DATPRF, ' ') AS DTENTR,
    COALESCE(SC1.C1_EMISSAO, ' ') AS DTEORD, /* data SC */

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
    convert(datetime, concat(CRPC.CR_DATALIB, ' ', CRPC.CR_YHRLIB), 113) as DATAAPROV_PC, /* data aprovação PC */
    
    1 as QORDCP, /* qtd de SCs */
    SC7.C7_QUANT as QTD_SOLICITADA,
    SC7.C7_QUJE as QTD_ATENDIDA,
    SC7.C7_PRECO as VALOR_UNITARIO,
    SC7.C7_TOTAL as VALOR_TOTAL,

    cast(SC7.C7_VALICM as numeric(14, 2)) as VL_PC_ICMS,
    cast(SC7.C7_VALIPI as numeric(14, 2)) as VL_PC_IPI,
    cast(SC7.C7_VALFRE as numeric(14, 2)) as VL_PC_FRETE_NF,
    cast(SC7.C7_DESPESA as numeric(14, 2)) as VL_PC_DESPESA,
    cast(SC7.C7_VALIMP6 as numeric(14, 2)) as VL_PC_PIS,
    cast(SC7.C7_VALIMP5 as numeric(14, 2)) as VL_PC_COFINS,
    cast(SC7.C7_VALISS as numeric(14, 2)) as VL_PC_ISS,
    cast(SC7.C7_ICMSRET as numeric(14, 2)) as VL_PC_ICMS_SUBST,
    cast(SC7.C7_VLDESC as numeric(12, 2)) as VL_PC_DESCONTO,
    cast(SC7.C7_VALINS as numeric(14, 2)) as VL_PC_INSS,
	cast(SC7.C7_SEGURO as numeric(14, 2)) as VL_PC_SEGURO

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
        and CTT.CTT_FILIAL = SUBSTRING(SC7.C7_FILIAL, 1, 4)
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
    left join SC1010 SC1
        on SC1.D_E_L_E_T_ = ' '
        and SC1.C1_FILIAL = SC7.C7_FILIAL
        and SC1.C1_NUM = SC7.C7_NUMSC
        and SC1.C1_ITEM = SC7.C7_ITEMSC
    left join SAH010 SAH
        on SAH.D_E_L_E_T_ = ' '
        and SAH.AH_FILIAL = '      '
        and SAH.AH_UNIMED = SC7.C7_UM
    left join SM2010 SM2
        on SM2.D_E_L_E_T_ = ' '
        and SM2.M2_DATA = SC7.C7_EMISSAO
    
    left join SCR010 CRPC
        on CRPC.D_E_L_E_T_ = ''
        and CRPC.CR_TIPO = 'PC'
        and CRPC.CR_FILIAL = SC7.C7_FILIAL
        and CRPC.CR_NUM = SC7.C7_NUM
        
        inner join SAK010
            on SAK010.D_E_L_E_T_ = ''
            and SAK010.AK_COD = CRPC.CR_LIBAPRO
WHERE
        SC7.C7_EMISSAO BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    AND SC7.D_E_L_E_T_ = ' '
