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
        'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6.C6_CC, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,
        concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
        cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,

        case when cast(ZC2.ZC2_TIPO as int) in (1, 4, 11) then 'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC2.ZC2_COD, ' ')), ' '), '|') else null end as COD_SB1,
        null as COD_DA3,
        null as COD_SRJ,
        null as COD_ZA7,
        null as COD_SE1,

        trim(ZC2.ZC2_COD) as INSUMO,
        trim(ZC2.ZC2_ITEM) as ITEM,
        cast(ZC1.ZC1_DTINI as date) as DT_INIOS,
        cast(ZC1.ZC1_DTFIM as date) as DT_FIMOS,
        cast(ZC2.ZC2_DTFIM as date) as DATA_APP,
        concat(left(ZC2.ZC2_COMPET, 6), '01') as COMPETENCIA,
        'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,

        null as ITEM_RATEIO,
        null as QTD_RATEIO,
        null as PERC_RATEIO,
        
        case when abs(ZC2.ZC2_QTDPRV) > 99999999.0 then 99999999.0 else ZC2.ZC2_QTDPRV end as QTD_PREV,
        case when abs(ZC2.ZC2_QTDREA) > 99999999.0 then 99999999.0 else ZC2.ZC2_QTDREA end as QTD_REAL,
        case when abs(ZC2.ZC2_VLUPRV) > 99999999.0 then 99999999.0 else ZC2.ZC2_VLUPRV end as VAL_PREV,
        case when abs(ZC2.ZC2_VLUREA) > 99999999.0 then 99999999.0 else ZC2.ZC2_VLUREA end as VAL_REAL,
        cast(ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_TOTAL,
        cast(ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_TOTAL,
        case when abs(ZC2.ZC2_TOTAL) > 99999999.0 then 99999999.0 else ZC2.ZC2_TOTAL end as VALOR_TOTAL,
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
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_FILIAL = ''
            and SB1.B1_COD = ZC2.ZC2_COD

            left join SAH010 SAH
                on SAH.D_E_L_E_T_ = ''
                and SAH.AH_UNIMED = SB1.B1_UM
        
        left join SC6010 SC6
            on SC6.D_E_L_E_T_ = ''
            and SC6.C6_FILIAL = ZC2.ZC2_FILIAL
            and SC6.C6_YOS = ZC2.ZC2_NUM
            and SC6.C6_YITOS = ZC2.ZC2_ITEM

            left join SD2010 SD2
                on SD2.D_E_L_E_T_= ''
                and SD2.D2_FILIAL = SC6.C6_FILIAL
                and SD2.D2_PEDIDO = SC6.C6_NUM
                and SD2.D2_ITEMPV = SC6.C6_ITEM
            left join CTD010 CTD
                on CTD.CTD_FILIAL = ''
                and CTD.CTD_ITEM = SC6.C6_ITEMCTA
                and CTD.D_E_L_E_T_ = ''
            left join CTT010 CTT
                on CTT.D_E_L_E_T_ = ''
                and CTT.CTT_FILIAL = substring(SC6.C6_FILIAL, 1, 4)
                and CTT.CTT_CUSTO = SC6.C6_CC
            left join SC5010 SC5
                on SC5.C5_FILIAL = SC6.C6_FILIAL
                and SC5.C5_NUM = SC6.C6_NUM
                and SC5.D_E_L_E_T_ = ' '
    where
            SC5.C5_EMISSAO BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
        and cast(ZC2.ZC2_TIPO as int) = 1
        and ZC2.D_E_L_E_T_ = ''
union
    select
        'P |01|01' AS BK_EMPRESA,
        CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
        'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
        concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
        PV.ID_PEDIDODEVENDA,
        PV.ID_NFS,
        concat('SD1', trim(SD1.D1_FILIAL), trim(SD1.D1_FORNECE), trim(SD1.D1_LOJA), trim(SD1.D1_DOC), trim(SD1.D1_SERIE)) as ID_NFE,
        concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
        'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
        'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
        PV.BK_ITEM_CONTABIL,
        PV.BK_CENTRO_DE_CUSTO,
        concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
        cast(ZC2.ZC2_TIPO as int) as ID_TIPO_ITEM,

        case when cast(ZC2.ZC2_TIPO as int) in (4, 5, 11) then 'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(ZC2.ZC2_COD, ' ')), ' '), '|') else null end as COD_SB1,
        case when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13, 16) then (select concat(trim(ST9010.T9_FILIAL), trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13)) else null end as COD_DA3,
        case when cast(ZC2.ZC2_TIPO as int) in (2, 14, 15) then (select concat(trim(SQ3010.Q3_FILIAL), trim(SQ3010.Q3_CARGO)) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and trim(SQ3010.Q3_CARGO) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (2, 14)) else null end as COD_SRJ,
        case cast(ZC2.ZC2_TIPO as int) when 7 then (select concat(trim(ZA7010.ZA7_FILIAL), trim(ZA7010.ZA7_COD)) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7) else null end as COD_ZA7,
        case cast(ZC2.ZC2_TIPO as int) when 8 then ZC2.ZC2_COD else null end as COD_SE1,

        trim(ZC2.ZC2_COD) as INSUMO,
        trim(ZC2.ZC2_ITEM) as ITEM,
        cast(ZC1.ZC1_DTINI as date) as DT_INIOS,
        cast(ZC1.ZC1_DTFIM as date) as DT_FIMOS,
        cast(ZC2.ZC2_DTFIM as date) as DATA_APP,
        concat(left(ZC2.ZC2_COMPET, 6), '01') as COMPETENCIA,
        'P |01|SAH010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SAH.AH_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_UM, ' ')), ' '), '|') AS BK_UNIDADE_DE_MEDIDA,

        null as ITEM_RATEIO,
        PV.QTD as QTD_RATEIO,
        null as PERC_RATEIO,
        
        case when abs(ZC2.ZC2_QTDPRV) > 99999999.0 then 99999999.0 else ZC2.ZC2_QTDPRV end as QTD_PREV,
        case when abs(ZC2.ZC2_QTDREA) > 99999999.0 then 99999999.0 else ZC2.ZC2_QTDREA end as QTD_REAL,
        case when abs(ZC2.ZC2_VLUPRV) > 99999999.0 then 99999999.0 else ZC2.ZC2_VLUPRV end as VAL_PREV,
        case when abs(ZC2.ZC2_VLUREA) > 99999999.0 then 99999999.0 else ZC2.ZC2_VLUREA end as VAL_REAL,
        cast(ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_TOTAL,
        cast(ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_TOTAL,
        case when abs(ZC2.ZC2_TOTAL) > 99999999.0 then 99999999.0 else ZC2.ZC2_TOTAL end as VALOR_TOTAL,
        case when abs(ZC2.ZC2_QTDREC) > 99999999.0 then 99999999.0 else ZC2.ZC2_QTDREC end as QTD_RECURSO,
        
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
        
        left join
        (
            select
                SC6010.C6_FILIAL as FILIAL,
                SC6010.C6_YOS as OS,
                SC6010.C6_YITOS as ITEM_PV,
                concat(trim(SC6010.C6_FILIAL), trim(SC6010.C6_NUM)) as ID_PEDIDODEVENDA,
                concat('SF2', trim(SF2010.F2_FILIAL), trim(SF2010.F2_CLIENTE), trim(SF2010.F2_LOJA), trim(SF2010.F2_DOC), trim(SF2010.F2_SERIE)) as ID_NFS,
                'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD010.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_ITEMCTA, ' ')), ' '), '|') as BK_ITEM_CONTABIL,
                'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT010.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SC6010.C6_CC, ' ')), ' '), '|') as BK_CENTRO_DE_CUSTO,
                1 as QTD
            from SC6010
                left join SD2010
                    on SD2010.D_E_L_E_T_= ''
                    and SD2010.D2_FILIAL = SC6010.C6_FILIAL
                    and SD2010.D2_PEDIDO = SC6010.C6_NUM
                    and SD2010.D2_ITEMPV = SC6010.C6_ITEM
                            
                    left join SF2010
                        on SF2010.D_E_L_E_T_= ' '
                        and SF2010.F2_FILIAL = SD2010.D2_FILIAL
                        and SF2010.F2_CLIENTE = SD2010.D2_CLIENTE
                        and SF2010.F2_LOJA = SD2010.D2_LOJA
                        and SF2010.F2_DOC = SD2010.D2_DOC
                        and SF2010.F2_SERIE = SD2010.D2_SERIE
                
                left join CTD010
                    on CTD010.CTD_FILIAL = ''
                    and CTD010.CTD_ITEM = SC6010.C6_ITEMCTA
                    and CTD010.D_E_L_E_T_ = ''
                left join CTT010
                    on CTT010.D_E_L_E_T_ = ''
                    and CTT010.CTT_FILIAL = substring(SC6010.C6_FILIAL, 1, 4)
                    and CTT010.CTT_CUSTO = SC6010.C6_CC
            where
                    SC6010.D_E_L_E_T_ = ''
        ) PV
            on PV.FILIAL = ZC2.ZC2_FILIAL
            and PV.OS = ZC2.ZC2_NUM
            and PV.ITEM_PV = ZC2.ZC2_ITEM
    where
            concat(left(ZC2.ZC2_COMPET, 6), '01') BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
        and concat(left(ZC2.ZC2_COMPET, 6), '01') > '20231201'
        and cast(ZC2.ZC2_TIPO as int) != 1
        and ZC2.D_E_L_E_T_ = ''
