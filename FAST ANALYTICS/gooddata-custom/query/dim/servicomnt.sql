select
	trim(ST4.T4_SERVICO) as T4_SERVICO,
	trim(ST4.T4_NOME) as T4_NOME
from ST4010 as ST4
where ST4.D_E_L_E_T_ = ''