select
    VIAGEM.DTQ_VIAGEM,
    
    convert(datetime, VIAGEM.CHE_CLIDEV_REAL, 113) as CHE_CLIDEV_REAL,
    convert(datetime, VIAGEM.SAI_CLIDEV_REAL, 113) as SAI_CLIDEV_REAL,
    convert(datetime, VIAGEM.CHE_VIAGEM_REAL, 113) as CHE_VIAGEM_REAL,
    convert(datetime, VIAGEM.SAI_VIAGEM_REAL, 113) as SAI_VIAGEM_REAL,
    
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    DT6.DT6_DATEMI,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    DT6.DT6_CLIREM +'-'+ DT6.DT6_LOJREM as REM,
    REM.A1_CGC as REM_CNPJ,
    REM.A1_NOME as REMETENTE,
    REM.A1_NREDUZ as REM_RED,
    
    DT6.DT6_CLIDES +'-'+ DT6.DT6_LOJDES as DES,
    DES.A1_CGC as DES_CNPJ,
    DES.A1_NOME as DESTINATARIO,
    DES.A1_NREDUZ as DES_RED,
    
    DT6.DT6_CLIDEV +'-'+ DT6.DT6_LOJDEV as DEV,
    DEV.A1_CGC as CLI_CNPJ,
    DEV.A1_NOME as CLIENTE,
    DEV.A1_NREDUZ as CLIENTE_RED,

    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    
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
    
    DIARIAS.DYV_IDCDIA,
    DIARIAS.DYX_DATDIA,
    DIARIAS.DYX_QTDE,
    DIARIAS.DYX_VLRUNI,

    VIAGEM.DTR_CODRB2 as SR2,
    VIAGEM.DTR_CODRB3 as SR3,

    DT6.DT6_VALFRE / isnull((select nullif(count(DTR010.DTR_CODVEI), 0) from DTR010 where DTR010.DTR_VIAGEM = VIAGEM.DTQ_VIAGEM), 1) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / isnull((select nullif(count(DTR010.DTR_CODVEI), 0) from DTR010 where DTR010.DTR_VIAGEM = VIAGEM.DTQ_VIAGEM), 1) IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,

    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    case when isnull
    (
        datetimefromparts(year(DF1.DF1_DATPRC), month(DF1.DF1_DATPRC), day(DF1.DF1_DATPRC), substring(DF1.DF1_HORPRC, 1, 2), substring(DF1.DF1_HORPRC, 4, 5), 0, 0),
        datetimefromparts(year(DF1.DF1_DATPRE), month(DF1.DF1_DATPRE), day(DF1.DF1_DATPRE), substring(DF1.DF1_HORPRE, 1, 2), substring(DF1.DF1_HORPRE, 4, 5), 0, 0)
    )
        <= VIAGEM.CHE_CLIDEV_REAL then 'FORA DO PRAZO' else 'DENTRO DO PRAZO'
    end as STATUS_ATENDIMENTO,

    DTC.DTC_DOC as NFCLI_DOCTO_TMS,
    DTC.DTC_SERIE as NFCLI_SERIE_TMS,
    DTC.DTC_NUMNFC as NFCLI_NUM,
    DTC.DTC_SERNFC as NFCLI_SERIE,
    DTC.DTC_CODPRO as NFCLI_PRODUTO,
    (select SB1010.B1_DESC from SB1010 where SB1010.B1_COD = DTC.DTC_CODPRO) as NFCLI_DESCPROD,
    DTC.DTC_VALOR as NFCLI_VALOR,
    DTC.DTC_PESO as NFCLI_PESO,

    case when DT5.DT5_STATUS = '4' then 'CORTESIA' else case when DT5.DT5_STATUS like '[0-9]' then 'DOCUMENTO PENDENTE' else 'DOCUMENTO OK' end end as TIPO_VIAGEM,

    DT5.DT5_NUMSOL,
    DT5.DT5_DOC as OS_COLETA,
    DT5.DT5_SERIE,
    DT5.DT5_STATUS as STATUS_COLETA,
    DT5.DT5_TIPCOL,
    DT5.DT5_CODSOL,
    DT5.DT5_CODOBC,
    
    case DF0.DF0_STATUS
		when '1' then 'A CONFIRMAR'
		when '2' then 'CONFIRMADO'
		when '3' then 'EM PROCESSO'
		when '4' then 'ENCERRADO'
		when '5' then 'PLANEJADO'
		when '9' then 'CANCELADO'
	end as STATUS_AGENDA,

    DF1.DF1_NUMAGE as AGENDAMENTO,
    DF1.DF1_ITEAGE as ITEM_AGENDA,
    substring(isnull(DF1.DF1_DATPRC, DF1.DF1_DATPRE), 1, 6) as PERIODO_AGECOL,
    convert(datetime, datetimefromparts(year(DF1.DF1_DATPRC), month(DF1.DF1_DATPRC), day(DF1.DF1_DATPRC), substring(DF1.DF1_HORPRC, 1, 2), substring(DF1.DF1_HORPRC, 4, 5), 0, 0), 113) as CHE_CLI_PREV_COL,
    convert(datetime, datetimefromparts(year(DF1.DF1_DATPRE), month(DF1.DF1_DATPRE), day(DF1.DF1_DATPRE), substring(DF1.DF1_HORPRE, 1, 2), substring(DF1.DF1_HORPRE, 4, 5), 0, 0), 113) as CHE_CLI_PREV_ENT,
    case when DF1.DF1_DATPRC = DF1.DF1_DATPRE then 'OK' else 'DIFF' end as DIFF_ENTCOL,
    trim(DF1.DF1_YDSPOR) as PORTO,
    trim(DF1.DF1_YDIBOO) as BOOKING,
    trim(DF1.DF1_YOSCLI) as OS_CLIENTE,
    trim(DF1.DF1_YNAVIO) as NAVIO_COD,
    trim(DF1.DF1_YDSNAV) as NAVIO,
    trim(DF1.DF1_YVIAGE) as VIAGEM_PORT,
    trim(DF1.DF1_YCONT) as CONTEINER,
    trim(DF1.DF1_YLACRE) as LACRE,
    convert(datetime, datetimefromparts(year(DF1.DF1_YDTCON), month(DF1.DF1_YDTCON), day(DF1.DF1_YDTCON), substring(DF1.DF1_YHRCON, 1, 2), substring(DF1.DF1_YHRCON, 4, 5), 0, 0), 113) as DATA_CONTEINER,
    DF1.DF1_YARMAD as ARMADORA_COD,
    DF1.DF1_YLJARM as LOJA_ARMADORA,
    trim(DF1.DF1_YDSARM) as ARMADORA,
        
    isnull(ZA0.ZA0_VEICUL, VIAGEM.DTR_CODVEI) as CM,
    isnull(ZA0.ZA0_PLACA, VIAGEM.PLACA_CM) as CM_PLACA,
    isnull(ZA0.ZA0_CARRET, VIAGEM.DTR_CODRB1) as SR1,
    isnull(ZA0.ZA0_PLCCAR, VIAGEM.PLACA_RB1) as SR1_PLACA,
    isnull(ZA0.ZA0_MOTORI, VIAGEM.DA4_COD) as MOTORISTA_CODIGO,
    trim(ZA0.ZA0_NOMMOT) as MOTORISTA,

    trim(REG_COL.EST_COL) as UF_COLETA,
	trim(REG_COL.MUN_COL) as MUN_COLETA,
	trim(REG_ENT.EST_ENT) as UF_ENTREGA,
	trim(REG_ENT.MUN_ENT) as MUN_ENTREGA

