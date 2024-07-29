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
    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_COD, ZC2.ZC2_ITEM) is null then ((select sum(ZC7010.ZC7_HRPAD) from ZC7010 where ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.ZC2_COD and ZC7010.ZC7_COMPET = substring(ZC2.ZC2_COMPET, 1, 6))) else 0.0 end as HORA_PAD,
    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_COD, ZC2.ZC2_ITEM) is null then ((select sum(ZC7010.ZC7_HRIMPR) from ZC7010 where ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.ZC2_COD and ZC7010.ZC7_COMPET = substring(ZC2.ZC2_COMPET, 1, 6))) else 0.0 end as HORAS_IMPR,
    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_COD, ZC2.ZC2_ITEM) is null then ((select ZC7010.ZC7_HRPAD from ZC7010 where ZC7010.ZC7_CC = 305 and ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.ZC2_COD and ZC7010.ZC7_COMPET = substring(ZC2.ZC2_COMPET, 1, 6))) else 0.0 end as HORA_OPE,
    case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_COD, ZC2.ZC2_ITEM) is null then ((select ZC7010.ZC7_HRPAD from ZC7010 where ZC7010.ZC7_CC = 304 and ZC7010.D_E_L_E_T_ = '' and ZC7010.ZC7_CODIGO = ZC2.ZC2_COD and ZC7010.ZC7_COMPET = substring(ZC2.ZC2_COMPET, 1, 6))) else 0.0 end as HORA_TMS,
    
    trim(ZC2.ZC2_CONTEI) as CONTEINER,
    trim(ZC2.ZC2_LACRE) as LACRE,

    cast(ZC2.ZC2_DATA as date) as DATA_ITEM,
    cast(ZC2.ZC2_DTINI as date) as DATA_INIAPONT,
    cast(ZC2.ZC2_DTFIM as date) as DATA_FIMAPONT,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO

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
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_COMPET like '2024%'