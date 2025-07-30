select
    DUD.DUD_FILIAL,
    DUD.DUD_VIAGEM,
    DT6.DT6_DOC,
    DT6.DT6_SERIE,
    DT6.DT6_DATEMI,
    DT6.DT6_CLIDEV,
    DT6.DT6_LOJDEV,
    DTC.DTC_CODPRO,
    SD2.D2_CCUSTO,
    SD2.D2_ITEMCC,

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
        select cast(DTW010.DTW_DATREA as date)
        from DTW010 (nolock)
        where 
                DTW010.D_E_L_E_T_ = ''
            and DTW010.DTW_FILIAL = DUD.DUD_FILIAL
            and DTW010.DTW_VIAGEM = DUD.DUD_VIAGEM
            and DTW010.DTW_ATIVID = 50
    ) as DATAFIM,
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
        left join SD2010 SD2 (nolock)
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_DOC = DT6.DT6_DOC
            and SD2.D2_SERIE = DT6.DT6_SERIE
            and SD2.D2_CLIENTE = DT6.DT6_CLIDEV
            and SD2.D2_LOJA = DT6.DT6_LOJDEV
        left join DTC010 DTC (nolock)
            on DTC.D_E_L_E_T_ = ''
            and DTC.DTC_FILDOC = DT6.DT6_FILDOC
            and DTC.DTC_DOC = DT6.DT6_DOC
            and DTC.DTC_SERIE = DT6.DT6_SERIE
where
        DUD.D_E_L_E_T_ = ''
