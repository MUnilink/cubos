    select
        ZC2_NUM + '-' + ZC2_ITEM as OS_ITEM,
        RJ_DESC RH,
        convert(date,ZC2_COMPET) as PERIODO,
        ZC2_CHVOS,
        NULL as VERBA,
        ZC2_TOTAL as TOTAL_OS,
        0 TOTAL_FOLHA,
        ZC2.R_E_C_N_O_
    from ZC2010 ZC2
    inner join SRJ010 SRJ
        on ZC2.D_E_L_E_T_=''
        and ZC2_COD = RJ_FUNCAO
    where ZC2_COMPET != ''
        and ZC2_TIPO = 2
        and ZC2.ZC2_INCLUS = 'M'

union

    select
        'FOLHA',
        RV_DESC,
        convert(date,RD_DATARQ+'01'),
        RD_YCHVOS as ZC2_CHVOS,
        RD_PD as VERBA,
        0 TOTAL_OS,
        RD_VALOR as TOTAL_FOLHA,
        SRD.R_E_C_N_O_
    from SRD010 SRD 
    inner join SRV010 SRV
        on SRV.D_E_L_E_T_ = ''
        and SRD.RD_PD = SRV.RV_COD
    where
            SRD.RD_YCHVOS != ''
        and SRD.D_E_L_E_T_ = ''
