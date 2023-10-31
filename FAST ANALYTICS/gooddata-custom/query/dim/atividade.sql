select
	trim(CTD.CTD_ITEM) as ITEM_CTA,
	trim(CTD.CTD_DESC01) as ATIVIDADE
from CTD010 CTD
where
		CTD.D_E_L_E_T_ = ''
	and cast(CTD.CTD_ITEM as int) > 9
