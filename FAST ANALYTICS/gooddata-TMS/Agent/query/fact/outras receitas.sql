    select
        'P |01|01' AS BK_EMPRESA,
        VIAGEM.DATAFIM as DATA_EMISSAO,
        
        SE1.E1_VALOR as VALOR,
        SE1.E1_EMISSAO as DATA_DOC,

        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6.DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
        'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB.DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB.DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
        'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
        'P |ND' AS BK_DOCTMS,
        'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
        CASE WHEN DT6.DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
        CASE WHEN DT6.DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
        CASE WHEN DT6.DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
        CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
        CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
        CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
        CASE WHEN DT6.DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
        DTC.DTC_CODPRO as PRODUTO,
        'ND' + SE1.E1_NUM AS ID_DOCUMENTO,
        VIAGEM.ID_VIAGEM,
        VIAGEM.ID_VEICULO_CM,
        VIAGEM.ID_VEICULO_RB1,
        VIAGEM.ID_VEICULO_RB2,
        VIAGEM.ID_VEICULO_RB3,
        VIAGEM.ID_MOTORISTA,
        null as INSTANCIA
    from
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
                    from DTW010 
                    where 
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_ATIVID = 50
                ) as DATAFIM,
                
                concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
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
            where DTQ.D_E_L_E_T_ = ''
        ) VIAGEM
        
        inner join SE1010 SE1 
            on SE1.D_E_L_E_T_ = ''
            and SE1.E1_FILIAL = VIAGEM.DTQ_FILORI
            and
            (
                trim(SE1.E1_YVIATMS) = VIAGEM.DTQ_VIAGEM or
                trim(SE1.E1_YVIAGEM) = VIAGEM.DTQ_VIAGEM
            )

        inner join DUD010 DUD
            on DUD.D_E_L_E_T_ = ''
            and DUD.DUD_FILIAL = VIAGEM.DTQ_FILIAL
            and DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
            and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM

            left join DT6010 DT6
                on DT6.D_E_L_E_T_ = ''
                and DT6.DT6_FILDOC = DUD.DUD_FILDOC
                and DT6.DT6_DOC = DUD.DUD_DOC
                and DT6.DT6_SERIE = DUD.DUD_SERIE

                left join DTC010 DTC
                    on DTC.D_E_L_E_T_ = ''
                    and DTC.DTC_FILDOC = DT6.DT6_FILDOC
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
    where
            VIAGEM.DATAFIM BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
union
    select
        'P |01|01' AS BK_EMPRESA,
        VIAGEM.DATAFIM as DATA_EMISSAO,

        RPS.D2_TOTAL as VALOR,
        RPS.D2_EMISSAO as DATA_DOC,

        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6.DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
        'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB.DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB.DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
        'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
        'P |RPS' AS BK_DOCTMS,
        'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
        CASE WHEN DT6.DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
        CASE WHEN DT6.DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
        CASE WHEN DT6.DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
        CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
        CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
        CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
        CASE WHEN DT6.DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
        DTC.DTC_CODPRO as PRODUTO,
        'RPS' + RPS.D2_DOC AS ID_DOCUMENTO,
        VIAGEM.ID_VIAGEM,
        VIAGEM.ID_VEICULO_CM,
        VIAGEM.ID_VEICULO_RB1,
        VIAGEM.ID_VEICULO_RB2,
        VIAGEM.ID_VEICULO_RB3,
        VIAGEM.ID_MOTORISTA,
        null as INSTANCIA
    from
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
                    from DTW010 
                    where 
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_ATIVID = 50
                ) as DATAFIM,
                
                concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
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
            where DTQ.D_E_L_E_T_ = ''
        ) VIAGEM

        inner join SC5010 SC5 
            on SC5.D_E_L_E_T_ = ''
            and SC5.C5_FILIAL = VIAGEM.DTQ_FILORI
            and trim(SC5.C5_YVIAGEM) = VIAGEM.DTQ_VIAGEM

            left join SD2010 RPS 
                on RPS.D_E_L_E_T_ = ''
                and RPS.D2_FILIAL = SC5.C5_FILIAL
                and RPS.D2_DOC = SC5.C5_NOTA
                and RPS.D2_SERIE = SC5.C5_SERIE
                and RPS.D2_CLIENTE = SC5.C5_CLIENTE
                and RPS.D2_LOJA = SC5.C5_LOJACLI

        inner join DUD010 DUD 
            on DUD.D_E_L_E_T_ = ''
            and DUD.DUD_FILIAL = VIAGEM.DTQ_FILIAL
            and DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
            and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM

            left join DT6010 DT6 
                on DT6.D_E_L_E_T_ = ''
                and DT6.DT6_FILDOC = DUD.DUD_FILDOC
                and DT6.DT6_DOC = DUD.DUD_DOC
                and DT6.DT6_SERIE = DUD.DUD_SERIE

                left join DTC010 DTC 
                    on DTC.D_E_L_E_T_ = ''
                    and DTC.DTC_FILDOC = DT6.DT6_FILDOC
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
    where
           VIAGEM.DATAFIM BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
