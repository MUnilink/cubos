    select
        'P |01|01' AS BK_EMPRESA,
        CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
        'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
        concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
        concat(trim(SC6.C6_FILIAL), trim(SC6.C6_NUM)) as ID_PEDIDODEVENDA,
        concat('SD2', trim(SD2.D2_FILIAL), trim(SD2.D2_CLIENTE), trim(SD2.D2_LOJA), trim(SD2.D2_DOC), trim(SD2.D2_SERIE)) as ID_NFS,
        null as ID_NFE,
        null as ID_PEDIDO,
        'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
        'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
        'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6.C6_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
        'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6.C6_CCUSTO, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
        concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
        cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,
        
        trim(ZC2.ZC2_TIPO) as ID_RECURSO,

        case when cast(ZC2.ZC2_TIPO as int) in (1, 4, 11) then 'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC2.ZC2_COD, ' ')), ' '), '|') else null end as COD_SB1,
        null as COD_DA3,
        null as COD_SRJ,
        null as COD_ZA7,
        null as COD_SE1,

        trim(ZC2.ZC2_COD) as INSUMO,
        trim(ZC2.ZC2_ITEM) as ITEM,
        ZC2.ZC2_DATA as COMPETENCIA,
        'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,

        trim(ZC3.ZC3_ITEM) as ITEM_RATEIO,
        ZC3.ZC3_QTD as QTD_RATEIO,
        ZC3.ZC3_PECRAT as PERC_RATEIO,
        
        case when ZC2.ZC2_QTDPRV > 99999999 then 99999999 else ZC2.ZC2_QTDPRV end as QTD_PREV,
        case when ZC2.ZC2_QTDREA > 99999999 then 99999999 else ZC2.ZC2_QTDREA end as QTD_REAL,
        case when ZC2.ZC2_VLUPRV > 99999999 then 99999999 else ZC2.ZC2_VLUPRV end as VAL_PREV,
        case when ZC2.ZC2_VLUREA > 99999999 then 99999999 else ZC2.ZC2_VLUREA end as VAL_REAL,
        cast(ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_TOTAL,
        cast(ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_TOTAL,
        case when ZC2.ZC2_TOTAL > 99999999 then 99999999 else ZC2.ZC2_TOTAL end as VALOR_TOTAL,
        ZC2.ZC2_QTDREC as QTD_RECURSO,
        
        case isdate(ZC2.ZC2_HRINI) when 1 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_APONT,
        case isdate(ZC2.ZC2_HRINI) when 1 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_TOTAIS

    from ZC2010 ZC2 (nolock)
        inner join ZC1010 ZC1
            on ZC1.D_E_L_E_T_ = ''
            and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
            and ZC1.ZC1_NUM = ZC2.ZC2_NUM

            left join SA1010 SA1
                on SA1.D_E_L_E_T_ = ''
                and SA1.A1_COD = ZC1.ZC1_CODSA1
                and SA1.A1_LOJA = ZC1.ZC1_LOJSA1
            left join SA2010 SA2
                on SA2.D_E_L_E_T_ = ''
                and SA2.A2_COD = ZC1.ZC1_DESPA
                and SA2.A2_LOJA = ZC1.ZC1_LJDESP
            left join SED010 SED
                on SED.D_E_L_E_T_ = ''
                and SED.ED_CODIGO = ZC1.ZC1_NATURE
            left join SE4010 SE4
                on SE4.D_E_L_E_T_ = ''
                and SE4.E4_CODIGO = ZC1.ZC1_COND
            left join DA0010 DA0
                on DA0.D_E_L_E_T_ = ''
                and DA0.DA0_CODTAB = ZC1.ZC1_TABPRC
        
        left join SB1010 SB1
            on SB1.D_E_L_E_T_ = ' '
            and SB1.B1_FILIAL = '      '
            and SB1.B1_COD = ZC2.ZC2_COD

            left join SAH010 SAH
                on SAH.D_E_L_E_T_ = ''
                and SAH.AH_UNIMED = SB1.B1_UM
            
        left join ZC3010 ZC3
            on ZC3.D_E_L_E_T_ = ''
            and ZC3.ZC3_FILIAL = ZC2.ZC2_FILIAL
            and ZC3.ZC3_NUM = ZC2.ZC2_NUM
            and ZC3.ZC3_ITEM = ZC2.ZC2_ITEM
        
            left join SC6010 SC6
                on SC6.D_E_L_E_T_ = ''
                and SC6.C6_FILIAL = ZC3.ZC3_FILIAL
                and SC6.C6_NUM = ZC3.ZC3_PEDIDO
                and SC6.C6_YOS = ZC3.ZC3_NUM
                and SC6.C6_YITOS = ZC3.ZC3_ITEM

                left join SD2010 SD2
                    on SD2.D_E_L_E_T_= ' '
                    and SD2.D2_FILIAL = SC6.C6_FILIAL
                    and SD2.D2_PEDIDO = SC6.C6_NUM
                    and SD2.D2_ITEMPV = SC6.C6_ITEM
                left join CTD010 CTD
                    on CTD.CTD_FILIAL = '      '
                    and CTD.CTD_ITEM = SC6.C6_ITEMCTA
                    and CTD.D_E_L_E_T_ = ' '
                left join CTT010 CTT
                    on CTT.D_E_L_E_T_ = ''
                    and CTT.CTT_FILIAL = substring(SC6.C6_FILIAL, 1, 4)
                    and CTT.CTT_CUSTO = SC6.C6_CCUSTO
    where
            cast(ZC2.ZC2_TIPO as int) = 1
        and ZC2.D_E_L_E_T_ = ''
union
    select
        'P |01|01' AS BK_EMPRESA,
        CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
        'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
        concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
        concat(trim(SC6.C6_FILIAL), trim(SC6.C6_NUM)) as ID_PEDIDODEVENDA,
        concat('SD2', trim(SD2.D2_FILIAL), trim(SD2.D2_CLIENTE), trim(SD2.D2_LOJA), trim(SD2.D2_DOC), trim(SD2.D2_SERIE)) as ID_NFS,
        concat('SD1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NFE,
        concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
        'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
        'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
        'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6.C6_ITEMCTA, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
        'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6.C6_CCUSTO, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
        concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
        cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,
        
        case
            when cast(ZC2.ZC2_TIPO as int) = 4 then concat(trim(ZC2.ZC2_TIPO), '-', trim(ZC2.ZC2_COD))
            when cast(ZC2.ZC2_TIPO as int) = 11 then concat(trim(ZC2.ZC2_TIPO), '-', trim(ZC2.ZC2_COD))
            else trim(ZC2.ZC2_TIPO)
        end as ID_RECURSO,

        case when cast(ZC2.ZC2_TIPO as int) in (4, 5, 11) then 'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC2.ZC2_COD, ' ')), ' '), '|') else null end as COD_SB1,
        case when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13) then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13)) else null end as COD_DA3,
        case when cast(ZC2.ZC2_TIPO as int) in (2, 14) then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (2, 14)) else null end as COD_SRJ,
        case cast(ZC2.ZC2_TIPO as int) when 7 then (select concat(trim(ZA7010.ZA7_FILIAL), trim(ZA7010.ZA7_COD)) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7) else null end as COD_ZA7,
        case cast(ZC2.ZC2_TIPO as int) when 8 then ZC2.ZC2_COD else null end as COD_SE1,

        trim(ZC2.ZC2_COD) as INSUMO,
        trim(ZC2.ZC2_ITEM) as ITEM,
        ZC2.ZC2_COMPET as COMPETENCIA,
        'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,

        trim(ZC3.ZC3_ITEM) as ITEM_RATEIO,
        ZC3.ZC3_QTD as QTD_RATEIO,
        ZC3.ZC3_PECRAT as PERC_RATEIO,
        
        case when ZC2.ZC2_QTDPRV > 99999999 then 99999999 else ZC2.ZC2_QTDPRV end as QTD_PREV,
        case when ZC2.ZC2_QTDREA > 99999999 then 99999999 else ZC2.ZC2_QTDREA end as QTD_REAL,
        case when ZC2.ZC2_VLUPRV > 99999999 then 99999999 else ZC2.ZC2_VLUPRV end as VAL_PREV,
        case when ZC2.ZC2_VLUREA > 99999999 then 99999999 else ZC2.ZC2_VLUREA end as VAL_REAL,
        cast(ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_TOTAL,
        cast(ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_TOTAL,
        case when ZC2.ZC2_TOTAL > 99999999 then 99999999 else ZC2.ZC2_TOTAL end as VALOR_TOTAL,
        case when ZC2.ZC2_QTDREC > 99999999 then 99999999 else ZC2.ZC2_QTDREC end as QTD_RECURSO,
        
        case isdate(ZC2.ZC2_HRINI) when 1 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_APONT,
        case isdate(ZC2.ZC2_HRINI) when 1 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_TOTAIS

    from ZC2010 ZC2 (nolock)
        inner join ZC1010 ZC1
            on ZC1.D_E_L_E_T_ = ''
            and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
            and ZC1.ZC1_NUM = ZC2.ZC2_NUM

            left join SA1010 SA1
                on SA1.D_E_L_E_T_ = ''
                and SA1.A1_COD = ZC1.ZC1_CODSA1
                and SA1.A1_LOJA = ZC1.ZC1_LOJSA1
            left join SED010 SED
                on SED.D_E_L_E_T_ = ''
                and SED.ED_CODIGO = ZC1.ZC1_NATURE
            left join SE4010 SE4
                on SE4.D_E_L_E_T_ = ''
                and SE4.E4_CODIGO = ZC1.ZC1_COND
            left join DA0010 DA0
                on DA0.D_E_L_E_T_ = ''
                and DA0.DA0_CODTAB = ZC1.ZC1_TABPRC
        
        left join SB1010 SB1
            on SB1.D_E_L_E_T_ = ' '
            and SB1.B1_FILIAL = '      '
            and SB1.B1_COD = ZC2.ZC2_COD

            left join SAH010 SAH
                on SAH.D_E_L_E_T_ = ''
                and SAH.AH_UNIMED = SB1.B1_UM
            
        left join ZC3010 ZC3
            on ZC3.D_E_L_E_T_ = ''
            and ZC3.ZC3_FILIAL = ZC2.ZC2_FILIAL
            and ZC3.ZC3_NUM = ZC2.ZC2_NUM
            and ZC3.ZC3_ITEM = ZC2.ZC2_ITEM
        
            left join SC6010 SC6
                on SC6.D_E_L_E_T_ = ''
                and SC6.C6_FILIAL = ZC3.ZC3_FILIAL
                and SC6.C6_NUM = ZC3.ZC3_PEDIDO
                and SC6.C6_YOS = ZC3.ZC3_NUM
                and SC6.C6_YITOS = ZC3.ZC3_ITEM

                left join SD2010 SD2
                    on SD2.D_E_L_E_T_= ' '
                    and SD2.D2_FILIAL = SC6.C6_FILIAL
                    and SD2.D2_PEDIDO = SC6.C6_NUM
                    and SD2.D2_ITEMPV = SC6.C6_ITEM
                left join CTD010 CTD
                    on CTD.CTD_FILIAL = '      '
                    and CTD.CTD_ITEM = SC6.C6_ITEMCTA
                    and CTD.D_E_L_E_T_ = ' '
                left join CTT010 CTT
                    on CTT.D_E_L_E_T_ = ''
                    and CTT.CTT_FILIAL = substring(SC6.C6_FILIAL, 1, 4)
                    and CTT.CTT_CUSTO = SC6.C6_CCUSTO
        
        left join SC7010 SC7
            on SC7.D_E_L_E_T_ = ''
            and SC7.C7_FILIAL = ZC2.ZC2_FILIAL
            and case when SC7.C7_YOS = '2024/0' then right(left(SC7.C7_OBS, 63), 11) else nullif(SC7.C7_YOS, '') end = ZC2.ZC2_NUM
            and SC7.C7_YOSIT = ZC2.ZC2_ITEM

            left join SD1010 SD1
                on SD1.D_E_L_E_T_ = ''
                and SD1.D1_FILIAL = SC7.C7_FILIAL
                and SD1.D1_PEDIDO = SC7.C7_NUM
                and SD1.D1_ITEMPC = SC7.C7_ITEM
            left join SA2010 SA2
                on SA2.D_E_L_E_T_ = ''
                and SA2.A2_COD = SC7.C7_FORNECE
                and SA2.A2_LOJA = SC7.C7_LOJA
    where
            ZC2.ZC2_COMPET > '202312'
        and cast(ZC2.ZC2_TIPO as int) != 1
        and ZC2.D_E_L_E_T_ = ''
