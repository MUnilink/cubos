select
	trim(ST1.T1_CODFUNC) as T1_CODFUNC,
	trim(ST1.T1_NOME) as T1_NOME,
	trim(SH7.H7_DESCRI) as TURNO
from ST1010 ST1
	left join SH7010 SH7
		on SH7.D_E_L_E_T_ = ''
		and SH7.H7_CODIGO = ST1.T1_TURNO
where ST1.D_E_L_E_T_ = ''
