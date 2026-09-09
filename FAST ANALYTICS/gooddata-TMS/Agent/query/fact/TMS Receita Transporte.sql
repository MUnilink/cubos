SELECT
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN DT8_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT8_FILIAL AS CHAR (8)) END AS BK_FILIAL,
    VIAGEM.CHE_CLIDEV_REAL AS DATA_EMISSAO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
    'P |01|DT3010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DT3_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT8_CODPAS, ' ')), ' '), '|') AS BK_COMPONENTE,
    'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
    CASE WHEN DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
    CASE WHEN DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
    CASE WHEN DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_DOCTMS, ' ')), ' '), '|') AS BK_DOCTMS,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
    DT8.DT8_FILDOC AS FILDOC,
    'CTRC' + DT8.DT8_DOC as ID_DOCUMENTO,
    DT8.DT8_CODPRO AS PRODUTO,
    CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
    CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
    CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
    CASE WHEN DUYDEV.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' '))+RTRIM(COALESCE(DUYDEV.DUY_CODMUN, ' ')), ' '), '|') END AS BK_REGIAO_CDRCAL,
    CASE WHEN DUYORI.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' '))+RTRIM(COALESCE(DUYORI.DUY_CODMUN, ' ')), ' '), '|') END AS BK_REGIAO_CDRORI,
    CASE WHEN DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
    CAST(COALESCE(DT8.DT8_VALPAS, 0) AS DECIMAL(14, 2)) AS VALOR_COMPONENTE,
    CAST(COALESCE(DT8.DT8_VALIMP, 0) AS DECIMAL(14, 2)) AS VALOR_IMPOSTO,
    CAST(COALESCE(DT8.DT8_VALTOT, 0) AS DECIMAL(14, 2)) AS VALOR_TOTAL,
    1 as INSTANCIA,
    DT6.DT6_DATEMI as DATA_DOC,
    VIAGEM.CHE_CLIDEV_REAL,
    VIAGEM.SAI_CLIDEV_REAL,
    VIAGEM.SAI_VIAGEM_REAL,
    VIAGEM.CHE_VIAGEM_REAL,

    DF1.ID_AGENDAMENTO,
    VIAGEM.ID_VIAGEM,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,
    VIAGEM.ID_ROTA

