select
    concat(trim(SC1.C1_FILIAL), trim(SC1.C1_NUM)) as ID_SOLICITACAO,
	trim(isnull(SC1.C1_ITEM, '-')) as ITEM_SC,
	trim(isnull(SC1.C1_OBS, '-')) as OBS_SC,
    trim(isnull(upper(SC1.C1_SOLICIT), '-')) as SOLICITANTE_SC,

    case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_SC,

from SC1010 SC1
where SC1.D_E_L_E_T_ = ''
