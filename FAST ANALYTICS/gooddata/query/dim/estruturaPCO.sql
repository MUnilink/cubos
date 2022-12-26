select
    AK3.AK3_ORCAME,
    AK3.AK3_VERSAO,
    AK3.AK3_CO,
    AK3.AK3_PAI,
    AK3.AK3_TIPO,
    AK3.AK3_NIVEL,
    AK3.AK3_DESCRI
from AK3010 AK3 (nolock)
where AK3.D_E_L_E_T_ = ''
