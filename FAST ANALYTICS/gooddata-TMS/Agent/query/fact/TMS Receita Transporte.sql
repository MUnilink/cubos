SELECT 'P |01|01' AS BK_EMPRESA,
       CASE
           WHEN DT8_FILIAL IS NULL THEN 'P |01||'
           ELSE 'P |01|01'+ CAST(DT8_FILIAL AS CHAR (8))
       END AS BK_FILIAL,
       VIAGEM.DATAFIM AS DATA_EMISSAO,
       'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
       'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
       'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
       'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
       'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
       'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
       'P |01|DT3010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DT3_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT8_CODPAS, ' ')), ' '), '|') AS BK_COMPONENTE,
       'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
       'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
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
       DT8_FILDOC AS FILDOC,
       DT8_DOC AS DOCUMENTO,
       DT8_SERIE AS SERIE,
       DT8_CODPRO AS PRODUTO,
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
       CASE
           WHEN DT6_FILORI IS NULL THEN 'P |01||'
           ELSE 'P |01|01'+ CAST(DT6_FILORI AS CHAR (8))
       END AS BK_FILIAL_ORIGEM,
       CAST(COALESCE(DT8_VALPAS, 0) AS DECIMAL(14, 2)) AS VALOR_COMPONENTE,
       CAST(COALESCE(DT8_VALIMP, 0) AS DECIMAL(14, 2)) AS VALOR_IMPOSTO,
       CAST(COALESCE(DT8_VALTOT, 0) AS DECIMAL(14, 2)) AS VALOR_TOTAL,
       null as INSTANCIA,
       DT6_DATEMI as DATA_DOC,
        
        VIAGEM.ID_VIAGEM,
        VIAGEM.ID_VEICULO_CM,
        VIAGEM.ID_VEICULO_RB1,
        VIAGEM.ID_VEICULO_RB2,
        VIAGEM.ID_VEICULO_RB3,
        VIAGEM.ID_MOTORISTA

FROM DT8010 DT8
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

        inner join DUD010 DUD
            on DUD.D_E_L_E_T_ = ''
            and DUD.DUD_FILDOC = DT6.DT6_FILDOC
            and DUD.DUD_DOC = DT6.DT6_DOC
            and DUD.DUD_SERIE = DT6.DT6_SERIE

            left join /* ver modelo para adição de dimensão motorista */
            (
                select
                    DTQ.DTQ_FILIAL,
                    DTQ.DTQ_FILORI,
                    DTQ.DTQ_VIAGEM,
                    DTQ.DTQ_DATGER,
                    DTQ.DTQ_DATFEC,
                    DTQ.DTQ_DATENC,
                    (
                        select DTW010.DTW_DATREA
                        from DTW010 (nolock)
                        where 
                                DTW010.D_E_L_E_T_ = ''
                            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                            and DTW010.DTW_ATIVID = '050'
                    ) as DATAFIM,

                    concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
                    concat(trim(DA4010.DA4_FILATU), trim(DA4010.DA4_COD)) as ID_MOTORISTA,
                    (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODVEI) as ID_VEICULO_CM,
                    (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB1) as ID_VEICULO_RB1,
                    (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB2) as ID_VEICULO_RB2,
                    (select concat(trim(DA3010.DA3_FILATU), trim(DA3010.DA3_COD)) from DA3010 where DA3010.D_E_L_E_T_ = '' and DA3010.DA3_FILATU = DTR.DTR_FILORI and DA3010.DA3_COD = DTR.DTR_CODRB3) as ID_VEICULO_RB3
                from DTQ010 DTQ (nolock)
                    inner join DTR010 DTR (nolock)
                        on DTR.D_E_L_E_T_ = ''
                        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
                        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
                        
                        inner join DUP010 (nolock)
                            on DUP010.D_E_L_E_T_ = ''
                            and DUP010.DUP_FILORI = DTR.DTR_FILORI
                            and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                            and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                            and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                            inner join DA4010 (nolock)
                                on DA4010.D_E_L_E_T_ = ''
                                and DA4010.DA4_COD = DUP010.DUP_CODMOT
                where DTQ.D_E_L_E_T_ = ''
            ) VIAGEM
                on substring(VIAGEM.DTQ_FILIAL, 1, 4) = DUD.DUD_FILIAL
                and VIAGEM.DTQ_FILORI = DUD.DUD_FILORI
                and VIAGEM.DTQ_VIAGEM = DUD.DUD_VIAGEM

    INNER JOIN DT3010 DT3
        ON DT3.DT3_FILIAL = DT8_FILIAL
        AND DT3.DT3_CODPAS = DT8.DT8_CODPAS
        AND DT3.D_E_L_E_T_ = ' '
WHERE
        DT6.DT6_DATEMI BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
    and DT8.D_E_L_E_T_ = ' '
