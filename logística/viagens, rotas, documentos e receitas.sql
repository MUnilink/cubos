select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    left(DT6.DT6_DATEMI, 6) as PERIODO_CTE,
    cast(DT6.DT6_DATEMI as date) as DT6_DATEMI,
    DA8.DA8_DESC,
    DTQ.DTQ_KMVGE,

    trim(REG_COL.DUY_EST) as UF_COLETA,
	trim(REG_COL.DUY_DESCRI) as MUN_COLETA,
	trim(REG_ENT.DUY_EST) as UF_ENTREGA,
	trim(REG_ENT.DUY_DESCRI) as MUN_ENTREGA,
    
    cast(DTQ.DTQ_DATGER as date) as DT_GERVGA,
    cast(DTQ.DTQ_DATFEC as date) as DT_FECVGA,
    cast(DTQ.DTQ_DATENC as date) as DT_ENCVGA,

    substring(DTQ.DTQ_DATGER, 1, 6) as PERIODO_GERVGA,
    substring(DTQ.DTQ_DATFEC, 1, 6) as PERIODO_FECVGA,
    substring(DTQ.DTQ_DATENC, 1, 6) as PERIODO_ENCVGA,

    case DTQ.DTQ_STATUS
        when '1' then upper('Em Aberto')
        when '2' then upper('Em Transito')
        when '3' then upper('Encerrada')
        when '4' then upper('Chegada em Filial')
        when '5' then upper('Fechada')
        when '9' then upper('Cancelada')
        else 'Outros'
    end as STATUS_VGA,

    case DUD.DUD_STATUS
        when 1 then upper('Em Aberto')
        when 2 then upper('Em Transito')
        when 3 then upper('Carregado')
        when 4 then upper('Encerrado')
        when 9 then upper('Cancelado')
        else 'Outros'
    end as STATUS_DOC,

    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    trim(DEV.A1_COD) as DEV_COD,
    trim(DEV.A1_LOJA) as DEV_LOJA,
    trim(DEV.A1_NOME) as CLI_DEVEDOR,
    trim(REM.A1_COD) as REM_COD,
    trim(REM.A1_LOJA) as REM_LOJA,
    trim(REM.A1_NOME) as CLI_ORIGEM,
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
                        and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                )
            , APT.DTW_YHODFI)
        from DTW010 APT (nolock)
        where
                APT.D_E_L_E_T_ = ''
            and APT.DTW_FILORI = DTR.DTR_FILORI
            and APT.DTW_VIAGEM = DTR.DTR_VIAGEM
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
                        and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                )
            , APT.DTW_YHODIN)
        from DTW010 APT (nolock)
        where
                APT.D_E_L_E_T_ = ''
            and APT.DTW_FILORI = DTR.DTR_FILORI
            and APT.DTW_VIAGEM = DTR.DTR_VIAGEM
            and APT.DTW_ATIVID = 49
    ) as km_ini,

    DTR.DTR_ITEM,
    DUP.DUP_CODMOT,
    DA4.DA4_MAT,
    trim(DA4.DA4_NOME) as DA4_NOME,
    DA4.DA4_FORNEC,
    DA4.DA4_LOJA,

    DTR.DTR_CODVEI,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODVEI) as PLACA_VEI,
    DTR.DTR_CODRB1,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB1) as PLACA_RB1,
    DTR.DTR_CODRB2,
    DTR.DTR_CODRB3,

    DT6.DT6_VALFRE/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as CTE_RAT,

    COMP.D2_TOTAL/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as COMP_RAT,

    RPS.D2_TOTAL/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as RPS_RAT,

    SE1.E1_VALOR/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as ND_RAT,
    
    DT6.DT6_VALIMP/
    (
        isnull((select nullif(count(DTR010.DTR_CODVEI), '') from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM), 1)
        *
        isnull
        (
            (
                select nullif(count(DTC010.DTC_NUMNFC), '')
                from DTC010 (nolock)
                where
                        DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
                    and DTC010.DTC_DOC = DT6.DT6_DOC
                    and DTC010.DTC_SERIE = DT6.DT6_SERIE
            ), 1
        )
    ) as IMPOSTO_CM,
    
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,
    DT6.DT6_VALMER,

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

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

    trim(DUA.DUA_NUMVTR) as VGATRA_OCOR,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,
    
    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as TIPO_VGA,
    cast(DF1.DF1_DATCON as date) as DT_AGE,
    left(DF1.DF1_DATCON, 6) as PERIODO_AGE,
    datetimefromparts(year(DF1.DF1_YDTCON), month(DF1.DF1_YDTCON), day(DF1.DF1_YDTCON), substring(DF1.DF1_YHRCON, 1, 2), substring(DF1.DF1_YHRCON, 4, 5), 0, 0) as DATA_CONTEINER,
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
    DF1.DF1_YARMAD as ARMADORA,
    DF1.DF1_YLJARM as LOJA_ARMADORA,
    DF1.DF1_CODOBC,
    DF1.DF1_YDSARM as NOME_ARMADORA,

    COMP.D2_DOC as COMP_DOC,
    COMP.D2_SERIE as COMP_SERIE,
    COMP.D2_TOTAL as COMP_TOTAL,
    COMP.D2_VALIPI as COMP_VALIPI,
    COMP.D2_VALICM as COMP_VALICM,
    cast(COMP.D2_EMISSAO as date) as COMP_EMISSAO,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    cast(RPS.D2_EMISSAO as date) as RPS_EMISSAO,

    SE1.E1_NUM as ND_TITULO,
    SE1.E1_VALOR as ND_VALOR,
    SE1.E1_EMISSAO as ND_EMISSAO,

    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as DATAINI,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as HORAINI,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as HORAFIM,
    (
        select top 1 first_value(cast(DTW010.DTW_DATREA as date)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 57
    ) as DATA_CHECLI,
    (
        select top 1 first_value(DTW010.DTW_HORREA) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 57
    ) as HORA_CHECLI,
    (
        select top 1 first_value(cast(DTW010.DTW_DATREA as date)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 56
    ) as DATA_SAICLI,
    (
        select top 1 first_value(DTW010.DTW_HORREA) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 56
    ) as HORA_SAICLI,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA

from DTQ010 DTQ (nolock)
    inner join DA8010 DA8 (nolock)
        on DA8.D_E_L_E_T_ = ''
        and DA8.DA8_COD = DTQ.DTQ_ROTA
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM

        inner join DUP010 DUP (nolock)
            on DUP.D_E_L_E_T_ = ''
            and DUP.DUP_FILORI = DTR.DTR_FILORI
            and DUP.DUP_VIAGEM = DTR.DTR_VIAGEM
            and DUP.DUP_ITEDTR = DTR.DTR_ITEM
            and DUP.DUP_CODVEI = DTR.DTR_CODVEI

            inner join DA4010 DA4 (nolock)
                on DA4.DA4_COD = DUP.DUP_CODMOT

    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = DTQ.DTQ_FILORI
        and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM

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

            left join SD2010 COMP (nolock)
                on COMP.D_E_L_E_T_ = ''
                and COMP.D2_NFORI = DT6.DT6_DOC
                and COMP.D2_SERIORI = DT6.DT6_SERIE
                and COMP.D2_CLIENTE = DT6.DT6_CLIDEV
                and COMP.D2_LOJA = DT6.DT6_LOJDEV

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
            ON DUYORI.DUY_FILIAL = DT6_FILIAL
            AND DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
            AND DUYORI.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDES
            ON DUYDES.DUY_FILIAL = DT6_FILIAL
            AND DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
            AND DUYDES.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDEV
            ON DUYDEV.DUY_FILIAL = DT6_FILIAL
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
            and DTC.DTC_FILDOC = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE

            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_ = ''
                and SB1.B1_COD = DTC.DTC_CODPRO
    
    left join SC5010 SC5 (nolock)
        on SC5.D_E_L_E_T_ = ''
        and trim(SC5.C5_YVIAGEM) = DTQ.DTQ_VIAGEM

        left join SD2010 RPS (nolock)
            on RPS.D_E_L_E_T_ = ''
            and RPS.D2_FILIAL = SC5.C5_FILIAL
            and RPS.D2_DOC = SC5.C5_NOTA
            and RPS.D2_SERIE = SC5.C5_SERIE
            and RPS.D2_CLIENTE = SC5.C5_CLIENTE
            and RPS.D2_LOJA = SC5.C5_LOJACLI
    
    left join SE1010 SE1 (nolock)
        on SE1.D_E_L_E_T_ = ''
        and (trim(SE1.E1_YVIATMS) = DTQ.DTQ_VIAGEM or SE1.E1_YVIAGEM = DTQ.DTQ_VIAGEM)
where
        DTQ.D_E_L_E_T_ = ''
