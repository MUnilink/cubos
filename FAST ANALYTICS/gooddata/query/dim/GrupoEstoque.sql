SELECT 'P |01|SBM010|'+ COALESCE(NULLIF(RTRIM(COALESCE(BM_FILIAL, ' '))+'|'+RTRIM(COALESCE(BM_GRUPO, ' ')), ' '), '|') AS BK_GRUPO_ESTOQUE,
       SBM.BM_GRUPO AS COD_GRUPO_ESTOQUE,
       replace(replace(replace(upper(SBM.BM_DESC), 'Ç', 'C'), 'Ã', 'A'), 'Õ', 'O') AS DESC_GRUPO_ESTOQUE,
       replace(replace(replace(upper(SBM.BM_YDEGRUP), 'Ç', 'C'), 'Ã', 'A'), 'Õ', 'O') AS DESC_GRUPO,
       replace(replace(replace(upper(SBM.BM_YDESUBG), 'Ç', 'C'), 'Ã', 'A'), 'Õ', 'O') AS DESC_SUBGRUPO
FROM SBM010 SBM
WHERE SBM.D_E_L_E_T_ = ' '
UNION
SELECT 'P |01|SBM010||',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO'