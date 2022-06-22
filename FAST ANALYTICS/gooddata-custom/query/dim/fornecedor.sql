select
	isnull(trim(SA2.A2_COD) + trim(SA2.A2_LOJA), '-') as ID_FORNECE,
	trim(SA2.A2_COD) as A2_COD,
	trim(SA2.A2_LOJA) as A2_LOJA,
	trim(SA2.A2_NOME) as A2_NOME,
	trim(SA2.A2_NREDUZ) as A2_NREDUZ
from SA2010 as SA2
where SA2.D_E_L_E_T_ = ''