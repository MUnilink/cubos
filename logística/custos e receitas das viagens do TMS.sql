select
    VIAGEM.*,    
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    trim(DEV.A1_COD) as DEV_COD,
    trim(DEV.A1_LOJA) as DEV_LOJA,
    trim(DEV.A1_NOME) as CLI_DEVEDOR,
    
    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(REM.A1_COD) as REM_COD,
    trim(REM.A1_LOJA) as REM_LOJA,
    trim(REM.A1_NOME) as CLI_ORIGEM,
    
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DES.A1_COD) as DES_COD,
    trim(DES.A1_LOJA) as DES_LOJA,
    trim(DES.A1_NOME) as CLI_DESTINO,

/*
    OPERAÇÕES
    01 – INICIO DE VIAGEM
    05 – CHEGADA NO CLIENTE
    06 -  SAIDA DO CLIENTE
    09 – CHEGADA NO PORTO - no TMS essa macro é apontada como chegada de cliente {porto}
    10 – SAIDA DO PORTO - no TMS essa macro é apontada como saída de cliente {porto}
    07 – FIM DE VIAGEM

    OCORRÊNCIA
    17 – ENTREGA EFETUADA
*/

    (
        select
            isnull
            (
                (
                    select top 1 nullif(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '')
                    from ZB1010 (nolock)
                    where
                            ZB1010.D_E_L_E_T_ = ''
                        and ZB1010.ZB1_STATUS = 'OK'
                        and
                            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                            =
                            datetimefromparts(year(APT.DTW_DATREA), month(APT.DTW_DATREA), day(APT.DTW_DATREA), substring(APT.DTW_HORREA, 1, 2), substring(APT.DTW_HORREA, 3, 4), 0, 0)
                        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                        and ZB1010.ZB1_MACRON = 7
                        and ZB1010.ZB1_CODDA3 = VIAGEM.ID_VEICULO_CM
                )
            , APT.DTW_YHODFI) 
        from DTW010 APT (nolock)
        where
                APT.D_E_L_E_T_ = ''
            and concat(APT.DTW_FILORI, APT.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and APT.DTW_ATIVID = 50
    ) as km_fim,
    (
        select
            isnull
            (
                (
                    select top 1 nullif(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '')
                    from ZB1010 (nolock)
                    where
                            ZB1010.D_E_L_E_T_ = ''
                        and ZB1010.ZB1_STATUS = 'OK'
                        and
                            dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                            =
                            datetimefromparts(year(APT.DTW_DATREA), month(APT.DTW_DATREA), day(APT.DTW_DATREA), substring(APT.DTW_HORREA, 1, 2), substring(APT.DTW_HORREA, 3, 4), 0, 0)
                        and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                        and ZB1010.ZB1_MACRON = 1
                        and ZB1010.ZB1_CODDA3 = VIAGEM.ID_VEICULO_CM
                )
            , APT.DTW_YHODIN)
        from DTW010 APT (nolock)
        where
                APT.D_E_L_E_T_ = ''
            and concat(APT.DTW_FILORI, APT.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and APT.DTW_ATIVID = 49
    ) as km_ini,

    DT6.DT6_DOC CTE_DOC,
    DT6.DT6_SERIE CTE_SERIE,
    left(DT6.DT6_DATEMI, 6) as PERIODO_CTE,
    cast(DT6.DT6_DATEMI as date) as DATA_CTE,
    DT6.DT6_VALFRE / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DUD.DUD_VIAGEM), 1) as IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,
    DT6.DT6_VALMER,

    DTC.DTC_FILORI,
    DTC.DTC_DOC,
    DTC.DTC_SERIE,
    DTC.DTC_NUMNFC,
    DTC.DTC_SERNFC,
    DTC.DTC_CODPRO,
    DTC.DTC_VALOR,
    DTC.DTC_PESO,
    DTC.DTC_PESLIQ,
    trim(SB1.B1_DESC) as NFCLI_PRODUTO,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,
    
    cast(DF1.DF1_DATCON as date) as DT_AGE,
    substring(DF1.DF1_DATCON, 1, 6) as PERIODO_AGE,
    DF1.DF1_NUMAGE as AGENDAMENTO,
    DF1.DF1_ITEAGE as ITEM_AGENDA,
    DF1.DF1_YDSPOR as PORTO,
    DF1.DF1_YDIBOO as BOOKING,
    DF1.DF1_YOSCLI as OS_CLIENTE,
    DF1.DF1_YNAVIO as NAVIO,
    DF1.DF1_YDSNAV as NOME_NAVIO,
    DF1.DF1_YVIAGE as VIAGEM_PORT,
    DF1.DF1_YCONT as CONTEINER,
    DF1.DF1_YLACRE as LACRE,
    datetimefromparts(year(DF1.DF1_YDTCON), month(DF1.DF1_YDTCON), day(DF1.DF1_YDTCON), substring(DF1.DF1_YHRCON, 1, 2), substring(DF1.DF1_YHRCON, 4, 5), 0, 0) as DATA_CONTEINER,
    DF1.DF1_YARMAD as ARMADORA,
    DF1.DF1_YLJARM as LOJA_ARMADORA,
    DF1.DF1_CODOBC,
    DF1.DF1_YDSARM as NOME_ARMADORA,

    DT6C.D2_DOC as DOCOMP_DOC,
    DT6C.D2_SERIE as DOCOMP_SERIE,
    DT6C.D2_TOTAL as DOCOMP_TOTAL,
    DT6C.D2_VALIPI as DOCOMP_VALIPI,
    DT6C.D2_VALICM as DOCOMP_VALICM,
    cast(DT6C.D2_EMISSAO as date) as DOCOMP_EMISSAO,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    cast(RPS.D2_EMISSAO as date) as RPS_EMISSAO,

    SE1.E1_NUM as ND_TITULO,
    SE1.E1_VALOR as ND_VALOR,
    cast(SE1.E1_EMISSAO as date) as ND_EMISSAO,

    cast(VIAGEM.DTQ_DATGER as date) as DT_GERVGA,
    cast(VIAGEM.DTQ_DATFEC as date) as DT_FECVGA,
    cast(VIAGEM.DTQ_DATENC as date) as DT_ENCVGA,
    left(VIAGEM.DTQ_DATGER, 6) as PERIODO_GERVGA,
    left(VIAGEM.DTQ_DATFEC, 6) as PERIODO_FECVGA,
    left(VIAGEM.DTQ_DATENC, 6) as PERIODO_ENCVGA,

    (
        select datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as DATAINI,
    (
        select datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
    
    datediff
    (
        minute,
        (
            select datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
            from DTW010 (nolock)
            where
                    DTW010.D_E_L_E_T_ = ''
                and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
                and DTW010.DTW_ATIVID = 49
        ),
        (
            select datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
            from DTW010 (nolock)
            where
                    DTW010.D_E_L_E_T_ = ''
                and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
                and DTW010.DTW_ATIVID = 50
        )
    )/60.0 as HORAS_VIAGEM,
    
    (
        select top 1 first_value(datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 57
    ) as DATA_CHECLI,
    (
        select top 1 first_value(datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 56
    ) as DATA_SAICLI,
    (
        select left(DTW010.DTW_DATREA, 6)
        from DTW010 (nolock)
        where
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA,

    ZE4.ZE4_VIAGEM as VIAGEM,
    ZE4.ZE4_TOTHR as HR_VIAGEM,
    ZE4.ZE4_STATUS as STATUS_TMS,
    ZE4.ZE4_KMINI as km_ini,
    ZE4.ZE4_YKMFIM as km_fim,
    ZE4.ZE4_YKMFIM - ZE4.ZE4_KMINI as km_VIAGEM,
    ZE5.ZE5_ITENS as ITEM_CAB,
    
    trim(ZE1.ZE1_COD) as CT_CODIGO,
    cast(ZE1.ZE1_TOTAL as numeric(15, 2)) as CT_VALOR,
    cast(ZE1.ZE1_DATA as date) as CT_DATA,
    left(ZE1.ZE1_COMPET, 6) as CT_PERIODO,

    ZE1.ZE1_ITEM as CT_ITEM,
    ZE1.ZE1_TIPO as CT_TIPO,
    case ZE1.ZE1_TIPO
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
    end as TIPO_ITEM,

    case
        when ZE1.ZE1_TIPO in (1, 4, 5, 11) then (select max(trim(SB1010.B1_DESC)) from SB1010 (nolock) where SB1010.D_E_L_E_T_ = '' and trim(SB1010.B1_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (1, 4, 5, 11))
        when ZE1.ZE1_TIPO in (2, 14, 15) then (select trim(SQ3010.Q3_DESCSUM) from SQ3010 (nolock) where SQ3010.D_E_L_E_T_ = '' and SQ3010.Q3_CARGO = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (2, 14))
        when ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16) then (select max(trim(ST9010.T9_CODBEM)) from ST9010 (nolock) where ST9010.D_E_L_E_T_ = '' and trim(ST9010.T9_CODBEM) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO in (3, 6, 9, 10, 12, 13, 16))
        when ZE1.ZE1_TIPO = 7 then (select trim(ZA7010.ZA7_DESC) from ZA7010 (nolock) where ZA7010.D_E_L_E_T_ = '' and trim(ZA7010.ZA7_COD) = trim(ZE1.ZE1_COD) and ZE1.ZE1_TIPO = 7)
    else null end as DESC_RECURSO,

    case
        when ZE1.ZE1_TIPO = 8 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then 0.0
        when ZE1.ZE1_TIPO = 3 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
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
                and STJ010.TJ_CODBEM = ZE1.ZE1_COD
                and left(STL010.TL_DTFIM, 6) = left(ZE1.ZE1_COMPET, 6)
                and STL010.TL_SEQRELA > 0
                and STJ010.TJ_SERVICO not in ('PNEMOV', 'PNEROD')
        )
        when ZE1.ZE1_TIPO = 6 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
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
                and SN1010.N1_CODBEM = ZE1.ZE1_COD
                and left(SN4010.N4_DATA, 6) = left(ZE1.ZE1_COMPET, 6)
                and SN4010.N4_OCORR = 6
                and SN4010.N4_TIPOCNT = 3
        )
        when ZE1.ZE1_TIPO = 7 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
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
                and ZA7010.ZA7_COD = ZE1.ZE1_COD
                and left(CT2010.CT2_DATA, 6) = left(ZE1.ZE1_COMPET, 6)
                and ZE1.ZE1_TIPO = 7
        )
        when ZE1.ZE1_TIPO = 9 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
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
            where
                    TS1010.TS1_CODBEM = ZE1.ZE1_COD
        )
        when ZE1.ZE1_TIPO = 10 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
        (
            select cast(sum(TQN010.TQN_VALTOT) as numeric(15, 2))
            from TQN010
            where
                    TQN010.D_E_L_E_T_ = ''
                and TQN010.TQN_FROTA = ZE1.ZE1_COD
                and left(TQN010.TQN_DTABAS, 6) = left(ZE1.ZE1_COMPET, 6)
        )
        when ZE1.ZE1_TIPO = 12 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
        (
            select cast(sum(ZC4010.ZC4_VLSEG)/sum(ZC4.VALOR_ANUAL)/12.0 as numeric(15, 2))
            from ZC4010 (nolock)
                inner join
                    (
                        select
                            cast(datediff(day, ZC4010.ZC4_DTVGIN, ZC4010.ZC4_DTVGFI)/365.0 as numeric(15, 5)) as VALOR_ANUAL,
                            cast(ZC4010.ZC4_DTVGIN as date) as INI_VIG,
                            cast(ZC4010.ZC4_DTVGFI as date) as FIM_VIG,
                            ZC4010.ZC4_CODBEM
                        from ZC4010 (nolock)
                        where
                                ZC4010.D_E_L_E_T_ = ''
                    ) ZC4
                        on ZC4010.ZC4_CODBEM = ZC4.ZC4_CODBEM
                        and ZC4010.ZC4_DTVGIN = ZC4.INI_VIG
                        and ZC4010.ZC4_DTVGFI = ZC4.FIM_VIG
            where
                    ZC4010.D_E_L_E_T_ = ''
                and ZE1.ZE1_COD = ZC4010.ZC4_CODBEM
                and eomonth(concat(left(ZE1.ZE1_COMPET, 6), '01')) between ZC4.INI_VIG and ZC4.FIM_VIG
        )
        when ZE1.ZE1_TIPO = 13 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
        (
            select sum(ZC6010.ZC6_CUSTO)
            from ZC6010 (nolock)
            where
                    ZC6010.D_E_L_E_T_ = ''
                and ZC6010.ZC6_ANOMES = left(ZE1.ZE1_COMPET, 6)
                and (ZC6010.ZC6_BEMPAI = ZE1.ZE1_COD or ZC6010.ZC6_BEMPA2 = ZE1.ZE1_COD)
        )
        when ZE1.ZE1_TIPO = 2 and left(left(ZE1.ZE1_COMPET, 6), 4) > 2023 then
        (
            select sum(FOLHA.VALOR)
            from
            (
                select
                    SRD.RD_VALOR,
                    case when SRV.RV_TIPOCOD = 2 then SRD.RD_VALOR*-1 else SRD.RD_VALOR end *
                    (
                        datediff
                        (
                            day,
                            case when
                            (
                                select max(SR7010.R7_DATA)
                                from SR7010
                                where
                                        SR7010.D_E_L_E_T_ = ''
                                    and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                    and SR7010.R7_MAT = SRD.RD_MAT
                                    and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
                            ) >= concat(SRD.RD_DATARQ, '01') then
                            (
                                select max(SR7010.R7_DATA)
                                from SR7010
                                where
                                        SR7010.D_E_L_E_T_ = ''
                                    and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                    and SR7010.R7_MAT = SRD.RD_MAT
                                    and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
                            )
                            else concat(SRD.RD_DATARQ, '01') end,
                            case when left(SRA010.RA_DEMISSA, 6) = SRD.RD_DATARQ then SRA010.RA_DEMISSA else dateadd(day, 1, eomonth(concat(SRD.RD_DATARQ, '01'))) end
                        )
                    ) / (1 + datediff(day, concat(SRD.RD_DATARQ, '01'), eomonth(concat(SRD.RD_DATARQ, '01')))) as VALOR, /* VALOR_PRO */
                    (
                        select top 1 last_value(trim(SR7010.R7_CARGO)) over (partition by SR7010.R7_FILIAL, SR7010.R7_MAT order by SR7010.R7_FILIAL, SR7010.R7_MAT, SR7010.R7_SEQ)
                        from SR7010
                        where
                                SR7010.D_E_L_E_T_ = ''
                            and SR7010.R7_FILIAL = SRD.RD_FILIAL
                            and SR7010.R7_MAT = SRD.RD_MAT
                            and SR7010.R7_DATA <= eomonth(concat(SRD.RD_DATARQ, '01'))
                    ) as CARGO_FOLHA,
                    SRD.RD_FILIAL,
                    SRD.RD_MAT,
                    SRD.RD_DATARQ
                from SRD010 SRD
                    inner join SRA010 (nolock)
                        on SRA010.D_E_L_E_T_ = ''
                        and SRA010.RA_FILIAL = SRD.RD_FILIAL
                        and SRA010.RA_MAT = SRD.RD_MAT
                where
                        exists
                        (
                            select *
                            from SR7010
                            where
                                    SR7010.D_E_L_E_T_ = ''
                                and SR7010.R7_FILIAL = SRD.RD_FILIAL
                                and SR7010.R7_MAT = SRD.RD_MAT
                                and SR7010.R7_DATA <= concat(SRD.RD_DATARQ, '01')
                        )
                    and exists (select * from SRV010 (nolock) where SRV010.D_E_L_E_T_ = '' and SRV010.RV_YCPOR = 'S' and SRV010.RV_COD = SRD.RD_PD)
                    and SRD.D_E_L_E_T_ = ''
            ) FOLHA
            where concat(FOLHA.RD_FILIAL, FOLHA.RD_DATARQ, FOLHA.CARGO_FOLHA) = concat(ze1.ZE1_FILIAL, left(ZE1.ZE1_COMPET, 6), ZE1.ZE1_COD)
        )
    else 0.0 end as CUSTO

from DUD010 DUD (nolock)
    inner join
    (
        select
            DTQ.DTQ_FILIAL as FILIAL,
            DTQ.DTQ_FILORI as FILORI,
            DTQ.DTQ_VIAGEM as VIAGEM,
            DTQ.DTQ_DATGER,
            DTQ.DTQ_DATFEC,
            DTQ.DTQ_DATENC,
            trim(DA8010.DA8_DESC) as ROTA,

            case DTQ.DTQ_STATUS
                when '1' then 'EXCLUÍDA'
                when '2' then 'EM TRANSITO'
                when '3' then 'ENCERRADA'
                when '4' then 'CHEGADA EM FILIAL'
                when '5' then 'FECHADA'
                when '9' then 'CANCELADA'
                else 'OUTROS'
            end as STATUS_VGA,
            
            concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
            trim(DA4010.DA4_COD) as ID_MOTORISTA,
            trim(DA4010.DA4_NOME) as MOTORISTA,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,
            DTR.DTR_ITEM as ITEM
        from DTQ010 DTQ
            left join DTR010 DTR
                on DTR.D_E_L_E_T_ = ''
                and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                
                left join DUP010
                    on DUP010.D_E_L_E_T_ = ''
                    and DUP010.DUP_FILORI = DTR.DTR_FILORI
                    and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                    and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                    and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                    left join DA4010
                        on DA4010.D_E_L_E_T_ = ''
                        and DA4010.DA4_COD = DUP010.DUP_CODMOT
            
            left join DA8010 (nolock)
                on DA8010.D_E_L_E_T_ = ''
                and DA8010.DA8_COD = DTQ.DTQ_ROTA
        where DTQ.D_E_L_E_T_ = ''
    ) VIAGEM
        on DUD.DUD_FILIAL = VIAGEM.FILIAL
        and DUD.DUD_FILORI = VIAGEM.FILORI
        and DUD.DUD_VIAGEM = VIAGEM.VIAGEM

        inner join ZE5010 ZE5 (nolock)
            on ZE5.D_E_L_E_T_ = ''
            and concat(ZE5.ZE5_FILIAL, ZE5.ZE5_VIAGEM) = VIAGEM.ID_VIAGEM
            and ZE5.ZE5_MOTORI = VIAGEM.ID_MOTORISTA
            and ZE5.ZE5_BEMCAV = VIAGEM.ID_VEICULO_CM
            and ZE5.ZE5_ITENS = VIAGEM.ITEM

    left join DT5010 DT5 (nolock)
        on DT5.D_E_L_E_T_ = ''
        and DT5.DT5_FILDOC = DUD.DUD_FILDOC
        and DT5.DT5_NUMSOL = DUD.DUD_DOC
        and DUD.DUD_SERIE = 'COL'

        left join DF1010 DF1 (nolock)
            on DF1.D_E_L_E_T_ = ''
            and DF1.DF1_FILDOC = DT5.DT5_FILORI
            and DF1.DF1_DOC = DT5.DT5_DOC
            and DF1.DF1_SERIE = DT5.DT5_SERIE

    left join DT6010 DT6 (nolock)
        on DT6.D_E_L_E_T_ = ''
        and DT6.DT6_FILDOC = DUD.DUD_FILDOC
        and DT6.DT6_DOC = DUD.DUD_DOC
        and DT6.DT6_SERIE = DUD.DUD_SERIE

        left join SD2010 DT6C (nolock)
            on DT6C.D_E_L_E_T_ = ''
            and DT6C.D2_NFORI = DT6.DT6_DOC
            and DT6C.D2_SERIORI = DT6.DT6_SERIE
            and DT6C.D2_CLIENTE = DT6.DT6_CLIDEV
            and DT6C.D2_LOJA = DT6.DT6_LOJDEV

        left join SA1010 DEV (nolock)
            on DEV.A1_FILIAL = '      '
            and DEV.A1_COD = DT6.DT6_CLIDEV
            and DEV.A1_LOJA = DT6.DT6_LOJDEV
            and DEV.D_E_L_E_T_ = ' '
        left join SA1010 REM
            ON REM.A1_FILIAL = '      '
            AND REM.A1_COD = DT6.DT6_CLIREM
            AND REM.A1_LOJA = DT6.DT6_LOJREM
            AND REM.D_E_L_E_T_ = ' '
        left join SA1010 DES
            ON DES.A1_FILIAL = '      '
            AND DES.A1_COD = DT6.DT6_CLIDES
            AND DES.A1_LOJA = DT6.DT6_LOJDES
            AND DES.D_E_L_E_T_ = ' '

    LEFT JOIN DUY010 DUYORI
        ON DUYORI.DUY_FILIAL = DT6.DT6_FILIAL
        AND DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
        AND DUYORI.D_E_L_E_T_ = ' '
    LEFT JOIN DUY010 DUYDES
        ON DUYDES.DUY_FILIAL = DT6.DT6_FILIAL
        AND DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
        AND DUYDES.D_E_L_E_T_ = ' '
    LEFT JOIN DUY010 DUYDEV
        ON DUYDEV.DUY_FILIAL = DT6.DT6_FILIAL
        AND DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
        AND DUYDEV.D_E_L_E_T_ = ' '
    
    left join DUY010 REG_COL (nolock)
        ON REG_COL.D_E_L_E_T_ = ' '
        and REG_COL.DUY_FILIAL = DT6.DT6_FILIAL
        and REG_COL.DUY_GRPVEN = DT6.DT6_CDRORI
    left join DUY010 REG_ENT (nolock)
        ON REG_ENT.D_E_L_E_T_ = ' '
        and REG_ENT.DUY_FILIAL = DT6.DT6_FILIAL
        and REG_ENT.DUY_GRPVEN = DT6.DT6_CDRCAL
    left join DTC010 DTC (nolock)
        on DTC.D_E_L_E_T_ = ''
        and DTC.DTC_FILORI = DT6.DT6_FILDOC
        and DTC.DTC_DOC = DT6.DT6_DOC
        and DTC.DTC_SERIE = DT6.DT6_SERIE

        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = DTC.DTC_CODPRO
    
    left join SC5010 SC5 (nolock)
        on SC5.D_E_L_E_T_ = ''
        and trim(SC5.C5_YVIAGEM) = DUD.DUD_VIAGEM

        left join SD2010 RPS (nolock)
            on RPS.D_E_L_E_T_ = ''
            and RPS.D2_FILIAL = SC5.C5_FILIAL
            and RPS.D2_DOC = SC5.C5_NOTA
            and RPS.D2_SERIE = SC5.C5_SERIE
            and RPS.D2_CLIENTE = SC5.C5_CLIENTE
            and RPS.D2_LOJA = SC5.C5_LOJACLI
    
    left join SE1010 SE1 (nolock)
        on SE1.D_E_L_E_T_ = ''
        and trim(SE1.E1_YVIATMS) = DUD.DUD_VIAGEM
        
    inner join ZE1010 ZE1 (nolock)
        on ZE1.D_E_L_E_T_ = ''
        and ZE1.ZE1_FILIAL = DUD.DUD_FILORI
        and ZE1.ZE1_NUM = DUD.DUD_VIAGEM
        
        left join ZE4010 ZE4 (nolock)
            on ZE4.D_E_L_E_T_ = ''
            and ZE4.ZE4_FILIAL = ZE1.ZE1_FILIAL
            and ZE4.ZE4_VIAGEM = ZE1.ZE1_NUM
where
        DUD.D_E_L_E_T_ = ''