union
    select
        'P |01|01' AS BK_EMPRESA,
        VIAGEM.DATAFIM as DATA_EMISSAO,
        
        DOCAV.DTC_VALOR as VALOR,
        DOCAV.DTC_DATENT as DATA_DOC,

        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6.DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
        'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
        'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
        'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB.DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB.DDB_CODNEG, ' ')), ' '), '|') AS BK_NEGOCIACAO,
        'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
        'P |CTE' AS BK_DOCTMS,
        'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
        CASE WHEN DT6.DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
        CASE WHEN DT6.DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
        CASE WHEN DT6.DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
        CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
        CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
        CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
        CASE WHEN DT6.DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
        DTC.DTC_CODPRO as PRODUTO,
        'DOCAV' + DOCAV.DTC_DOC AS ID_DOCUMENTO,
        VIAGEM.ID_VIAGEM,
        VIAGEM.ID_VEICULO_CM,
        VIAGEM.ID_VEICULO_RB1,
        VIAGEM.ID_VEICULO_RB2,
        VIAGEM.ID_VEICULO_RB3,
        VIAGEM.ID_MOTORISTA,
        null as INSTANCIA
    from
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
                    from DTW010 
                    where 
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_ATIVID = 50
                ) as DATAFIM,
                
                concat(trim(DTQ.DTQ_FILORI), trim(DTQ.DTQ_VIAGEM)) as ID_VIAGEM,
                trim(DA4010.DA4_COD) as ID_MOTORISTA,
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
            where DTQ.D_E_L_E_T_ = ''
        ) VIAGEM
        inner join DTC010 DOCAV 
            on DOCAV.D_E_L_E_T_ = ''
            and DOCAV.DTC_FILIAL = VIAGEM.DTQ_FILORI
            and trim(DOCAV.DTC_YVIAGE) = VIAGEM.DTQ_VIAGEM
        inner join DUD010 DUD 
            on DUD.D_E_L_E_T_ = ''
            and DUD.DUD_FILIAL = VIAGEM.DTQ_FILIAL
            and DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
            and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM

            left join DT6010 DT6 
                on DT6.D_E_L_E_T_ = ''
                and DT6.DT6_FILDOC = DUD.DUD_FILDOC
                and DT6.DT6_DOC = DUD.DUD_DOC
                and DT6.DT6_SERIE = DUD.DUD_SERIE

                left join DTC010 DTC 
                    on DTC.D_E_L_E_T_ = ''
                    and DTC.DTC_FILDOC = DT6.DT6_FILDOC
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
    where
           VIAGEM.DATAFIM BETWEEN <<START_DATE>> AND <<FINAL_DATE>>
