select
	trim(CTT010.CTT_CUSTO) as CTT_CUSTO,
	trim(CTT010.CTT_DESC01) as CTT_DESC01
from CTT010
where CTT010.D_E_L_E_T_ = ''
union select null, null
