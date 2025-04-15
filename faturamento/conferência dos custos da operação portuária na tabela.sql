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
        when 9 then 'DOCUMENTAÇÃO'
        when 10 then 'COMBUSTIVEL'
        when 11 then 'SERVIÇOS TOMADOS'
        when 12 then 'SEGURO EQUIPAMENTO'
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
    trim(upper(ZC2.ZC2_NMUSU)) as USUARIO,

    case
        when cast(ZC2.ZC2_TIPO as int) = 8 and ZC2.ZC2_COMPET like '2024%' then 0.0
        when cast(ZC2.ZC2_TIPO as int) = 4 and ZC2.ZC2_COMPET like '2024%' then (select cast(sum(SD3010.D3_CUSTO1) as numeric(15, 2)) from SD3010 (nolock) where SD3010.D_E_L_E_T_ = '' and SD3010.D3_FILIAL = ZC2.ZC2_FILIAL and SD3010.D3_YOS = ZC2.ZC2_NUM and SD3010.D3_COD = ZC2.ZC2_COD and eomonth(SD3010.D3_EMISSAO) = ZC2.ZC2_COMPET and SD3010.D3_ESTORNO = '')
        when cast(ZC2.ZC2_TIPO as int) in (5, 11) then (select cast(sum(SD1010.D1_CUSTO) as numeric(15, 2)) from SD1010 (nolock) where SD1010.D_E_L_E_T_ = '' and SD1010.D1_FILIAL = ZC2.ZC2_FILIAL and SD1010.D1_YOS = ZC2.ZC2_NUM and SD1010.D1_COD = ZC2.ZC2_COD and eomonth(SD1010.D1_DTDIGIT) = ZC2.ZC2_COMPET)
        when cast(ZC2.ZC2_TIPO as int) = 3 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
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
                and STJ010.TJ_SERVICO not in ('PNEMOV', 'PNEROD')
        ) else 0.0 end
        when cast(ZC2.ZC2_TIPO as int) = 6 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
        (
            select cast(sum(SN4010.N4_VLROC1) as numeric(15, 2))
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
        ) else 0.0 end
        when cast(ZC2.ZC2_TIPO as int) = 7 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
        (
            select cast(sum(case when CT2010.CT2_DEBITO between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2)) else case when CT2010.CT2_CREDIT between ZA8010.ZA8_CT1INI and ZA8010.ZA8_CT1FIM then cast(CT2010.CT2_VALOR as numeric(15, 2))*-1 else 0.0 end end) as numeric(15, 2))
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
        ) else 0.0 end
        when cast(ZC2.ZC2_TIPO as int) = 9 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
        (
            select cast(sum(TS1010.TS1_VALOR)/12 as numeric(15, 2))
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
            where TS1010.TS1_CODBEM = ZC2.ZC2_COD
        ) else 0.0 end
        when cast(ZC2.ZC2_TIPO as int) = 10 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
        (
            select cast(sum(TQN010.TQN_VALTOT) as numeric(15, 2))
            from TQN010
            where
                    TQN010.D_E_L_E_T_ = ''
                and TQN010.TQN_FROTA = ZC2.ZC2_COD
                and eomonth(TQN010.TQN_DTABAS) = ZC2.ZC2_COMPET
        ) else 0.0 end
        when cast(ZC2.ZC2_TIPO as int) = 12 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
        (
            select cast(sum(ZC4010.ZC4_VLSEG)/sum(ZC4.VALOR_ANUAL)/12.0 as numeric(15, 2))
            from ZC4010 (nolock)
                inner join
                    (
                        select
                            cast(datediff(day, ZC4010.ZC4_DTVGIN, ZC4010.ZC4_DTVGFI)/365.0 as numeric(15, 5)) as VALOR_ANUAL,
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
                and ZC2.ZC2_COD = ZC4010.ZC4_CODBEM
                and ZC2.ZC2_COMPET between ZC4.ZC4_DTVGIN and ZC4.ZC4_DTVGFI
        ) else 0.0 end
        when cast(ZC2.ZC2_TIPO as int) = 13 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
        (
            select sum(ZC6010.ZC6_CUSTO)
            from ZC6010
            where
                    ZC6010.D_E_L_E_T_ = ''
                and ZC6010.ZC6_ANOMES = substring(ZC2.ZC2_COMPET, 1, 6)
                and (ZC6010.ZC6_BEMPAI = ZC2.ZC2_COD or ZC6010.ZC6_BEMPA2 = ZC2.ZC2_COD)
        ) else 0.0 end
        when cast(ZC2.ZC2_TIPO as int) = 2 and ZC2.ZC2_COMPET like '2024%' then case when lag(ZC2.ZC2_ITEM, 1, null) over(partition by ZC2.ZC2_FILIAL, ZC2.ZC2_COMPET, ZC2.ZC2_TIPO, ZC2.ZC2_COD order by ZC2.ZC2_ITEM) is null then
        (
            select sum(case when SRV.RV_COD in (440, 445) then SRD.RD_VALOR*-1 else SRD.RD_VALOR end)
            from SRV010 SRV (nolock)
                left join SRD010 SRD (nolock)
                    on SRD.D_E_L_E_T_ = ''
                    and substring(SRD.RD_FILIAL, 1, 4) = SRV.RV_FILIAL
                    and SRD.RD_PD = SRV.RV_COD
            where
                    SRV.D_E_L_E_T_ = ''
                and SRD.RD_PERIODO = substring(ZC2.ZC2_COMPET, 1, 6)
                and
                (
                    ZC2.ZC2_COD in (select distinct SRA010.RA_CODFUNC from SRA010 where SRA010.D_E_L_E_T_ = ''  and SRA010.RA_FILIAL = SRD.RD_FILIAL and SRA010.RA_MAT = SRD.RD_MAT) or
                    ZC2.ZC2_COD in (select distinct SRA010.RA_CARGO from SRA010 where SRA010.D_E_L_E_T_ = ''  and SRA010.RA_FILIAL = SRD.RD_FILIAL and SRA010.RA_MAT = SRD.RD_MAT)
                )
                and exists (select * from SX6010 where SX6010.X6_VAR in ('UN_OSVERBA', 'UN_OSVERB1') and SX6010.X6_CONTEUD like '%' || SRV.RV_COD || '%')
        ) else 0.0 end
    else 0.0 end as CUSTO


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