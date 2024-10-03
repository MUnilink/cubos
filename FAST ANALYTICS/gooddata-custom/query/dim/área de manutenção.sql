select
	trim(STD.TD_CODAREA) as TD_CODAREA,
	trim(STD.TD_NOME) as TD_NOME
from STD010 STD
where STD.D_E_L_E_T_ = ''
