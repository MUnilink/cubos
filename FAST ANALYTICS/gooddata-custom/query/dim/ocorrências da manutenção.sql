select 
    ST8.T8_CODOCOR as COD_OCOR,
    ST8.T8_NOME as NOME_OCOR
from ST8010 ST8 (nolock)
where ST8.D_E_L_E_T_ = ''