from DF1010 DF1 (nolock)
    left join DF0010 DF0 (nolock)
        on DF0.D_E_L_E_T_ = ''
        and DF0.DF0_FILIAL = DF1.DF1_FILIAL
        and DF0.DF0_NUMAGE = DF1.DF1_NUMAGE
        and DF0.DF0_NUMAGE > 5800
    left join ZA0010 ZA0 (nolock)
        on ZA0.D_E_L_E_T_ = ''
        and ZA0.ZA0_FILIAL = DF1.DF1_FILIAL
        and ZA0.ZA0_AGENDA = DF1.DF1_NUMAGE
        and ZA0.ZA0_ITEAGE = DF1.DF1_ITEAGE
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

        left join DUA010 DUA (nolock)
            on DUA.D_E_L_E_T_ = ''
            and DUA.DUA_FILDOC = DT5.DT5_FILDOC
            and DUA.DUA_DOC = DT5.DT5_DOC
            and DUA.DUA_SERIE = DT5.DT5_SERIE
        
            left join
            (
                select
                    (select DTQ010.DTQ_VIAGEM from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_VIAGEM,
                    (select convert(date, DTQ010.DTQ_DATGER, 103) from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATGER,
                    (select convert(date, DTQ010.DTQ_DATFEC, 103) from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATFEC,
                    (select convert(date, DTQ010.DTQ_DATENC, 103) from DTQ010 where DTQ010.D_E_L_E_T_ = '' and DTQ010.DTQ_FILORI = DUD.DUD_FILORI and DTQ010.DTQ_VIAGEM = DUD.DUD_VIAGEM) as DTQ_DATENC,
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
                        from DTW010 (nolock)
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
                        from DTW010 (nolock)
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
                        from DTW010 (nolock)
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
                        from DTW010 (nolock)
                        where
                                DTW010.D_E_L_E_T_ = ''
                            and DTW010.DTW_FILORI = DUD.DUD_FILORI
                            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
                            and DTW010.DTW_SYSHOR != ''
                            and DTW010.DTW_SYSDAT != ''
                            and DTW010.DTW_ATIVID = 50
                    ) as CHE_VIAGEM_REAL,
                    
                    DUD.DUD_FILORI,
                    DUD.DUD_FILDOC,
                    DUD.DUD_DOC,
                    DUD.DUD_SERIE,
                    DUD.DUD_VIAGEM

                from DUD010 DUD (nolock)
                    inner join DTR010 DTR (nolock)
                        on DTR.D_E_L_E_T_ = ''
                        and DTR.DTR_FILORI = DUD.DUD_FILORI
                        and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM
                        
                        inner join DUP010 (nolock)
                            on DUP010.D_E_L_E_T_ = ''
                            and DUP010.DUP_FILORI = DTR.DTR_FILORI
                            and DUP010.DUP_VIAGEM = DTR.DTR_VIAGEM
                            and DUP010.DUP_ITEDTR = DTR.DTR_ITEM
                            and DUP010.DUP_CODVEI = DTR.DTR_CODVEI

                            inner join DA4010 (nolock)
                                on DA4010.D_E_L_E_T_ = ''
                                and DA4010.DA4_COD = DUP010.DUP_CODMOT

                where DUD.D_E_L_E_T_ = ''
            ) VIAGEM
            on VIAGEM.DUD_FILDOC = DUA.DUA_FILDOC
            and VIAGEM.DUD_DOC = DUA.DUA_DOC
            and VIAGEM.DUD_SERIE = DUA.DUA_SERIE

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
                where DYV010.D_E_L_E_T_ = ''
            ) DIARIAS
                on DIARIAS.DYV_FILORI = VIAGEM.DUD_FILORI
                and DIARIAS.DYV_VIAGEM = VIAGEM.DUD_VIAGEM
                and DIARIAS.DYV_CODMOT = VIAGEM.DA4_COD
                
            left join DT6010 DT6 (nolock)
                on DT6.D_E_L_E_T_ = ''
                and DT6.DT6_FILDOC = VIAGEM.DUD_FILDOC
                and DT6.DT6_DOC = VIAGEM.DUD_DOC
                and DT6.DT6_SERIE = VIAGEM.DUD_SERIE

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
