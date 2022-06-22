select
	trim(CTT.CTT_CUSTO) as CTT_CUSTO,
	trim(CTT.CTT_DESC01) as CTT_DESC01
from CTT010 as CTT
where CTT.D_E_L_E_T_ = ''