select
    concat(substring(AK2.AK2_PERIOD, 1, 6), trim(AK2.AK2_CO), AK2.AK2_CLASSE, AK2.AK2_OPER) as ID_ITEMPCO,
    AK2.AK2_PERIOD,
    AK2.AK2_CO,
    AK2.AK2_CLASSE,
    AK2.AK2_OPER,

    AK2.AK2_DATAI,
    AK2.AK2_DATAF
from AK2010 AK2 (nolock)
where AK2.D_E_L_E_T_ = ''