FROM DT8010 DT8
    INNER JOIN DT3010 DT3
        ON DT3.DT3_FILIAL = DT8_FILIAL
        AND DT3.DT3_CODPAS = DT8.DT8_CODPAS
        AND DT3.D_E_L_E_T_ = ' '
    INNER JOIN DT6010 DT6
        ON DT6.DT6_FILIAL = DT8_FILIAL
        AND DT6.DT6_FILDOC = DT8.DT8_FILDOC
        AND DT6.DT6_DOC = DT8.DT8_DOC
        AND DT6.DT6_SERIE = DT8.DT8_SERIE
        AND DT6.DT6_SERIE <> 'COL'
        AND DT6.DT6_SERIE <> 'PED'
        AND DT6.D_E_L_E_T_ = ' '

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
        LEFT JOIN DUY010 DUYDEV
            ON DUYDEV.DUY_FILIAL = DT6_FILIAL
            AND DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
            AND DUYDEV.D_E_L_E_T_ = ' '
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
                    concat(trim(DA8010.DA8_FILIAL), trim(DA8010.DA8_COD)) as ID_ROTA,
                    trim(DA8010.DA8_COD) as COD_ROTA,
                    trim(DA8010.DA8_DESC) as NOME_ROTA,
                    DA8010.DA8_YKMVGE as km_ROTA,
                    DA4010.DA4_COD,
                    DTR.DTR_CODVEI,
                    DTR.DTR_CODRB1,
                    DTR.DTR_CODRB2,
                    DTR.DTR_CODRB3,

                    concat(trim(DUD.DUD_FILDOC), trim(DUD.DUD_VIAGEM)) as ID_VIAGEM,
                    trim(DA4010.DA4_COD) as ID_MOTORISTA,
                    (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                    (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                    (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                    (select trim(DA3010.DA3_COD) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,

                    (
                        select top 1 first_value(concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))) over (partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
                        from DTW010
                        where
                                DTW010.D_E_L_E_T_ = ''
                            and DTW010.DTW_FILORI = DUD.DUD_FILORI
                            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                            and DTW010.DTW_HORREA != ''
                            and DTW010.DTW_DATREA != ''
                            and DTW010.DTW_ATIVID = 57 /*58 PONTO DE APOIO*/
                            and DTW010.DTW_CODCLI != 761
                    ) as CHE_CLIDEV_REAL,
                    (
                        select top 1 first_value(concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))) over (partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
                        from DTW010
                        where
                                DTW010.D_E_L_E_T_ = ''
                            and DTW010.DTW_FILORI = DUD.DUD_FILORI
                            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                            and DTW010.DTW_HORREA != ''
                            and DTW010.DTW_DATREA != ''
                            and DTW010.DTW_ATIVID = 56 /*58 PONTO DE APOIO*/
                            and DTW010.DTW_CODCLI != 761
                    ) as SAI_CLIDEV_REAL,

                    (
                        select concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                        from DTW010
                        where
                                DTW010.D_E_L_E_T_ = ''
                            and DTW010.DTW_FILORI = DUD.DUD_FILORI
                            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                            and DTW010.DTW_HORREA != ''
                            and DTW010.DTW_DATREA != ''
                            and DTW010.DTW_ATIVID = 49
                    ) as SAI_VIAGEM_REAL,
                    (
                        select concat(DTW010.DTW_DATREA, ' ', concat(substring(DTW010.DTW_HORREA, 1, 2), ':', substring(DTW010.DTW_HORREA, 3, 2), ':', '00'))
                        from DTW010
                        where
                                DTW010.D_E_L_E_T_ = ''
                            and DTW010.DTW_FILORI = DUD.DUD_FILORI
                            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                            and DTW010.DTW_HORREA != ''
                            and DTW010.DTW_DATREA != ''
                            and DTW010.DTW_ATIVID = 50
                    ) as CHE_VIAGEM_REAL,
                    
                    DUD.DUD_FILIAL,
                    DUD.DUD_FILORI,
                    DUD.DUD_FILDOC,
                    DUD.DUD_DOC,
                    DUD.DUD_SERIE,
                    DUD.DUD_VIAGEM

                from DUD010 DUD
                    left join DTR010 DTR
                        on DTR.D_E_L_E_T_ = ''
                        and DTR.DTR_FILIAL = DUD.DUD_FILIAL
                        and DTR.DTR_FILORI = DUD.DUD_FILORI
                        and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM
                        
                        left join DUP010
                            on DUP010.D_E_L_E_T_ = ''
                            and DUP010.DUP_FILORI = DTR.DTR_FILORI
                            and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                            and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                            and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                            left join DA4010
                                on DA4010.D_E_L_E_T_ = ''
                                and DA4010.DA4_COD = DUP010.DUP_CODMOT
                    
                    left join DTQ010
                        on DTQ010.D_E_L_E_T_ = ''
                        and DTQ010.DTQ_FILIAL = DUD.DUD_FILIAL
                        and DTQ010.DTQ_FILORI = DUD.DUD_FILORI
                        and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM
                        
                        left join DA8010
                            on DA8010.D_E_L_E_T_ = ''
                            and DA8010.DA8_COD = DTQ010.DTQ_ROTA
                where DUD.D_E_L_E_T_ = ''
            ) VIAGEM
                on VIAGEM.DUD_FILDOC = DT6.DT6_FILDOC
                and VIAGEM.DUD_DOC = DT6.DT6_DOC
                and VIAGEM.DUD_SERIE = DT6.DT6_SERIE

                left join
                (
                    select
                        concat(trim(DF1010.DF1_FILIAL), trim(DF1010.DF1_NUMAGE), trim(DF1010.DF1_ITEAGE), trim(DF1010.DF1_FILDOC), trim(DF1010.DF1_DOC), trim(DF1010.DF1_SERIE)) as ID_AGENDAMENTO,
                        DF1010.DF1_NUMAGE,
                        DF1010.DF1_ITEAGE,
                        DF1010.DF1_YOSCLI,
                        DF1010.DF1_FILDOC,
                        DF1010.DF1_DOC,
                        DF1010.DF1_SERIE,
                        DTC010.DTC_FILDOC,
                        DTC010.DTC_DOC,
                        DTC010.DTC_SERIE,
                        concat(DF1010.DF1_DATPRC, DF1010.DF1_HORPRC) as PREV_COL,
                        concat(DF1010.DF1_DATPRE, DF1010.DF1_HORPRE) as PREV_ENT,
                        coalesce
                        (
                            concat(DF1010.DF1_DATPRC, ' ', nullif(trim(concat(substring(DF1010.DF1_HORPRC, 1, 2), ':', substring(DF1010.DF1_HORPRC, 3, 2), ':', substring(DF1010.DF1_HORPRC, 5, 2), '00')), ':  :00')),
                            concat(DF1010.DF1_DATPRE, ' ', nullif(trim(concat(substring(DF1010.DF1_HORPRE, 1, 2), ':', substring(DF1010.DF1_HORPRE, 3, 2), ':', substring(DF1010.DF1_HORPRE, 5, 2), '00')), ':  :00'))
                        ) as CHE_CLIDEV_PREV,

                        /* RM */
                        DTC010.DTC_NUMNFC,
                        DTC010.DTC_SERNFC

                    from DF1010
                        inner join DTC010
                            on DTC010.D_E_L_E_T_ = ''
                            and DTC010.DTC_FILDOC = DF1010.DF1_FILDOC
                            and DTC010.DTC_NUMSOL = DF1010.DF1_DOC
                    where DF1010.D_E_L_E_T_ = ''
                ) DF1
                    on DF1.DTC_FILDOC = VIAGEM.DUD_FILDOC
                    and DF1.DTC_DOC = VIAGEM.DUD_DOC
                    and DF1.DTC_SERIE = VIAGEM.DUD_SERIE

        INNER JOIN SD2010 SD2
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_NFORI = DT6.DT6_DOC
            and SD2.D2_SERIORI = DT6.DT6_SERIE
            and SD2.D2_CLIENTE = DT6.DT6_CLIDEV
            and SD2.D2_LOJA = DT6.DT6_LOJDEV
WHERE
        DT8.D_E_L_E_T_ = ' '
    and DT6.DT6_DATEMI BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
