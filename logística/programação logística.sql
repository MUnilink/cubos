select
    'P |01|01' AS BK_EMPRESA,
    VIAGEM.DTQ_VIAGEM,
    
    VIAGEM.CHE_CLIDEV_REAL,
    VIAGEM.SAI_CLIDEV_REAL,
    VIAGEM.CHE_VIAGEM_REAL,
    VIAGEM.SAI_VIAGEM_REAL,
    
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    DT6.DT6_DATEMI,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIREM, ' '))+RTRIM(COALESCE(DT6.DT6_LOJREM, ' ')), ' '), '|') AS BK_REMETENTE,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDES, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDES, ' ')), ' '), '|') AS BK_DESTINATARIO,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CLIDEV, ' '))+RTRIM(COALESCE(DT6.DT6_LOJDEV, ' ')), ' '), '|') AS BK_DEVEDOR,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYORI.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRORI, ' ')), ' '), '|') AS BK_CDRORI,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDES.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRDES, ' ')), ' '), '|') AS BK_CDRDES,
    'P |01|DUY010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DUYDEV.DUY_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_CDRCAL, ' ')), ' '), '|') AS BK_CDRCAL,
    'P |01|SX5010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SX5.X5_FILIAL, ' '))+'|'+RTRIM(COALESCE(DT6.DT6_SERVIC, ' ')), ' '), '|') AS BK_SERVICO,
    CASE WHEN DT6.DT6_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILIAL AS CHAR (8)) END AS BK_FILIAL,
    CASE WHEN DT6.DT6_FILORI IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILORI AS CHAR (8)) END AS BK_FILIAL_ORIGEM,
    CASE WHEN DT6.DT6_FILDES IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDES AS CHAR (8)) END AS BK_FILIAL_DESTINO,
    CASE WHEN REM.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(REM.A1_EST, ' '))+RTRIM(COALESCE(REM.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_REM,
    CASE WHEN DES.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DES.A1_EST, ' '))+RTRIM(COALESCE(DES.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DES,
    CASE WHEN DEV.A1_COD_MUN = ' ' THEN 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' ')), ' '), '|') ELSE 'P |01|CC2010|'+ COALESCE(NULLIF(RTRIM(COALESCE(DEV.A1_EST, ' '))+RTRIM(COALESCE(DEV.A1_COD_MUN, ' ')), ' '), '|') END AS BK_REGIAO_DEV,
    CASE WHEN DT6.DT6_FILDOC IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DT6.DT6_FILDOC AS CHAR (8)) END AS BK_FILIAL_DOCTO,
    trim(DTC.DTC_CODPRO) as PRODUTO,

    DIARIAS.DYV_IDCDIA,
    DIARIAS.DYX_DATDIA,
    DIARIAS.DYX_QTDE,
    DIARIAS.DYX_VLRUNI,
    
    VIAGEM.DTR_CODVEI,
    VIAGEM.DTR_CODRB1,
    VIAGEM.DTR_CODRB2,
    VIAGEM.DTR_CODRB3,

    DT6.DT6_VALFRE / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = VIAGEM.DTQ_VIAGEM) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = VIAGEM.DTQ_VIAGEM) IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    DTC.DTC_FILORI,
    DTC.DTC_DOC,
    DTC.DTC_SERIE,
    DTC.DTC_NUMNFC,
    DTC.DTC_SERNFC,
    DTC.DTC_CODPRO,
    DTC.DTC_VALOR,
    DTC.DTC_PESO,
    DTC.DTC_PESLIQ,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as TIPO_VIAGEM,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,
    
    DF1.DF1_NUMAGE as AGENDAMENTO,
    DF1.DF1_ITEAGE as ITEM_AGENDA,
    datetimefromparts(year(DF1.DF1_DATPRC), month(DF1.DF1_DATPRC), day(DF1.DF1_DATPRC), substring(DF1.DF1_HORPRC, 1, 2), substring(DF1.DF1_HORPRC, 4, 5), 0, 0) as CHE_CLI_PRCV_COL,
    datetimefromparts(year(DF1.DF1_DATPRE), month(DF1.DF1_DATPRE), day(DF1.DF1_DATPRE), substring(DF1.DF1_HORPRE, 1, 2), substring(DF1.DF1_HORPRE, 4, 5), 0, 0) as CHE_CLI_PREV_ENT,
    DF1.DF1_YDSPOR as PORTO,
    DF1.DF1_YDIBOO as BOOKING,
    DF1.DF1_YOSCLI as OS_CLIENTE,
    DF1.DF1_YNAVIO as NAVIO,
    DF1.DF1_YDSNAV as NOME_NAVIO,
    DF1.DF1_YVIAGE as VIAGEM_PORT,
    DF1.DF1_YCONT as CONTEINER,
    DF1.DF1_YLACRE as LACRE,
    datetimefromparts(year(DF1.DF1_YDTCON), month(DF1.DF1_YDTCON), day(DF1.DF1_YDTCON), substring(DF1.DF1_YHRCON, 1, 2), substring(DF1.DF1_YHRCON, 4, 5), 0, 0) as DATA_CONTEINER,
    DF1.DF1_YARMAD as ARMADORA,
    DF1.DF1_YLJARM as LOJA_ARMADORA,
    DF1.DF1_YDSARM as NOME_ARMADORA,

    trim(REG_COL.EST_COL) as UF_COLETA,
	trim(REG_COL.MUN_COL) as MUN_COLETA,
	trim(REG_ENT.EST_ENT) as UF_ENTREGA,
	trim(REG_ENT.MUN_ENT) as MUN_ENTREGA

