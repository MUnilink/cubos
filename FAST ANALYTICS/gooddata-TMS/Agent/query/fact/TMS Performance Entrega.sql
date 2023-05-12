SELECT
    'P |01|01' AS BK_EMPRESA,
    CASE
        WHEN DT6_FILIAL IS NULL THEN 'P |01||'
        ELSE 'P |01|01'+ CAST(DT6_FILIAL AS CHAR (8))
    END AS BK_FILIAL,
    VIAGEM.CHE_CLIDEV_REAL AS DATA_EMISSAO,
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
    DT6.DT6_DOC AS DOCUMENTO,
    DT6.DT6_SERIE AS SERIE,
    
    DF1.CHE_CLIDEV_PREV as PRAZO_ENTREGA,
    VIAGEM.CHE_CLIDEV_REAL as DATA_ENTREGA,

    case when DF1.CHE_CLIDEV_PREV < VIAGEM.CHE_CLIDEV_REAL then 'FORA DO PRAZO' else 'DENTRO DO PRAZO' end as BK_STATUS,
    
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
        WHEN DUYDEV.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' '))+RTRIM(COALESCE(DUYDEV.DUY_CODMUN, ' ')), ' '), '|')
    END AS BK_REGIAO_CDRCAL,
    CASE
        WHEN DUYORI.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' ')), ' '), '|')
        ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' '))+RTRIM(COALESCE(DUYORI.DUY_CODMUN, ' ')), ' '), '|')
    END AS BK_REGIAO_CDRORI,
    1 AS INSTANCIA,

    VIAGEM.CHE_CLIDEV_REAL,
    VIAGEM.SAI_CLIDEV_REAL,
    VIAGEM.SAI_VIAGEM_REAL,
    VIAGEM.CHE_VIAGEM_REAL,

    VIAGEM.ID_VIAGEM,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,
    DF1.DF1_YOSCLI,
    1 as FATO1

FROM DT6010 DT6
    LEFT JOIN SA1010 REM
        ON REM.A1_FILIAL = '      '
        AND REM.A1_COD = DT6.DT6_CLIREM
        AND REM.A1_LOJA = DT6.DT6_LOJREM
        AND REM.D_E_L_E_T_ = ' '
    LEFT JOIN SA1010 DES
        ON DES.A1_FILIAL = '      '
        AND DES.A1_COD = DT6.DT6_CLIDES
        AND DES.A1_LOJA = DT6.DT6_LOJDES
        AND DES.D_E_L_E_T_ = ' '
    LEFT JOIN SA1010 DEV
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

    left join /* ver modelo para adição de dimensão motorista */
    (
        select
            DA4010.DA4_COD,
            DTR.DTR_CODVEI,
            DTR.DTR_CODRB1,
            DTR.DTR_CODRB2,
            DTR.DTR_CODRB3,

            concat(trim(DUD.DUD_FILDOC), trim(DUD.DUD_VIAGEM)) as ID_VIAGEM,
            concat(trim(DA4010.DA4_FILATU), trim(DA4010.DA4_COD)) as ID_MOTORISTA,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
            (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3,

            (
                select
                        top 1 concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DUD.DUD_FILORI
                    and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 57 /*58 PONTO DE APOIO*/
                    and DTW010.DTW_CODCLI != 761
                order by DTW010.DTW_SEQUEN
            ) as CHE_CLIDEV_REAL,
            (
                select
                        top 1 concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DUD.DUD_FILORI
                    and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 56 /*58 PONTO DE APOIO*/
                    and DTW010.DTW_CODCLI != 761
                order by DTW010.DTW_SEQUEN
            ) as SAI_CLIDEV_REAL,

            (
                select
                        concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DUD.DUD_FILORI
                    and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 49
            ) as SAI_VIAGEM_REAL,
            (
                select
                        concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                from DTW010
                where
                        DTW010.D_E_L_E_T_ = ''
                    and DTW010.DTW_FILORI = DUD.DUD_FILORI
                    and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                    and DTW010.DTW_SYSHOR != ''
                    and DTW010.DTW_SYSDAT != ''
                    and DTW010.DTW_ATIVID = 50
            ) as CHE_VIAGEM_REAL,
            
            DUD.DUD_FILDOC,
            DUD.DUD_DOC,
            DUD.DUD_SERIE,
            DUD.DUD_VIAGEM

        from DUD010 DUD
            left join DTR010 DTR
                on DTR.D_E_L_E_T_ = ''
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

        where DUD.D_E_L_E_T_ = ''
    ) VIAGEM
        on DT6.DT6_FILDOC = VIAGEM.DUD_FILDOC
        and DT6.DT6_DOC = VIAGEM.DUD_DOC
        and DT6.DT6_SERIE = VIAGEM.DUD_SERIE

        left join
        (
            select
                DF1010.DF1_NUMAGE,
                DF1010.DF1_YOSCLI,
                DTC010.DTC_FILDOC,
                DTC010.DTC_DOC,
                DTC010.DTC_SERIE,

                case when concat(DF1010.DF1_DATPRC, DF1010.DF1_HORPRC) = concat(DF1010.DF1_DATPRE, DF1010.DF1_HORPRE) and DF1010.DF1_DATPRC != ''
                    then concat(DF1010.DF1_DATPRC, ' ', concat(substring(DF1010.DF1_HORPRC, 1, 2), ':', substring(DF1010.DF1_HORPRC, 3, 2), ':', substring(DF1010.DF1_HORPRC, 5, 2), '00'))
                    else null
                end as CHE_CLIDEV_PREV

            from DF1010
                inner join DTC010
                    on DTC010.D_E_L_E_T_ = ''
                    and DTC010.DTC_FILDOC = DF1010.DF1_FILDOC
                    and DTC010.DTC_NUMSOL = DF1010.DF1_DOC
            where
                    DF1010.D_E_L_E_T_ = ''
                and (DF1010.DF1_HORPRC != '' or DF1010.DF1_HORPRE != '')
                and (DF1010.DF1_DATPRC != '' or DF1010.DF1_DATPRE != '')
        ) DF1
            on DF1.DTC_FILDOC = VIAGEM.DUD_FILDOC
            and DF1.DTC_DOC = VIAGEM.DUD_DOC
            and DF1.DTC_SERIE = VIAGEM.DUD_SERIE
where
        VIAGEM.CHE_CLIDEV_REAL between <<START_DATE>> and <<FINAL_DATE>>
    AND DT6.D_E_L_E_T_ = ' '
    AND DT6.DT6_DATENT <> ' '
    AND DT6.DT6_SERIE <> 'COL'
    AND DT6.DT6_SERIE <> 'PED'
