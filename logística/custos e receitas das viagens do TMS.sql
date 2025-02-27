select
    VIAGEM.*,
    cast(VIAGEM.DATAFIM as date) as DATA_FIMVGA,
    left(VIAGEM.DATAFIM, 6) as PERIODO_FIMVGA,
    
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
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as DATAINI,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as HORAINI,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as HORAFIM,
    (
        select top 1 first_value(cast(DTW010.DTW_DATREA as date)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 57
    ) as DATA_CHECLI,
    (
        select top 1 first_value(DTW010.DTW_HORREA) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 57
    ) as HORA_CHECLI,
    (
        select top 1 first_value(cast(DTW010.DTW_DATREA as date)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 56
    ) as DATA_SAICLI,
    (
        select top 1 first_value(DTW010.DTW_HORREA) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 56
    ) as HORA_SAICLI,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and concat(DTW010.DTW_FILORI, DTW010.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA,

    ZE4.ZE4_VIAGEM as VIAGEM,
    ZE4.ZE4_TOTHR as HORAS_VIAGEM,
    ZE4.ZE4_STATUS as STATUS_TMS,
    ZE4.ZE4_KMINI as km_ini,
    ZE4.ZE4_YKMFIM as km_fim,
    ZE4.ZE4_YKMFIM - ZE4.ZE4_KMINI as km_VIAGEM,
    convert(datetime, concat(ZE4.ZE4_DTINI, ' ', ZE4.ZE4_HRINI), 113) as VGA_DATAINI,
    convert(datetime, concat(ZE4.ZE4_DTFIM, ' ', ZE4.ZE4_HRFIM), 113) as VGA_DATAFIM,
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
    end as TIPO_ITEM

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

            (
                select DTW010.DTW_DATREA
                from DTW010 
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = 50
            ) as DATAFIM,
            
            concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
            trim(DA4010.DA4_COD) as ID_MOTORISTA,
            trim(DA4010.DA4_NOME) as MOTORISTA,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
            (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3
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
        on DUD.DUD_FILIAL = VIAGEM.DTQ_FILIAL
        and DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
        and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM

        inner join ZE5010 ZE5 (nolock)
            on ZE5.D_E_L_E_T_ = ''
            and concat(ZE5.ZE5_FILIAL, ZE5.ZE5_VIAGEM) = VIAGEM.ID_VIAGEM
            and ZE5.ZE5_MOTORI = VIAGEM.ID_MOTORISTA
            and ZE5.ZE5_BEMCAV = VIAGEM.ID_VEICULO_CM
            and ZE5.ZE5_CARR1 = VIAGEM.ID_VEICULO_RB1
            and ZE5.ZE5_CARR2 = VIAGEM.ID_VEICULO_RB2
            and ZE5.ZE5_CARR3 = VIAGEM.ID_VEICULO_RB3

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
        and ZE1.ZE1_VIAGEM = DUD.DUD_VIAGEM
        
        inner join ZE4010 ZE4 (nolock)
            on ZE4.D_E_L_E_T_ = ''
            and ZE4.ZE4_FILIAL = ZE1.ZE1_FILIAL
            and ZE4.ZE4_VIAGEM = ZE1.ZE1_VIAGEM
where
        DUD.D_E_L_E_T_ = ''
