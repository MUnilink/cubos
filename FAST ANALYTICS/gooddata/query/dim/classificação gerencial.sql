SELECT
    'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(BM_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
    SBM.BM_GRUPO AS COD_GRUPO_ESTOQUE,
    replace(replace(replace(upper(SBM.BM_DESC), 'Ç', 'C'), 'Ã', 'A'), 'Õ', 'O') AS DESC_GRUPO_ESTOQUE,
    replace(replace(replace(upper(SBM.BM_YDEGRUP), 'Ç', 'C'), 'Ã', 'A'), 'Õ', 'O') AS DESC_GRUPO,
    replace(replace(replace(upper(SBM.BM_YDESUBG), 'Ç', 'C'), 'Ã', 'A'), 'Õ', 'O') AS DESC_SUBGRUPO,
    SBM.BM_YCONTA as CT_ATIVO,
    SBM.BM_YCTDEAD as CT_DESPE,
    SBM.BM_YCTCUST as CT_CUSTO,

    as CLASSIFICACAO
FROM SBM010 SBM
    left join CT1010 CT_A
        on CT_A.D_E_L_E_T_ = ''
        and CT_A.CT1_CONTA = SBM.BM_YCONTA
    left join CT1010 CT_D
        on CT_D.D_E_L_E_T_ = ''
        and CT_D.CT1_CONTA = SBM.BM_YCTDEAD
    left join CT1010 CT_C
        on CT_C.D_E_L_E_T_ = ''
        and CT_C.CT1_CONTA = SBM.BM_YCTCUST
WHERE SBM.D_E_L_E_T_ = ' '
UNION
SELECT 'P |01|SBM010||',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO'
