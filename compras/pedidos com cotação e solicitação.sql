select
	trim(isnull(SC7.C7_NUM, '-')) as NUM_PC,
	trim(SC7.C7_ITEM) as ITEM_PC,
	SC7.C7_EMISSAO,
	case SC7.C7_CONAPRO
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_PC,
    
    SC8.C8_NUM,
    SC8.C8_ITEM,

    trim(isnull(SC1.C1_NUM, '-')) as NUM_SC,
	trim(SC1.C1_ITEM) as ITEM_SC,
	trim(isnull(SC1.C1_SOLICIT, '-')) as SOLICITANTE_SC,
	SC1.C1_EMISSAO,
	case SC1.C1_APROV
		when 'B' then 'PENDENTE'
		when 'L' then 'APROVADO'
		when 'R' then 'REJEITADO'
		else 'OUTROS'
	end as SITAPR_SC
from SC7010 SC7 (nolock)
    inner join SC8010 SC8 (nolock)
        on SC8.D_E_L_E_T_ = ''
        and SC8.C8_NUMPED = SC7.C7_NUM
        and SC8.C8_ITEMPED = SC7.C7_ITEM

        inner join SC1010 SC1 (nolock)
            on SC1.D_E_L_E_T_ = ''
            and SC1.C1_NUM = SC8.C8_NUMSC
            and SC1.C1_ITEM = SC8.C8_ITEMSC
where SC7.D_E_L_E_T_ = ''
