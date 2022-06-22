select
	trim(ST7.T7_FABRICA) as T7_FABRICA,
	trim(ST7.T7_NOME) as T7_NOME
from ST7010 as ST7
where ST7.D_E_L_E_T_ = ''