select
    DTQ.DTQ_VIAGEM,

    REG_COL.DUY_EST as UF_COLETA,
	REG_COL.DUY_DESCRI as MUN_COLETA,
	REG_ENT.DUY_EST as UF_ENTREGA,
	REG_ENT.DUY_DESCRI as MUN_ENTREGA,

    trim(DUYORI.DUY_DESCRI) as ORIGEM,
    trim(DUYDES.DUY_DESCRI) as DESTINO,
    trim(DUYDEV.DUY_DESCRI) as DEVEDOR,
    trim(DEV.A1_COD) as A1_COD,
    trim(DEV.A1_LOJA) as A1_LOJA,
    trim(DEV.A1_NOME) as CLIENTE,

    DTR.DTR_CODVEI,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,
    DT6.DT6_PRZENT AS PRAZO_ENTREGA,
    DT6.DT6_DATENT AS DATA_ENTREGA,
    
    CASE
        WHEN DT6.DT6_PRZENT < DT6.DT6_DATENT THEN 'FORA DO PRAZO'
        ELSE 'DENTRO DO PRAZO'
    END AS STATUS_ATENDIMENTO,

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS

from DTQ010 DTQ (nolock)
    inner join DA8010 DA8 (nolock)
        on DA8.D_E_L_E_T_ = ''
        and DA8.DA8_COD = DTQ.DTQ_ROTA
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM
    
    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = DTQ.DTQ_FILORI
        and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM

        left join DT5010 DT5 (nolock)
            on DT5.D_E_L_E_T_ = ''
            and DT5.DT5_FILDOC = DUD.DUD_FILDOC
            and DT5.DT5_NUMSOL = DUD.DUD_DOC
            and DUD.DUD_SERIE = 'COL'

		left join DT6010 DT6 (nolock)
			on DT6.D_E_L_E_T_ = ''
			and DT6.DT6_FILDOC = DUD.DUD_FILDOC
			and DT6.DT6_DOC = DUD.DUD_DOC
			and DT6.DT6_SERIE = DUD.DUD_SERIE
            and DT6.DT6_DATEMI > '20211231'

            left join SD2010 COMP (nolock)
                on COMP.D_E_L_E_T_ = ''
                and COMP.D2_NFORI = DT6.DT6_DOC
                and COMP.D2_SERIORI = DT6.DT6_SERIE
                and COMP.D2_CLIENTE = DT6.DT6_CLIDEV
                and COMP.D2_LOJA = DT6.DT6_LOJDEV

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
            and DTC.DTC_FILORI = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE

where
        DTQ.D_E_L_E_T_ = ''