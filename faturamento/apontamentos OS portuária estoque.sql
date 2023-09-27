/*
    SELECT
        'ESTOQUE',
        SD3.D3_YOS as OS,
        SD3.D3_COD,
        SB1.B1_DESC as DESCRICAO,
        CONVERT(date, SD3.D3_EMISSAO),
        SD3.D3_YCHVOS as ZC2_CHVOS,
        0 as TOTAL_OS,
        SD3.D3_CUSTO1 as TOTAL_ESTOQUE,
        SD3.R_E_C_N_O_
    FROM SD3010 SD3
        inner join SB1010 SB1
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SD3.D3_COD
    WHERE
            SD3.D_E_L_E_T_ = ''
        and SD3.D3_YCHVOS != ''
*/

select
    SCP.CP_NUM,
    SCP.CP_YOSPORT,
    SCP.CP_PRODUTO,
    CONVERT(date, ZC2.ZC2_COMPET) as PERIODO,
    
    case ZC2.ZC2_COMPET when '' then isnull(ZC2.ZC2_CHVOS, concat('SD3', substring(ZC2.ZC2_COMPET, 1, 6), ZC2.ZC2_COD)) else ZC2.ZC2_CHVOS end as CHAVE_OS,
    
    ZC2.ZC2_TOTAL as TOTAL_OS

from ZC2010 ZC2 (nolock)
    left join SCP010 SCP (nolock)
        on SCP.D_E_L_E_T_ = ''
        and SCP.CP_FILIAL = ZC2.ZC2_FILIAL
        and SCP.CP_YOSPORT = ZC2.ZC2_NUM
        and concat('SD3', substring(SCP.CP_EMISSAO, 1, 6), SCP.CP_YOSPORT) = case ZC2.ZC2_COMPET when '' then isnull(ZC2.ZC2_CHVOS, concat('SD3', substring(ZC2.ZC2_COMPET, 1, 6), ZC2.ZC2_COD)) else ZC2.ZC2_CHVOS end
    
        left join SB1010 SB1 (nolock)
            on SB1.D_E_L_E_T_ = ''
            and SB1.B1_COD = SCP.CP_PRODUTO
where
        ZC2.D_E_L_E_T_ = ''
    and ZC2.ZC2_COMPET != ''
