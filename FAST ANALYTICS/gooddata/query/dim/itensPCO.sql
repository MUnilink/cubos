select
    concat(trim(AK2.AK2_ORCAME), trim(AK2.AK2_VERSAO), substring(AK2.AK2_PERIOD, 1, 6), trim(AK2.AK2_CO), trim(AK2.AK2_CLASSE), trim(AK2.AK2_OPER)) as ID_ITEMPCO,
    AK2.AK2_ORCAME,
    AK2.AK2_VERSAO,
    AK2.AK2_PERIOD,
    AK2.AK2_CO,
    AK2.AK2_CLASSE,
    AK2.AK2_OPER
from AK2010 AK2 (nolock)
where AK2.D_E_L_E_T_ = ''
