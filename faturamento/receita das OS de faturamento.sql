select
    ZC1.ZC1_FILIAL as FILIAL,
    concat(trim(ZC1.ZC1_NUM), trim(ZC2.ZC2_ITEM)) as ID_OS,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    ZC2.ZC2_FILORI as FILORI,
    ZC2.ZC2_ITEM as ITEM,
    substring(ZC1.ZC1_NUM, 1, 4) as ANO_OS,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    convert(date, ZC1.ZC1_EMISSA, 103) as DATA_OS,
    substring(ZC2.ZC2_COMPET, 1, 6) as PERIODO,

    convert(
        datetime,
        case isdate(concat(substring(ZC1.ZC1_HRINI, 1, 2), ':', substring(ZC1.ZC1_HRINI, 3, 2)))
            when 1 then concat(ZC1.ZC1_DTINI, ' ', isnull(nullif(trim(concat(substring(ZC1.ZC1_HRINI, 1, 2), ':', substring(ZC1.ZC1_HRINI, 3, 2), ':', '00')), ':  :00'), '00:00'))
            else concat(ZC1.ZC1_DTINI, ' ', '12:00')
        end, 113
    ) as DTINI_OS,
    
    convert(
        datetime,
        case isdate(concat(substring(ZC1.ZC1_HRFIM, 1, 2), ':', substring(ZC1.ZC1_HRFIM, 3, 2)))
            when 1 then concat(ZC1.ZC1_DTFIM, ' ', isnull(nullif(trim(concat(substring(ZC1.ZC1_HRFIM, 1, 2), ':', substring(ZC1.ZC1_HRFIM, 3, 2), ':', '00')), ':  :00'), '00:00'))
            else concat(ZC1.ZC1_DTFIM, ' ', '12:00')
        end, 113
    ) as DTFIM_OS,
    
    ZC1.ZC1_PORTO as PORTO,
    (select trim(SX5010.X5_DESCRI) from SX5010 where SX5010.D_E_L_E_T_ = '' and SX5010.X5_TABELA = '_1' and SX5010.X5_CHAVE = ZC1.ZC1_PORTO) as DESC_PORTO,
    ZC1.ZC1_NAVIO as NAVIO,
    (select trim(ZA3010.ZA3_DESC) from ZA3010 where ZA3010.D_E_L_E_T_ = '' and ZA3010.ZA3_COD = ZC1.ZC1_NAVIO) as DESC_NAVIO,
    trim(ZC1.ZC1_VIAGEM) as VIAGEM_PORT,
    
    case ZC2.ZC2_TIPO
        when 1 then 'RECEITA'
        when 2 then 'FUNÇÃO'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO E TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'TAXAS CIPP'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        else 'OUTROS'
    end as TIPO_INSUMO,
    
    case cast(ZC2.ZC2_TIPO as int)
        when 2 then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 2)
        when 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7)
        when 8 then null
    else
        case
            when cast(ZC2.ZC2_TIPO as int) in (1, 4, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (1, 4, 11))
            when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13))
        else null end
    end as DESC_RECURSO,

    case when cast(ZC2.ZC2_TIPO as int) in (1, 4, 5, 11) then (select max(trim(SAH010.AH_DESCPO)) from SB1010 (nolock) inner join SAH010 (nolock) on SAH010.D_E_L_E_T_ = '' and SAH010.AH_UNIMED = SB1010.B1_UM where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (1, 4, 5, 11))
        when cast(ZC2.ZC2_TIPO as int) in (7) then 'q'
        else 'h'
    end as UN,

    DEV.A1_COD as CLI_CODIGO,
    DEV.A1_LOJA as CLI_LOJA,
    DEV.A1_CGC as CLI_CNPJ,
    trim(DEV.A1_NOME) as CLIENTE,

    ARM.A1_COD as ARM_CODIGO,
    ARM.A1_LOJA as ARM_LOJA,
    ARM.A1_CGC as ARM_CNPJ,
    trim(DEV.A1_NOME) as ARMADORA,

    DES.A2_COD as DESP_CODIGO,
    DES.A2_LOJA as DESP_LOJA,
    DES.A2_CGC as DESP_CNPJ,
    trim(DES.A2_NOME) as DESPACHANTE,
    
    ZC2.ZC2_INCLUS as TIPO_INCLUSAO,
    ZC1.ZC1_TABPRC as TABELADEPRECO,
    (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC1.ZC1_TABPRC) as TABELA_PRECO,

    trim(ZC2.ZC2_COD) as INSUMO,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 2 then 'SOLICITADO CANCELAMENTO'
        when 3 then 'CANCELADA'
        when 1 then 'ABERTA'
        when 6 then 'ENCERRADA'
        when 9 then 'PEDIDO CRIADO'
        else 'OUTROS'
    end as STATUS_OS,
    
    case ZC1.ZC1_STATU2
        when 1 then 'PENDENTE'
        when 2 then 'PARCIAL'
        when 3 then 'FINALIZADO'
        else 'OUTROS'
    end as STATUS_PEDIDO,
    
    cast(ZC2.ZC2_QTDPRV as numeric(15, 2)) as QTD_PREV_ITEM,
    cast(ZC2.ZC2_QTDREA as numeric(15, 2)) as QTD_REAL_ITEM,
    cast(ZC2.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_ITEM,
    cast(ZC2.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_ITEM,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    cast(ZC2.ZC2_QTDPRV * ZC2.ZC2_VLUPRV as numeric(15, 2)) as VAL_PREV_TOTAL,
    cast(ZC2.ZC2_QTDREA * ZC2.ZC2_VLUREA as numeric(15, 2)) as VAL_REAL_TOTAL,

    case isdate(ZC2.ZC2_HRINI) when 1 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORA_UNIT_ITEM,
	case isdate(ZC2.ZC2_HRINI) when 1 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_PROD,
    
    lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_ITEM) as ITEM_ANT,
    case when cast(ZC2.ZC2_TIPO as int) in (2, 3) and lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_ITEM) is null then ((select ZC7010.ZC7_HRPAD from ZC7010 where ZC7010.ZC7_CC = 305 and ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.ZC2_COD and ZC7010.ZC7_COMPET = substring(ZC2.ZC2_COMPET, 1, 6))) else 0.0 end as HORA_PAD,
    case when cast(ZC2.ZC2_TIPO as int) in (2, 3) and lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_ITEM) is null then ((select ZC7010.ZC7_HRIMPR from ZC7010 where ZC7010.ZC7_CC = 305 and ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.ZC2_COD and ZC7010.ZC7_COMPET = substring(ZC2.ZC2_COMPET, 1, 6))) else 0.0 end as HORAS_IMPR,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,

    convert(date, ZC2.ZC2_DTINI, 103) as DATA_INIAPONT,
    convert(date, ZC2.ZC2_DTFIM, 103) as DATA_FIMAPONT,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO,

    SC6.C6_NUM as PEDIDO,
    SC6.C6_ITEM as ITEM_PEDIDO,
    SC6.C6_UM as UN_PEDIDO,
    SC6.C6_QTDVEN as QTD_PEDIDO,
    SC6.C6_PRCVEN as PRECO_PEDIDO,
    SC6.C6_VALOR as VALOR_PEDIDO,
    SC6.C6_CC as CC_PEDIDO,
    SC6.C6_ITEMCTA as ATIVIDADE_PEDIDO,

    convert(date, SD2.D2_EMISSAO, 103) as DATA_NF,
    substring(SD2.D2_EMISSAO, 1, 6) PERIODO_NF,

    SD2.D2_DOC as NF_DOC,
    SD2.D2_SERIE as NF_SERIE,
    SD2.D2_LOCAL as ARMAZEM,
    SD2.D2_TES as TM,
    SD2.D2_CF as CF,

    CAST(COALESCE(SD2.D2_VALBRUT, 0) AS DECIMAL(14, 2)) AS VL_FATURAMENTO_TOTAL,
    CAST(COALESCE(SD2.D2_VALICM, 0) AS DECIMAL(14, 2)) AS VL_ICMS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIPI, 0) AS DECIMAL(14, 2)) AS VL_IPI_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALFRE, 0) AS DECIMAL(14, 2)) AS VL_FRETE_NF,
    CAST(COALESCE(SD2.D2_DESPESA, 0) AS DECIMAL(14, 2)) AS VL_DESPESA,
    CAST(COALESCE(SD2.D2_TOTAL, 0) AS DECIMAL(14, 2)) AS VL_FATURAMENTO_MERCADORIA,
    CAST(COALESCE(SD2.D2_VALIMP6, 0) AS DECIMAL(14, 2)) AS VL_PIS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIMP5, 0) AS DECIMAL(14, 2)) AS VL_COFINS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_QUANT, 0) AS DECIMAL(13, 3)) AS QTD_FATURADA_ITEM,
    CAST(COALESCE(SD2.D2_VALISS, 0) AS DECIMAL(14, 2)) AS VL_ISS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_ICMSRET, 0) AS DECIMAL(14, 2)) AS VL_ICMS_SUBST_FATURAMENTO,
    CAST(COALESCE(SD2.D2_DESCON, 0) AS DECIMAL(12, 2)) AS VL_DESCONTO_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALIRRF, 0) AS DECIMAL(14, 2)) AS VL_IRF_FATURAMENTO,
    CAST(COALESCE(SD2.D2_VALINS, 0) AS DECIMAL(14, 2)) AS VL_INSS_FATURAMENTO,
    CAST(COALESCE(SD2.D2_PESO * SD2.D2_QUANT, 0) AS DECIMAL(12, 4)) AS PESO_LIQUIDO,
    CAST(COALESCE(SD2.D2_PRUNIT, 0) AS DECIMAL(16, 4)) AS VL_UNITARIO,
    CAST(COALESCE(SD2.D2_SEGURO, 0) AS DECIMAL(14, 2)) AS VL_SEGURO,

    (select sum(SD3010.D3_CUSTO1) from SD3010 (nolock) where SD3010.D_E_L_E_T_ = '' and SD3010.D3_FILIAL = ZC2.ZC2_FILIAL and SD3010.D3_YOS = ZC2.ZC2_NUM and SD3010.D3_COD = ZC2.ZC2_COD and eomonth(SD3010.D3_EMISSAO) = ZC2.ZC2_COMPET and SD3010.D3_ESTORNO = '' and ZC2.ZC2_TIPO = 4) as ESTOQUE,
    (select sum(SD1010.D1_CUSTO) from SD1010 (nolock) where SD1010.D_E_L_E_T_ = '' and SD1010.D1_FILIAL = ZC2.ZC2_FILIAL and SD1010.D1_YOS = ZC2.ZC2_NUM and SD1010.D1_COD = ZC2.ZC2_COD and eomonth(SD1010.D1_DTDIGIT) = ZC2.ZC2_COMPET and cast(ZC2.ZC2_TIPO as int) in (5, 11)) as COMPRAS_TAXAS,
    
    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_ITEM) is null then
    (
        select sum(STL010.TL_CUSTO)
        from STJ010 (nolock)
            left join STL010 (nolock)
                on STL010.D_E_L_E_T_ = ''
                and STL010.TL_FILIAL = STJ010.TJ_FILIAL
                and STL010.TL_PLANO = STJ010.TJ_PLANO
                and STL010.TL_ORDEM = STJ010.TJ_ORDEM
        where
                STJ010.D_E_L_E_T_ = ''
            and STJ010.TJ_CODBEM = ZC2.ZC2_COD
            and eomonth(STL010.TL_DTFIM) = ZC2.ZC2_COMPET
            and STL010.TL_SEQRELA > 0
            and ZC2.ZC2_TIPO = 3
    ) else 0.0 end as MANUTENCAO,
    
    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_ITEM) is null then
    (
        select sum(SN4010.N4_VLROC1)
        from SN4010 (nolock)
            inner join SN3010 (nolock)
                on SN3010.D_E_L_E_T_ = ''
                and SN3010.N3_CBASE = SN4010.N4_CBASE
                and SN3010.N3_ITEM = SN4010.N4_ITEM

                inner join SN1010 (nolock)
                    on SN1010.D_E_L_E_T_ = ''
                    and SN1010.N1_CBASE = SN3010.N3_CBASE
                    and SN1010.N1_ITEM = SN3010.N3_ITEM
        where
                SN4010.D_E_L_E_T_ = ''
            and SN1010.N1_CODBEM = ZC2.ZC2_COD
            and eomonth(SN4010.N4_DATA) = ZC2.ZC2_COMPET
            and SN4010.N4_OCORR = 6
            and SN4010.N4_TIPOCNT = 3
            and ZC2.ZC2_TIPO = 6
    ) else 0.0 end as DEPRECIACAO,

    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_ITEM) is null then
    (
        select sum(TS1010.TS1_VALOR)/12
        from TS1010 (nolock)
        inner join
        (
            select
                TS1010.TS1_CODBEM,
                TS1010.TS1_DOCTO,
                max(TS1010.TS1_DTVENC) as TS1_DTVENC
            from TS1010 (nolock)
            where
                    TS1010.D_E_L_E_T_ = ''
                and TS1010.TS1_DOCTO in (1, 2, 3, 7)
            group by
                TS1010.TS1_CODBEM,
                TS1010.TS1_DOCTO
        ) TS1
            on TS1010.D_E_L_E_T_ = ''
            and TS1.TS1_DOCTO = TS1010.TS1_DOCTO
            and TS1.TS1_CODBEM = TS1010.TS1_CODBEM
            and TS1.TS1_DTVENC = TS1010.TS1_DTVENC
        where
                ZC2.ZC2_TIPO = 9
            and TS1010.TS1_CODBEM = ZC2.ZC2_COD
    ) else 0.0 end as DOCUMENTACAO,
    
    (
        select sum(case when CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2)) else case when CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2))*-1 else 0.0 end end)
        from CT2010 (nolock)
            inner join ZA8010 (nolock)
                on ZA8010.D_E_L_E_T_ = ''
                and (CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM or CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM)
                and (CT2010.CT2_ITEMD between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM or CT2010.CT2_ITEMC between ZA8010.ZA8_CTDINI and ZA8010.ZA8_CTDFIM)
                and (CT2010.CT2_CCD between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM or CT2010.CT2_CCC between ZA8010.ZA8_CTTINI and ZA8010.ZA8_CTTFIM)

                inner join ZA7010 (nolock)
                    on ZA7010.D_E_L_E_T_ = ''
                    and ZA7010.ZA7_COD = ZA8010.ZA8_COD
        where
                CT2010.D_E_L_E_T_ = ''
            and ZA7010.ZA7_COD = ZC2.ZC2_COD
            and eomonth(CT2010.CT2_DATA) = ZC2.ZC2_COMPET
            and ZC2.ZC2_TIPO = 7
    ) as CONTABILIDADE,
    
    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_NUM, ZC2.ZC2_ITEM) is null then
    (
        select sum(ZC4010.ZC4_VLSEG)/sum(ZC4.diff)
        from ZC4010 (nolock)
            inner join
                (
                    select
                        datediff(day, ZC4010.ZC4_DTVGIN, ZC4010.ZC4_DTVGFI)/30.0 as diff,
                        ZC4010.ZC4_CODBEM,
                        ZC4010.ZC4_DTVGIN,
                        ZC4010.ZC4_DTVGFI
                    from ZC4010 (nolock)
                    where
                            ZC4010.D_E_L_E_T_ = ''
                ) ZC4
                    on ZC4010.ZC4_CODBEM = ZC4.ZC4_CODBEM
                    and ZC4010.ZC4_DTVGIN = ZC4.ZC4_DTVGIN
                    and ZC4010.ZC4_DTVGFI = ZC4.ZC4_DTVGFI
        where
                ZC4010.D_E_L_E_T_ = ''
            and ZC2.ZC2_TIPO = 12
            and ZC2.ZC2_COD = ZC4010.ZC4_CODBEM
            
            and ZC2.ZC2_COMPET between ZC4.ZC4_DTVGIN and ZC4.ZC4_DTVGFI
    ) else 0.0 end as SEGURO

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
        
        left join SA1010 DEV (nolock)
            on DEV.D_E_L_E_T_ = ''
            and DEV.A1_COD = ZC1.ZC1_CODSA1
            and DEV.A1_LOJA = ZC1.ZC1_LOJSA1
        left join SA1010 ARM (nolock)
            on ARM.D_E_L_E_T_ = ''
            and ARM.A1_COD = ZC1.ZC1_ARMADO
            and ARM.A1_LOJA = ZC1.ZC1_LJARMA
        left join SA2010 DES (nolock)
            on DES.D_E_L_E_T_ = ''
            and DES.A2_COD = ZC1.ZC1_DESPA
            and DES.A2_LOJA = ZC1.ZC1_LJDESP

    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)
    left join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = trim(ZC2.ZC2_COD)
    left join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
    
    left join SC6010 SC6 (nolock)
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = ZC2.ZC2_FILIAL
        and SC6.C6_YOS = ZC2.ZC2_NUM
        and SC6.C6_YITOS = ZC2.ZC2_ITEM

        left join SC5010 SC5 (nolock)
            on SC5.D_E_L_E_T_ = ' '
            and SC5.C5_FILIAL = SC6.C6_FILIAL
            and SC5.C5_NUM = SC6.C6_NUM
                
        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_FILIAL = SC6.C6_FILIAL
            and SD2.D2_PEDIDO = SC6.C6_NUM
            and SD2.D2_ITEMPV = SC6.C6_ITEM
where
        ZC2.D_E_L_E_T_ = ''
    and substring(ZC1.ZC1_EMISSA, 1, 6) > 202309
