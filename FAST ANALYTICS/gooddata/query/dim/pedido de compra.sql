select distinct
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
	trim(SC7.C7_NUM) as NUM_PC,
	trim(SC7.C7_RESIDUO) as RESIDUO_PC
from SC7010 SC7
where SC7.D_E_L_E_T_ = ''

union select null, null, null
