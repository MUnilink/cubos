select
    concat(trim(SC5.C5_FILIAL), trim(SC5.C5_NUM)) as ID_PEDIDO,
	trim(SC5.C5_NUM) as NUM_PV,
    trim(SC5.C5_MENNOTA) as OBS
from SC5010 SC5
where SC5.D_E_L_E_T_ = ''
