select
	trim(SRV.RV_DESC) as DESC_VERBA1,
	trim(SRV.RV_DESCDET) as DESC_VERBA2,
	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,
from SRD010 SRD (nolock)
