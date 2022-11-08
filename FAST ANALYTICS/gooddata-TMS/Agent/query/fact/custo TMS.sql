select
    VIAGEM.DTQ_VIAGEM,
    VIAGEM.DTR_CODVEI,
    VIAGEM.DTR_CODRB1,
    VIAGEM.DTR_CODRB3,
    VIAGEM.DTR_CODRB2,
    isnull(VIAGEM.DA4_MAT, VIAGEM.DUP_CODMOT) as ID_MOT,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DT6.DT6_CDRORI,
    DT6.DT6_CDRDES,
    DT6.DT6_CDRCAL,

    (
        select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
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
            and DTW010.DTW_FILORI = VIAGEM.DTQ_FILORI
            and DTW010.DTW_VIAGEM = VIAGEM.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = VIAGEM.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('050')
    ) as km_fim,
    (
        select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
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
            and DTW010.DTW_FILORI = VIAGEM.DTQ_FILORI
            and DTW010.DTW_VIAGEM = VIAGEM.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = VIAGEM.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('049')
    ) as km_ini,
    VIAGEM.DTQ_KMVGE,

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

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
    
    VIAGEM.DTQ_FILORI,

    VIAGEM.DATAINI,
    VIAGEM.HORAINI,
    VIAGEM.DATAFIM,
    VIAGEM.HORAFIM,
    VIAGEM.COMPETENCIA,
    VIAGEM.DTQ_STATUS,

    DIARIAS.DYV_IDCDIA,
    DIARIAS.DYX_DATDIA,
    DIARIAS.DYX_VLRUNI,

    null as OUTROS_CUSTOS,
    null as SEGURO_CARGA /* PLANILHA DE SEGURO */,
    null as SEGURO_VEICULOS,
    null as COMISSOES

from DUD010 DUD (nolock)
    left join /* ver modelo para adição de dimensão motorista */
    (
        select
            DTQ_1.DTQ_FILIAL,
            DTQ_1.DTQ_FILORI,
            DTQ_1.DTQ_VIAGEM,
            DTQ_1.DTQ_DATGER,
            DTQ_1.DTQ_DATFEC,
            DTQ_1.DTQ_DATENC,
            DTQ_1.DTQ_KMVGE,
            
            DTR010.DTR_CODVEI,
            DUP010.DUP_CODMOT,
            DA4010.DA4_MAT,
            DTR010.DTR_CODRB1,
            DTR010.DTR_CODRB2,
            DTR010.DTR_CODRB3,

            (
                select DTW010.DTW_DATREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '049'
            ) as DATAINI,
            (
                select DTW010.DTW_HORREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '049'
            ) as HORAINI,
            (
                select DTW010.DTW_DATREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as DATAFIM,
            (
                select DTW010.DTW_HORREA
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as HORAFIM,

            (
                select substring(DTW010.DTW_DATREA, 1, 6)
                from DTW010 (nolock)
                where 
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ_1.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ_1.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = '050'
            ) as COMPETENCIA,

            case DTQ_1.DTQ_STATUS
                when '1' then 'EXCLUÍDA'
                when '2' then 'EM TRANSITO'
                when '3' then 'ENCERRADA'
                when '4' then 'CHEGADA EM FILIAL'
                when '5' then 'FECHADA'
                when '9' then 'CANCELADA'
                else 'OUTROS'
            end as DTQ_STATUS

        from DTQ010 DTQ_1 (nolock)
            inner join DTR010 (nolock)
                on DTR010.D_E_L_E_T_ = ''
                and DTR010.DTR_FILORI = DTQ_1.DTQ_FILORI
                and DTR010.DTR_VIAGEM = DTQ_1.DTQ_VIAGEM
                
                inner join DUP010 (nolock)
                    on DUP010.D_E_L_E_T_ = ''
                    and DUP010.DUP_FILORI = DTR010.DTR_FILORI
                    and DUP010.DUP_VIAGEM = DTR010.DTR_VIAGEM
                    and DUP010.DUP_ITEDTR = DTR010.DTR_ITEM
                    and DUP010.DUP_CODVEI = DTR010.DTR_CODVEI

                    inner join DA4010 (nolock)
                        on DA4010.D_E_L_E_T_ = ''
                        and DA4010.DA4_COD = DUP010.DUP_CODMOT
        where DTQ_1.D_E_L_E_T_ = ''
    ) VIAGEM
        on year(VIAGEM.DTQ_DATGER) = 2022
        and substring(VIAGEM.DTQ_FILIAL, 1, 4) = DUD.DUD_FILIAL
        and VIAGEM.DTQ_FILORI = DUD.DUD_FILORI
        and VIAGEM.DTQ_VIAGEM = DUD.DUD_VIAGEM
    left join DT5010 DT5 (nolock)
        on DT5.D_E_L_E_T_ = ''
        and DT5.DT5_FILDOC = DUD.DUD_FILDOC
        and DT5.DT5_NUMSOL = DUD.DUD_DOC
        and DT5.DT5_SERIE = DUD.DUD_SERIE
    left join DT6010 DT6 (nolock)
        on DT6.D_E_L_E_T_ = ''
        and DT6.DT6_FILDOC = DUD.DUD_FILDOC
        and DT6.DT6_DOC = DUD.DUD_DOC
        and DT6.DT6_SERIE = DUD.DUD_SERIE

        left join SA1010 REM
            on REM.A1_FILIAL = '      '
            and REM.A1_COD = DT6.DT6_CLIREM
            and REM.A1_LOJA = DT6.DT6_LOJREM
            and REM.D_E_L_E_T_ = ' '
        left join SA1010 DES
            on DES.A1_FILIAL = '      '
            and DES.A1_COD = DT6.DT6_CLIDES
            and DES.A1_LOJA = DT6.DT6_LOJDES
            and DES.D_E_L_E_T_ = ' '
        left join SA1010 DEV
            on DEV.A1_FILIAL = '      '
            and DEV.A1_COD = DT6.DT6_CLIDEV
            and DEV.A1_LOJA = DT6.DT6_LOJDEV
            and DEV.D_E_L_E_T_ = ' '
        left join DUY010 DUYORI
            on DUYORI.DUY_FILIAL = DT6.DT6_FILIAL
            and DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
            and DUYORI.D_E_L_E_T_ = ' '
        left join DUY010 DUYDES
            on DUYDES.DUY_FILIAL = DT6.DT6_FILIAL
            and DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
            and DUYDES.D_E_L_E_T_ = ' '
        left join DUY010 DUYDEV
            on DUYDEV.DUY_FILIAL = DT6.DT6_FILIAL
            and DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
            and DUYDEV.D_E_L_E_T_ = ' '
        left join DDB010 DDB
            on DDB.DDB_FILIAL = DT6.DT6_FILIAL
            and DDB.DDB_CODNEG = DT6.DT6_CODNEG
            and DDB.D_E_L_E_T_ = ' '
        inner join SX5010 SX5
            on SX5.X5_FILIAL = '      ' /*SUBSTRING(DT6_FILIAL, 1, 5) + SUBSTRING(X5_FILIAL, 6, 8)*/
            and SX5.X5_TABELA = 'L4'
            and SX5.X5_CHAVE = DT6.DT6_SERVIC
            and SX5.D_E_L_E_T_ = ' '
        left join DTC010 DTC (nolock)
            on DTC.D_E_L_E_T_ = ''
            and DTC.DTC_FILORI = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE
    left join
    (
        select
            DYV010.DYV_FILORI,
            DYV010.DYV_VIAGEM,
            DYV010.DYV_CODMOT,
            DYV010.DYV_IDCDIA,
            DYX010.DYX_ITEM,
            DYX010.DYX_DATDIA,
            DYX010.DYX_QTDE,
            DYX010.DYX_VLRUNI
        from DYV010 (nolock)
            inner join DYX010 (nolock)
                on DYX010.D_E_L_E_T_ = ''
                and DYX010.DYX_IDCDIA = DYV010.DYV_IDCDIA
                and year(DYX010.DYX_DATDIA) = 2022
        where DYV010.D_E_L_E_T_ = ''
    ) DIARIAS
        on DIARIAS.DYV_FILORI = VIAGEM.DTQ_FILORI
        and DIARIAS.DYV_VIAGEM = VIAGEM.DTQ_VIAGEM
where DUD.D_E_L_E_T_ = ''