from DF1010 DF1 (nolock)
    left join
    (
        select
            DUY010.DUY_GRPVEN as GRP_COL,
            DUY010.DUY_EST as EST_COL,
            DUY010.DUY_DESCRI as MUN_COL
        from DUY010 (nolock)
        where DUY010.D_E_L_E_T_ = ''
    ) AS REG_COL
    on REG_COL.GRP_COL = DF1.DF1_CDRORI

    left join
    (
        select
            DUY010.DUY_GRPVEN as GRP_ENT,
            DUY010.DUY_EST as EST_ENT,
            DUY010.DUY_DESCRI as MUN_ENT
        from DUY010 (nolock)
        where DUY010.D_E_L_E_T_ = ''
    ) AS REG_ENT
    on REG_ENT.GRP_ENT = DF1.DF1_CDRDES

    left join DT5010 DT5 (nolock)
        on DT5.D_E_L_E_T_ = ''
        and DT5.DT5_FILDOC = DF1.DF1_FILDOC
        and DT5.DT5_NUMSOL = DF1.DF1_DOC
    
    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = DF1.DF1_FILORI
        and DUD.DUD_FILDOC = DF1.DF1_FILDOC
        and DUD.DUD_DOC = DF1.DF1_DOC
        and DUD.DUD_SERIE = DF1.DF1_SERIE
    
        left join
        (
            select
                DTQ.DTQ_FILIAL,
                DTQ.DTQ_FILORI,
                DTQ.DTQ_VIAGEM,
                DTQ.DTQ_DATGER,
                DTQ.DTQ_DATFEC,
                DTQ.DTQ_DATENC,
                DA4010.DA4_COD,
                DTR.DTR_CODVEI,
                DTR.DTR_CODRB1,
                DTR.DTR_CODRB2,
                DTR.DTR_CODRB3,
                (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODVEI) as PLACA_CM,
                (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB1) as PLACA_RB1,
                (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB2) as PLACA_RB2,
                (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB3) as PLACA_RB3,

                (
                    select
                            top 1 concat(DTW010.DTW_SYSDAT, ' ', concat(substring(DTW010.DTW_SYSHOR, 1, 2), ':', substring(DTW010.DTW_SYSHOR, 3, 2), ':', substring(DTW010.DTW_SYSHOR, 5, 2)))
                    from DTW010
                    where
                            DTW010.D_E_L_E_T_ = ''
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
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
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
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
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
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
                        and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
                        and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
                        and DTW010.DTW_SYSHOR != ''
                        and DTW010.DTW_SYSDAT != ''
                        and DTW010.DTW_ATIVID = 50
                ) as CHE_VIAGEM_REAL

            from DTQ010 DTQ
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
        on DUD.DUD_FILORI = VIAGEM.DTQ_FILORI
        and DUD.DUD_VIAGEM = VIAGEM.DTQ_VIAGEM

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
                    inner join DYX010 (nolock)
                        on DYX010.D_E_L_E_T_ = ''
                        and DYX010.DYX_IDCDIA = DYV010.DYV_IDCDIA
                where DYV010.D_E_L_E_T_ = ''
            ) DIARIAS
                on DIARIAS.DYV_FILORI = VIAGEM.DTQ_FILORI
                and DIARIAS.DYV_VIAGEM = VIAGEM.DTQ_VIAGEM
                and DIARIAS.DYV_CODMOT = VIAGEM.DA4_COD         
             
                left join DT6010 DT6 (nolock)
                    on DT6.D_E_L_E_T_ = ''
                    and DT6.DT6_FILDOC = DUD.DUD_FILDOC
                    and DT6.DT6_DOC = DUD.DUD_DOC
                    and DT6.DT6_SERIE = DUD.DUD_SERIE

                    left join DTC010 DTC (nolock)
                        on DTC.D_E_L_E_T_ = ''
                        and DTC.DTC_FILORI = DT6.DT6_FILDOC
                        and DTC.DTC_DOC = DT6.DT6_DOC
                        and DTC.DTC_SERIE = DT6.DT6_SERIE
                    left join SA1010 REM (nolock)
                        on REM.A1_FILIAL = '      '
                        and REM.A1_COD = DT6.DT6_CLIREM
                        and REM.A1_LOJA = DT6.DT6_LOJREM
                        and REM.D_E_L_E_T_ = ' '
                    left join SA1010 DES (nolock)
                        on DES.A1_FILIAL = '      '
                        and DES.A1_COD = DT6.DT6_CLIDES
                        and DES.A1_LOJA = DT6.DT6_LOJDES
                        and DES.D_E_L_E_T_ = ' '
                    left join SA1010 DEV (nolock)
                        on DEV.A1_FILIAL = '      '
                        and DEV.A1_COD = DT6.DT6_CLIDEV
                        and DEV.A1_LOJA = DT6.DT6_LOJDEV
                        and DEV.D_E_L_E_T_ = ' '
                    left join DUY010 DUYORI (nolock)
                        on DUYORI.DUY_FILIAL = DT6.DT6_FILIAL
                        and DUYORI.DUY_GRPVEN = DT6.DT6_CDRORI
                        and DUYORI.D_E_L_E_T_ = ' '
                    left join DUY010 DUYDES (nolock)
                        on DUYDES.DUY_FILIAL = DT6.DT6_FILIAL
                        and DUYDES.DUY_GRPVEN = DT6.DT6_CDRDES
                        and DUYDES.D_E_L_E_T_ = ' '
                    left join DUY010 DUYDEV (nolock)
                        on DUYDEV.DUY_FILIAL = DT6.DT6_FILIAL
                        and DUYDEV.DUY_GRPVEN = DT6.DT6_CDRCAL
                        and DUYDEV.D_E_L_E_T_ = ' '
                    left join SX5010 SX5 (nolock)
                        on SX5.X5_FILIAL = '      '
                        and SX5.X5_TABELA = 'L4'
                        and SX5.X5_CHAVE = DT6.DT6_SERVIC
                        and SX5.D_E_L_E_T_ = ' '
where DF1.D_E_L_E_T_ = ''