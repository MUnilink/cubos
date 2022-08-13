select
/* veículos com ao menos uma OS; as OS deverão ficar abertas se, e somente se, os veículo está parado na manutenção*/
	STJ.TJ_FILIAL,
	case STJ.TJ_PLANO when '000000' then 'CORRETIVA' else 'PREVENTIVA' end as TJ_PLANO,
	count(distinct STJ.TJ_CODBEM) as QTD_BENS,
	STJ.TJ_CCUSTO,

	case when STJ.TJ_CODBEM like 'CM%' then 'CM'
	else
		case when STJ.TJ_CODBEM like 'SR%' then 'SR'
		else ST9.T9_CODFAMI
		end
	end as T6_CODFAMI

from STJ010 STJ (nolock)
	inner join ST9010 ST9 (nolock)
		on ST9.D_E_L_E_T_ = ''
		and ST9.T9_CODBEM = STJ.TJ_CODBEM
where
		STJ.D_E_L_E_T_ = ''
	and trim(ST9.T9_CODFAMI) != 'PN'
    and STJ.TJ_TERMINO = 'N'
group by
    STJ.TJ_FILIAL,
	STJ.TJ_PLANO,
	STJ.TJ_CCUSTO,
    ST9.T9_CODFAMI,
    STJ.TJ_CODBEM