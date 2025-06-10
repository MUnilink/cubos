select
    concat(trim(SRY.RY_FILIAL), trim(SRY.RY_CALCULO)) as ID_ROTEIRO,
    trim(SRY.RY_CALCULO) as COD_ROTEIRO,
	trim(SRY.RY_DESC) as DESC_ROTEIRO,
from SRY010 SRY (nolock)
where SRY.D_E_L_E_T_ = ''
