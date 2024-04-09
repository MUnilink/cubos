select
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN ZC1.ZC1_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(ZC1.ZC1_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
    'P |01|SA2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA2.A2_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA2.A2_COD, ' '))+RTRIM(COALESCE(SA2.A2_LOJA, ' ')), ' '), '|') as BK_FORNECEDOR,
    concat(trim(ZC1.ZC1_FILIAL), trim(ZC1.ZC1_NUM)) as ID_OSPORTUARIA,
    concat(trim(SC5.C5_FILIAL), trim(SC5.C5_NUM)) as ID_PEDIDODEVENDA,
    concat('SF2', trim(SF2.F2_FILIAL), trim(SF2.F2_CLIENTE), trim(SF2.F2_LOJA), trim(SF2.F2_DOC), trim(SF2.F2_SERIE)) as ID_NF,

    ZC1.ZC1_EMISSA as DATA_OS,
    ZC1.ZC1_TABPRC as TABELA_PRECO,
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,
    trim(ZC2.ZC2_COD) as INSUMO,
    
    case ZC2.ZC2_TIPO
        /* SB1 */ when 1 then 'RECEITA'
        /* SRJ */ when 2 then 'FUNÇÃO'
        /* ST9 */ when 3 then 'EQUIPAMENTO'
        /* SB1 */ when 4 then 'MATERIAIS'
        /* ST9 */ when 6 then 'DEPRECIAÇÃO'
        /* ZA7 */ when 7 then 'CONTABILIDADE'
        /*  */ when 8 then 'DESPESAS FINANCEIRAS'
        /* TS0 */ when 9 then 'DOCUMENTAÇÃO E TAXAS'
        /* ST9 */ when 10 then 'COMBUSTIVEL'
        /* SB1 */ when 11 then 'TAXAS'
        /* ST9 */ when 12 then 'SEGURO'
        /* ST9 */ when 13 then 'PNEUS'
        else 'OUTROS'
    end as TIPO_INSUMO,

    trim(ZC3.ZC3_ITEM) as ITEM_RATEIO,
    ZC3.ZC3_QTD as QTD_RATEIO,
    ZC3.ZC3_PECRAT as PERC_RATEIO,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_VLUPRV as VAL_PREV,
    ZC2.ZC2_VLUREA as VAL_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as HORAS_APONT,
    cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) as HORAS_TOTAIS,

    /**/
    substring(ZC2.ZC2_DTFIM, 1, 6) as PERIODO_APONT,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    SC6.C6_NUM as PEDIDO,
    cast(SC6.C6_ITEM as int) as ITEM_PEDIDO,
    trim(SC6.C6_UM) as UN_PEDIDO,
    SC6.C6_QTDVEN as QTD_PEDIDO,
    trim(SC6.C6_CC) as CC_PEDIDO,
    trim(SC6.C6_ITEMCTA) as ATIVIDADE_PEDIDO,
    
    case ZC2.ZC2_TIPO
        when 1 then (select case when SB1010.B1_DESC like 'TRANSPORTE PORTUARIO - %' then replace(trim(SB1010.B1_DESC), 'TRANSPORTE PORTUARIO - ', '') else trim(SB1010.B1_DESC) end from DA1010 (nolock) inner join SB1010 (nolock) on SB1010.D_E_L_E_T_ = '' and SB1010.B1_COD like '21%' and SB1010.B1_COD = DA1010.DA1_CODPRO where DA1010.D_E_L_E_T_ = '' and DA1010.DA1_CODTAB = ZC1.ZC1_TABPRC and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 1)
        when 2 then (select trim(SRJ010.RJ_DESC) from SRJ010 (nolock) where SRJ010.D_E_L_E_T_ = '' and SRJ010.RJ_FUNCAO = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 2)
        when 3 then trim(ST9.T9_CODBEM)
        when 4 then (select trim(SB1010.B1_DESC) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and ZC2.ZC2_TIPO = 4)
        when 6 then trim(ST9.T9_CODBEM)
        when 7 then trim(ZA7.ZA7_DESC)
        else trim(ZC2.ZC2_DESC)
    end as DESC_INSUMO

from ZC2010 ZC2
    left join ZC1010 ZC1
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        and substring(ZC1.ZC1_NUM, 1, 4) > 2022
        
        left join SA2010 SA2
            on SA2.D_E_L_E_T_ = ''
            and SA2.A2_COD = ZC1.ZC1_DESPA
            and SA2.A2_LOJA = ZC1.ZC1_LJDESP
        
        left join ZC3010 ZC3
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

    left join ST9010 ST9
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)
    left join ZA7010 ZA7
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = trim(ZC2.ZC2_COD)
    left join DA4010 DA4
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
where
        ZC2.D_E_L_E_T_ = ''
    and nullif(nullif(ZC2.ZC2_DTINI, ''), '  :  ') is not null
	and nullif(nullif(ZC2.ZC2_HRINI, ''), '  :  ') is not null
	and nullif(nullif(ZC2.ZC2_DTFIM, ''), '  :  ') is not null
	and nullif(nullif(ZC2.ZC2_HRFIM, ''), '  :  ') is not null
