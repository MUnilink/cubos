    SELECT
        ZC2_NUM + '-' + ZC2_ITEM as OS_ITEM,
        RJ_DESC RH,
        CONVERT(DATE,ZC2_COMPET) as PERIODO,
        ZC2_CHVOS,
        ZC2_TOTAL as TOTAL_OS,
        0 TOTAL_FOLHA,
        ZC2.R_E_C_N_O_
    FROM ZC2010 ZC2, SRJ010 SRJ
    WHERE
            ZC2.D_E_L_E_T_=''
        AND SRJ.D_E_L_E_T_= ''
        AND ZC2_COMPET <> ''
        AND ZC2_TIPO = 2
        AND ZC2_COD = RJ_FUNCAO
        and ZC2.ZC2_INCLUS = 'M'

union

    SELECT
        'FOLHA',
        RV_DESC,
        CONVERT(DATE,RD_DATARQ+'01'),
        RD_YCHVOS as ZC2_CHVOS,
        0 TOTAL_OS,
        RD_VALOR as TOTAL_FOLHA,
        SRD.R_E_C_N_O_
    FROM SRD010 SRD, SRV010 SRV
    WHERE
            SRD.D_E_L_E_T_ = ''
        AND RD_YCHVOS <> ''
        AND SRV.D_E_L_E_T_=''
        AND RD_PD = RV_COD
