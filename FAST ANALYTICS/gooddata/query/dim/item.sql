select
    'P |01|SB1010|'+ COALESCE(NULLIF(RTRIM(COALESCE(B1_FILIAL, ' '))+'|'+RTRIM(COALESCE(B1_COD, ' ')), ' '), '|') as BK_ITEM,
    SB1.B1_COD as COD_ITEM,
    SB1.B1_DESC as DESC_ITEM,
    SB1.B1_POSIPI as CLASSIFICACAO_FISCAL
from SB1010 SB1
where SB1.D_E_L_E_T_ = ' '
union
select 'P |01|SB1010||',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO'
