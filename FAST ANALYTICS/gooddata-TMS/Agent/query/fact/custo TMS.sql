select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DTQ.DTQ_KMVGE,

    DT6.DT6_CDRORI,
    DT6.DT6_CDRDES,
    DT6.DT6_CDRCAL,

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

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    DTC.DTC_FILORI,
    DTC.DTC_DOC,
    DTC.DTC_SERIE,
    DTC.DTC_VALOR,

    DTC.DTC_VALOR *
    (
        select case DU5010.DU5_INTERV when 1000 then (DU5010.DU5_VALOR/10)/100 else (DU5010.DU5_VALOR)/100 end
        from DU5010 (nolock)
            inner join DTC010 (nolock)
                on DTC010.D_E_L_E_T_ = ''
                and DU5010.DU5_CDRORI = DTC010.DTC_CDRORI
                and DU5010.DU5_CDRDES = DTC010.DTC_CDRCAL
        where
                DU5010.D_E_L_E_T_ = ''
            and DTC010.DTC_FILORI = DTC.DTC_FILORI
            and DTC010.DTC_NUMNFC = DTC.DTC_NUMNFC
            and DTC010.DTC_SERNFC = DTC.DTC_SERNFC
            and DTC010.DTC_FILDOC = DT6.DT6_FILDOC
            and DTC010.DTC_DOC = DT6.DT6_DOC
            and DTC010.DTC_SERIE = DT6.DT6_SERIE
    ) as SEGURO,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,

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
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = DTQ.DTQ_FILORI
        and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM
        and DUD.DUD_STATUS = DTQ.DTQ_STATUS

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
                on DUYORI.DUY_FILIAL = DT6_FILIAL
                and DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
                and DUYORI.D_E_L_E_T_ = ' '
            left join DUY010 DUYDES
                on DUYDES.DUY_FILIAL = DT6_FILIAL
                and DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
                and DUYDES.D_E_L_E_T_ = ' '
            left join DUY010 DUYDEV
                on DUYDEV.DUY_FILIAL = DT6_FILIAL
                and DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
                and DUYDEV.D_E_L_E_T_ = ' '
            left join DDB010 DDB
                on DDB.DDB_FILIAL = DT6_FILIAL
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
where
        DTQ.D_E_L_E_T_ = ''
    and DTQ.DTQ_DATGER > '20211231'
