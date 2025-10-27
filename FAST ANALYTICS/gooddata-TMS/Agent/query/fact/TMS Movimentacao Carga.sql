SELECT
    'P |01|01' AS BK_EMPRESA,
    CASE
        WHEN DT6_FILIAL IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILIAL AS CHAR (8))
    END AS BK_FILIAL,
    DT6_DATEMI AS DATA_EMISSAO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
    'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB_CODNEG, ' ')), ' '), '|') AS BK_CODNEG,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_SERVIC, ' ')), ' '), '|') AS BK_SERNEG,
    CASE
        WHEN DT6_FILORI IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILORI AS CHAR (8))
    END AS BK_FILIAL_ORIGEM,
    CASE
        WHEN DT6_FILDES IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILDES AS CHAR (8))
    END AS BK_FILIAL_DESTINO,
    CASE
        WHEN DT6_FILDOC IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILDOC AS CHAR (8))
    END AS BK_FILIAL_DOCTO,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_DOCTMS, ' ')), ' '), '|') AS BK_DOCTMS,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
    CASE
        WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|')
    END AS BK_REGIAO_REM,
    CASE
        WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|')
    END AS BK_REGIAO_DES,
    CASE
        WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|')
    END AS BK_REGIAO_DEV,
    CASE
        WHEN DUYCAL.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYCAL.DUY_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYCAL.DUY_EST, ' '))+RTRIM(COALESCE(DUYCAL.DUY_CODMUN, ' ')), ' '), '|')
    END AS BK_REGIAO_CDRCAL,
    CASE
        WHEN DUYORI.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' '))+RTRIM(COALESCE(DUYORI.DUY_CODMUN, ' ')), ' '), '|')
    END AS BK_REGIAO_CDRORI,

    'CTRC' + DT6.DT6_DOC as ID_DOCUMENTO,

    CAST(COALESCE(DT6_PESO, 0) AS DECIMAL(11, 4)) AS PESO,
    CAST(COALESCE(DT6_PESOM3, 0) AS DECIMAL(11, 4)) AS PESO_CUBADO,
    CAST(COALESCE(DT6_METRO3, 0) AS DECIMAL(11, 4)) AS PESO_M3,
    CAST(COALESCE(DT6_VOLORI, 0) AS DECIMAL(5, 0)) AS VOLUME,
    CAST(COALESCE(DT6_VALMER, 0) AS DECIMAL(14, 2)) AS VALOR_MERCADORIA,
    CAST(COALESCE(DT6_VALTOT, 0) AS DECIMAL(14, 2)) AS VALOR_TOTAL,
    <<CODE_INSTANCE>> AS INSTANCIA,

    VIAGEM.ID_VIAGEM,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,

    cast
    (
        (
            select
                coalesce
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
                    ),
                    nullif(APT.DTW_YHODFI, ''),
                    0
                )
            from DTW010 APT (nolock)
            where
                    APT.D_E_L_E_T_ = ''
                and concat(APT.DTW_FILORI, APT.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
                and APT.DTW_ATIVID = 50
        ) as numeric(15, 2)
    ) -
    cast
    (
        (
            select
                coalesce
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
                    ),
                    nullif(APT.DTW_YHODIN, ''),
                    0
                )
            from DTW010 APT (nolock)
            where
                    APT.D_E_L_E_T_ = ''
                and concat(APT.DTW_FILORI, APT.DTW_VIAGEM) = VIAGEM.ID_VIAGEM
                and APT.DTW_ATIVID = 49
        ) as numeric(15, 2)
    ) as km
FROM DT6010 DT6
    INNER JOIN SA1010 REM
        ON REM.A1_FILIAL = '      '
        AND REM.A1_COD = DT6.DT6_CLIREM
        AND REM.A1_LOJA = DT6.DT6_LOJREM
        AND REM.D_E_L_E_T_ = ' '
    INNER JOIN SA1010 DES
        ON DES.A1_FILIAL = '      '
        AND DES.A1_COD = DT6.DT6_CLIDES
        AND DES.A1_LOJA = DT6.DT6_LOJDES
        AND DES.D_E_L_E_T_ = ' '
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
    LEFT JOIN DUY010 DUYCAL
        ON DUYCAL.DUY_FILIAL = DT6_FILIAL
        AND DUYCAL.DUY_GRPVEN = DT6.DT6_CDRCAL
        AND DUYCAL.D_E_L_E_T_ = ' '
    LEFT JOIN DDB010 DDB
        ON DDB.DDB_FILIAL = DT6_FILIAL
        AND DDB.DDB_CODNEG = DT6.DT6_CODNEG
        AND DDB.D_E_L_E_T_ = ' '
    INNER JOIN SX5010 SX5
        ON SX5.X5_FILIAL = '      ' /*SUBSTRING(DT6_FILIAL, 1, 5) + SUBSTRING(X5_FILIAL, 6, 8)*/
        AND SX5.X5_TABELA = 'L4'
        AND SX5.X5_CHAVE = DT6.DT6_SERVIC
        AND SX5.D_E_L_E_T_ = ' '
    
    left join
        (
            select
                (select DTQ010.DTQ_DATGER from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATGER,
                (select DTQ010.DTQ_DATFEC from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATFEC,
                (select DTQ010.DTQ_DATENC from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATENC,
                DUD.DUD_FILORI,
                DUD.DUD_FILDOC,
                DUD.DUD_DOC,
                DUD.DUD_SERIE,
                DUD.DUD_VIAGEM,
                (
                    select DTW010.DTW_DATREA
                    from DTW010 (nolock)
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DUD.DUD_FILORI
                        and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                        and DTW010.DTW_ATIVID = 50
                ) as DATAFIM,

                concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) as ID_VIAGEM,
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3
            from DUD010 DUD (nolock)
                left join DTR010 DTR (nolock)
                    on DTR.D_E_L_E_T_ = ''
                    and DTR.DTR_FILORI = DUD.DUD_FILORI
                    and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM
                    
                    left join DUP010 (nolock)
                        on DUP010.D_E_L_E_T_ = ''
                        and DUP010.DUP_FILORI = DTR.DTR_FILORI
                        and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                        and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                        and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                        left join DA4010 (nolock)
                            on DA4010.D_E_L_E_T_ = ''
                            and DA4010.DA4_COD = DUP010.DUP_CODMOT
            where DUD.D_E_L_E_T_ = ''
        ) VIAGEM
            on VIAGEM.DUD_FILORI = DT6.DT6_FILORI
            and VIAGEM.DUD_FILDOC = DT6.DT6_FILDOC
            and VIAGEM.DUD_DOC = DT6.DT6_DOC
            and VIAGEM.DUD_SERIE = DT6.DT6_SERIE
WHERE
        DT6.DT6_DOCTMS <> '1'
    AND DT6.D_E_L_E_T_ = ' '
