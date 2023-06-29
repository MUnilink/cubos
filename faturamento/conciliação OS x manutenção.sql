    SELECT
        ZC2_NUM+'-'+ZC2_ITEM OS_ITEM,
        ZC2_COD as EQUIPAMENTO,
        CONVERT(DATE,ZC2_COMPET) as PERIODO,
        ZC2_CHVOS,
        ZC2_TOTAL as TOTAL_OS,
        0 as TOTAL_MANUTENCAO,
        R_E_C_N_O_
    FROM ZC2010 ZC2
    WHERE
            ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_COMPET != ''
        and ZC2.ZC2_TIPO = 3
        and ZC2.ZC2_INCLUS = 'M'

union

    SELECT
        'MANUTENCAO',
        STJ.TJ_CODBEM,
        CONVERT(DATE,STJ.TJ_DTORIGI),
        STJ.TJ_YCHVOS as ZC2_CHVOS,
        0 as TOTAL_OS,
        ((STJ.TJ_CUSTMDO+STJ.TJ_CUSTMAT+STJ.TJ_CUSTMAA+STJ.TJ_CUSTMAS)/CASE WHEN STJ.TJ_YVLD>0 THEN STJ.TJ_YVLD ELSE 1 END) as TOTAL_MANUTENCAO,
        STJ.R_E_C_N_O_
    FROM STJ010 STJ
    WHERE
            D_E_L_E_T_=''
        AND STJ.TJ_YCHVOS != ''
