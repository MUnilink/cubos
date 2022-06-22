select
	trim(STI.TI_PLANO) as TI_PLANO,
	trim(STI.TI_DESCRIC) as TI_DESCRIC,
	case when cast(STI.TI_PLANO as int) = 0 then 'CORRETIVA' else 'PREVENTIVA' end as TIPO_PLANO
from STI010 as STI
where STI.D_E_L_E_T_ = ''