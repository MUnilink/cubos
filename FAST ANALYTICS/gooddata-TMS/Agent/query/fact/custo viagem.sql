select
    'P |01|01' AS BK_EMPRESA,
    VIAGEM.DTQ_FILORI,
    VIAGEM.DTQ_VIAGEM,
    
    VIAGEM.CHE_CLIDEV,
    VIAGEM.SAI_CLIDEV,
    VIAGEM.CHE_VIAGEM,
    VIAGEM.SAI_VIAGEM,
    VIAGEM.DTQ_STATUS,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI, /* CONVERT TEMPORÁRIO ATÉ CRIAÇÃO DO ETL*/

    (
        select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010
            inner join ZB1010
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
            and ZB1010.ZB1_CODDA3 = VIAGEM.ID_VEICULO_CM
            and DTW010.DTW_ATIVID = 50
    ) as km_fim,
    (
        select top 1 substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010
            inner join ZB1010
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
            and ZB1010.ZB1_CODDA3 = VIAGEM.ID_VEICULO_CM
            and DTW010.DTW_ATIVID = 49
    ) as km_ini,
    
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,

    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6.DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
    'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB.DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB.DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6.DT6_DOCTMS, ' ')), ' '), '|') AS BK_DOCTMS,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6.DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
    CASE WHEN DT6.DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
    CASE WHEN DT6.DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
    CASE WHEN DT6.DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
    CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
    CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
    CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
    CASE WHEN DT6.DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
    DTC.DTC_CODPRO as PRODUTO,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,

    DIARIAS.DYV_IDCDIA,
    DIARIAS.DYX_DATDIA,
    DIARIAS.DYX_VLRUNI,
    VIAGEM.ID_VIAGEM,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,
    
    null as INSTANCIA,
    null as SEGURO_CARGA, /* PLANILHA DE SEGURO */
    null as OUTROS_CUSTOS

from
    (
        select
            DTQ.DTQ_FILIAL,
            DTQ.DTQ_FILORI,
            DTQ.DTQ_VIAGEM,
            DTQ.DTQ_DATGER,
            DTQ.DTQ_DATFEC,
            DTQ.DTQ_DATENC,
            
            DA4010.DA4_COD,
            concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
            concat(trim(DA4010.DA4_FILATU), trim(DA4010.DA4_COD)) as ID_MOTORISTA,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,

            (
                select
                        first_value(datetimefromparts(year(DTW010.DTW_SYSDAT), month(DTW010.DTW_SYSDAT), day(DTW010.DTW_SYSDAT), substring(DTW010.DTW_SYSHOR, 1, 2), substring(DTW010.DTW_SYSHOR, 3, 4), substring(DTW010.DTW_SYSHOR, 5, 6), 0))
                        over
                        (
                            partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID, DTW010.DTW_SEQUEN
                            order by DTW010.DTW_SEQUEN
                        )
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = 57 /*58 PONTO DE APOIO*/
                    and DTW010.DTW_CODCLI != 761
            ) as CHE_CLIDEV,
            (
                select
                        first_value(datetimefromparts(year(DTW010.DTW_SYSDAT), month(DTW010.DTW_SYSDAT), day(DTW010.DTW_SYSDAT), substring(DTW010.DTW_SYSHOR, 1, 2), substring(DTW010.DTW_SYSHOR, 3, 4), substring(DTW010.DTW_SYSHOR, 5, 6), 0))
                        over
                        (
                            partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID, DTW010.DTW_SEQUEN
                            order by DTW010.DTW_SEQUEN
                        )
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = 56 /*58 PONTO DE APOIO*/
                    and DTW010.DTW_CODCLI != 761
            ) as SAI_CLIDEV,

            (
                select
                        datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = 49
            ) as SAI_VIAGEM,
            (
                select
                        datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                    and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                    and DTW010.DTW_ATIVID = 50
            ) as CHE_VIAGEM,

            case DTQ.DTQ_STATUS
                when '1' then 'EXCLUÍDA'
                when '2' then 'EM TRANSITO'
                when '3' then 'ENCERRADA'
                when '4' then 'CHEGADA EM FILIAL'
                when '5' then 'FECHADA'
                when '9' then 'CANCELADA'
                else 'OUTROS'
            end as DTQ_STATUS

        from DTQ010 DTQ
            inner join DTR010 DTR
                on DTR.D_E_L_E_T_ = ''
                and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                
                inner join DUP010
                    on DUP010.D_E_L_E_T_ = ''
                    and DUP010.DUP_FILORI = DTR.DTR_FILORI
                    and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                    and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                    and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                    inner join DA4010
                        on DA4010.D_E_L_E_T_ = ''
                        and DA4010.DA4_COD = DUP010.DUP_CODMOT

        where DTQ.D_E_L_E_T_ = ''
    ) VIAGEM

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
        from DYV010
            inner join DYX010
                on DYX010.D_E_L_E_T_ = ''
                and DYX010.DYX_IDCDIA = DYV010.DYV_IDCDIA
        where DYV010.D_E_L_E_T_ = ''
    ) DIARIAS
        on DIARIAS.DYV_FILORI = VIAGEM.DTQ_FILORI
        and DIARIAS.DYV_VIAGEM = VIAGEM.DTQ_VIAGEM
        and DIARIAS.DYV_CODMOT = VIAGEM.DA4_COD
    
    left join DUD010 DUD
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
        and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM
        
        left join DT5010 DT5
            on DT5.D_E_L_E_T_ = ''
            and DT5.DT5_FILDOC = DUD.DUD_FILDOC
            and DT5.DT5_NUMSOL = DUD.DUD_DOC
            and DT5.DT5_SERIE = DUD.DUD_SERIE
        left join DT6010 DT6
            on DT6.D_E_L_E_T_ = ''
            and DT6.DT6_FILDOC = DUD.DUD_FILDOC
            and DT6.DT6_DOC = DUD.DUD_DOC
            and DT6.DT6_SERIE = DUD.DUD_SERIE

            left join DTC010 DTC
                on DTC.D_E_L_E_T_ = ''
                and DTC.DTC_FILORI = DT6.DT6_FILDOC
                and DTC.DTC_DOC = DT6.DT6_DOC
                and DTC.DTC_SERIE = DT6.DT6_SERIE
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
