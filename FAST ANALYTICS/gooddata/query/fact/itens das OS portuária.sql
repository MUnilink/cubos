select
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
    concat(trim(SC5.C5_FILIAL), trim(SC5.C5_NUM)) as ID_PEDIDODEVENDA,
    concat('SF2', trim(SF2.F2_FILIAL), trim(SF2.F2_CLIENTE), trim(SF2.F2_LOJA), trim(SF2.F2_DOC), trim(SF2.F2_SERIE)) as ID_NF,
    'P |01|SED010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SED.ED_FILIAL, ' '))+'|'+RTRIM(COALESCE(SED.ED_CODIGO, ' ')), ' '), '|') AS BK_NAT_FINANCEIRA,
    'P |01|SE4010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SE4.E4_FILIAL, ' '))+'|'+RTRIM(COALESCE(SE4.E4_CODIGO, ' ')), ' '), '|') AS BK_CONDICAO_DE_PAGAMENTO,
    concat(trim(DA0.DA0_FILIAL), trim(DA0.DA0_CODTAB)) as ID_TABELA_PRECO,
    ZC2.ZC2_TIPO as ID_TIPO_ITEM,

    case when ZC2.ZC2_TIPO in (1, 4, 11) then ZC2.ZC2_COD else null end as COD_SB1,
    case when ZC2.ZC2_TIPO in (3, 6, 9, 10, 12, 13) then ZC2.ZC2_COD else null end as COD_DA3,
    case ZC2.ZC2_TIPO when 2 then ZC2.ZC2_COD else null end as COD_SRJ,
    case ZC2.ZC2_TIPO when 7 then ZC2.ZC2_COD else null end as COD_ZA7,
    case ZC2.ZC2_TIPO when 8 then ZC2.ZC2_COD else null end as COD_SE1,

    trim(ZC2.ZC2_COD) as INSUMO,
    trim(ZC2.ZC2_ITEM) as ITEM,
    ZC2.ZC2_COMPET as COMPETENCIA,

    trim(ZC3.ZC3_ITEM) as ITEM_RATEIO,
    ZC3.ZC3_QTD as QTD_RATEIO,
    ZC3.ZC3_PECRAT as PERC_RATEIO,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    case isdate(ZC2.ZC2_HRINI) when 1 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_APONT,
	case isdate(ZC2.ZC2_HRINI) when 1 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_TOTAIS

from ZC2010 ZC2
    inner join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        
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
        
    inner join ZC3010 ZC3
        on ZC3.D_E_L_E_T_ = ''
        and ZC3.ZC3_FILIAL = ZC2.ZC2_FILIAL
        and ZC3.ZC3_NUM = ZC2.ZC2_NUM
        and ZC3.ZC3_ITEM = ZC2.ZC2_ITEM
        
        left join SA1010 SA1
            on SA1.D_E_L_E_T_ = ''
            and SA1.A1_COD = ZC3.ZC3_CODSA1
            and SA1.A1_LOJA = ZC3.ZC3_LOJSA1
    
        left join SC5010 SC5
            on SC5.D_E_L_E_T_ = ''
            and SC5.C5_FILIAL = ZC3.ZC3_FILIAL
            and SC5.C5_NUM = ZC3.ZC3_PEDIDO
            and SC5.C5_YOS = ZC3.ZC3_NUM

            left join SC6010 SC6
                on SC6.D_E_L_E_T_ = ''
                and SC6.C6_FILIAL = SC5.C5_FILIAL
                and SC6.C6_NUM = SC5.C5_NUM

            left join SD2010 SD2
                on SD2.D_E_L_E_T_ = ''
                and SD2.D2_FILIAL = SC5.C5_FILIAL
                and SD2.D2_PEDIDO = SC5.C5_NUM

                left join SF2010 SF2
                    on SF2.D_E_L_E_T_= ' '
                    and SF2.F2_FILIAL = SD2.D2_FILIAL
                    and SF2.F2_CLIENTE = SD2.D2_CLIENTE
                    and SF2.F2_LOJA = SD2.D2_LOJA
                    and SF2.F2_DOC = SD2.D2_DOC
                    and SF2.F2_SERIE = SD2.D2_SERIE
where
        ZC2.ZC2_COMPET BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and ZC2.D_E_L_E_T_ = ''
