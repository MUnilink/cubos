select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DA8.DA8_DESC,
    DTQ.DTQ_KMVGE,

    REG_COL.EST_COL as UF_COLETA,
	REG_COL.MUN_COL as MUN_COLETA,
	REG_ENT.EST_ENT as UF_ENTREGA,
	REG_ENT.MUN_ENT as MUN_ENTREGA,

    (
        select substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010 (nolock)
            inner join ZB1010 (nolock)
                on ZB1010.D_E_L_E_T_ = ''
                and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                and
                    dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                    =
                    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('050')
    ) as km_fim,
    (
        select substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT))
        from DTW010 (nolock)
            inner join ZB1010 (nolock)
                on ZB1010.D_E_L_E_T_ = ''
                and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                and
                    dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                    =
                    datetimefromparts(year(DTW010.DTW_DATREA), month(DTW010.DTW_DATREA), day(DTW010.DTW_DATREA), substring(DTW010.DTW_HORREA, 1, 2), substring(DTW010.DTW_HORREA, 3, 4), 0, 0)
        where
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
            and DTW010.DTW_ATIVID in ('049')
    ) as km_ini,

    DTR.DTR_ITEM,
    DUP.DUP_CODMOT,
    DA4.DA4_MAT,
    DA4.DA4_NOME,
    DA4.DA4_FORNEC,
    DA4.DA4_LOJA,

    DTR.DTR_CODVEI,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODVEI) as PLACA_VEI,
    DTR.DTR_CODRB1,
    (select DA3010.DA3_PLACA from DA3010 where DA3010.DA3_COD = DTR.DTR_CODRB1) as PLACA_RB1,

    DTR.DTR_CODRB2,
    DTR.DTR_CODRB3,
    
    DT6.DT6_VALFRE / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) as CTE_CM,
    DT6.DT6_VALFRE as CTE_TOTAL,
    DT6.DT6_VALIMP / (select count(DTR010.DTR_CODVEI) from DTR010 where DTR010.DTR_VIAGEM = DTQ.DTQ_VIAGEM) IMPOSTO_CM,
    DT6.DT6_VALIMP as IMPOSTO_TOTAL,
    DT6.DT6_VALTOT,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,

    SA1.A1_COD,
    SA1.A1_LOJA,
    SA1.A1_NOME,
    SD2.D2_DOC,
    SD2.D2_SERIE,
    SD2.D2_NFORI,
    SD2.D2_SERIORI,
    convert(date, SD2.D2_EMISSAO, 103) as D2_EMISSAO,
    SD2.D2_TIPO,
    SD2.D2_TOTAL,
    SD2.D2_VALIPI,
    SD2.D2_VALICM,
    DF1.DF1_NUMAGE,
    DF1.DF1_ITEAGE,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '049'
    ) as DATAINI,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '049'
    ) as HORAINI,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as DATAFIM,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as HORAFIM,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = '050'
    ) as COMPETENCIA

from DTQ010 DTQ (nolock)
    inner join DA8010 DA8 (nolock)
        on DA8.D_E_L_E_T_ = ''
        and DA8.DA8_COD = DTQ.DTQ_ROTA
    inner join DTR010 DTR (nolock)
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DTQ.DTQ_FILORI
        and DTR.DTR_VIAGEM = DTQ.DTQ_VIAGEM

        inner join DUP010 DUP (nolock)
            on DUP.D_E_L_E_T_ = ''
            and DUP.DUP_FILORI = DTR.DTR_FILORI
            and DUP.DUP_VIAGEM = DTR.DTR_VIAGEM
            and DUP.DUP_ITEDTR = DTR.DTR_ITEM
            and DUP.DUP_CODVEI = DTR.DTR_CODVEI

            inner join DA4010 DA4 (nolock)
                on DA4.DA4_COD = DUP.DUP_CODMOT

    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM

		left join DT6010 DT6 (nolock)
			on DT6.D_E_L_E_T_ = ''
			and DT6.DT6_FILDOC = DUD.DUD_FILDOC
			and DT6.DT6_DOC = DUD.DUD_DOC
			and DT6.DT6_SERIE = DUD.DUD_SERIE

            left join
            (
                select
                    trim(DUY010.DUY_GRPVEN) as GRP_COL,
                    trim(DUY010.DUY_EST) as EST_COL,
                    trim(DUY010.DUY_DESCRI) as MUN_COL
                from DUY010 (nolock)
                where DUY010.D_E_L_E_T_ = ''
            ) AS REG_COL
            on REG_COL.GRP_COL = DT6.DT6_CDRORI

            left join
            (
                select
                    trim(DUY010.DUY_GRPVEN) as GRP_ENT,
                    trim(DUY010.DUY_EST) as EST_ENT,
                    trim(DUY010.DUY_DESCRI) as MUN_ENT
                from DUY010 (nolock)
                where DUY010.D_E_L_E_T_ = ''
            ) AS REG_ENT
            on REG_ENT.GRP_ENT = DT6.DT6_CDRCAL

            left join SD2010 SD2 (nolock)
                on SD2.D_E_L_E_T_ = ''
                and SD2.D2_NFORI = DT6.DT6_DOC
                and SD2.D2_SERIORI = DT6.DT6_SERIE
                and SD2.D2_CLIENTE = DT6.DT6_CLIDEV
                and SD2.D2_LOJA = DT6.DT6_LOJDEV
            left join SA1010 SA1 (nolock)
                on SA1.D_E_L_E_T_ = ''
                and SA1.A1_COD = DT6.DT6_CLIDEV
                and SA1.A1_LOJA = DT6.DT6_LOJDEV
            left join DTC010 DTC (nolock)
                on DTC.D_E_L_E_T_ = ''
                and DTC.DTC_FILORI = DT6.DT6_FILDOC
                and DTC.DTC_DOC = DT6.DT6_DOC
                and DTC.DTC_SERIE = DT6.DT6_SERIE

                left join DF1010 DF1 (nolock)
                    on DF1.D_E_L_E_T_ = ''
                    and DF1.DF1_FILDOC = DTC.DTC_FILORI
                    and DF1.DF1_DOC = DTC.DTC_NUMSOL
where 
        DTQ.D_E_L_E_T_ = ''
