select
	trim(ST5.T5_TAREFA) as T5_TAREFA,
	trim(ST5.T5_DESCRIC) as T5_DESCRIC,
	trim(ST5.T5_SERVICO) as T5_SERVICO
from ST5010 as ST5
where ST5.D_E_L_E_T_ = ''