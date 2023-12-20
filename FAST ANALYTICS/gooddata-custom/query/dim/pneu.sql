select
    ST9.T9_FILIAL as FILIAL,
	trim(isnull(ST9.T9_CODBEM, '-')) as T9_CODBEM,
	trim(isnull(ST9.T9_DTCOMPR, '-')) as T9_DTCOMPR,
	trim(isnull(ST9.T9_NFCOMPR, '-')) as T9_NFCOMPR,

	case ST9.T9_CATBEM
		when 1 then 'BEM'
		when 2 then 'FROTA NAO INTEGRADA'
        when 3 then 'PNEU'
		when 4 then 'FROTA INTEGRADA'
		else '-'
	end as T9_CATBEM,

	case ST9.T9_SITBEM when 'A' then 'ATIVO' when 'I' then 'INATIVO' else 'OUTROS' end as T9_SITBEM

from ST9010 ST9
    inner join 
		on TQS.D_E_L_E_T_ = ''
		and TQS.TQS_CODBEM = ST9.T9_CODBEM
where
		ST9.D_E_L_E_T_ = ''
	and ST9.T9_CATBEM = 3
