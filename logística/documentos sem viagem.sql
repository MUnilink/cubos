select
    DTQ.DTQ_FILORI,
    DTQ.DTQ_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    convert(date, DT6.DT6_DATEMI, 103) as DT6_DATEMI,
    DTQ.DTQ_KMVGE,
    
    DTQ.DTQ_DATGER,
    DTQ.DTQ_DATFEC,
    DTQ.DTQ_DATENC,

    trim(DEV.A1_COD) as A1_COD,
    trim(DEV.A1_LOJA) as A1_LOJA,
    trim(DEV.A1_NOME) as CLIENTE,

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

    case when DT5.DT5_STATUS = '4' then 'INTERNA' else case when DT5.DT5_STATUS like '[0-9]' then 'COLETA' else 'ENTREGA' end end as STATUS,

    COMP.D2_DOC as COMP_DOC,
    COMP.D2_SERIE as COMP_SERIE,
    COMP.D2_TOTAL as COMP_TOTAL,
    COMP.D2_VALIPI as COMP_VALIPI,
    COMP.D2_VALICM as COMP_VALICM,
    convert(date, COMP.D2_EMISSAO, 103) as COMP_EMISSAO,

    SC5.C5_NUM as RPS_PEDIDO,
    RPS.D2_DOC as RPS_DOC,
    RPS.D2_SERIE as RPS_SERIE,
    RPS.D2_TOTAL as RPS_TOTAL,
    RPS.D2_VALIPI as RPS_VALIPI,
    RPS.D2_VALICM as RPS_VALICM,
    convert(date, RPS.D2_EMISSAO, 103) as RPS_EMISSAO,

    SD2.D2_DOC as D2_DOC,
    SD2.D2_SERIE as D2_SERIE,
    SD2.D2_TOTAL as D2_TOTAL,
    SD2.D2_VALIPI as D2_VALIPI,
    SD2.D2_VALICM as D2_VALICM,
    convert(date, SD2.D2_EMISSAO, 103) as D2_EMISSAO,

    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as DATAINI,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as HORAINI,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
    (
        select DTW010.DTW_HORREA
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as HORAFIM,
    (
        select distinct first_value(cast(DTW010.DTW_DATREA as date)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 57
    ) as DATA_CHECLI,
    (
        select distinct first_value(DTW010.DTW_HORREA) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 57
    ) as HORA_CHECLI,
    (
        select distinct first_value(cast(DTW010.DTW_DATREA as date)) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 56
    ) as DATA_SAICLI,
    (
        select distinct first_value(DTW010.DTW_HORREA) over(partition by DTW010.DTW_FILORI, DTW010.DTW_VIAGEM, DTW010.DTW_ATIVID order by DTW010.DTW_SEQUEN)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 56
    ) as HORA_SAICLI,
    (
        select substring(DTW010.DTW_DATREA, 1, 6)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILORI = DTQ.DTQ_FILORI
            and DTW010.DTW_VIAGEM = DTQ.DTQ_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA,

    case DTQ.DTQ_STATUS
        when '1' then 'EXCLUÍDA'
        when '2' then 'EM TRANSITO'
        when '3' then 'ENCERRADA'
        when '4' then 'CHEGADA EM FILIAL'
        when '5' then 'FECHADA'
        when '9' then 'CANCELADA'
        else 'OUTROS'
    end as DTQ_STATUS

from DTQ010 DTQ (nolock)
    left join DUD010 DUD (nolock)
        on DUD.D_E_L_E_T_ = ''
        and DUD.DUD_FILORI = DTQ.DTQ_FILORI
        and DUD.DUD_VIAGEM = DTQ.DTQ_VIAGEM

        left join DT5010 DT5 (nolock)
            on DT5.D_E_L_E_T_ = ''
            and DT5.DT5_FILDOC = DUD.DUD_FILDOC
            and DT5.DT5_NUMSOL = DUD.DUD_DOC
            and DUD.DUD_SERIE = 'COL'

            left join DF1010 DF1 (nolock)
                on DF1.D_E_L_E_T_ = ''
                and DF1.DF1_FILDOC = DT5.DT5_FILORI
                and DF1.DF1_DOC = DT5.DT5_DOC
                and DF1.DF1_SERIE = DT5.DT5_SERIE

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

        left join DTC010 DTC (nolock)
            on DTC.D_E_L_E_T_ = ''
            and DTC.DTC_FILORI = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE
    
    left join SC5010 SC5 (nolock)
        on SC5.D_E_L_E_T_ = ''
        and trim(SC5.C5_YVIAGEM) = DTQ.DTQ_VIAGEM

        left join SD2010 RPS (nolock)
            on RPS.D_E_L_E_T_ = ''
            and RPS.D2_FILIAL = SC5.C5_FILIAL
            and RPS.D2_DOC = SC5.C5_NOTA
            and RPS.D2_SERIE = SC5.C5_SERIE
            and RPS.D2_CLIENTE = SC5.C5_CLIENTE
            and RPS.D2_LOJA = SC5.C5_LOJACLI
        
        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_FILIAL = DT6.DT6_FILDOC
            and SD2.D2_DOC = DT6.DT6_DOC
            and SD2.D2_SERIE = DT6.DT6_SERIE
where
        DTQ.D_E_L_E_T_ = ''
    and
    (
            DUD.DUD_DOC in (55065, 55066, 55067, 55068, 55069, 55070, 55071, 55073, 55074, 55075, 55076, 55077, 55078, 55079, 55080, 55081, 55082, 55083, 55084, 55085, 55087, 55088, 55089, 55102, 55103, 55104, 55105, 55106, 55107, 55108, 55109, 55110, 55111, 55112, 55113, 55114, 55115, 55116, 55118, 55119, 55120, 55121, 55122, 55172, 55408, 55416, 55417, 55419, 55769, 55771, 55772, 56042, 56044, 56287, 56624, 56628, 56630, 56634, 56635, 56638, 56641, 56648, 56649, 56650, 56651, 56652, 56653, 56654, 56655, 56656, 56657, 56658, 56659)
        or COMP.D2_DOC in (55065, 55066, 55067, 55068, 55069, 55070, 55071, 55073, 55074, 55075, 55076, 55077, 55078, 55079, 55080, 55081, 55082, 55083, 55084, 55085, 55087, 55088, 55089, 55102, 55103, 55104, 55105, 55106, 55107, 55108, 55109, 55110, 55111, 55112, 55113, 55114, 55115, 55116, 55118, 55119, 55120, 55121, 55122, 55172, 55408, 55416, 55417, 55419, 55769, 55771, 55772, 56042, 56044, 56287, 56624, 56628, 56630, 56634, 56635, 56638, 56641, 56648, 56649, 56650, 56651, 56652, 56653, 56654, 56655, 56656, 56657, 56658, 56659)
        or RPS.D2_DOC in (55065, 55066, 55067, 55068, 55069, 55070, 55071, 55073, 55074, 55075, 55076, 55077, 55078, 55079, 55080, 55081, 55082, 55083, 55084, 55085, 55087, 55088, 55089, 55102, 55103, 55104, 55105, 55106, 55107, 55108, 55109, 55110, 55111, 55112, 55113, 55114, 55115, 55116, 55118, 55119, 55120, 55121, 55122, 55172, 55408, 55416, 55417, 55419, 55769, 55771, 55772, 56042, 56044, 56287, 56624, 56628, 56630, 56634, 56635, 56638, 56641, 56648, 56649, 56650, 56651, 56652, 56653, 56654, 56655, 56656, 56657, 56658, 56659)
        or SD2.D2_DOC in (55065, 55066, 55067, 55068, 55069, 55070, 55071, 55073, 55074, 55075, 55076, 55077, 55078, 55079, 55080, 55081, 55082, 55083, 55084, 55085, 55087, 55088, 55089, 55102, 55103, 55104, 55105, 55106, 55107, 55108, 55109, 55110, 55111, 55112, 55113, 55114, 55115, 55116, 55118, 55119, 55120, 55121, 55122, 55172, 55408, 55416, 55417, 55419, 55769, 55771, 55772, 56042, 56044, 56287, 56624, 56628, 56630, 56634, 56635, 56638, 56641, 56648, 56649, 56650, 56651, 56652, 56653, 56654, 56655, 56656, 56657, 56658, 56659)
    )
