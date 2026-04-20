    SELECT
        ZC2.ZC2_NUM + '-' + ZC2.ZC2_ITEM as OS_ITEM,
        ZC2.ZC2_NUM as OS,
        ZC2.ZC2_COD as PRODUTO,
        ZC2.ZC2_DESC as DESCRICAO,
        CONVERT(date, ZC2.ZC2_COMPET) as PERIODO,
        null as SA,
        ZC2.ZC2_CHVOS,
        ZC2.ZC2_TOTAL as TOTAL_OS,
        0 as TOTAL_ESTOQUE,
        ZC2.R_E_C_N_O_
    FROM ZC2010 ZC2
    WHERE
            ZC2.D_E_L_E_T_ = ''
        and ZC2.ZC2_COMPET != ''
        and ZC2.ZC2_TIPO = 4

union

    SELECT
        'ESTOQUE',
        SD3.D3_YOS as OS,
        trim(SD3.D3_COD) as PRODUTO,
        trim(SB1.B1_DESC) as DESCRICAO,
        CONVERT(date, SD3.D3_EMISSAO),
        SCP.CP_NUM as SA,
        SD3.D3_YCHVOS as ZC2_CHVOS,
        0 as TOTAL_OS,
        SD3.D3_CUSTO1 as TOTAL_ESTOQUE,
        SD3.R_E_C_N_O_
    FROM SD3010 SD3
        inner join SB1010 SB1
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
        left join SCP010 SCP
            on SCP.D_E_L_E_T_ = ''
            and SCP.CP_FILIAL = SD3.D3_FILIAL
            and SCP.CP_NUM = SD3.D3_NUMSA
            and SCP.CP_ITEM = SD3.D3_ITEMSA
    WHERE
            SD3.D_E_L_E_T_ = ''
        and SD3.D3_YCHVOS != ''
