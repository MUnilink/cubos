select
    'P |01|01' AS BK_EMPRESA,
    CASE WHEN DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
    'P |01|DDB010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DDB_FILIAL, ' '))+'|'+RTRIM(COALESCE(DDB_CODNEG, ' ')), ' '), '|') AS BK_CODNEG,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6_SERVIC, ' ')), ' '), '|') AS BK_SERNEG,
    CASE WHEN DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
    CASE WHEN DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
    CASE WHEN DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_DOCTMS, ' ')), ' '), '|') AS BK_DOCTMS,
    'P |'+ COALESCE(NULLIF(RTRIM(COALESCE(DT6_TIPTRA, ' ')), ' '), '|') AS BK_TIPTRA,
    'CTRC' + DT6.DT6_DOC as ID_DOCUMENTO,
    CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
    CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
    CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
    CASE WHEN DUYDEV.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_EST, ' '))+RTRIM(COALESCE(DUYDEV.DUY_CODMUN, ' ')), ' '), '|') END AS BK_REGIAO_CDRCAL,
    CASE WHEN DUYORI.DUY_CODMUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_EST, ' '))+RTRIM(COALESCE(DUYORI.DUY_CODMUN, ' ')), ' '), '|') END AS BK_REGIAO_CDRORI,
    
    concat(DYV.DYV_FILIAL, DYV.DYV_FILORI, DYV.DYV_IDCDIA, DYX.DYX_ITEM, SE2.E2_NUM) as ID_DIARIA,
    VIAGEM.SAI_VIAGEM_REAL,
    VIAGEM.CHE_CLIDEV_REAL,
    VIAGEM.SAI_CLIDEV_REAL,
    VIAGEM.CHE_VIAGEM_REAL,

    DF1.ID_AGENDAMENTO,
    VIAGEM.ID_VIAGEM,
    VIAGEM.ID_VEICULO_CM,
    VIAGEM.ID_VEICULO_RB1,
    VIAGEM.ID_VEICULO_RB2,
    VIAGEM.ID_VEICULO_RB3,
    VIAGEM.ID_MOTORISTA,
    VIAGEM.ID_ROTA,
    DYX.DYX_DATDIA as DATA_DIARIA,
    
    cast(DYX.DYX_QTDE as int) as QTD,
    cast(DYX.DYX_VLRTOT as numeric(15, 2)) as VALOR_UNI,
    trim(SE2.E2_NUM) as TITULO,
    cast(SE2.E2_VALOR as numeric(15, 2)) as VL_TITULO,
    cast(SE2.E2_VALLIQ as numeric(15, 2)) as VL_LIQUIDO,
    SE2.E2_EMISSAO as DT_TITULO,
	SE2.E2_VENCTO as DT_VENCIMENTO,
	SE2.E2_VENCREA as DT_VENCREAL,
	SE2.E2_BAIXA as DT_BAIXA

from DYX010 DYX
    left join SE2010 SE2
        on SE2.D_E_L_E_T_ = ''
        and SE2.E2_PREFIXO = DYX.DYX_PRETIT
        and SE2.E2_NUM = DYX.DYX_NUMTIT
    left join SX5010 TP_DIA
        on TP_DIA.D_E_L_E_T_ = ''
        and TP_DIA.X5_TABELA = 'MS'
        and TP_DIA.X5_CHAVE = DYX.DYX_TIPVAL
    left join SYS_USR
        on SYS_USR.D_E_L_E_T_ = ''
        and SYS_USR.USR_ID = DYX.DYX_USRAPR
    inner join DYV010 DYV
        on DYV.D_E_L_E_T_ = ''
        and DYV.DYV_IDCDIA = DYX.DYX_IDCDIA

        inner join DA4010 DA4
            on DA4.D_E_L_E_T_ = ''
            and DA4.DA4_COD = DYV.DYV_CODMOT
        
        left join
        (
            select
                concat(trim(DA8010.DA8_FILIAL), trim(DA8010.DA8_COD)) as ID_ROTA,
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
                        and DTW010.DTW_ATIVID = '057' /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != '000761'
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
                        and DTW010.DTW_ATIVID = '056' /*58 PONTO DE APOIO*/
                        and DTW010.DTW_CODCLI != '000761'
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
                        and DTW010.DTW_ATIVID = '049'
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
                        and DTW010.DTW_ATIVID = '050'
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
            on VIAGEM.DUD_FILIAL = DYV.DYV_FILIAL
            and VIAGEM.DUD_FILORI = DYV.DYV_FILORI
            and VIAGEM.DUD_VIAGEM = DYV.DYV_VIAGEM
            
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
    
    left join DT6010 DT6
        on DT6.DT6_FILDOC = VIAGEM.DUD_FILDOC
        and DT6.DT6_DOC = VIAGEM.DUD_DOC
        and DT6.DT6_SERIE = VIAGEM.DUD_SERIE
        
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
            ON DUYORI.DUY_FILIAL = DT6.DT6_FILIAL
            AND DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
            AND DUYORI.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDES
            ON DUYDES.DUY_FILIAL = DT6.DT6_FILIAL
            AND DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
            AND DUYDES.D_E_L_E_T_ = ' '
        LEFT JOIN DUY010 DUYDEV
            ON DUYDEV.DUY_FILIAL = DT6.DT6_FILIAL
            AND DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
            AND DUYDEV.D_E_L_E_T_ = ' '
        LEFT JOIN DDB010 DDB
            ON DDB.DDB_FILIAL = DT6.DT6_FILIAL
            AND DDB.DDB_CODNEG = DT6.DT6_CODNEG
            AND DDB.D_E_L_E_T_ = ' '
        INNER JOIN SX5010 SX5
            ON SX5.X5_FILIAL = '      '
            AND SX5.X5_TABELA = 'L4'
            AND SX5.X5_CHAVE = DT6.DT6_SERVIC
            AND SX5.D_E_L_E_T_ = ' '
where
        DYX.D_E_L_E_T_ = ''
    and DYX.DYX_DATDIA between <<START_DATE>> and <<FINAL_DATE>>
