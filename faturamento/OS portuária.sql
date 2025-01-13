select
    ZC1.ZC1_FILIAL as FILIAL,
    concat(trim(ZC1.ZC1_NUM), trim(ZC2.ZC2_ITEM)) as ID_OS,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    ZC2.ZC2_ITEM as ITEM,
    substring(ZC1.ZC1_NUM, 1, 4) as ANO_OS,
    substring(ZC1.ZC1_EMISSA, 1, 6) as PERIODO_OS,
    cast(ZC1.ZC1_EMISSA as date) as DATA_OS,
    
    convert
    (
        datetime,
        case isdate(concat(substring(ZC1.ZC1_HRINI, 1, 2), ':', substring(ZC1.ZC1_HRINI, 3, 2)))
            when 1 then concat(ZC1.ZC1_DTINI, ' ', isnull(nullif(trim(concat(substring(ZC1.ZC1_HRINI, 1, 2), ':', substring(ZC1.ZC1_HRINI, 3, 2), ':', '00')), ':  :00'), '00:00'))
            else concat(ZC1.ZC1_DTINI, ' ', '12:00')
        end, 113
    ) as DTINI_OS,
    
    convert
    (
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
    
    case cast(ZC2.ZC2_TIPO as int)
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'OUTROS CUSTOS - TAXAS'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO'
        when 13 then 'PNEUS'
        when 14 then 'PROVISÕES'
        when 15 then 'TIPO RH IMPROD'
        when 16 then 'TIPO MNT IMPROD'
        else 'OUTROS'
    end as TIPO_INSUMO,

    trim(ZC2.ZC2_COD) as INSUMO,
    
    case cast(ZC2.ZC2_TIPO as int)
        when 2 then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 2)
        when 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 7)
        when 8 then null
    else
        case
            when cast(ZC2.ZC2_TIPO as int) in (1, 4, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (1, 4, 11))
            when cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) in (3, 6, 9, 10, 12, 13))
        else null end
    end as DESC_INSUMO,
    
    case cast(ZC2.ZC2_TIPO as int) when 3 then (select max(trim(ST9010.T9_CODFAMI)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZC2.ZC2_COD) and cast(ZC2.ZC2_TIPO as int) = 3) else '-' end as FAMILIA_EQUIP,

    case ZC1.ZC1_STATUS
        when 1 then 'ABERTA'
        when 2 then 'SOLICITADO CANCELAMENTO'
        when 3 then 'CANCELADA'
        when 5 then 'CORTESIA'
        when 6 then 'ENCERRADA'
        else 'OUTROS'
    end as STATUS_OS,
    
    case ZC1.ZC1_STATU2
        when 1 then 'PENDENTE'
        when 2 then 'PARCIAL'
        when 3 then 'FINALIZADO'
        else 'OUTROS'
    end as STATUS_PEDIDO,
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,
    ZC2.ZC2_MOTORI as COD_MOT,
    DA4.DA4_NOME as MOTORISTA,
    ZC2.ZC2_VEICUL as CM,
    ZC2.ZC2_CARRET as SR,

    substring(ZC2.ZC2_COMPET, 1, 6) as PERIODO,
    substring(ZC2.ZC2_DTFIM, 1, 6) as PERIODO_APONT,
    
    convert(date, ZC2.ZC2_DTINI, 103) as DATA_INIAPONT,
    convert(date, ZC2.ZC2_DTFIM, 103) as DATA_FIMAPONT,
    convert(datetime, case isdate(ZC2.ZC2_HRINI) when 1 then concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI) else concat(ZC2.ZC2_DTINI, ' ', '00:00') end, 113) as DTINI_APONT,
    convert(datetime, case isdate(ZC2.ZC2_HRFIM) when 1 then concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM) else concat(ZC2.ZC2_DTFIM, ' ', '00:00') end, 113) as DTFIM_APONT,
    case isdate(ZC2.ZC2_HRINI) when 1 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_APONT,
	case isdate(ZC2.ZC2_HRINI) when 1 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end as HORAS_TOTAIS,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO,

    SC6.C6_NUM as PEDIDO,
    SC6.C6_ITEM as ITEM_PEDIDO,
    SC6.C6_UM as UN_PEDIDO,
    SC6.C6_QTDVEN as QTD_PEDIDO,
    trim(SC6.C6_CC) as CC_PEDIDO,
    trim(SC6.C6_ITEMCTA) as ATIVIDADE_PEDIDO,
    convert(date, SC6.C6_ENTREG, 103) as DATA_PEDIDO,
    substring(SC6.C6_ENTREG, 1, 6) as PERIODO_PEDIDO,

    SD2.D2_DOC as FAT_DOC,
    SD2.D2_SERIE as FAT_SERIE,
    SD2.D2_ITEM as FAT_ITEM,
    cast(SD2.D2_QUANT as numeric(15, 2)) as FAT_QUANT,

    TAX.A2_COD as TAX_CODIGO,
    TAX.A2_LOJA as TAX_LOJA,
    TAX.A2_CGC as TAX_CNPJ,
    trim(TAX.A2_NOME) as TAXA_FOR,

    (
        select max(SD1010.D1_DOC)
        from SD1010 (nolock)
            left join SC7010 (nolock)
                on SC7010.D_E_L_E_T_ = ''
                and SC7010.C7_FILIAL = SD1010.D1_FILIAL
                and SC7010.C7_NUM = SD1010.D1_PEDIDO
                and SC7010.C7_ITEM = SD1010.D1_ITEMPC
        where
                case when trim(SC7010.C7_YOS) = '2024/0' then right(left(replace(replace(SC7010.C7_OBS, char(10), ''), char(13), ''), 63), 11) else SC7010.C7_YOS end = ZC2.ZC2_NUM
            and SC7010.C7_YOSIT = ZC2.ZC2_ITEM
            and SD1010.D_E_L_E_T_ = ''
    ) as TAXA_NF

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
    
    left join SA2010 TAX (nolock)
        on TAX.D_E_L_E_T_ = ''
        and TAX.A2_COD = ZC2.ZC2_YFORNE
        and TAX.A2_LOJA = ZC2.ZC2_YLOJA
    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)
    left join ZA7010 ZA7 (nolock)
        on ZA7.D_E_L_E_T_ = ''
        and trim(ZA7.ZA7_COD) = trim(ZC2.ZC2_COD)
    left join DA4010 DA4 (nolock)
        on DA4.D_E_L_E_T_ = ''
        and DA4.DA4_COD = ZC2.ZC2_MOTORI
    
    left join ZA9010 ZA9 (nolock)
        on ZA9.D_E_L_E_T_ = ''
        and ZA9.ZA9_FILIAL = ZC2.ZC2_FILIAL
        and ZA9.ZA9_SERVIC = ZC2.ZC2_COD

        left join AIB010 AIB (nolock)
            on AIB.D_E_L_E_T_ = ''
            and AIB.AIB_CODFOR = ZA9.ZA9_PORTO
            and AIB.AIB_LOJFOR = ZA9.ZA9_LJPORT
            and AIB.AIB_CODPRO = ZA9.ZA9_CODTAX
    
    left join SC6010 SC6 (nolock)
        on SC6.D_E_L_E_T_ = ''
        and SC6.C6_FILIAL = ZC2.ZC2_FILIAL
        and SC6.C6_YOS = ZC2.ZC2_NUM
        and SC6.C6_YITOS = ZC2.ZC2_ITEM

        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_FILIAL = SC6.C6_FILIAL
            and SD2.D2_PEDIDO = SC6.C6_NUM
            and SD2.D2_ITEMPV = SC6.C6_ITEM

where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_INCLUS != 'C'
    and nullif(nullif(ZC1.ZC1_DTINI, ''), '  :  ') is not null and nullif(nullif(ZC1.ZC1_HRINI, ''), '  :  ') is not null
	and nullif(nullif(ZC1.ZC1_DTFIM, ''), '  :  ') is not null and nullif(nullif(ZC1.ZC1_HRFIM, ''), '  :  ') is not null
    and substring(ZC1.ZC1_EMISSA, 1, 6) > 202309
