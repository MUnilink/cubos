    select
        'CTRC' + DT6.DT6_DOC AS ID_DOCUMENTO,
        DT6.DT6_DOC as DOCUMENTO,
        DT6.DT6_SERIE as SERIE,
        1 as INSTANCIA
    from DT6010 DT6
    where DT6.D_E_L_E_T_ = ''
union
    select
        'ND' + SE1.E1_NUM AS ID_DOCUMENTO,
        SE1.E1_NUM as DOCUMENTO,
        null as SERIE,
        1 as INSTANCIA
    from SE1010 SE1
    where SE1.D_E_L_E_T_ = '' and (SE1.E1_YVIATMS is not null or SE1.E1_YVIAGEM is not null or SE1.E1_YVIATMS != '' or SE1.E1_YVIAGEM != '')
union
    select
        'RPS' + SD2.D2_DOC AS ID_DOCUMENTO,
        SD2.D2_DOC as DOCUMENTO,
        SD2.D2_SERIE as SERIE,
        1 as INSTANCIA
    from SC5010 SC5
        left join SD2010 SD2
            on SD2.D_E_L_E_T_ = ''
            and SD2.D2_FILIAL = SC5.C5_FILIAL
            and SD2.D2_DOC = SC5.C5_NOTA
            and SD2.D2_SERIE = SC5.C5_SERIE
            and SD2.D2_CLIENTE = SC5.C5_CLIENTE
            and SD2.D2_LOJA = SC5.C5_LOJACLI
    where SC5.D_E_L_E_T_ = '' and (SC5.C5_YVIAGEM is not null or SC5.C5_YVIAGEM != '')
union
    select
        'DOCAV' + DTC.DTC_DOC AS ID_DOCUMENTO,
        DTC.DTC_DOC as DOCUMENTO,
        DTC.DTC_SERIE as SERIE,
        1 as INSTANCIA
    from DTC010 DTC
    where DTC.D_E_L_E_T_ = ' ' and (DTC.DTC_YVIAGE is not null or DTC.DTC_YVIAGE != '')
