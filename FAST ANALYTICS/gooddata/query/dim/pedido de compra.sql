select
    concat(trim(SC7.C7_FILIAL), trim(SC7.C7_NUM)) as ID_PEDIDO,
	trim(isnull(SC7.C7_ITEM, '-')) as ITEM_PC,
	trim(isnull(SC7.C7_OBS, '-')) as OBS_PC,
	trim(isnull(SC7.C7_OBSM, '-')) as MEMO_PC,

	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as APROVACAO_PC,

from SC7010 SC7
where SC7.D_E_L_E_T_ = ''
