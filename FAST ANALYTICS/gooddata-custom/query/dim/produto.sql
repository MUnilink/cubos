select
	trim(isnull(SB1010.B1_COD, '-')) as B1_COD,
	trim(isnull(SB1010.B1_DESC, '-')) as B1_DESC,
	SB1010.B1_GRUPO as B1_GRUPO
from SB1010
where SB1010.D_E_L_E_T_ = ''
