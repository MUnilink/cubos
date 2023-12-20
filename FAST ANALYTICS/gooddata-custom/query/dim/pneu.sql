select
    concat(trim(ST9.T9_FILIAL), trim(ST9.T9_CODBEM)) as ID_PNEU,
	trim(ST9.T9_CODBEM) as PNEU_FERRO,
	trim(isnull(ST9.T9_NFCOMPR, '-')) as NF_COMPRA,
	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as SITUACAO_PNEU

from ST9010 ST9
    inner join TQS010 TQS
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = ST9.T9_CODBEM
where
		ST9.D_E_L_E_T_ = ''
	and ST9.T9_CATBEM = 3
