    select
        ZC2.ZC2_NUM + '-' + ZC2.ZC2_ITEM as OS_ITEM,
        trim(SRJ.RJ_DESC) as RH,
        convert(date, ZC2.ZC2_COMPET) as PERIODO,
        ZC2.ZC2_CHVOS,
        SRJ.RJ_FUNCAO as VERBA,
        ZC2.ZC2_TOTAL as TOTAL_OS,
        0 TOTAL_FOLHA,
        ZC2.R_E_C_N_O_
    from ZC2010 ZC2
        inner join SRJ010 SRJ
            on ZC2.D_E_L_E_T_=''
            and ZC2.ZC2_COD = SRJ.RJ_FUNCAO
        where 
                ZC2.ZC2_COMPET != ''
            and ZC2.ZC2_TIPO = 2
            and ZC2.ZC2_INCLUS = 'M'
            and ZC2.ZC2_HRINI != '  :  '
            and ZC2.ZC2_HRFIM != '  :  '

union

    select
        'FOLHA',
        (SRV.RV_DESC) as RH,
        convert(date, SRD.RD_DATARQ+'01'),
        SRD.RD_YCHVOS as ZC2_CHVOS,
        SRD.RD_PD as VERBA,
        0 TOTAL_OS,
        SRD.RD_VALOR as TOTAL_FOLHA,
        SRD.R_E_C_N_O_
    from SRD010 SRD
        inner join SRV010 SRV
            on SRV.D_E_L_E_T_ = ''
            and SRD.RD_PD = SRV.RV_COD
    where
            SRD.RD_YCHVOS != ''
        and SRD.D_E_L_E_T_ = ''
