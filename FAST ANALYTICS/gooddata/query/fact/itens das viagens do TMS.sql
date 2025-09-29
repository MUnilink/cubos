select
    CASE WHEN DUD.DUD_FILIAL IS NULL THEN 'P |01||' ELSE 'P |01|01'+ CAST(DUD.DUD_FILIAL AS CHAR (6)) END AS BK_FILIAL,
    concat(trim(DUD.DUD_FILORI), trim(DUD.DUD_VIAGEM)) as BK_VIAGEMTMS,
    DT6.DT6_DATEMI,
    concat('SF2', trim(SD2.D2_FILIAL), trim(SD2.D2_CLIENTE), trim(SD2.D2_LOJA), trim(SD2.D2_DOC), trim(SD2.D2_SERIE)) as ID_NF,
    'P |01|SA1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SA1.A1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SA1.A1_COD, ' '))+RTRIM(COALESCE(SA1.A1_LOJA, ' ')), ' '), '|') as BK_CLIENTE,
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(SB1.B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(SB1.B1_COD, ' ')), ' '), '|') as ID_PRODUTO,
    'P |01|CTD010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTD.CTD_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_ITEMCC, ' ')), ' '), '|') AS BK_ITEM_CONTABIL,
    'P |01|CTT010|'+ COALESCE(NULLIF(RTRIM(COALESCE(CTT.CTT_FILIAL, ' '))+'|'+RTRIM(COALESCE(SD2.D2_CCUSTO, ' ')), ' '), '|') AS BK_CENTRO_DE_CUSTO,

    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 49
    ) as DATAINI,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
    (
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_FILORI = DUD.DUD_FILORI
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as COMPETENCIA,
    
    cast
    (
        (
            select
                coalesce
                (
                    (
                        select top 1 nullif(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '')
                        from ZB1010 (nolock)
                        where
                                ZB1010.D_E_L_E_T_ = ''
                            and ZB1010.ZB1_STATUS = 'OK'
                            and
                                dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                                =
                                datetimefromparts(year(APT.DTW_DATREA), month(APT.DTW_DATREA), day(APT.DTW_DATREA), substring(APT.DTW_HORREA, 1, 2), substring(APT.DTW_HORREA, 3, 4), 0, 0)
                            and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                            and ZB1010.ZB1_MACRON = 7
                            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                    ),
                    nullif(APT.DTW_YHODFI, ''),
                    0
                )
            from DTW010 APT (nolock)
            where
                    APT.D_E_L_E_T_ = ''
                and APT.DTW_FILORI = DTR.DTR_FILORI
                and APT.DTW_VIAGEM = DTR.DTR_VIAGEM
                and APT.DTW_ATIVID = 50
        ) as numeric(15, 2)
    ) as km_fim,
    cast
    (
        (
            select
                coalesce
                (
                    (
                        select top 1 nullif(substring(ZB1010.ZB1_MSGTXT, 2, len(ZB1010.ZB1_MSGTXT)), '')
                        from ZB1010 (nolock)
                        where
                                ZB1010.D_E_L_E_T_ = ''
                            and ZB1010.ZB1_STATUS = 'OK'
                            and
                                dateadd(hour, -3, datetimefromparts(substring(ZB1010.ZB1_MSGTIM, 1, 4), substring(ZB1010.ZB1_MSGTIM, 6, 2), substring(ZB1010.ZB1_MSGTIM, 9, 2), substring(ZB1010.ZB1_MSGTIM, 12, 2), substring(ZB1010.ZB1_MSGTIM, 15, 2), 0, 0))
                                =
                                datetimefromparts(year(APT.DTW_DATREA), month(APT.DTW_DATREA), day(APT.DTW_DATREA), substring(APT.DTW_HORREA, 1, 2), substring(APT.DTW_HORREA, 3, 4), 0, 0)
                            and ZB1010.ZB1_MSGTXT like '&_%' escape '&'
                            and ZB1010.ZB1_MACRON = 1
                            and ZB1010.ZB1_CODDA3 = DTR.DTR_CODVEI
                    ),
                    nullif(APT.DTW_YHODIN, ''),
                    0
                )
            from DTW010 APT (nolock)
            where
                    APT.D_E_L_E_T_ = ''
                and APT.DTW_FILORI = DTR.DTR_FILORI
                and APT.DTW_VIAGEM = DTR.DTR_VIAGEM
                and APT.DTW_ATIVID = 49
        ) as numeric(15, 2)
    ) as km_ini,
    
    concat(trim(ST9.T9_FILIAL), trim(ST9.T9_CODBEM)) as ID_VEICULOTMS

from DUD010 DUD (nolock)
    left join DT6010 DT6 (nolock)
        on DT6.D_E_L_E_T_ = ''
        and DT6.DT6_FILDOC = DUD.DUD_FILDOC
        and DT6.DT6_DOC = DUD.DUD_DOC
        and DT6.DT6_SERIE = DUD.DUD_SERIE

        left join SA1010 SA1 (nolock)
            on SA1.A1_FILIAL = '      '
            and SA1.A1_COD = DT6.DT6_CLIDEV
            and SA1.A1_LOJA = DT6.DT6_LOJDEV
            and SA1.D_E_L_E_T_ = ' '
        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_DOC = DT6.DT6_DOC
            and SD2.D2_SERIE = DT6.DT6_SERIE
            and SD2.D2_CLIENTE = DT6.DT6_CLIDEV
            and SD2.D2_LOJA = DT6.DT6_LOJDEV

            left join CTD010 CTD (nolock)
                on CTD.CTD_FILIAL = ''
                and CTD.CTD_ITEM = SD2.D2_ITEMCC
                and CTD.D_E_L_E_T_ = ' '
            left join CTT010 CTT (nolock)
                on CTT.D_E_L_E_T_ = ''
                and CTT.CTT_FILIAL = substring(SD2.D2_FILIAL, 1, 4)
                and CTT.CTT_CUSTO = SD2.D2_CCUSTO
        
        left join DTC010 DTC (nolock)
            on DTC.D_E_L_E_T_ = ''
            and DTC.DTC_FILDOC = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE

            left join SB1010 SB1 (nolock)
                on SB1.D_E_L_E_T_ = ''
                and SB1.B1_COD = DTC.DTC_CODPRO
    
    left join DTR010 DTR
        on DTR.D_E_L_E_T_ = ''
        and DTR.DTR_FILORI = DUD.DUD_FILORI
        and DTR.DTR_VIAGEM = DUD.DUD_VIAGEM

        left join ST9010 ST9
            on ST9.D_E_L_E_T_ = ''
            and ST9.T9_CODBEM = DTR.DTR_CODVEI
where
        DUD.D_E_L_E_T_ = ''
