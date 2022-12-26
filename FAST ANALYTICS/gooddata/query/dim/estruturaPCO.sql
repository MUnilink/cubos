select
    concat(trim(AK3.AK3_ORCAME), trim(AK3.AK3_VERSAO), trim(AK3.AK3_CO)) as ID_ESTRUTURAPCO,
    AK3.AK3_ORCAME,
    AK3.AK3_VERSAO,
    AK3.AK3_CO,
    AK3.AK3_PAI,
    AK3.AK3_TIPO,
    AK3.AK3_NIVEL,
    AK3.AK3_DESCRI
from AK3010 AK3 (nolock)
where AK3.D_E_L_E_T_ = ''
