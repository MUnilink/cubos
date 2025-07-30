select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    left(DT6.DT6_DATEMI, 6) as PERIODO_CTE,
    cast(DT6.DT6_DATEMI as date) as DT6_DATEMI,
    DA8.DA8_DESC,
    DTQ.DTQ_KMVGE,

    cast(DTQ.DTQ_DATGER as date) as DT_GERVGA,
    cast(DTQ.DTQ_DATFEC as date) as DT_FECVGA,
    cast(DTQ.DTQ_DATENC as date) as DT_ENCVGA,

    DTQ.DTQ_STATUS as STATUS_VGA,

    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    trim(DEV.A1_COD) as DEV_COD,
    trim(DEV.A1_LOJA) as DEV_LOJA,
    trim(DEV.A1_NOME) as CLI_DEVEDOR,
    trim(REM.A1_COD) as REM_COD,
    trim(REM.A1_LOJA) as REM_LOJA,
    trim(REM.A1_NOME) as CLI_ORIGEM,
    trim(DES.A1_COD) as DES_COD,
    trim(DES.A1_LOJA) as DES_LOJA,
    trim(DES.A1_NOME) as CLI_DESTINO,
    trim(REG_COL.DUY_EST) as UF_COLETA,
	trim(REG_COL.DUY_DESCRI) as MUN_COLETA,
	trim(REG_ENT.DUY_EST) as UF_ENTREGA,
	trim(REG_ENT.DUY_DESCRI) as MUN_ENTREGA,

    DTR.DTR_ITEM,
    DUP.DUP_CODMOT,
    DA4.DA4_MAT,

    DTR.DTR_CODVEI,
    DTR.DTR_CODRB1,
    DTR.DTR_CODRB2,
    DTR.DTR_CODRB3,
    
    DT6.DT6_VALMER,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,
    
    trim(SB1.B1_DESC) as NFCLI_PRODUTO,

    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as DATAINI,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as HORAINI,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as HORAFIM,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA

from DUD010 DUD (nolock)
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DUD.DUD_FILORI
        and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM

        inner join DUP010 DUP (nolock)
            on DUP.D_E_L_E_T_ = ''
            and DUP.DUP_FILORI = DTR.DTR_FILORI
            and DUP.DUP_VIAGEM = DTR.DTR_VIAGEM
            and DUP.DUP_ITEDTR = DTR.DTR_ITEM
            and DUP.DUP_CODVEI = DTR.DTR_CODVEI

            inner join DA4010 DA4 (nolock)
                on DA4.DA4_COD = DUP.DUP_CODMOT

    left join DTQ010 DTQ (nolock)
        on DTQ.D_E_L_E_T_ = ''
        and DTQ.DTQ_FILORI = DUD.DUD_FILORI
        and DTQ.DTQ_VIAGEM = DUD.DUD_VIAGEM

        inner join DA8010 DA8 (nolock)
            on DA8.D_E_L_E_T_ = ''
            and DA8.DA8_COD = DTQ.DTQ_ROTA

    left join DT6010 DT6 (nolock)
        on DT6.D_E_L_E_T_ = ''
        and DT6.DT6_FILDOC = DUD.DUD_FILDOC
        and DT6.DT6_DOC = DUD.DUD_DOC
        and DT6.DT6_SERIE = DUD.DUD_SERIE

        left join SA1010 DEV (nolock)
            on DEV.A1_FILIAL = '      '
            and DEV.A1_COD = DT6.DT6_CLIDEV
            and DEV.A1_LOJA = DT6.DT6_LOJDEV
            and DEV.D_E_L_E_T_ = ' '
        left join SA1010 REM
            ON REM.A1_FILIAL = '      '
            AND REM.A1_COD = DT6.DT6_CLIREM
            AND REM.A1_LOJA = DT6.DT6_LOJREM
            AND REM.D_E_L_E_T_ = ' '
        left join SA1010 DES
            ON DES.A1_FILIAL = '      '
            AND DES.A1_COD = DT6.DT6_CLIDES
            AND DES.A1_LOJA = DT6.DT6_LOJDES
            AND DES.D_E_L_E_T_ = ' '

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
    
    left join DUY010 REG_COL (nolock)
        ON REG_COL.D_E_L_E_T_ = ' '
        and REG_COL.DUY_FILIAL = DT6.DT6_FILIAL
        and REG_COL.DUY_GRPVEN = DT6.DT6_CDRORI
    left join DUY010 REG_ENT (nolock)
        ON REG_ENT.D_E_L_E_T_ = ' '
        and REG_ENT.DUY_FILIAL = DT6.DT6_FILIAL
        and REG_ENT.DUY_GRPVEN = DT6.DT6_CDRCAL
    left join DTC010 DTC (nolock)
        on DTC.D_E_L_E_T_ = ''
        and DTC.DTC_FILDOC = DT6.DT6_FILDOC
        and DTC.DTC_DOC = DT6.DT6_DOC
        and DTC.DTC_SERIE = DT6.DT6_SERIE

        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = DTC.DTC_CODPRO
where
        DTQ.D_E_L_E_T_ = ''
