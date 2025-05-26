select
    ZC1.ZC1_FILIAL as FILIAL,
    ZC1.ZC1_NUM as NUM_OS,
    cast(substring(ZC1.ZC1_NUM, 6, 10) as int) as OS,
    ZC2.ZC2_ITEM as ITEM,

    ZC1.ZC1_DTINI,
	ZC1.ZC1_HRINI,
	ZC1.ZC1_DTFIM,
	ZC1.ZC1_HRFIM,
    ZC2.ZC2_DTINI,
    ZC2.ZC2_HRINI,
    ZC2.ZC2_DTFIM,
    ZC2.ZC2_HRFIM,
    ZC2.ZC2_DATA,

    left(ZC1.ZC1_EMISSA, 6) as PERIODO_INIOS,
    cast(ZC1.ZC1_EMISSA as date) as DATA_INIOS,
    left(ZC1.ZC1_DTENCE, 6) as PERIODO_ENCOS,
    cast(ZC1.ZC1_DTENCE as date) as DATA_ENCOS,
    
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
    
    ZC2.ZC2_INCLUS as TIPO_INCLUSAO,
    concat(trim(ZC1.ZC1_TABPRC), ' - ', (select trim(DA0010.DA0_DESCRI) from DA0010 where DA0010.D_E_L_E_T_ = '' and DA0010.DA0_CODTAB = ZC1.ZC1_TABPRC)) as TABELA_PRECO,
    
    case cast(ZC2.ZC2_TIPO as int)
        when 1 then 'RECEITA'
        when 2 then 'FOLHA'
        when 3 then 'MANUTENÇÃO'
        when 4 then 'MATERIAIS'
        when 5 then 'COMPRAS'
        when 6 then 'DEPRECIAÇÃO'
        when 7 then 'CONTABILIDADE'
        when 8 then 'DESPESAS FINANCEIRAS'
        when 9 then 'DOCUMENTAÇÃO'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO EQUIPAMENTO'
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
    
    ZC2.ZC2_QTDPRV as QTD_PREV,
    ZC2.ZC2_QTDREA as QTD_REAL,
    ZC2.ZC2_QTDREC as QTD_RECURSO,

    ZC2.ZC2_VEICUL as CM,
    ZC2.ZC2_CARRET as SR,

    left(ZC2.ZC2_COMPET, 6) as PERIODO,
    left(coalesce(nullif(ZC2.ZC2_DATA, ''), ZC2.ZC2_COMPET), 6) as PERIODO_APONT,
    
    convert(date, ZC2.ZC2_DTINI, 103) as DATA_INIAPONT,
    convert(date, ZC2.ZC2_DTFIM, 103) as DATA_FIMAPONT,
    convert(date, isnull(nullif(ZC2.ZC2_DATA, ''), ZC2.ZC2_DTFIM), 103) as DATA_ITEM,
    convert(datetime, case isdate(ZC2.ZC2_HRINI) when 1 then concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI) else concat(ZC2.ZC2_DTINI, ' ', '00:00') end, 113) as DTINI_APONT,
    convert(datetime, case isdate(ZC2.ZC2_HRFIM) when 1 then concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM) else concat(ZC2.ZC2_DTFIM, ' ', '00:00') end, 113) as DTFIM_APONT,
    case when cast(ZC2.ZC2_TIPO as int) in (2, 3) then case when isdate(ZC2.ZC2_HRINI) + isdate(ZC2.ZC2_HRFIM) = 2 then cast(datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end else 0.0 end as HORAS_APONT,
	case when cast(ZC2.ZC2_TIPO as int) in (2, 3) then case when isdate(ZC2.ZC2_HRINI) + isdate(ZC2.ZC2_HRFIM) = 2 then cast(ZC2.ZC2_QTDREC * datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 as numeric(15, 4)) else 0.0 end else 0.0 end as HORAS_TOTAIS,
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO,

    case
        when cast(ZC2.ZC2_TIPO as int) not in (2, 3) then 'N/A'
        when day(ZC2.ZC2_DTINI) %2 = 0 and datepart(hour, ZC2.ZC2_HRINI) between 7 and 18 then 'DIA PAR'
        when day(ZC2.ZC2_DTINI) %2 != 0 and datepart(hour, ZC2.ZC2_HRINI) between 7 and 18 then 'DIA ÍMPAR'
        when day(ZC2.ZC2_DTINI) %2 = 0 and (datepart(hour, ZC2.ZC2_HRINI) between 19 and 23 or ((day(ZC2.ZC2_DTINI) +1) %2 != 0 and datepart(hour, ZC2.ZC2_HRINI) between 0 and 6)) then 'NOITE PAR'
        when day(ZC2.ZC2_DTINI) %2 != 0 and (datepart(hour, ZC2.ZC2_HRINI) between 19 and 23 or ((day(ZC2.ZC2_DTINI) +1) %2 = 0 and datepart(hour, ZC2.ZC2_HRINI) between 0 and 6)) then 'NOITE ÍMPAR'
    else 'N/A' end as TURNO,
    
    case
        when cast(ZC2.ZC2_TIPO as int) not in (2, 3) then 'não se aplica'
        when isdate(ZC2.ZC2_DTINI) = 0 or nullif(ZC2.ZC2_DTINI, '') is null or isdate(ZC2.ZC2_HRINI) = 0 or nullif(ZC2.ZC2_HRINI, '') is null then 'data ou hora ini ausente'
        when isdate(ZC2.ZC2_DTFIM) = 0 or nullif(ZC2.ZC2_DTFIM, '') is null or isdate(ZC2.ZC2_HRFIM) = 0 or nullif(ZC2.ZC2_HRFIM, '') is null then 'data ou hora fim ausente'
        when datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM))/60.0 > 12.5 then 'mais que 12,5 h apontadas'
        when datediff(minute, concat(ZC2.ZC2_DTINI, ' ', ZC2.ZC2_HRINI), concat(ZC2.ZC2_DTFIM, ' ', ZC2.ZC2_HRFIM)) < 0.0 then 'data/hora ini maior que data/hora fim'
        else 'item OK'
    end as STATUS_APONT

from ZC2010 ZC2 (nolock)
    left join ZC1010 ZC1 (nolock)
        on ZC1.D_E_L_E_T_ = ''
        and ZC1.ZC1_FILIAL = ZC2.ZC2_FILIAL
        and ZC1.ZC1_NUM = ZC2.ZC2_NUM
    left join ST9010 ST9 (nolock)
        on ST9.D_E_L_E_T_ = ''
        and trim(ST9.T9_CODBEM) = trim(ZC2.ZC2_COD)

where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_INCLUS != 'C'
    and substring(ZC1.ZC1_EMISSA, 1, 6) > 202312
