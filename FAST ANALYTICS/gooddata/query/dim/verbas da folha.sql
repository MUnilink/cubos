select
    concat(trim(SRV.RV_FILIAL), trim(SRV.RV_COD)) as ID_VERBA,
    trim(SRV.RV_COD) as COD_VERBA,
	trim(SRV.RV_DESC) as DESC_VERBA1,
	coalesce(nullif(trim(SRV.RV_DESCDET), ''), trim(SRV.RV_DESC)) as DESC_VERBA2,
	case trim(SRV.RV_TIPOCOD)
		when '1' then 'PROVENTO'
		when '2' then 'DESCONTO'
		when '3' then 'BASE PROVENTO'
		when '4' then 'BASE DESCONTO'
		else '-'
	end as TIPO_VERBA,
	
	case when SRV.RV_YCPOR = 'S' and SRV.RV_YCTMS = 'S' then 'CUSTO/DESPESA GERAL' when SRV.RV_YCPOR = 'S' then 'CUSTO OP. PORTUÁRIA' when SRV.RV_YCTMS = 'S' then 'CUSTO OP. RODOVIÁRIA' else 'OUTRO TIPO' end as VERBA_CUSTO
from SRV010 SRV (nolock)
where SRV.D_E_L_E_T_ = ''
