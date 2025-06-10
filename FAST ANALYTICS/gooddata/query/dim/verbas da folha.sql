select
    concat(trim(SRV.RV_FILIAL), trim(SRV.RV_COD)) as ID_VERBA,
    trim(SRV.RV_COD) as COD_VERBA,
	trim(SRV.RV_DESC) as DESC_VERBA1,
	trim(SRV.RV_DESCDET) as DESC_VERBA2,
	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,
	
	case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'AMBOS' when SRV.RV_YCPOR = 'S' then 'OPP' when SRV.RV_YCTMS = 'S' then 'TMS' else 'OUTRAS' end as VERBA_CUSTO
from SRV010 SRV (nolock)
where SRV.D_E_L_E_T_ = ''
