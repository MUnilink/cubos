select
	trim(ST9.T9_CODBEM) as T9_CODBEM,
	trim(ST9.T9_NOME) as T9_NOME,
	trim(ST9.T9_DTCOMPR) as T9_DTCOMPR,
	trim(ST9.T9_PLACA) as T9_PLACA,
	trim(ST9.T9_NFCOMPR) as T9_NFCOMPR,
	trim(ST9.T9_TIPMOD) as T9_TIPMOD,
	trim(ST9.T9_CODFAMI) as T9_CODFAMI,

	case ST9.T9_CATBEM
		when 1 then 'BEM'
		when 2 then 'FROTA NAO INTEGRADA'
		when 3 then 'PNEU'
		when 4 then 'FROTA INTEGRADA'
		else '-'
	end as T9_CATBEM,

	(select case TQS010.TQS_XPNEU when 'S' then 'S' else 'N' end from TQS010 where TQS010.D_E_L_E_T_ = '' and TQS010.TQS_CODBEM = ST9.T9_CODBEM) as PNEU_AGG,
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as T9_SITBEM

from ST9010 ST9
where ST9.D_E_L_E_T_ = ''
