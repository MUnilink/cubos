select
	trim(CTD010.CTD_ITEM) as ITEM_CTA,
	trim(CTD010.CTD_DESC01) as ATIVIDADE
from CTD010
where
		CTD010.D_E_L_E_T_ = ''
	and cast(CTD010.CTD_ITEM as int) > 9
union select null, null
