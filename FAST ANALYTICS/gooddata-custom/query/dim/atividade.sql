select
	trim(isnull(CTD.CTD_ITEM, '-')) as ITEM_CTA,
	trim(isnull(CTD.CTD_DESC01, '-')) as ATIVIDADE
from CTD010 as CTD (nolock)
where CTD.D_E_L_E_T_ = '' and cast(CTD.CTD_ITEM as int) > 9