select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DA8.DA8_DESC,
    DTQ.DTQ_KMVGE,
    
    DTQ.DTQ_DATGER,
    DTQ.DTQ_DATFEC,
    DTQ.DTQ_DATENC,

    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    trim(DEV.A1_COD) as A1_COD,
    trim(DEV.A1_LOJA) as A1_LOJA,
    trim(DEV.A1_NOME) as CLIENTE,

    (
        select substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010 (nolock)
            inner join ZB1010 (nolock)
                on ZB1010.D_E_L_E_T_ = ''
                and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                and
                    dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                    =
                    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('050')
    ) as km_fim,
    (
        select substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010 (nolock)
            inner join ZB1010 (nolock)
                on ZB1010.D_E_L_E_T_ = ''
                and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                and
                    dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                    =
                    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        where
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('049')
    ) as km_ini,

    DTR.DTR_ITEM,
    DUP.DUP_CODMOT,
    DA4.DA4_MAT,
    DA4.DA4_NOME,
    DA4.DA4_FORNEC,
    DA4.DA4_LOJA,

    DTR.DTR_CODVEI,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODVEI) as PLACA_VEI,
    DTR.DTR_CODRB1,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB1) as PLACA_RB1,
    DTR.DTR_CODRB2,
    DTR.DTR_CODRB3,

    DT6.DT6_VALFRE / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    DTC.DTC_FILORI,
    DTC.DTC_DOC,
    DTC.DTC_SERIE,
    DTC.DTC_NUMNFC,
    DTC.DTC_SERNFC,
    DTC.DTC_VALOR,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,

    DF1.DF1_NUMAGE,
    DF1.DF1_ITEAGE,

    COMP.D2_DOC as COMP_DOC,
    COMP.D2_SERIE as COMP_SERIE,
    COMP.D2_TOTAL as COMP_TOTAL,
    COMP.D2_VALIPI as COMP_VALIPI,
    COMP.D2_VALICM as COMP_VALICM,
    convert(date, COMP.D2_EMISSAO, 103) as COMP_EMISSAO,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    convert(date, RPS.D2_EMISSAO, 103) as RPS_EMISSAO,

    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '049'
    ) as DATAINI,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '049'
    ) as HORAINI,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as DATAFIM,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as HORAFIM,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as COMPETENCIA,

    case DTQ.DTQ_STATUS
        when '1' then 'EXCLUÍDA'
        when '2' then 'EM TRANSITO'
        when '3' then 'ENCERRADA'
        when '4' then 'CHEGADA EM FILIAL'
        when '5' then 'FECHADA'
        when '9' then 'CANCELADA'
        else 'OUTROS'
    end as DTQ_STATUS

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
        and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM

        left join DT5010 DT5 (nolock)
            on DT5.D_E_L_E_T_ = ''
            and DT5.DT5_FILDOC = DUD.DUD_FILDOC
            and DT5.DT5_NUMSOL = DUD.DUD_DOC
            and DUD.DUD_SERIE = 'COL'

		left join DT6010 DT6 (nolock)
			on DT6.D_E_L_E_T_ = ''
			and DT6.DT6_FILDOC = DUD.DUD_FILDOC
			and DT6.DT6_DOC = DUD.DUD_DOC
			and DT6.DT6_SERIE = DUD.DUD_SERIE
            and DT6.DT6_DATEMI > '20211231'

            left join SD2010 COMP (nolock)
                on COMP.D_E_L_E_T_ = ''
                and COMP.D2_NFORI = DT6.DT6_DOC
                and COMP.D2_SERIORI = DT6.DT6_SERIE
                and COMP.D2_CLIENTE = DT6.DT6_CLIDEV
                and COMP.D2_LOJA = DT6.DT6_LOJDEV

            INNER JOIN SA1010 DEV
                ON DEV.A1_FILIAL = '      '
                AND DEV.A1_COD = DT6.DT6_CLIDEV
                AND DEV.A1_LOJA = DT6.DT6_LOJDEV
                AND DEV.D_E_L_E_T_ = ' '

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

            left join DTC010 DTC (nolock)
                on DTC.D_E_L_E_T_ = ''
                and DTC.DTC_FILORI = DT6.DT6_FILDOC
                and DTC.DTC_DOC = DT6.DT6_DOC
                and DTC.DTC_SERIE = DT6.DT6_SERIE

                left join DF1010 DF1 (nolock)
                    on DF1.D_E_L_E_T_ = ''
                    and DF1.DF1_FILDOC = DTC.DTC_FILORI
                    and DF1.DF1_DOC = DTC.DTC_NUMSOL
    
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
where /*DTQ_VIAGEM in ('008814', '008816', '008818', '008819', '008820', '008822', '008824', '008825', '008826', '008827', '008829', '008831') AND*/
    (
        DT6.DT6_DOC in ('000002165', '000002166', '000002167', '000002168', '000002169', '000002170', '000002171', '000002172', '000002173', '000002174', '000002175', '000002176', '000002179', '000002180', '000002181', '000002182', '000002184', '000002185', '000002186', '000002187', '000002188', '000002189', '000002190', '000002195', '000002196', '000002203', '000002208', '000002209', '000002210', '000002211', '000002212', '000002213', '000002214', '000002215', '000002216', '000002217', '000002218', '000002219', '000002221', '000002222', '000002227', '000002228', '000002229', '000002230', '000002231', '000002232', '000002233', '000002234', '000002235', '000002246', '000002247', '000002249', '000002250', '000002251', '000002252', '000002253', '000002254', '000002255', '000002256', '000002262', '000002263', '000002264', '000002265', '000002266', '000002267', '000002268', '000002269', '000002270', '000002271', '000002294', '000002295', '000002296', '000002297', '000002298', '000002299', '000002300', '000002301', '000002302', '000002303', '000002304', '000002305', '000002306', '000002307', '000002314', '000002323') or
        COMP.D2_DOC in ('000002165', '000002166', '000002167', '000002168', '000002169', '000002170', '000002171', '000002172', '000002173', '000002174', '000002175', '000002176', '000002179', '000002180', '000002181', '000002182', '000002184', '000002185', '000002186', '000002187', '000002188', '000002189', '000002190', '000002195', '000002196', '000002203', '000002208', '000002209', '000002210', '000002211', '000002212', '000002213', '000002214', '000002215', '000002216', '000002217', '000002218', '000002219', '000002221', '000002222', '000002227', '000002228', '000002229', '000002230', '000002231', '000002232', '000002233', '000002234', '000002235', '000002246', '000002247', '000002249', '000002250', '000002251', '000002252', '000002253', '000002254', '000002255', '000002256', '000002262', '000002263', '000002264', '000002265', '000002266', '000002267', '000002268', '000002269', '000002270', '000002271', '000002294', '000002295', '000002296', '000002297', '000002298', '000002299', '000002300', '000002301', '000002302', '000002303', '000002304', '000002305', '000002306', '000002307', '000002314', '000002323') or
        RPS.D2_DOC in ('000002165', '000002166', '000002167', '000002168', '000002169', '000002170', '000002171', '000002172', '000002173', '000002174', '000002175', '000002176', '000002179', '000002180', '000002181', '000002182', '000002184', '000002185', '000002186', '000002187', '000002188', '000002189', '000002190', '000002195', '000002196', '000002203', '000002208', '000002209', '000002210', '000002211', '000002212', '000002213', '000002214', '000002215', '000002216', '000002217', '000002218', '000002219', '000002221', '000002222', '000002227', '000002228', '000002229', '000002230', '000002231', '000002232', '000002233', '000002234', '000002235', '000002246', '000002247', '000002249', '000002250', '000002251', '000002252', '000002253', '000002254', '000002255', '000002256', '000002262', '000002263', '000002264', '000002265', '000002266', '000002267', '000002268', '000002269', '000002270', '000002271', '000002294', '000002295', '000002296', '000002297', '000002298', '000002299', '000002300', '000002301', '000002302', '000002303', '000002304', '000002305', '000002306', '000002307', '000002314', '000002323')
    ) and
    DTQ.D_E_L_E_T_ = ''
