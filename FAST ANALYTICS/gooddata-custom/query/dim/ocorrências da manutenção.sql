select 
    trim(ST8.T8_CODOCOR) as T8_CODOCOR,
    trim(ST8.T8_NOME) as T8_NOME
from ST8010 ST8 (nolock)
where ST8.D_E_L_E_T_ = ''
