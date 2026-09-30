select
    'P |01|NNR010|'+ COALESCE(NULLIF(RTRIM(COALESCE(NNR.NNR_FILIAL, ' '))+'|'+RTRIM(COALESCE(NNR.NNR_CODIGO, ' ')), ' '), '|') as ID_ARMAZEM,
    trim(NNR.NNR_CODIGO) as COD_ARMAZEM,
    trim(NNR.NNR_DESCRI) as DESC_ARMAZEM
from NNR010 NNR
where NNR.D_E_L_E_T_ = ' '
union
select 'P |01|NNR010||',
       '01 - INDEFINIDO',
       '01 - INDEFINIDO'
